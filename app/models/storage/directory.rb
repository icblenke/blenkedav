class Storage::Directory
  include DataMapper::Resource
  include WebDavResource 

  property :id, Serial

  # Metadata
  property :parent_id, Integer #, :key => true
  property :path, String, :nullable => false
  property :name, String, :nullable => false
  property :created_at, Time
  property :updated_at, Time
  property :deleted, Boolean, :default => false

  has n, :files, :class_name => 'Storage::File'

  belongs_to :parent, :child_key => [ :parent_id ],
	              :class_name => 'Storage::Directory'

  def href
    self.path
  end

  def properties
    Array.new
  end

  def move! (dest_path, depth)
    
  end
    
  def copy! (dest_path, depth)
    
  end
  
  def status
    gen_status(200, "OK").to_s
  end
  
  def collection?
    true
  end
  
  def children
    self.files
  end

  def get_displayname
    URI.escape(self.name).gsub(/\+/, '%20') unless self.displayname.nil?
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
