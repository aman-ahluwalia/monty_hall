class User < ApplicationRecord
  has_many :games, dependent: :destroy 

  has_secure_password
 
  VALID_USERNAME_MATCHER = /\A[a-zA-Z0-9_]+\z/
  VALID_EMAIL_MATCHER = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: VALID_EMAIL_MATCHER }

  # validates :name,
  #           presence: true,
  #           uniqueness: true,
  #           format: { with: VALID_USERNAME_MATCHER },
  #           length: { maximum: 20 }

  before_save :downcase_email, :strip_input_values

  def self.from_auth(params)
    params = params.with_indifferent_access
    authorization = Authorization.find_or_initialize_by(provider: params[:provider], uid: params[:uid])
    if authorization.persisted?
      user = authorization.user
    else
      if params[:email].present?
        user = User.find_or_initialize_by(email: params[:email])
      else
        user = User.new(email: "#{params[:uid]}@facebook.com")
      end
    end

    authorization.secret = params[:secret]
    authorization.token  = params[:token]

    user.password = SecureRandom.hex if user.password.blank?
    # user.username = Rufus::Mnemo.from_integer(params[:uid].to_i) if user.username.blank?
    user.save!

    authorization.user_id ||= user.id
    authorization.save
    user
  end

  def downcase_email
    self.email.to_s.downcase!
  end

  def strip_input_values
    self.email.to_s.strip!
  end
end
