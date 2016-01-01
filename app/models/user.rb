class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  after_create :create_profile

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

   has_many :posts

   has_one :profile, dependent: :destroy
   has_many :listens, :dependent => :destroy
   has_many :listenings, :through => :listens, :source => :post


  def create_profile
    @profile = Profile.new(:user_id => id)
    @profile.display_name = self.name
    @profile.save
  end

end
