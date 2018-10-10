class User < ApplicationRecord
    has_secure_password
    validates :username, uniqueness: { case_sensitive: false}, length: { minimum: 5}

    def redirect_to_monzo
        client_id = "oauth2client_00009bXbTwawriRvwomm8n"
        redirect_uri = "http://localhost:3000/"
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


end