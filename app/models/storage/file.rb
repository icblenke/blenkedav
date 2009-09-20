class Storage::File
  include DataMapper::Resource

  property :id, Serial

  # Metadata
  property :parent_id, Integer, :key => true
  property :name, String, :nullable => false
  property :type, String, :nullable => false
  property :size, Integer, :nullable => false, :default => 0
  property :created_at, Time
  property :updated_at, Time
  property :deleted, Boolean, :nullable => false, :default => false

  belongs_to :parent, :class => 'Storage::Directory'

  # Data
  has n, :fragments, :class => 'Storage::Fragment'

end
