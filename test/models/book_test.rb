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

  test "marks a book as pending after an update" do
    before = Book.pending.count

    book = books(:pride_and_prejudice)
    book.title += 's'
    book.save!

    assert_equal 'pending', book.reload.bundle_status
    assert_equal before + 1, Book.pending.count
  end

  test "schedules book bundle after update" do
    assert_enqueued_jobs(+1) do
      book = books(:pride_and_prejudice)
      book.title += 's'
      book.save!
    end
  end
end
