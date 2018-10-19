require 'rest-client'

class User < ApplicationRecord
    has_secure_password
    validates :username, uniqueness: { case_sensitive: false}, length: { minimum: 5}, presence: true
    has_many :categories

    def redirect_to_monzo
        client_id = "oauth2client_00009bXbTwawriRvwomm8n"
        redirect_uri = "https://zealous-kalam-8b6c52.netlify.com/login"
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

    def exchange_token
    response = RestClient::Request.execute(
        method: :post,
        url: "https://api.monzo.com/oauth2/token",
        payload: {  'grant_type': 'authorization_code', 
                    'code': 'eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJlYiI6ImdmWmJMdW1ZakhBQ3ZpQjVjN3F1IiwianRpIjoiYXV0aHpjb2RlXzAwMDA5YnNPdFBNNXF5QTNJa284VEIiLCJ0eXAiOiJhemMiLCJ2IjoiNSJ9.QytaLtpJoZwfHxb7dTaWB94MwFi02UgCVERvnZWhFml9aTUl98qVFhi2kIo7sGx7AahE_A9-jXQU10whmo1Wkw',
                    'client_id': 'oauth2client_00009bXcUYcbaBlM4oMMqX',
                    'client_secret': 'mnzpub.4SIcUmdjk6TAj8EyelSL5RS6sOCj+LB/LhiQt1NsmyQzWJ8Hwqbr39evxUfZHp2yGN7US1pDwwu5Y7boLIb5',
                    'redirect_uri': 'https://zealous-kalam-8b6c52.netlify.com/'
                 }
        )
        data = JSON.parse(response)
    end

end
