##
# admin_dashboard_controller.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

class AdminDashboardController < ApplicationController
    before_filter :require_login

    def index
        @users           = User.all
        @latest_searches = Search.fetch_most_searched
    end
end
