class Message < ApplicationRecord
  attr_accessor :receiver_email

  belongs_to :sender, class_name: 'User', foreign_key: 'from'
  belongs_to :receiver, class_name: 'User', foreign_key: 'to'

  delegate :name,:email, to: :sender, prefix: true
  delegate :name, to: :receiver, prefix: true

  validates :title, :content, :from, :to, presence: true

  enum status: { unread: 0, read: 1, archived: 2 }

  scope :sent_to, -> (user) { includes(:sender).where(to: user.id).where.not(status: 2) }
  scope :sent_from, -> (user) { includes(:receiver).where(from: user.id).where.not(status: 2) }
  scope :all_sent_to, -> (user) { where(to: user.id) }
  scope :ordered, -> { order('created_at DESC') }
  scope :master_messages, -> { includes(:sender).where.not(status: 2) }

  before_update :update_tracker

  private

  # callback on update
  def update_tracker
    return unless status_changed?

    # only update visualized if status change from unread
    if read? && status_was == 'unread'
      self.visualized = Time.now
    # only update archived if status wasn't already archived
    elsif archived? && status_was != 'archived'
      self.archived = Time.now
    end
  end
end
