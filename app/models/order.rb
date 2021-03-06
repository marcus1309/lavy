class Order < ApplicationRecord
  attr_accessor :pick_up_time_hs, :delivery_time_hs, :service_type

  belongs_to :user
  belongs_to :pick_up_guy, class_name: "User"
  belongs_to :delivery_guy, class_name: "User"
  belongs_to :laundromat
  has_many :reviews, dependent: :destroy

  validates :pick_up_time, :delivery_time, presence: true
  validate :delivery_time_after_pick_up_time

  monetize :amount_cents

  geocoded_by :address # this is the how
  after_validation :geocode, if: :will_save_change_to_address? # this is the do command

  private

  def delivery_time_after_pick_up_time
    errors.add(:delivery_time, 'must be after pick_up_time') if delivery_time <= pick_up_time
  end
end
