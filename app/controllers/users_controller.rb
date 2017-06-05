class UsersController < ActionController::Base
  before_action :load_user, only: [:update, :show, :destroy]

  def index
    render json: User.all
  end

  def show
    render json: @user
  end

  def create
    @user = User.create(user_params)

    if @user.save
      render json: @user
    else
      render json: { errors: @user.errors }, status: 400
    end
  end

  def update
    if @user.update_attributes(user_params)
      render json: @user
    else
      render json: { errors: @user.errors }, status: 400
    end
  end

  def destroy
    if @user && @user.destroy
      render json: { message: "Deleted"}, status: 204
    else
      render json: { message: "Not found"}, status: 404
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :address_line_1, :dob)
  end

  def load_user
    @user = User.find_by_id(params[:id])

    unless @user
      render json: { message: "Not found"}, status: 404
      return false
    end
  end
end
