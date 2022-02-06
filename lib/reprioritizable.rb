require "reprioritizable/version"
require "reprioritizable/railtie"

module Reprioritizable
  extend ActiveSupport::Concern

  class_methods do
    def reprioritize!(column:, scope:, instance:, new_priority:)
      instance.restrict_max_priority!(column, new_priority, scope)
      instance.restrict_minimum_priority!(column, new_priority, scope)

      before_priority = instance.send(column)
      if before_priority > new_priority
        reprioritize(
          scope.where("#{column} >= ?", new_priority).where("#{column} < ?", before_priority)
        ) do |record|
          record.increase_priority(column)
        end
      elsif before_priority < new_priority
        reprioritize(
          scope.where("#{column} <= ?", new_priority).where("#{column} > ?", before_priority)
        ) do |record|
          record.decrease_priority(column)
        end
      end

      instance.update!("#{column}": new_priority)
    end

    def reprioritize(scope, &_block)
      attributes = scope.map do |prioritable|
        yield(prioritable)
        prioritable.updated_at = Time.zone.now
        prioritable.attributes
      end
      scope.klass.upsert_all(attributes) if attributes.any?
    end
  end

  def increase_priority(column)
    eval("self.#{column} += 1")
  end

  def decrease_priority(column)
    eval("self.#{column} -= 1")
  end

  def restrict_max_priority!(column, new_priority, scope)
    max_size = scope.maximum(column)
    errors.add(:base, "Please register with a value of #{max_size} or less.") if max_size < new_priority

    raise ActiveRecord::RecordInvalid, self if errors.any?
  end

  def restrict_minimum_priority!(column, new_priority, scope)
    minimum_size = scope.minimum(column)
    errors.add(:base, "Please register with a value of #{minimum_size} or more.") if minimum_size > new_priority

    raise ActiveRecord::RecordInvalid, self if errors.any?
  end
end
