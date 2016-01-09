Maktoub.from = "Narrated Org <narratedorg@gmail.com>" # the email the newsletter is sent from
Maktoub.twitter_url = "http://twitter.com/#!/narrated_org" # your twitter page
# Maktoub.facebook_url = "http://www.facebook.com/facebook" # your facebook page
# Maktoub.linkedin_url = "http://www.linkedin.com/company/linkedin" # your linkedin page
Maktoub.subscription_preferences_url = "http://www.narrated.org/users/edit" #subscribers management url
Maktoub.logo = "http://res.cloudinary.com/narration/image/upload/v1451762450/narrated_banner_trans.png" # path to your logo asset
Maktoub.home_domain = "narrated.org" # your domain
Maktoub.app_name = "Narrated.org" # your app name
 Maktoub.unsubscribe_method = "unsubscribe" # method to call from unsubscribe link (doesn't include link by default)

# pass a block to subscribers_extractor that returns an object that  reponds to :name and :email
# (fields can be configured as shown below)

users = []

require "ostruct"
Maktoub.subscribers_extractor do
  User.where(:unsubscribe => false).each do |i|
  	# if i.unsubscribe == false
    users << OpenStruct.new({name: "#{i.name}", email: "#{i.email}"})
	# end
  end
end

# uncomment lines below to change subscriber fields that contain email and
	# Maktoub.email_field = :email
	# Maktoub.name_field = :name
