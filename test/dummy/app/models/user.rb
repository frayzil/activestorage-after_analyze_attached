class User < ApplicationRecord
  has_one_attached :avatar
  has_many_attached :pictures

  after_analyze_attached :avatar do
    update_column(:avatar_analyzed, true)
  end

  after_analyze_attached :pictures do
    update_column(:pictures_analyzed, self.pictures_analyzed + 1)
  end
end
