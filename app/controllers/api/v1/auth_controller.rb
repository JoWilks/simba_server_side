class Api::V1::AuthController < ApplicationController
    skip_before_action :authorized, only: [:create]
 
    def create
      @user = User.find_by(username: user_login_params[:username])
      #User#authenticate comes from BCrypt
      if @user && @user.authenticate(user_login_params[:password])
          # encode token comes from ApplicationController
          token = encode_token({ user_id: @user.id })
          
          #check that access_token exists
          if @user.access_token
          #Check whether access_token still valid, if not send refresh for new one
          access_token_response = @user.check_access_token_valid
          
                if access_token_response["authenticated"]
                  
                  access_token = JWT.decode(@user.access_token, 'my_s3cr3t', true, algorithm: 'HS256')
                  render json: { user: UserSerializer.new(@user), jwt: token, access_token: access_token[0]["access_token"] }, status: :accepted
                else 
                  refresh_token_response = @user.send_for_refresh_token
                  
                    if refresh_token_response["access_token"]
                      encoded_access_token = JWT.encode({ access_token: refresh_token_response["access_token"] }, 'my_s3cr3t')
                      @user.update(access_token: encoded_access_token)
                      render json: { user: UserSerializer.new(@user), jwt: token, access_token: refresh_token_response["access_token"] }, status: :accepted
                    else
                      render json: { user: UserSerializer.new(@user), jwt: token, message: refresh_token_response["message"] }
                    end
                end

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
