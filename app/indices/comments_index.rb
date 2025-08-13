ThinkingSphinx::Index.define :comment, :with => :active_record do
  indexes body

  has created_at
  has updated_at

  set_property delta: true
end
