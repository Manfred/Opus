class Book < ActiveRecord::Base
  scope :pending, -> { where(bundle_status: 'pending') }

  before_save :mark_as_pending
  after_save :schedule_bundle

protected

  def mark_as_pending
    self.bundle_status = 'pending'
  end

  def schedule_bundle
    BuildBookBundleJob.perform_later(id)
  end

  def self.take
    if book = Book.pending.lock(true).first
      yield book
      # Don't trigger save callback, otherwise it will schedule another
      # job.
      book.update_column(:bundle_status, 'generated')
    end
  end
end
