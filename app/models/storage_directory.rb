class StorageDirectory
  include DataMapper::Resource

  property :id, Serial

  # Metadata
  property :parent_id, Integer, :key => true
  property :name, String, :nullable => false, :messages => { :presence => "A file name is required" }
  property :created_at, Datetime
  property :updated_at, Datetime
  property :deleted, Boolean, :nullable => false

  validates_is_unique :name, :scope => :parent_id,
    :message => "There is already a directory with that name there"
end
