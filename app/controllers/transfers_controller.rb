class TransfersController < ActionController::Base
  before_action :authenticate

  before_action :load_user
  before_action :load_transfer, only: [:update, :show, :destroy]

  def index
    render json: @user.transfers
  end

  def show
    render json: @transfer
  end

  def create
    @transfer = @user.transfers.build(transfer_params)

    if @transfer.save
      render json: @transfer
    else
      render json: { errors: @transfer.errors }, status: 400
    end
  end

  def update
    if @transfer.update_attributes(transfer_params)
      render json: @transfer
    else
      render json: { errors: @transfer.errors }, status: 400
    end
  end

  def destroy
    if @transfer.destroy
      render json: { message: "Deleted"}, status: 204
    else
      render json: { errors: @transfer.errors }, status: 400
    end
  end

  private
  def transfer_params
    params.permit(:account_number_from, :account_number_to,
                  :country_code_from, :country_code_to,
                  :amount_pennies)
  end

  def authenticate
    unless params[:auth_token] && @current_user = User.find_by_authentication_token(params[:auth_token])
      render json: { message: "Unauthorized"}, status: 401
      return false
    end
  end

  def load_user
    @user = User.find_by_id(params[:user_id])

    unless @user
      render json: { message: "User not found"}, status: 404
      return false
    end

    if @user != @current_user
      render json: { message: "Forbidden"}, status: 403
      return false
    end
  end

  def load_transfer
    @transfer = @user.transfers.find_by_id(params[:id])

    unless @transfer
      render json: { message: "Transfer not found"}, status: 404
      return false
    end
  end
end
