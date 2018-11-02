require 'net/http'
require 'uri'
require 'json'

class Aoj::Api

  AOJ_URI = 'https://judgeapi.u-aizu.ac.jp'

  def api_get(path, params = {})
    request_api('get', path, params)
  end


  private

  def request_api(method, path, params = {})
    raise Exception, 'pathを設定してください' unless path.present?

    endpoint = "#{AOJ_URI}/#{path}"
    encoded_params = URI.encode_www_form(params)
    endpoint += '?' + encoded_params if encoded_params.present?
    p "#{method.upcase} #{endpoint}"
    uri = URI.parse(endpoint)
    begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      response = http.send(method, uri.request_uri)
      case response
      when Net::HTTPSuccess
        response = JSON.parse(response.body)
      else
        raise Exception, "エラー: code=#{response.code} message=#{response.message}"
      end

      response
    rescue => e
      raise Exception, e.message
    end
  end
end

