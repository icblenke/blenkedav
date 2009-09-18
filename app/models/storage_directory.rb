class StorageDirectory
  include DataMapper::Resource

  property :id, Serial

  # Metadata
  property :parent_id, Integer, :key => true
  property :name, String, :nullable => false
  property :created_at, Time
  property :updated_at, Time
  property :deleted, Boolean, :default => false

#  validates_is_unique :name, :scope => :parent_id,
#    :message => "There is already a directory with that name there"
end
