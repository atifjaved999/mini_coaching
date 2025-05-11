class SessionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :scheduled_at, :start_time, :end_time, :created_at, :updated_at
  has_many :users, serializer: UserSerializer
end
