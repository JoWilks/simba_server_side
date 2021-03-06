require 'rest-client'

class User < ApplicationRecord
    has_secure_password
    validates :username, uniqueness: { case_sensitive: false}, length: { minimum: 5}, presence: true
    has_many :categories

    def redirect_to_monzo
        # client_id = "oauth2client_00009bXcTSHJgJqAJJ7L6X"
        redirect_uri = "https://zealous-kalam-8b6c52.netlify.com/"
        #some random string stored in env variable
        # state_token = "randomstring" 

        response = RestClient::Request.execute(
            method: :get,
            url: "https://auth.monzo.com/?
            client_id=#{ENV['client_id']}&
            redirect_uri=#{redirect_uri}&
            response_type=code&
            state=#{ENV['state_token']}"
        )
        data = JSON.parse(response)
    end

    def exchange_token(auth_token)
    RestClient::Request.execute(
        method: :post,
        url: "https://api.monzo.com/oauth2/token",
        payload: {  'grant_type': 'authorization_code', 
                    'client_id': ENV['client_id'],
                    'redirect_uri': 'https://zealous-kalam-8b6c52.netlify.com/',
                    'client_secret': ENV['client_secret'],
                    'code': auth_token,
                 }
        ){|response, request, result| 
            data = JSON.parse(response)
            return data
        }
    end

    def send_refresh_token()
        refresh_token = JWT.decode(self.refresh_token, ENV['Secret'], true, algorithm: 'HS256') #get this from env file?
        response = RestClient::Request.execute(
            method: :post,
            url: "https://api.monzo.com/oauth2/token",
            payload: {  'grant_type': 'refresh_token', 
                        'client_id': ENV['client_id'],
                        'client_secret': ENV['client_secret'],
                        'refresh_token': refresh_token[0]["response_token"]
                     }
            )
            data = JSON.parse(response)
            
        end

end
