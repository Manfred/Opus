require 'fileutils'

class BookBundler
  attr_reader :book

  def initialize(book: nil)
    if book.nil?
      raise ArgumentError, "Please initialize the BookBundler with a book."
    end

    @book = book
  end

  def relative_path
    File.join('books', book.id.to_s, 'bundle.html')
  end

  def full_path
    self.class.base_path.join(relative_path)
  end

  def write(out)
    out.puts("<html><title>#{book.title}</title><body><h1>#{book.title}</h1></body></html>")
  end

  def generate
    FileUtils.mkdir_p(File.dirname(full_path.to_s))
    File.open(full_path, 'w') do |file|
      write(file)
    end
  end

  def self.generate(book)
    new(book: book).generate
  end

  class << self
    attr_writer :base_path
  end

  def self.base_path
    @base_path || Rails.root.join('public')
  end
end