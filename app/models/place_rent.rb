class PlaceRent < ActiveRecord::Base
  belongs_to :parking
  belongs_to :car
  validates :start_date, :end_date, :parking, :car, presence: true

  before_save :calculate_price
  scope :open_and_future, -> { where("end_date >= ?", DateTime.now) }

  before_create :generate_identifier

  def finish 
    update_attribute(:end_date, DateTime.now)
  end

  def generate_identifier
    self.identifier = SecureRandom.uuid 
  end

  def to_param
    self.identifier
  end

  private 
    def calculate_price
      self.price = parking.day_price.to_i * days_spent + parking.hour_price.to_i * hours_spent
    end

    def days_spent
      (end_date.to_date - start_date.to_date).to_i
    end

    def hours_spent
      ((end_date - start_date)%1.day/3600).ceil
    end

end

