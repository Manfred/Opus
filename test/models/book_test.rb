require_relative '../test_helper'

class BookTest < ActiveSupport::TestCase
  class ProcessingFailed < StandardError
  end

  test "takes a book for processing" do
    book = books(:great_expectations)
    took = false

    assert_difference('Book.pending.count', -1) do
      Book.take(book.id) do |book|
        # A successful take will mark the book as
        # processed.
        took = true
      end
    end

    assert took
  end

  test "does not take a book for processing when it's not pending" do
    book = books(:pride_and_prejudice)
    took = false

    assert_no_difference('Book.pending.count') do
      Book.take(book.id) do |book|
        # A successful take will mark the book as
        # processed.
        took = true
      end
    end

    refute took
  end

  test "is resiliant against superfluous queuing" do
    book = books(:great_expectations)
    assert_difference('Book.pending.count', -1) do
      10.times do
        Book.take(book.id) { |book| }
      end
    end
  end

  test "leaves a book for processing when it fails" do
    before = Book.pending.count
    book = books(:great_expectations)

    begin
      Book.take(book.id) do
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

  test "returns its public path" do
    assert books(:pride_and_prejudice).path.to_s.ends_with?('bundle.html')
  end
end
