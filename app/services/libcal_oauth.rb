class LibcalOauth
  URL = "https://api2.libcal.com/1.1/oauth/token"

  def self.default_token
    @@default_token ||= begin
        client_id = ENV.fetch("LIBCAL_CLIENT_ID")
        client_secret = ENV.fetch("LIBCAL_CLIENT_SECRET")
        LibcalOauth.new(client_id, client_secret)
      end
  end

  def initialize(id, secret)
    @id = id
    @secret = secret
    @auth_token = nil
    @expires_at = Time.current
  end

  def auth_token
    return @auth_token unless expired?

    get_auth_token
  end

  def expired?
    @expires_at <= Time.current
  end

  private

  def get_auth_token
    authToken = [@id, @secret].join(":")
    authTokenEncoded = Base64.encode64(authToken)
    oauthRequestPayload = {
                            grant_type: "client_credentials",
                            username: @id,
                            password: @secret,
                            scope: "",
                          }

    headers = { Authorization: "Basic #{authTokenEncoded}" }

    request = RestClient.post(URL, oauthRequestPayload, headers)
    response = JSON.parse(request.body)
    @expires_at = Time.current + response.fetch("expires_in").to_i.seconds
    @auth_token = response.fetch("access_token")

    @auth_token
  end
end
