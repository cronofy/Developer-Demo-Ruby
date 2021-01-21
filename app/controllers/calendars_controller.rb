class CalendarsController < UsersController
before_action :preload_client

    def show
      sub = User.first.account_id
      time = Time.new(2021, 1, 23).change({ hour: 9 })
      id = [params[:id]]
      @duration_minutes = 60

      @request = {
        "participants": [
          {
            "members": [
              {
                "sub": sub,
                "calendar_ids": id
              }
            ],
            "required": "all"
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
            "start": time.change({ day: 24, hour: 9 }),
            "end": time.change({ day: 24, hour: 17 })
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

end
