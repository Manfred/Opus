require 'test_helper'

class BuildBookBundleJobTest < ActiveJob::TestCase
  test "takes and bundles a book" do
    book = books(:lord_of_the_flies)
    assert_difference('Book.pending.count', -1) do
      BuildBookBundleJob.perform_now(book.id)
    end
  end

  test "force takes and bundles a book" do
    book = books(:pride_and_prejudice)
    assert_no_difference('Book.pending.count') do
      BuildBookBundleJob.perform_now(book.id, force: true)
    end
  end
end
