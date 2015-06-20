##
# food_apis_helper.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

module FoodAPIsHelper
    # translations
    def translate_key(key, local)
        translation = key.downcase
        translation.slice! 'nf_'
        translation = I18n.t translation, locale: local

        translation
    end

    def create_food_item_structure(item_details)
        # raise 'item name is nil' unless !item_details[:name].blank?
        # raise 'item api_key is nil' unless !item_details[:api_key].blank?
        # raise 'item item_id is nil' unless !item_details[:item_id].blank?
        # raise 'item object_source_id is nil' unless !item_details[:object_source_id].blank?
        # raise 'item serving_weight is nil' unless !item_details[:serving_weight][:unit].blank?
        # raise 'item serving_weight is nil' unless !item_details[:serving_weight][:value].blank?

        item_details[:nutritions] = {}
        item_details
    end

    def base_nutrition_information(nutrition_data, base)
        (nutrition_data.to_f / base[:value].to_f * 100).round(4)
    end
end
