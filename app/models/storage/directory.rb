class Storage::Directory
  include DataMapper::Resource

  property :id, Serial

  # Metadata
  property :parent_id, Integer, :key => true
  property :name, String, :nullable => false
  property :created_at, Time
  property :updated_at, Time
  property :deleted, Boolean, :default => false

  has n, :files, :class_name => 'Storage::File'

  belongs_to :parent, :child_key => [ :parent_id ],
	              :class_name => 'Storage::Directory'

#  validates_is_unique :name, :scope => :parent_id
end
