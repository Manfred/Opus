class BooksController < ApplicationController
  before_action :find_book, only: %i(edit update)

  def index
    @books = Book.ordered
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to books_url
    else
      render :new
    end
  end

  def update
    if @book.update_attributes(book_params)
      redirect_to books_url
    else
      render :edit
    end
  end

private

  def book_params
    params.require(:book).permit(:title)
  end

  def find_book
    @book = Book.find(params[:id])
  end
end
