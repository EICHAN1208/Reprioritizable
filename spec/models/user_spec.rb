require 'rails_helper'

RSpec.describe ::User, type: :model do
  before do
    User.bulk_generate
  end

  subject { User.exec_reprioritize!(:priority, User.all, instance, priority) }

  # 優先順位が「4」のものを「2」にする
  context '優先順位を下げる場合' do
    let(:instance) { User.find_by(priority: 4, name: 'D') }
    let(:priority) { 2 }

    it '期待通りの取得ができる' do
      subject
      expect(User.all.pluck(:priority, :name)).to include [1, 'A'], [2, 'D'], [3, 'B'], [4, 'C'], [5, 'E']
    end
  end

  # 5 -> 1
  context '優先順位を下げる場合' do
    let(:instance) { User.find_by(priority: 5, name: 'E') }
    let(:priority) { 1 }

    it '期待通りの取得ができる' do
      subject
      expect(User.all.pluck(:priority, :name)).to include [2, 'A'], [3, 'B'], [4, 'C'], [5, 'D'], [1, 'E']
    end
  end

  # 優先順位が「2」のものを「4」にする
  context '優先順位を上げる場合' do
    let(:instance) { User.find_by(priority: 2, name: 'B') }
    let(:priority) { 4 }

    it '期待通りの取得ができる' do
      subject
      expect(User.all.pluck(:priority, :name)).to include [1, 'A'], [4, 'B'], [2, 'C'], [3, 'D'], [5, 'E']
    end
  end

  # 1 -> 5
  context '優先順位を上げる場合' do
    let(:instance) { User.find_by(priority: 1, name: 'A') }
    let(:priority) { 5 }

    it '期待通りの取得ができる' do
      subject
      expect(User.all.pluck(:priority, :name)).to include [5, 'A'], [1, 'B'], [2, 'C'], [3, 'D'], [4, 'E']
    end
  end

  context '数値が大きすぎて登録できない場合' do
    let(:instance) { User.find_by(priority: 1, name: 'A') }
    let(:priority) { 6 }

    it '例外が発生する' do
      expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context '数値が小さすぎて登録できない場合' do
    let(:instance) { User.find_by(priority: 5, name: 'E') }
    let(:priority) { 0 }

    it '例外が発生する' do
      expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
