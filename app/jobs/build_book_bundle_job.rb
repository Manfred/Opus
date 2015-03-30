class BuildBookBundleJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Book.take(*args) do |book|
      BookBundler.generate(book)
    end
  end
end
