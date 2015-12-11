json.array!(@posts) do |post|
  json.extract! post, :id, :title, :url, :audio, :audio_link, :summary, :image, :user_id, :slug, :plays, :banner, :tag_list, :hidden, :featured, :html, :body
  json.url post_url(post, format: :json)
end
