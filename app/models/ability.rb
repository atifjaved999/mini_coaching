class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    if user.has_role?(:admin)
      can :manage, :all
    end

    if user.has_role?(:coach)
      # Coaches can manage their own sessions
      can [:read, :update, :destroy], Session do |session|
        session.coaches.include?(user)
      end
      
      # Coaches can create new sessions
      can :create, Session
      
      # Coaches can view their clients
      can :read, User do |client|
        client.has_role?(:client) && client.sessions.any? { |s| s.coaches.include?(user) }
      end
    end

    if user.has_role?(:client)
      # Clients can read their own sessions
      can :read, Session do |session|
        session.clients.include?(user)
      end
      
      # Clients can book sessions with coaches
      can :book, Session
      
      # Clients can view their coaches
      can :read, User do |coach|
        coach.has_role?(:coach) && coach.sessions.any? { |s| s.clients.include?(user) }
      end
    end

    # All users can read and update their own profile
    can [:read, :update], User, id: user.id
  end
end
