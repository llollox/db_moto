class Model < ActiveRecord::Base
  # attr_accessible :name, :brand_id, :motoit_code
  belongs_to :brand
  has_many :bikes

  validates :name, :presence => true
  validates :brand_id, :presence => true

  scope :alphabetically, -> { order(:name => :asc) }
end
