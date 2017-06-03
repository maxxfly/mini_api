class UsersController < ActionController::Base
  def index
    render json: User.all
  end

  def show
    @user = User.find_by_id(params[:id])

    if @user
      render json: @user
    else
      render json: { message: "Not found"}, :status => 404
    end
  end

  def create
  end

  def update
  end

  def destroy
    @user = User.find_by_id(params[:id])

    if @user && @user.destroy
      render json: { message: "Deleted"}, :status => 204
    else
      render json: { message: "Not found"}, :status => 404
    end
  end
end
