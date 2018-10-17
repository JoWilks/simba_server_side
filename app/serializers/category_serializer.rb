class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :budget_amount, :budget_timeframe, :user_id
end
