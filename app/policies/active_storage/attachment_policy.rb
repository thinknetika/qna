module ActiveStorage
  class AttachmentPolicy < ApplicationPolicy
    def destroy?
      user&.admin? || user == record.record.author
    end
  end
end
