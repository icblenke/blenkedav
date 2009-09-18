class StorageFile
  include DataMapper::Resource

  property :id, Serial

  # Metadata
  property :storage_directory_id, Integer, :key => true
  property :name, String, :nullable => false, :messages => { :presence => "A file name is required" }
  property :created_at, Time
  property :updated_at, Time
  property :deleted, Boolean, :nullable => false, :default => false

  # Data
  property :content, String

  validates_is_unique :name, :scope => :storage_directory_id,
    :message => "There is already a file named that there"
end
