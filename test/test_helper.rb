ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'fileutils'

class ActiveSupport::TestCase
  fixtures :all

  setup do
    BookBundler.base_path = Rails.root.join('tmp/public')
  end

  teardown do
    FileUtils.rm_rf(BookBundler.base_path.to_s)
  end
end
