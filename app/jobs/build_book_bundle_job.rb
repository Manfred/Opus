class BuildBookBundleJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Book.take do |book|
      BookBundler.generate(book)
    end
  end
end
