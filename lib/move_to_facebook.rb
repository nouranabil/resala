class MoveToFacebook
  @queue = SERVER_IP
  
  def self.perform(obj, obj_id, share_to_facebook = false)
    obj_class = Article if obj == "Article"
    obj_class = Activity if obj == "Activity"
    
    objec = obj_class.find(obj_id) if obj_class
    if objec
      if obj == "Article"
        FilesUpload.new(objec, nil, share_to_facebook).upload
      elsif obj == "Activity"
        FilesUpload.new(nil, objec, share_to_facebook).upload
      end
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end