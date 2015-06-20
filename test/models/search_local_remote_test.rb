require 'test_helper'

class SearchLocalRemoteTest < ActiveSupport::TestCase
    test 'get element from Nutritionix' do
        check_element '0-513fceb475b8dbbc21000fd4'
    end

    test 'get element from fddb' do
        check_element '1-138163'
    end

    test 'get element from fatsecret' do
        check_element '2-37746'
    end

    def check_element(id)
        element = SearchLocalRemote.fetch_single_item id
        assert_not_nil element['name'], 'name is nil'
        assert_not_nil element['_id'], '_id is nil'
        assert_not_nil element['nutritions'], 'nutritions is nil'
    end
    private :check_element
end
