##
# user_controller.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

class UsersController < ApplicationController
    def index
        if logged_in?
            @users = User.all
        else
            redirect_to :root, notice: "Not permitted"
        end
    end

    def new
        if logged_in?
            @user = User.new(user_params)
            # redirect_to dashboard_path, :notice => 'User created'
        else
            redirect_to root_url, notice: "Not permitted to create new user"
        end
    end

    def create
        @user = User.new(params[:user])
        if @user.save
            redirect_to :back, notice: "Signed up!"
        else
            render :new
        end
    end

    def destroy
        User.find(params[:user_id]).destroy
        redirect_to dashboard_path, notice: "deleted user!"
    end

    def user_params
        params.permit(:email, :password, :password_confirmation)
    end

    private :user_params
end
