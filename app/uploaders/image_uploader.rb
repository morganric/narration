# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
   include Cloudinary::CarrierWave

  # Choose what kind of storage to use for this uploader:
  #storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process :eager => true
       # process :resize_to_fill => [100, 100, crop: :scale]

    cloudinary_transformation :transformation =>[
        {:width => 100, :height => 100, :crop => :fill}, 
        {  :overlay => "play.png", crop: :fill, :width=>0.5, :height=>0.5, :flags=>:relative,
             :gravity => :center }]



  end


  version :thumbnail do
    process :resize_to_fill => [100, 100]
  end  
  
   version :avatar do
    process :resize_to_fill => [25, 25]
  end  

    version :listener do
    process :resize_to_fill => [50, 50]
  end  

   version :square do
    process :resize_to_fill => [340, 340]
  end

   version :banner do
    process :resize_to_fill => [1200, 340]
  end

   version :mpu do
    process :resize_to_fill => [300, 250]
  end


   version :featured do
    process :resize_to_fill => [310, 60]
  end

   version :embed_cover do
      process :eager => true
    # process :resize_to_fill => [600, 600]


    cloudinary_transformation :transformation =>[
        {:width => 600, :height => 600, :crop => :fill}, 
        {  :overlay => "play.png", crop: :fill, :width=>0.25, :height=>0.25, :flags=>:relative,
             :gravity => :center }]
  end

   version :facebook do
      process :eager => true
    # process :resize_to_fill => [600, 600]


    cloudinary_transformation :transformation =>[
        {:width => 470, :height => 470, :crop => :fill}, 
        {  :overlay => "play.png", crop: :fill, :width=>0.25, :height=>0.25, :flags=>:relative,
             :gravity => :center }]
  end

    version :twitter_card do
      process :eager => true
    # process :resize_to_fill => [600, 600]


    cloudinary_transformation :transformation =>[
        {:width => 600, :height => 600, :crop => :fill}, 
        {  :overlay => "play.png", crop: :fill, :width=>0.25, :height=>0.25, :flags=>:relative,
             :gravity => :center }]
  end



  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
