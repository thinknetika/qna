ThinkingSphinx::Index.define :question, :with => :active_record do
  indexes title, sortable: true
  indexes body

  has created_at
  has updated_at

  set_property delta: true
end
