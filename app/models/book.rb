class Book < ActiveRecord::Base
  scope :ordered, -> { order(title: :desc) }
  scope :pending, -> { where(bundle_status: 'pending') }

  before_save :mark_as_pending
  after_save :schedule_bundle

  def path
    '/' + BookBundler.new(book: self).relative_path
  end

  def force_rebuild
    BuildBookBundleJob.perform_later(id, force: true)
  end

protected

  def mark_as_pending
    self.bundle_status = 'pending'
  end

  def schedule_bundle
    BuildBookBundleJob.perform_later(id)
  end

  def self.take(id, force: false)
    if force
      book = Book.where(id: id).lock(true).first
    else
      book = Book.pending.where(id: id).lock(true).first
    end

    if book
      yield book
      # Don't trigger save callback, otherwise it will schedule another
      # job.
      book.update_column(:bundle_status, 'generated')
    end
  end
end
