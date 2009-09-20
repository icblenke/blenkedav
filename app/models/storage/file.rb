class Storage::File
  include DataMapper::Resource
  include WebDavResource 

  property :id, Serial

  # Metadata
  property :parent_id, Integer, :key => true
  property :path, String, :nullable => false
  property :name, String, :nullable => false
  property :type, String, :nullable => false
  property :size, Integer, :nullable => false, :default => 0
  property :created_at, Time
  property :updated_at, Time
  property :deleted, Boolean, :nullable => false, :default => false

  belongs_to :parent, :class => 'Storage::Directory'

  # Data
  has n, :fragments, :class => 'Storage::Fragment'

  def href
    @path
  end

  def initialize(path)
    @path = path
    @file=Storage::File.first( :name => @path )
    @directory=Storage::Directory.first( :name => @path )
  end
    
  def properties
    Array.new
  end
  
  def delete!
    if file=Storage::File.first( :name => @path )
      file.delete
    else
      if delete.Storage::Directory.first( :name => @path )
        directory.delete
      end
    end
  end
  
  def move! (dest_path, depth)
    
  end
    
  def copy! (dest_path, depth)
    
  end
  
  def status
    gen_status(200, "OK").to_s
  end
  
  def collection?
    return true if Storage::Directory.first( :name => @path )
    false
  end
  
  def children
    if dir=Storage::Directory.first( :name => @path )
      dir.files.map do |file|
        StorageResource.new("#{@path}/#{file.name}")
      end
    else
      return []
    end
  end

  def get_displayname
    URI.escape(self.displayname).gsub(/\+/, '%20') unless self.displayname.nil?
  end

  def get_href
    self.href.gsub(/\+/, '%20') unless self.href.nil?
  end

  def get_properties
    hsh = {}
    self.properties.each do|meth|
      if self.respond_to?('get_'+meth.to_s)
        hsh[meth] = self.send(('get_'+meth.to_s).to_sym)
      else
        hsh[meth] = self.send(meth)
      end
    end
    hsh
  end

  protected
   def gen_element(elem, text = nil, attrib = {})
     e = REXML::Element.new elem
     text and e.text = text
     attrib.each {|k, v| e.attributes[k] = v }
     e
   end

   def gen_status(status_code, reason_phrase)
       "HTTP/1.1 #{status_code} #{reason_phrase}"
   end
end
