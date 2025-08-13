ThinkingSphinx::Index.define :user, :with => :active_record do
  indexes email

  has created_at
  has updated_at
  has admin

  set_property delta: true
end
