class Api::V1::UsersController < ApplicationController
    skip_before_action :authorized, only: [:create]
 
    def index
      @users = User.all
      render json: {users: @users}
    end
    
    def create
      @user = User.create(user_params)
      if @user.valid?
        @token = encode_token(user_id: @user.id)
        render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
      else
        render json: { error: 'failed to create user' }, status: :not_acceptable
      end
    end

    def validate
      user = current_user
      if user
          render json: {id: user.id, username: user.username}
      else
          render json: {error: 'Validation failed.', status: 400}
      end
    end
   
    private
   
    def user_params
      params.require(:user).permit(:username, :password)
    end


end
