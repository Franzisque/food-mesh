##
# sessions_controller.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

class SessionsController < ApplicationController
    def create
        user = login(params[:email], params[:password], params[:remember_me])
        if user
            redirect_to dashboard_path, notice: "Logged in!"
        else
            flash.now.alert = "Email or password was invalid"
            render :new
        end
    end

    #
    # redirects administrator to intern admin page
    # when side is reloaded
    def new
        redirect_to dashboard_path, notice: "Logged in!" if logged_in?
    end

    def destroy
        t = user_session.fetch_user_items
        logout
        user_session.add_items_to_basket t
        redirect_to login_path
    end
end
