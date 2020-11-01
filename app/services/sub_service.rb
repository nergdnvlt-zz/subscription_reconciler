class SubService
  def initialize(sub_event)
    @type = sub_event.fs_type
    @id = sub_event.fs_id
    @sub_info = sub_event.data.symbolize_keys
    @sub = sub
  end

  def eval_activation
    if !@sub_info[:customReferenceId]
      activate_sub
    else
      reconcile_sub
    end
  end

  def activate_sub
    return @id if Sub.create(
      fs_id: @sub_info[:subscription],
      active: @sub_info[:active],
      state: @sub_info[:state],
      term: @sub_info[:intervalUnit],
      next_charge_date: seconds_to_date(@sub_info[:nextInSeconds]),
      product: @sub_info[:product],
      product_display: @sub_info[:display],
      account_id: @sub_info[:account]
    )
  end

  def reconcile_sub
    if @sub.state == 'cancelled'
      save_and_cancel_sub
    elsif @sub.next_charge_date > seconds_to_date(@sub_info[:nextInSeconds])
      sub_date_job
    else
      save_sub
    end
  end

  def sub_date_job
    return @id if FastspringService.new(save_rebilled_sub).post_sub_update
  end

  def save_rebilled_sub
    @sub.update(
      fs_id: @sub_info[:subscription],
      active: @sub_info[:active],
      state: @sub_info[:state],
      term: @sub_info[:intervalUnit],
      product: @sub_info[:product],
      product_display: @sub_info[:display],
      account_id: @sub_info[:account]
    )
    @sub.save
    @sub
  end

  def save_and_cancel_sub
    return @id if FastspringService.new(cancelled_sub).cancel_sub
  end

  def cancelled_sub
    @sub.update(
      fs_id: @sub_info[:subscription],
      product: @sub_info[:product],
      product_display: @sub_info[:display],
      account_id: @sub_info[:account]
    )
    @sub.save
    @sub
  end

  def save_sub
    @sub.update(
      fs_id: @sub_info[:subscription],
      active: @sub_info[:active],
      state: @sub_info[:state],
      term: @sub_info[:intervalUnit],
      next_charge_date: seconds_to_date(@sub_info[:nextInSeconds]),
      product: @sub_info[:product],
      product_display: @sub_info[:display],
      account_id: @sub_info[:account]
    )
    return @id if @sub.save
  end

  def sub
    @sub = Sub.find_by(xsolla_id: @sub_info[:customReferenceId])
  end

  def seconds_to_date(seconds)
    Date.strptime(seconds.to_s, '%s')
  end
end
