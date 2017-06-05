class SessionsController < ActionController::Base

  def create
    resource = User.find_for_database_authentication(:username=>params[:username])

    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:password])
     sign_in("user", resource)
     resource.generate_token

     render json: {auth_token: resource.authentication_token}
     return
   end
   invalid_login_attempt
  end

  private

  def invalid_login_attempt
  warden.custom_failure!
  render json: { message: "Unauthorized"}, status: 401
end

end
