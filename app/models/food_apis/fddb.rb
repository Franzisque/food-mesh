##
# fddb.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

require_dependency 'food_apis/food_api_interface'
require 'nokogiri'

class Fddb < FoodAPIInterface
    def initialize
        @api_key = 'U9H3TXH05S933NMQFMJIL64C'
    end

    def search(api_id, query)
        params = {
            apikey: @api_key,
            q:      query,
            lang:   'de'
        }

        data = Curl::Easy.http_post('http://fddb.info/api/v8/search/item.xml?' + params.to_query).body_str
        (parse_xml api_id, data) unless data.nil?
    end

    def fetch_item(api_id, id)
        params = {
            apikey: @api_key,
            lang:   'de'
        }

        url  = "http://fddb.info/api/v8/item/id_#{id}.xml?#{ params.to_query }"
        data = Curl::Easy.http_post(url).body_str

        (parse_xml api_id, data) unless data.nil?
    end

    def parse_xml(api_id, data)
        object  = []
        xml_obj = Nokogiri::XML(data)

        xml_obj.xpath("//item/data//*[not(text())]").remove # remove all empty nodes
        xml_obj.xpath("//item").each do |item|
            food_item = create_food_item_structure(
                name:               item.xpath("./description/name")[0].content,
                api_key:            api_id,
                item_id:            item.xpath("./id")[0].content,
                object_source_id:   object_id,
                serving_weight: {
                    unit:   item.xpath("./data/amount_measuring_system")[0].content,
                    value:  item.xpath("./data/amount")[0].content
                }
            )

            item.xpath("./data/*").each do |ingredient|
                key   = translate_key ingredient.name, :fddb
                value = ingredient.content
                continue unless (!value.is_a? Integer) || (!value.is_a? Float)
                food_item[:nutritions][key] = base_nutrition_information value, food_item[:serving_weight]
            end

            object.push(food_item)
        end

        object
    end

    private :parse_xml
end
