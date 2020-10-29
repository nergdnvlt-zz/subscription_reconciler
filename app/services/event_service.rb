class EventService
  def process_all_events
    @events.map do |event|
      process_event(event)
    end
  end

  def initialize(events)
    @events = events
  end

  def process_event(event)
    case event.fs_type
    when 'subscription.activated'
      SubService.new(event).eval_activation
    when 'subscription.charge.completed'
      complete_charge(event.data)
    when 'subscription.cancelled'
      cancel(event.data)
    when 'subscription.deactivated'
      deactivate(event.data)
    end
  end
end
