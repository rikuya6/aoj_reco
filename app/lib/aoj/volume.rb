module Aoj::Volume

  def get_volume_list
    @list ||= get_list
  end

  private

  def get_list
    api_get('problems/filters')['volumes']
  end
end
