class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :roles

  def roles
    object.roles.pluck(:name)
  end
end
