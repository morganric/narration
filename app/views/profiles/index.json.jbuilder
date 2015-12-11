json.array!(@profiles) do |profile|
  json.extract! profile, :id, :user_id, :display_name, :image, :banner, :slug, :bio, :website, :twitter
  json.url profile_url(profile, format: :json)
end
