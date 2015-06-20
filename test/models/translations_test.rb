require 'test_helper'
require 'awesome_print'

class TranslationsTest < ActiveSupport::TestCase
    test "get translation for beer" do
        @translator = Translations.new
        translation = @translator.translate 'bier'
        assert translation == 'beer'
    end
end
