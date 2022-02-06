class User < ApplicationRecord
  include ::Reprioritizable

  class << self
    def bulk_generate
      [{ A: 1 }, { B: 2 }, { C: 3 }, { D: 4 }, { E: 5 }].each do |hash|
        key = hash.keys.first
        create!(name: key, priority: hash[key])
      end
    end

    def exec_reprioritize!(column, scope, instance, priority)
      reprioritize!(
        column: column,
        scope: scope,
        instance: instance,
        new_priority: priority
      )
    end
  end
end
