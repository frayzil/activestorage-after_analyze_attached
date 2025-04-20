class User < ApplicationRecord
  has_one_attached :avatar
  has_many_attached :pictures

  after_analyze_attached :avatar do |attachment, blob|
    update_column(:avatar_analyzed, true)
    blob.metadata[:after_analyze_attached_called_at] = Time.current
    blob.metadata[:after_analyze_attached_attachment_name] = attachment.name
    blob.metadata[:after_analyze_attached_attachment_id] = attachment.id
    blob.save!
  end

  after_analyze_attached :pictures do |attachment, blob|
    update_column(:pictures_analyzed, self.pictures_analyzed + 1)
    blob.metadata[:after_analyze_attached_called_at] = Time.current
    blob.metadata[:after_analyze_attached_attachment_name] = attachment.name
    blob.metadata[:after_analyze_attached_attachment_id] = attachment.id
    blob.save!
  end
end
