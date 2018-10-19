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
        console.log(data)
    end

    def exchange_token(auth_token:)
    response = RestClient::Request.execute(
        method: :post,
        url: "https://api.monzo.com/oauth2/token",
        payload: {  'grant_type': 'authorization_code', 
                    'code': auth_token,
                    'client_id': 'oauth2client_00009bXcTSHJgJqAJJ7L6X',
                    'client_secret': 'mnzconf.Z8Xb0mhAD5Y3nSmenAa+IOnuSrMxJB758d9Dq/Q2+kWHPVv6Jwmrns9Ubw3zdaKhTgR4AauFYWDsIJ/bSqVU',
                    'redirect_uri': 'https://zealous-kalam-8b6c52.netlify.com/'
                 }
        )
        data = JSON.parse(response)
        
    end

    def refresh_token()
        refresh_token = 'fdsdfjsajdfk;a' #get this from env file?
        response = RestClient::Request.execute(
            method: :post,
            url: "https://api.monzo.com/oauth2/token",
            payload: {  'grant_type': 'refresh_token', 
                        'client_id': 'oauth2client_00009bXcTSHJgJqAJJ7L6X',
                        'client_secret': 'mnzconf.Z8Xb0mhAD5Y3nSmenAa+IOnuSrMxJB758d9Dq/Q2+kWHPVv6Jwmrns9Ubw3zdaKhTgR4AauFYWDsIJ/bSqVU',
                        'refresh_token': refresh_token
                     }
            )
            data = JSON.parse(response)
            
        end

end
