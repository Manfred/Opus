namespace :books do
  namespace :rebuild do
    desc "Rebuild all books"
    task all: :environment do
      Book.find_each { |book| book.force_rebuild }
    end
  end
end