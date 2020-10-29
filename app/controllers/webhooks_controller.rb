class WebhooksController < ApplicationController
  def index
    @webhooks = Webhook.all
    binding.pry
  end
end
