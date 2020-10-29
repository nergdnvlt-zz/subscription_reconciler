class Api::V1::FastspringController < ApiController
  def create
    if fastspring_response
      render plain: @fastspring_response[:string], status: @fastspring_response[:status]
    else
      render status: 400
    end
  end

  def fastspring_response
    @fastspring_response ||= WebhookService.log(JSON.parse(params.to_json, symbolize_names: true))
  end
end
