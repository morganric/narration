class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?
  paginates_per 10

  after_create :create_profile

  def set_default_role
    self.role ||= :user
  end

  validates_exclusion_of :name, :in => %w( inboxes message discussions search feedback tedx users feeds photos videos items oembed api facebook new popular featured favicon superuser 
    pages partners categories category creators platforms media posts authors types providers tagged ), :message => "Sorry, try something else"


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

   has_many :posts, dependent: :destroy

   has_one :profile, dependent: :destroy
   has_many :listens, :dependent => :destroy
   has_many :listenings, :through => :listens, :source => :post

   has_many :user_favs
  has_many :favourites, through: :user_favs, :source => :post


  def create_profile
    @profile = Profile.new(:user_id => id)
    @profile.display_name = self.name
    @profile.save
  end

end
