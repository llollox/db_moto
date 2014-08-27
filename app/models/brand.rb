class Brand < ActiveRecord::Base

  has_attached_file :logo, :styles => { :small => "250x150>", :thumb => "100x100>" }, :default_url => ActionController::Base.helpers.asset_path('missing_:style.png')
  
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  has_many :models, :dependent => :delete_all
  has_many :bikes, :dependent => :delete_all

  validates :name, :presence => true
  validates_uniqueness_of :name

  scope :alphabetically, -> { order(:name => :asc) }
end
