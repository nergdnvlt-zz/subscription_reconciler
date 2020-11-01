class FastspringService
  def initialize(sub)
    @sub = sub
  end

  def post_sub_update
    resp = fs_response
    return true if resp.status == 200

    false
  end

  def fs_response
    conn = Faraday.new(
      url: 'https://api.fastspring.com',
      headers: {'Content-Type': 'application/json'}
    )
    conn.basic_auth(auth[:username], auth[:password])
    conn.post('/subscriptions') do |req|
      req.body = post_body.to_json
    end
  end

  def auth
    {
      username: Rails.application.credentials.fastspring[:username],
      password: Rails.application.credentials.fastspring[:password]
    }
  end

  def post_body
    {
      "subscriptions": [
        {
          "subscription": @sub.fs_id,
          "next": @sub.next_charge_date.strftime('%Q')
        }
      ]
    }
  end

  def cancel_sub
    resp = fs_cancel_response
    return true if resp.status == 200

    false
  end

  def fs_cancel_response
    conn = Faraday.new(
      url: 'https://api.fastspring.com',
      headers: {'Content-Type': 'application/json'}
    )
    conn.basic_auth(auth[:username], auth[:password])
    conn.delete("/subscriptions/#{@sub.fs_id}")
  end
end
