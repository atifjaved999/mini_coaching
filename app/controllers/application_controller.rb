class ApplicationController < ActionController::API
  protected

  def current_user
    @current_user
  end
end
