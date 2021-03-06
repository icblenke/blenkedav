#class StorageController < Railsdav::ActiveRecord::ActiveRecordWebDavController
class StorageController < ActionController::Base

  act_as_railsdav

  def mkcol_for_path(path)
    logger.info("StorageController.mkcol_for_path(#{path})")
    parent=Storage::Directory.new
    parent.parent_id=nil
    directory_name=path
    path.split(/\//).each do |name|
      next if name.length == 0
      parent=Storage::Directory.all( :parent_id => parent.parent_id,
				   :name => name )
      directory_name=name
    end
    collection=Storage::Directory.new
    collection.parent_id=parent.parent_id
    collection.name=directory_name
    collection.save
  end

  def write_content_to_path(path, content)
    logger.info("StorageController.write_content_to_path(#{path},<content>)")
    parent=Storage::Directory.new
    parent.parent_id=nil
    file_name=path
    path.split(/\//).each do |name|
      next if name.length == 0
      parent=Storage::Directory.all( :parent_id => parent.parent_id,
				   :name => name )
      file_name=name
    end
    file=Storage::File.new
    file.storage_directory_id=parent.parent_id
    file.name=directory_name
    file.content=content
    file.save
  end

  def copy_to_path(resource, dest_path, depth)
    logger.info("StorageController.copy_to_path(<resource>,#{dest_path},#{depth})")
  end

  def move_to_path(resource, dest_path, depth)
    logger.info("StorageController.move_to_path(<resource>,#{dest_path},#{depth})")
  end

  def get_resource_for_path(path)
    logger.info("StorageController.get_resource_for_path(#{path})")
    return file if file=Storage::File.first(:path => path)
    return directory if file=Storage::Directory.first(:path => path)
    EmptyRootStorageResource.new(path)
  end

#  def index
#    Storage::File.all
#  end
	
  def after_webdav_put
    logger.info("StorageController.after_webdav_put")
  end
end
