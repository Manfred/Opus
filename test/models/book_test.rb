require_relative '../test_helper'

class BookTest < ActiveSupport::TestCase
  class ProcessingFailed < StandardError
  end

  test "takes a book for processing until all are down" do
    (Book.pending.count + 1).times do
      Book.take do |book|
        # A successful take will mark the book as
        # processed.
      end
    end
    assert 0, Book.pending.count
  end

  test "leaves a book for processing when it fails" do
    before = Book.pending.count

    begin
      Book.take do
        raise BookTest::ProcessingFailed, "Force failure"
      end
    rescue BookTest::ProcessingFailed
    end

    assert_equal before, Book.pending.count
  end
end
