class TransfersController < ActionController::Base
  before_action :load_user
  before_action :load_transfer, only: [:update, :show, :destroy]

  def index
    render json: @user.transfers
  end

  def show
    render json: @transfer
  end


  private
  def load_user
    @user = User.find_by_id(params[:user_id])

    unless @user
      render json: { message: "User not found"}, status: 404
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
