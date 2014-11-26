class Car < ActiveRecord::Base
  belongs_to :owner, class_name: "Person", foreign_key: "owner_id"
  has_many :place_rents
  validates :registration_number, :model, :owner, presence: true
  validates_size_of :image, maximum: 200.kilobytes
  validates_property :format, of: :image, in: ['jpeg', 'png', 'gif', 'jpg']

  dragonfly_accessor :image

  def to_param
     "#{id}-#{model.parameterize}"
  end

end

