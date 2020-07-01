class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  has_many :messages, foreign_key: 'to'

  validates :name, :email, :password, :password_confirmation, presence: true

  enum permission: { normal: 0, master: 1 }

  before_create :create_token

  # get all sent messages from user
  def messages_sent
    Message.sent_from(self)
  end

  protected

  # callback to create api token when user is created
  def create_token
    self.token = name.first(4).upcase + Time.now.strftime("%H:%M:%S").strip().to_s.gsub(/[^\d]/, "")
  end
end
