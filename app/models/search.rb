##
# search.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

class Search
    include Mongoid::Document
    field :_id, type: String
    field :food_items, type: Array
    field :timestamp, type: Array
    field :length, type: Integer, :default => 1

    validates :_id, :food_items, :length, presence: true
    validates :_id, uniqueness: true

    def self.search(_query)
        item = Search.find(_query)
        return nil if item.nil?
        item['timestamp'] = [] if item['timestamp'].nil?
        timestamps = item['timestamp'] + [Time.now.getutc]
        item.update_attributes!(timestamp: timestamps, length: (item['timestamp'].length+1))
        item
    end

    def self.add(_query, _item_list)
        i = Search.new(
            _id:        _query,
            food_items: prepare_item_list(_item_list),
            timestamp:  [Time.now.getutc]
        )
        i.save
    end

    def self.clear_cache
        Search.all.desc(:length).limit(10)
    end

    def self.fetch_most_searched
        items = Search.all.order_by([[:timestamp.length, :desc]])
        items
    end

    def self.prepare_item_list(_item_list)
        list = []
        _item_list.each do |item|
            list << (FoodItem.create_id item[:api_key], item[:item_id])
        end
        list
    end

    private_class_method :prepare_item_list
end
