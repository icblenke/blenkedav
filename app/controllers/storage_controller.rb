#class StorageController < Railsdav::ActiveRecord::ActiveRecordWebDavController
class StorageController < ActionController::Base

  act_as_railsdav

#  def index
#    logger.info("StorageController::index")
#  end

#  def ping
#    render :text => "ping"
#  end

  def mkcol_for_path(path)
    logger.info("mkcol_for_path('#{path}')")
    parent=StorageDirectory.new
    parent.parent_id=nil
    directory_name=path
    path.split(/\//).each do |name|
      next if name.length == 0
      parent=StorageDirectory.all( :parent_id => parent.parent_id,
				   :name => name )
      directory_name=name
    end
    collection=StorageDirectory.new
    collection.parent_id=parent.parent_id
    collection.name=directory_name
    collection.save
  end

  def write_content_to_path(path, content)
    logger.info("write_content_to_path('#{path}','#{content}')")
    parent=StorageDirectory.new
    parent.parent_id=nil
    file_name=path
    path.split(/\//).each do |name|
      next if name.length == 0
      parent=StorageDirectory.all( :parent_id => parent.parent_id,
				   :name => name )
      file_name=name
    end
    file=StorageFile.new
    file.storage_directory_id=parent.parent_id
    file.name=directory_name
    file.content=content
    file.save
  end

  def copy_to_path(resource, dest_path, depth)
    logger.info("copy_to_path('#{resource}','#{dest_path}','#{depth}')")
  end

  def move_to_path(resource, dest_path, depth)
    logger.info("move_to_path('#{resource}','#{dest_path}','#{depth}')")
  end

  def get_resource_for_path(path)
    logger.info("get_resource_for_path('#{path}')")
    path
  end

#  def index
#    StorageFile.all
#  end
	
  def after_webdav_put
    logger.info("after_webdav_put")
  end
end
