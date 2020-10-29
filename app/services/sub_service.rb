class SubService
  def initialize(sub_event)
    @type = sub_event.fs_type
    @id = sub_event.fs_id
    @sub_info = sub_event.data.symbolize_keys
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
    if sub.next_charge_date > seconds_to_date(@sub_info[:nextInSeconds])
      sub_date_job(save_rebilled_sub)
    else
      save_sub
    end
  end

  def save_sub(sub)
    sub.update(
      active: @sub_info[:active],
      state: @sub_info[:state],
      term: @sub_info[:intervalUnit],
      next_charge_date: seconds_to_date(@sub_info[:nextInSeconds]),
      product: @sub_info[:product],
      product_display: @sub_info[:display],
      account_id: @sub_info[:account]
    )
  end

  def sub_date_job
    # Send request to update /sub with XSolla's new billing date
  end

  def save_rebilled_sub
    @sub.update(
      active: @sub_info[:active],
      state: @sub_info[:state],
      term: @sub_info[:intervalUnit],
      product: @sub_info[:product],
      product_display: @sub_info[:display],
      account_id: @sub_info[:account]
    )
  end

  def sub
    @sub = Sub.find_by(xsolla_id: @sub_info[:customReferenceId])
  end

  def seconds_to_date(seconds)
    Date.strptime(seconds.to_s, '%s')
  end
end
