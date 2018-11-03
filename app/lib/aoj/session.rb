class Aoj::Session < Aoj::Api

  def create(id, password)
    begin
      convert_to_user_model_atter_hash(api_create({id: id, password: password}))
    rescue Exception => e
      p e
      nil # ログイン失敗とする
    end
  end

  def destroy
    begin
      api_destroy
    rescue Exception => e
      p e
      raise Exception, e
    end
  end

  private

  def api_create(params)
    api_post('session', params)
  end

  def api_destroy
    api_delete('session')
  end

  def convert_to_user_model_atter_hash(response)
    time = response['lastSubmitDate']
    last_submit_at = Time.at(time / 1000.0)
    {
      code:           response['id'],
      name:           response['name'],
      last_submit_at: last_submit_at,
      submissions:    response['status']['submissions'],
      solved:         response['status']['solved'],
      accepted:       response['status']['accepted'],
      wronganswer:    response['status']['wrongAnswer'],
      timelimit:      response['status']['timeLimit'],
      memorylimit:    response['status']['memoryLimit'],
      outputlimit:    response['status']['outputLimit'],
      compileerror:   response['status']['compileError'],
      runtimeerror:   response['status']['runtimeError']
    }
  end
end
