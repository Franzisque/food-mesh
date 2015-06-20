##
# user_basket.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

module UserBasket
    include FoodApisModule

    def delete_all_items
        @session[:item_basket] = []
    end

    ##
    # checks if element is already in the user list
    # if not it adds the item to the item_basket
    def add_item_to_basket(item_id)
        @session[:item_basket] << item_id unless @session[:item_basket].include? item_id
    end

    def delete_item_from_basket(basket_idx)
        @session[:item_basket].delete_at(basket_idx.to_i)
    end

    def add_items_to_basket(items)
        @session[:item_basket] = items
    end

    def fetch_user_items
        basket = FoodItem.fetch_local_items @session[:item_basket]
        return nil if basket.nil?
        basket
    end
end
