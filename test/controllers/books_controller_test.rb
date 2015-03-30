require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  test "sees all books" do
    get :index
    assert_response :ok
  end

  test "sees a form to create a new book" do
    get :new
    assert_response :ok
  end

  test "creates a book" do
    post :create, book: { title: 'New book' }
    assert_redirected_to books_url
  end

  test "sees a form to edit a book" do
    get :edit, id: books(:pride_and_prejudice).to_param
    assert_response :ok
  end

  test "updates a book" do
    post :update, id: books(:pride_and_prejudice).to_param, book: { title: 'New title' }
    assert_redirected_to books_url
  end
end
