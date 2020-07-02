module ResponseManager
  def json_response(object, serializer = nil, status = :ok)
    serialized_object = serializer.nil? ? object : serializer.new(object).as_json

    render json: serialized_object, status: status
  end
end
