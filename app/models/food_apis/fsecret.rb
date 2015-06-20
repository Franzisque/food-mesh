##
# fsecret.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

require_dependency 'food_apis/food_api_interface'

require 'fatsecret'
require 'awesome_print'

class Fsecret < FoodAPIInterface
    def initialize
        FatSecret.init('e2310b092c9f4acbb43657f59c242245', '3d0cc9b6114741bbbfe6c2510e8913c3')
    end

    def search(api_key, query)
        data = FatSecret.search_food(query)
        return nil unless data['foods']['total_results'].to_i > 0
        items = []

        data['foods']['food'].each do |item|
            item_id = item['food_id'].to_i
            items << (fetch_item api_key, item_id)
        end

        items
    end

    def fetch_item(api_key, id)
        data = FatSecret.food(id)
        (parse_data_item(data, api_key)) unless data.nil?
    end

    def create_item_header_information(item, api_key)
        create_food_item_structure(
                                        name:                item['food_name'],
                                        api_key:             api_key,
                                        item_id:             item['food_id'],
                                        object_source_id:    object_id,
                                        serving_weight:      {
                                            unit:   item[:serving]['metric_serving_unit'],
                                            value:  item[:serving]['metric_serving_amount']
                                       }
                                   )
    end

    def parse_data_item(data, api_key)
        item = data['food']

        item[:serving] = fetch_serving_object item
        food           = create_item_header_information item, api_key

        item[:serving].each do |key, ingredient|
            key                    = translate_key key, :fatsecret
            food[:nutritions][key] = ingredient
        end

        food
    end

    def parse_data_search(data, api_key)
        parsed_data = []
        data["foods"]["food"].each do |item|
            food          = create_item_header_information item, api_key
            tmp           = item['food_description'].split(' - ')
            food[:amount] = tmp[0]

            ingredients = tmp[1].split(' | ')
            ingredients.each do |ingredient|
                tmp                    = ingredient.split(": ")
                key                    = translate_key tmp[0], :fatsecret
                food[:nutritions][key] = tmp[1]
            end
            parsed_data.push(food)
        end

        parsed_data
    end

    ##
    # fatsecret returns a list of possible servings (apple, slices of apples, ...)
    # if there is only one serving it will return an object with all the ingredients
    # if there are more possibilities it will return an array
    def fetch_serving_object(item)
        servings = item['servings']['serving']
        return servings unless servings.class == Array
        servings[0]
    end

    private :create_item_header_information,
            :parse_data_item,
            :parse_data_search,
            :fetch_serving_object
end
