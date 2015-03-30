class BuildBookBundleJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Book.take(args[0]) do |book|
      BookBundler.generate(book)
    end
  end
end
