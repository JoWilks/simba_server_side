require 'rest-client'

class User < ApplicationRecord
    has_secure_password
    validates :username, uniqueness: { case_sensitive: false}, length: { minimum: 5}, presence: true
    has_many :categories

    def redirect_to_monzo
        client_id = "oauth2client_00009bXcTSHJgJqAJJ7L6X"
        redirect_uri = "https://zealous-kalam-8b6c52.netlify.com/"
        #some random string stored in env variable
        state_token = "randomstring" 

        response = RestClient::Request.execute(
            method: :get,
            url: "https://auth.monzo.com/?
            client_id=#{client_id}&
            redirect_uri=#{redirect_uri}&
            response_type=code&
            state=#{state_token}"
        )
        data = JSON.parse(response)
    end

    def exchange_token(auth_token)
        RestClient::Request.execute(
            method: :post,
            url: "https://api.monzo.com/oauth2/token",
            payload: {  'grant_type': 'authorization_code', 
                        'client_id': 'oauth2client_00009bXcTSHJgJqAJJ7L6X',
                        'redirect_uri': 'https://zealous-kalam-8b6c52.netlify.com/',
                        'client_secret': 'mnzconf.Z8Xb0mhAD5Y3nSmenAa+IOnuSrMxJB758d9Dq/Q2+kWHPVv6Jwmrns9Ubw3zdaKhTgR4AauFYWDsIJ/bSqVU',
                        'code': auth_token,
                    }
            ){|response, request, result| 
                data = JSON.parse(response)
                return data
            }
    end

    def check_access_token_valid
        access_token = JWT.decode(self.refresh_token, 'my_s3cr3t', true, algorithm: 'HS256')
        RestClient::Request.execute(
            method: :get,
            url: "https://api.monzo.com/ping/whoami",
            headers: {'Authorization': "Bearer #{access_token}"}
            ){|response, request, result| 
                data = JSON.parse(response)
                return data
            }
    end

    def send_for_refresh_token
        refresh_token = JWT.decode(self.refresh_token, 'my_s3cr3t', true, algorithm: 'HS256') #get secret from env file?
        response = RestClient::Request.execute(
            method: :post,
            url: "https://api.monzo.com/oauth2/token",
            payload: {  'grant_type': 'refresh_token', 
                        'client_id': 'oauth2client_00009bXcTSHJgJqAJJ7L6X',
                        'client_secret': 'mnzconf.Z8Xb0mhAD5Y3nSmenAa+IOnuSrMxJB758d9Dq/Q2+kWHPVv6Jwmrns9Ubw3zdaKhTgR4AauFYWDsIJ/bSqVU',
                        'refresh_token': refresh_token[0]["response_token"]
                     }
            ){|response, request, result|
            byebug 
            data = JSON.parse(response)
            return data
            }
        end

end
