module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :user

    def connect
      self.user = env["warden"]&.user
    end
  end

  private
  def find_verified_user
    env["warden"]&.user
  end
end
