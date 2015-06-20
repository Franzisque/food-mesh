##
# nutritionx_api.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

require_dependency 'food_apis/food_api_interface'
require 'awesome_print'
require 'nutritionix/api_1_1'

class NutritionixAPI < FoodAPIInterface
    def initialize
        @app_id   = '3f0f5d7f'
        @app_key  = '96802c411ee8f2ba80568c157238d980'
        @provider = Nutritionix::Api_1_1.new(@app_id, @app_key)
    end

    def search(api_key, query)
        search_params = {
            offset: 0,
            limit:  50,
            query:  query
        }

        results_json = @provider.nxql_search(search_params)
        results_json = JSON.parse(results_json)

        (parse_data_search(results_json, api_key)) unless results_json.nil?
    end

    def fetch_item(api_key, item_id)
        item = @provider.get_item item_id.to_s # if id is not a string you will receive undefined encoding
        item = JSON.parse item
        parse_data_item item, api_key
    end

    def parse_data_item(item, api_key)
        serving_weight = item['nf_serving_size_qty'] or item['nf_serving_size_qty']
        food = create_food_item_structure(
            name:             "#{item['item_name']} #{item['brand_name']}",
            api_key:          api_key,
            item_id:          item['item_id'],
            object_source_id: object_id,
            serving_weight: {
                unit:   item['nf_serving_size_unit'],
                value:  serving_weight
            }
        )
        food[:nutritions] = parse_single_item item, food[:serving_weight]
        food
    end

    # find out in which mass the given values are given
    def parse_data_search(data, api_key)
        parsed_data = []

        data['hits'].each do |item|
            if item['_source']['weights'].nil?
                serving_weight = item['_source']['nf_serving_weight_grams']
            else
                weights        = item['_source']['weights'][0]
                serving_weight = weights['serving_weight_grams']
            end

            next if serving_weight.nil?

            food = create_food_item_structure(
                name:               "#{item['_source']['item_name']} #{item['_source']['brand_name']}",
                api_key:            api_key,
                item_id:            item['_id'],
                object_source_id:   object_id,
                serving_weight: {
                    unit:   'g',
                    value:  serving_weight
                }
            )

            item['_source'].delete('item_name')
            item['_source'].delete('brand_name')

            food[:nutritions] = parse_single_item item['_source'], food[:serving_weight]

            parsed_data.push(food)
        end
        parsed_data
    end

    ##
    # parses the nutrition data from a single item and translates the key
    # @param source - source array of elements
    def parse_single_item(source, serving_weight)
        nutrition_elements = {}
        source.each do |key, ingredients|
            if valid_pair? key, ingredients
                key                     = translate_key key, :nutritionix
                nutrition_elements[key] = base_nutrition_information ingredients, serving_weight
            end
        end
        nutrition_elements
    end

    # checks a given pair on following things
    # starts key with nf_ (for nutrition information)
    # is value wether 0 or nil
    def valid_pair?(key, value)
        true unless value.nil? || value == 0 || !key.include?('nf_')
    end

    private :parse_data_item,
            :parse_data_search,
            :parse_single_item,
            :valid_pair?
end
