module ResponseManager
  def json_renderer(object, status = :ok, serializer = nil)
    render json: object, status: status, serializer: serializer
  end
end
