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
      book.bundle_status = 'generated'
      book.save!
    end
  end
end
