##
# food_item_controller.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

require 'food_apis_module'

class FoodItemController < ApplicationController
    before_filter :before_actions
    include FoodApisModule

    # @todo add a static member to PieChart fetch_chart so only one call for pie_chart is needed
    def show
        @food_item    = SearchLocalRemote.fetch_single_item params[:item_id]
        recalculation = IntakeCalculations.instance.fetch_recalculated_infos @food_item[:nutritions]

        pie_chart_instance = PieChart.new recalculation
        @pie_chart         = pie_chart_instance.fetch_pie_chart
    end

    def search
        translation_en = @translator.translate params[:query]
        food_items     = @local_remote.search translation_en

        @food_items       = food_items[:items]
        @name_translation = food_items[:translations]
    end

    def compare
        @food_items = user_session.fetch_user_items
        @chart = LineChart.fetch_chart @food_items unless @food_items.empty?
        ap @chart
    end

    def redirect_to_index
        set_current_locale
        redirect_to search_db_path params[:query]
    end

    def clear_search_cache
        Search.clear_cache  if logged_in?
        redirect_to dashboard_path, notice: 'Cleared search cache'
    end

    def before_actions
        @translator   = Translations.new params[:locale]
        @local_remote = SearchLocalRemote.new
    end

    private :before_actions
end
