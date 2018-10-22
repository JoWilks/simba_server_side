class Api::V1::UsersController < ApplicationController
    skip_before_action :authorized, only: [:create]
    
    def index
      @users = User.all
      render json: {users: @users}
    end
    
    def create
      @user = User.create(user_params)
      if @user.valid?
        Category.create_base_categories(@user.id)  #creates and associates base categories with newly created user
        @token = encode_token(user_id: @user.id)
        render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
      else
        render json: { error: 'failed to create user' }, status: :not_acceptable
      end
    end

    def validate
      user = current_user
      if user
          render json: { id: user.id, username: user.username }
      else
          render json: {error: 'Validation failed.', status: 400}
      end
    end

    def exchange
      user = current_user
      response = user.exchange_token(token_params["auth_token"])
      if response["access_token"]
        access_token = JWT.encode({ access_token: response["access_token"] }, 'my_s3cr3t')
        refresh_token = JWT.encode({ response_token: response["refresh_token"] }, 'my_s3cr3t')
        user.update( access_token: access_token, refresh_token: refresh_token )
        render json: { access_token: response["access_token"] }
      else
        render json: { response: response }, status: :failed
      end
    end
   
    def refresh
      user = current_user
      response = user.send_for_refresh_token
      if response["access_token"]
        render json: { access_token: response["access_token"]}
      else
        render json: {response: response}, status: :failed
      end
    end

    private
   
    def user_params
      params.require(:user).permit(:username, :password)
    end

    def token_params
      params.require(:exchange).permit(:auth_token)
    end


end
