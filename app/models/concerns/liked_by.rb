module LikedBy
  extend ActiveSupport::Concern
  included do
    def liked_by
      like_by = Like.where(likeable: self)
      persons = Person::Person.where('id IN (?)' , like_by.pluck(:id))
      persons
    end

    def liked_by?(current_user_id)
      like_by = nil
      like = Like.where(likeable: self, user_id: current_user_id).first
      like_by = Person::Person.where(id: current_user_id).first if like.present?
      like_by
    end
  end
end