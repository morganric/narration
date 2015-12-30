json.array!(@listens) do |listen|
  json.extract! listen, :id, :user_id, :post_id
  json.url listen_url(listen, format: :json)
end
