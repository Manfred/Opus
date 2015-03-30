class Book < ActiveRecord::Base
  scope :pending, -> { where(bundle_status: 'pending') }

  def self.take
    if book = Book.pending.lock(true).first
      yield book
      book.bundle_status = 'generated'
      book.save!
    end
  end
end
