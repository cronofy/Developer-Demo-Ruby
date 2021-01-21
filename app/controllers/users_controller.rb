class UsersController < ApplicationController
before_action :preload_client

    def index
        @authorization_url = @cronofy.user_auth_link('http://localhost:3000/oauth2/callback')

        @calendars = @cronofy.list_calendars
    end

    def connect
        code = [params[:code]]
        response = @cronofy.get_token_from_code(code, 'http://localhost:3000/oauth2/callback')

        if User.where(account_id: response.account_id).exists?
            user = User.find_by(account_id: response.account_id)
            user.update(access_token: response.access_token, refresh_token: response.refresh_token)
            user.save

        else 
            user = User.create(account_id: response.account_id, access_token: response.access_token, refresh_token: response.refresh_token)
        end

        redirect_to root_path
    end

    def preload_client
        client_id =     Rails.application.credentials[:cronofy][:client_id]
        client_secret = Rails.application.credentials[:cronofy][:client_secret]

        @cronofy = Cronofy::Client.new(
            client_id:     client_id,
            client_secret: client_secret,
            access_token: User.first.access_token,
            refresh_token: User.first.refresh_token
        )
    end

end
