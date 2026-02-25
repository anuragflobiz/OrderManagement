module SoftDelete
  extend ActiveSupport::Concern

  included do
    acts_as_paranoid

    scope :active, -> {
      where(deleted_at: nil)
    }
  end
end