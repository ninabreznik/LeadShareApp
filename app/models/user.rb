class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_messageable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_many :orders, foreign_key: "selector_id"
  has_many :selected_leads, through: :orders, source: :selected
  has_many :leads, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :likes, as: :likeable

  has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_size :picture, less_than: 1.megabytes
  validates_attachment_content_type :picture, content_type: ["image/jpeg", "image/png", "image/jpg", "image/bmp"]
  validates :picture_file_name, length: { maximum: 150 }


   # #############################################################################
  # Order between User and Lead
  # #############################################################################
  def selecting?(one_lead)
    orders.find_by_selected_id(one_lead.id)
  end

  def select!(one_lead)
    orders.create!(selected_id: one_lead.id)
  end

   # #############################################################################
  # Like // User and Project
  # #############################################################################
  def liking?(one_project)
    self.likes.find_by_likeable_id(one_project.id)
  end

  def like!(one_project)
    self.likes.create!(likee_id: one_project.id)
  end

  private

#Mailboxer

  def name
    email
  end

  def mailboxer_email(object)
    email
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.name   # assuming the user model has a name
      picture_from_url(auth.info.image)
      user.picture = auth.info.image # assuming the user model has an image
      UserMailer.welcome_email(user, user.password).deliver
      User.find_by_id(1).send_message(beta, "Hi, this is Nina from ZweiDesign. Congrats on creating your account. I noticed you haven't set up your profile. The longer you wait, the more clients you're missing out on. Log in, add your information, and upload the best three examples of your work. Once you do, I'll have a chance to review your profile. If you have questions, please contact me and I'll get back to you shortly.", ":)")
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def picture_from_url(url)
    self.picture = URI.parse(url)
  end


end
