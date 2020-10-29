class WebhookService
  def self.log(request)
    new(request).build_response
  end

  def build_response
    { string: process_ids, status: 202 }
  end

  # def process
  #   EventService.new(@events).process_events
  # end

  def initialize(request)
    @webhook = Webhook.create
    @events = create_events(request)
  end

  def create_events(request)
    request[:events].map do |event|
      Event.create(
        webhook: @webhook,
        fs_id: event[:id],
        fs_type: event[:type],
        data: event[:data]
      )
    end
  end

  def process_events
    EventService.new(@events).process_all_events
  end

  def process_ids
    response_string = ''
    process_events.each_with_index do |event, index|
      response_string << event
      if index != (process_events.length - 1)
        response_string << '\n'
      end
    end
    response_string
  end
end
