class User < ActiveRecord::Base
  FAKE_PASSWORD = SecureRandom.urlsafe_base64
  has_one :cart
  has_many :orders
  has_many :comments

  has_secure_password validations: false
  validates :password, presence: true, on: :create, length: {minimum: 5}
  validates :password, on: :update, length: {minimum: 5}, allow_blank: true
  validates_confirmation_of :password
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => /@/

  def admin?
    self.role == "admin"
  end

  def self.fake_mail(uid)
    "#{uid}@hanchor.fake.com"
  end

  def self.find_or_create_from_omniauth(auth)
    errors = []
    info = auth.extra.raw_info
    info.email = User.fake_mail(auth.uid) if info.email.blank?
    
    user = find_or_initialize_by(email: info.email)
    user.password = User::FAKE_PASSWORD if  user.password_digest.nil?
    user.name = info.name
    user.avatar = auth["info"]["image"]
    user.gender = info.gender
    user.provider = auth.provider
    user.uid = auth.uid
    user.save
    user
  end
end
