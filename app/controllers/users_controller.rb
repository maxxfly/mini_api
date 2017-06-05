class UsersController < ActionController::Base
  def index
    render json: User.all
  end

  def show
    @user = User.find_by_id(params[:id])

    if @user
      render json: @user
    else
      render json: { message: "Not found"}, status: 404
    end
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
    @user = User.find_by_id(params[:id])

    if @user
      if @user.update_attributes(user_params)
        render json: @user
      else
        render json: { errors: @user.errors }, status: 400
      end
    else
      render json: { message: "Not found"}, status: 404
    end
  end

  def destroy
    @user = User.find_by_id(params[:id])

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
end
