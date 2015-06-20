##
# user_session.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

require_dependency 'user_session/user_basket'
require_dependency 'user_session/user_settings'

class UserSession
    def initialize(session)
        @session                 = session
        @session[:item_basket]   ||= [] # init session item_basket
        @session[:user_settings] ||= {
            weight: 80,
            height: 180,
            age:    21
        }
    end

    include UserBasket
    include UserSettings
end
