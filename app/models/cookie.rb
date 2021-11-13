class Cookie < ActiveRecord::Base
  belongs_to :storage, polymorphic: :true
  validates :storage, presence: true

  attribute :ready, :boolean, default: false

  def ready?
    return self.ready
  end

  def set_ready(new_ready)
    update(ready: new_ready)
  end
end
