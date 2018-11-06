class Api::V1::AuthController < ApplicationController
    skip_before_action :authorized, only: [:create]
 
    def create
      @user = User.find_by(username: user_login_params[:username])
      #User#authenticate comes from BCrypt
      if @user && @user.authenticate(user_login_params[:password])
        # encode token comes from ApplicationController
        token = encode_token({ user_id: @user.id })
        # auth_token = encode_token({ auth_token: @user.auth_token })
        if (@user.access_token)
          access_token = JWT.decode(@user.access_token, ENV['secret'], true, algorithm: 'HS256')
          render json: { user: UserSerializer.new(@user), jwt: token, access_token: access_token[0]["access_token"] }, status: :accepted
        else
          render json: { user: UserSerializer.new(@user), jwt: token }, status: :accepted
        end
      else
        render json: { message: 'Invalid username or password' }, status: :unauthorized
      end
    end
   
    private
   
    def user_login_params
      # params { user: {username: 'Chandler Bing', password: 'hi' } }
      params.require(:user).permit(:username, :password, :temp_auth_code)
    end
end
