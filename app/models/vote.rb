class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, inclusion: { in: [ -1, 1 ] }
  validates :votable_id, uniqueness: { scope: [ :user_id, :votable_type ] }
end
