class CalendarsController < ApplicationController
  before_action :preload_cronofy

    def show
      sub = @user.account_id
      time = Time.now + 1.days
      @calendar = [params[:id]]
      @duration_minutes = 60

      @request = {
        "participants": [
          {
            "members": [
              {
                "sub": sub
              }
            ],
          }
        ],
        "response_format": "slots",
        "required_duration": { "minutes": @duration_minutes },
        "available_periods": [
          {
            "start": time.change({ hour: 9 }),
            "end": time.change({ hour: 17 })
          },
          {
            "start": time.change({hour: 9 }) + 1.days,
            "end": time.change({hour: 17 }) + 1.days
          }
        ]
      }

      @available_periods = @cronofy.availability(@request)
    end

  def create
    calendar_id = params[:id]
    start_time = Time.parse(params[:slot])
    end_time = start_time + params[:duration_minutes].to_i.minutes

    @event_data = {
      event_id: 'uniq-id',
      summary: 'Demo event summary',
      description: 'Demo event description',
      start: start_time,
      end: end_time,
      location: {
        description: "Meeting room"
      }
    }

    @cronofy.upsert_event(calendar_id, @event_data)
  end

  def preload_cronofy
    @user = User.first
    @cronofy = cronofy_client(User.first)
  end

end
