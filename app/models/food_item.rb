##
# food_item.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser
require 'food_apis_module'

class FoodItem
    :helper

    include Mongoid::Document
    include Mongoid::Attributes

    field :name, type: String
    field :nutritions, type: Object
    field :translations, type: Array

    ##
    # creates a new object in the database and returns
    def self.new_item(item)
        id = "#{item[:api_key]}-#{item[:item_id]}"
        if FoodItem.where(_id: id).exists?
            "element exists"
        else
            safe_item_to_db item
            fetch_local_item id
        end
    end

    ##
    # searches local database for an item with given id
    # @return item or nil
    def self.fetch_local_item(item_id)
        FoodItem.find(item_id)
    end

    ##
    # searches local database for an array of item_ids
    # @item_ids ['string'] item ids
    # @returns elements or nil if no element was found
    def self.fetch_local_items(item_ids)
        FoodItem.find(item_ids)
    end

    def self.fetch_all_items
        FoodItem.all
    end

    def self.add_translation_to_item!(item, locale, translation)
        new_translations = item['translations'] + [{ locale => translation }]
        item.update_attributes!(translations: new_translations)
        item
    end

    def self.fetch_translation(item, locale)
        locale = locale.to_s
        item['translations'].each do |t|
            return t[locale] if t.key? locale
        end
    end

    ##
    # returns true if a given item has a translation
    # false if translation is missing
    def self.translation?(item, locale)
        item['translations'] ||= []
        item['translations'].each do |t|
            return true if t.key?(locale.to_s)
        end
        false
    end

    ##
    # safes a given items to the database
    # checks if the item is already in the database
    # returns true if it was saved
    def self.safe_item_to_db(items)
        items = [items] if items.class == Hash

        items.each do |item|
            id      = create_id item[:api_key], item[:item_id]
            item_db = FoodItem.find(id)

            if item_db.nil?
                name       = item[:name]
                nutritions = item[:nutritions]
                i          = FoodItem.new(_id: id, name: name, nutritions: nutritions, translations: [])
                i.save
            end
        end
    end

    def self.create_id(api_key, item_id)
        "#{api_key}-#{item_id}"
    end
end
