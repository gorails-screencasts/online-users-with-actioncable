class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :masqueradable, :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable

  has_person_name

  has_many :notifications, foreign_key: :recipient_id
  has_many :services

  #scope :online, ->{ where("last_seen_at > ?", 15.minutes.ago) }

  def self.online
    ids = ActionCable.server.pubsub.redis_connection_for_subscriptions.smembers "online"
    where(id: ids)
  end
end
