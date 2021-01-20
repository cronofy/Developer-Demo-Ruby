class ApplicationController < ActionController::Base
    rescue_from Cronofy::AuthenticationFailureError, with: :refresh_access_token

    private
    def refresh_access_token
        client_id =     Rails.application.credentials[:cronofy][:client_id]
        client_secret = Rails.application.credentials[:cronofy][:client_secret]

        @user = User.first

        @cronofy = Cronofy::Client.new(
        client_id:     client_id,
        client_secret: client_secret,
        access_token:  @user.access_token,
        refresh_token: @user.refresh_token
        )

        response = @cronofy.refresh_access_token

        if User.where(refresh_token: response.refresh_token).exists?
        user = User.find_by(refresh_token: response.refresh_token)
        user.update(access_token: response.access_token)
        user.save
        redirect_to root_path    
        else 
        redirect_to root_path
        end
    end
end
