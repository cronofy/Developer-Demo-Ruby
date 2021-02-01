class UsersController < ApplicationController
  def index
    if User.first
      @cronofy = cronofy_client(User.first)
      @calendars = @cronofy.list_calendars
    else
      @cronofy = cronofy_client
      @calendars = []
    end

    @authorization_url = @cronofy.user_auth_link('http://localhost:3000/oauth2/callback')
  end

  def connect
    @cronofy = cronofy_client
    code = [params[:code]]
    response = @cronofy.get_token_from_code(code, 'http://localhost:3000/oauth2/callback')

    if User.where(account_id: response.account_id).exists?
      user = User.find_by(account_id: response.account_id)
      user.update(access_token: response.access_token, refresh_token: response.refresh_token)
      user.save
    else
      User.create(account_id: response.account_id, access_token: response.access_token,
                         refresh_token: response.refresh_token)
    end

    redirect_to root_path
  end
end
