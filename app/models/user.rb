class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  has_many :messages, foreign_key: 'to'

  validates :name, :email, presence: true, on: :create
  validates :email, uniqueness: true

  enum permission: { normal: 0, master: 1 }

  before_create :create_token

  # get all sent messages from user
  def messages_sent
    Message.sent_from(self)
  end

  protected

  def token_first_half
    self.name.gsub(/\s+/, '').first(4).upcase
  end

  def token_last_half
    Time.now.strftime("%H:%M:%S").strip().to_s.gsub(/[^\d]/, "")
  end

  # callback to create api token when user is created
  def create_token
    self.token = "#{token_first_half + token_last_half}"
  end
end
