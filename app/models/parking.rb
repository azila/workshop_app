class Parking < ActiveRecord::Base
  belongs_to :address
  belongs_to :owner, class_name: "Person", foreign_key: "owner_id"
  has_many :place_rents
  KINDS = ['outdoor', 'indoor', 'private', 'street']
  validates :places, :hour_price, :day_price, presence: true
  validates :kind, inclusion: { in: KINDS, :message => "must be one of: #{KINDS.join(', ')}"}
  validates :hour_price, :day_price, :places, :numericality => {:greater_than => 0}
  accepts_nested_attributes_for :address

  before_destroy :finish_rentals

  scope :public_parkings, -> { where("kind IS NOT ?", "private") }
  scope :private_parkings, -> { where(kind: 'private') }
  scope :day_price_within_range, ->  (from, to) { where("day_price between ? and ?", (from || 0), (to || Float::MAX)) }
  scope :hour_price_within_range, -> (from, to) { where("hour_price between ? and ?", (from || 0), (to || Float::MAX)) }
  scope :located_in, -> (city) { joins(:address).where(" addresses.city = ?", city) }

  self.per_page = 5

  def finish_rentals
    place_rents.open_and_future.each(&:finish)
  end

  def self.search(criteria)
    found_parkings = Parking.all
    
    unless criteria[:public].present? && criteria[:private].present?
      if criteria[:private] == "1"
        found_parkings = found_parkings.private_parkings
      end
      if criteria[:public] == "1"
        found_parkings = found_parkings.public_parkings
      end
    end

    if criteria[:location].present?
      found_parkings = found_parkings.located_in(criteria[:location])
    end
    found_parkings = found_parkings.day_price_within_range(criteria[:day_price_min].presence, criteria[:day_price_max].presence)
    found_parkings = found_parkings.hour_price_within_range(criteria[:hour_price_min].presence, criteria[:hour_price_max].presence)
    
    found_parkings
  end

end

