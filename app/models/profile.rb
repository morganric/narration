class Profile < ActiveRecord::Base

mount_uploader :image, ImageUploader

 belongs_to :user

 
 def username
  	self.user.name
  end

 extend FriendlyId
  friendly_id :username, use: :slugged


end
