class SubService
  def initialize(sub_event)
    @type = sub_event.fs_type
    @id = sub_event.fs_id
    @sub_info = sub_event.data
  end

  def eval_activation
    if !@sub_info[:customReferenceId]
      activate_sub
    else
      reconcile_sub
    end
  end

  def activate_sub
    return @id if Sub.create!(
      fs_id: @sub_info[:subscription],
      active: @sub_info[:active],
      state: @sub_info[:state],
      term: @sub_info[:intervalUnit],
      next_charge_date: @sub_info[:nextDisplay],
      product: @sub_info[:product],
      product_display: @sub_info[:display],
      account_id: @sub_info[:account]
    )
  end

  # def reconcile_sub
  #   sub = Sub.find_by(xsolla_id: )
  #   return @id if 
  # end
end