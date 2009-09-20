class Storage::Fragment
  include DataMapper::Resource

  property :id, Serial

  # Metadata
  property :file_id, Integer, :key => true
  property :offset, Integer, :nullable => false, :default => 0
  property :size, Integer, :nullable => false, :default => 0

  belongs_to :file, :class => 'Storage::File'

  # Data
  property :content, Text

end
