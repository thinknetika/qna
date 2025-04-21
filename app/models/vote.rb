class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, inclusion: { in: [ -1, 0, 1 ] }
  validates :votable_id, uniqueness: { scope: [ :user_id, :votable_type ] }

  def self.create_or_update_vote(votable, user, value)
    vote = votable.votes.find_or_initialize_by(user: user)

    if vote.value == value
      vote.value = 0
    else
      vote.value = value
    end

    vote
  end
end
