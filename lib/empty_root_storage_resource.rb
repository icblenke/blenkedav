class EmptyRootStorageResource
  include WebDavResource 

  def href
    @logger.info("EmptyRootStorageResource.href => '#{@path}'")
    @path
  end

  def initialize(path)
    @logger = AppEngine::Logger.new
    @logger.info("EmptyRootStorageResource.initialize(#{path})")
    @path = path
  end
    
  def properties
    @logger.info("EmptyRootStorageResource.properties => []")
    Array.new
  end
  
  def delete!
    @logger.info("EmptyRootStorageResource.delete!")
  end
  
  def move! (dest_path, depth)
    @logger.info("EmptyRootStorageResource.move!(#{dest_path},#{depth})")
  end
    
  def copy! (dest_path, depth)
    @logger.info("EmptyRootStorageResource.copy!(#{dest_path},#{depth})")
  end
  
  def status
    @logger.info("EmptyRootStorageResource.status => 200 OK")
    gen_status(200, "OK").to_s
  end
  
  def collection?
    @logger.info("EmptyRootStorageResource.collection? => true")
    true
  end
  
  def children
    @logger.info("EmptyRootStorageResource.children")
    return []
  end

  def get_displayname
    @logger.info("EmptyRootStorageResource.get_displayname")
    ""
  end

  def get_href
    @logger.info("EmptyRootStorageResource.get_href")
    self.href.gsub(/\+/, '%20') unless self.href.nil?
  end

  def get_properties
    @logger.info("EmptyRootStorageResource.get_properties")
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
     @logger.info("EmptyRootStorageResource.gen_element(#{elem.to_json},#{text},#{attrib})")
     e = REXML::Element.new elem
     text and e.text = text
     attrib.each {|k, v| e.attributes[k] = v }
     e
   end

   def gen_status(status_code, reason_phrase)
     @logger.info("EmptyRootStorageResource.gen_status(#{status_code},#{reason_phrase})")
       "HTTP/1.1 #{status_code} #{reason_phrase}"
   end
end
