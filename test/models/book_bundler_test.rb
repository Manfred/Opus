require_relative '../test_helper'
require 'stringio'

class BookBundlerTest < ActiveSupport::TestCase
  setup do
    @book = books(:lord_of_the_flies)
    @book_bundler = BookBundler.new(book: @book)
  end

  test "initializes with a book" do
    assert_equal @book, @book_bundler.book
  end

  test "returns a relative path for the book" do
    assert_equal 'books/474327802/bundle.html', @book_bundler.relative_path
  end

  test "returns a full path for the book on disk" do
    assert @book_bundler.full_path.to_s.end_with?(@book_bundler.relative_path)
    assert @book_bundler.full_path.to_s.start_with?(BookBundler.base_path.to_s)
  end

  test "writes HTML to an output" do
    out = StringIO.new
    @book_bundler.write(out)
    out.rewind
    assert out.read.include?(@book.title)
  end

  test "generates a book bundle" do
    @book_bundler.generate
    refute File.read(@book_bundler.full_path).blank?
  end

  test "generates a book bundle for a book" do
    assert_nothing_raised do
      BookBundler.generate(@book)
    end
  end
end
