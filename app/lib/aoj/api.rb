require 'net/http'
require 'uri'
require 'json'

class Aoj::Api

  AOJ_BASE_URI = 'https://judgeapi.u-aizu.ac.jp'

  def api_get(path, params = {})
    request_api('get', path, params)
  rescue Exception => e
    raise e
  end

  def api_post(path, params = {})
    request_api('post', path, params)
  rescue Exception => e
    raise e
  end


  private

  def request_api(method, path, params = {})
    raise Exception, 'pathを設定してください' unless path.present?

    uri = URI.parse("#{AOJ_BASE_URI}/#{path}")
    case method
    when 'get'
      uri.query = URI.encode_www_form(params)
      req = Net::HTTP::Get.new uri
    when 'post'
      req = Net::HTTP::Post.new uri.path
      req.content_type = 'application/json'
      req.body = params.to_json
    else
      raise Exception, "想定外のmethod(#{method})です"
    end
    p "#{method.upcase} #{uri}"
    begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      response = http.request req
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

