class UsersController < ActionController::Base
  def index
    render :json => User.all
  end
end
