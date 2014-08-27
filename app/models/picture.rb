class Picture < ActiveRecord::Base
  # attr_accessible :photo, :title
	belongs_to :picturable, polymorphic: true

  has_attached_file :photo, 

  :styles => lambda { |a|
   if a.instance.is_pdf?
     { :thumb => ["100x100>", :jpg], :small => ["250x250>", :jpg], :original => ["600x600>", :jpg]}
   else
     { :thumb => ["100x100>"], :small => ["250x250>"], :original => ["600x600>"]}
   end
  },
    
  :processors => lambda { |a|
   if a.is_pdf?
     [:ghostscript, :thumbnail]
   else
     [:thumbnail]
   end
  },

  :convert_options => { :all => '-density 300 -quality 100' } 

  # :default_url => ActionController::Base.helpers.asset_path('missing_:style.png')
     
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png','application/pdf','image/gif']

  def is_pdf?
     ["application/pdf"].include?(self.photo_content_type) 
  end

  def as_json(options = { })
    p = super(options)
    p[:photo_url] = self.photo.url
    p
  end

end
