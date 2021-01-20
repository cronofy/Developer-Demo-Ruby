class CalendarsController < ApplicationController
  before_action :preload_user

    def index
      @authorization_url = @cronofy.user_auth_link('http://localhost:3000/oauth2/callback')
      @calendars = @cronofy.list_calendars
    end

    def show
      time = Time.new(2021, 1, 20).change({ hour: 9 })
      id = [params[:id]]

      @request = {
        "participants": [
          {
            "members": [
              {
                "sub": @user.account_id,
                "calendar_ids": id
              }
            ],
            "required": "all"
          }
        ],
        "response_format": "slots",
        "required_duration": { "minutes": 60 },
        "available_periods": [
          {
            "start": time.change({ hour: 9 }),
            "end": time.change({ hour: 17 })
          },
          {
            "start": time.change({ day: 21, hour: 9 }),
            "end": time.change({ day: 21, hour: 17 })
          }
        ]
      }

      @available_periods = @cronofy.availability(@request)
    end

  def create
    calendar_id = params[:id]
    startTime = Time.parse(params[:slot].split[0])
    endTime = Time.parse(params[:slot].split[1])

    @event_data = {
      event_id: 'uniq-id',
      summary: 'Demo event summary',
      description: 'Demo event description',
      start: startTime,
      end: endTime,
      location: {
        description: "Meeting room"
      }
    }

    @cronofy.upsert_event(calendar_id, @event_data)
  end

  def preload_user
    client_id =     Rails.application.credentials[:cronofy][:client_id]
    client_secret = Rails.application.credentials[:cronofy][:client_secret]

    @user = User.first

    @cronofy = Cronofy::Client.new(
        client_id:     client_id,
        client_secret: client_secret,
        access_token: @user.access_token,
        refresh_token: @user.refresh_token
    )
  end

end
