##
# application_controller.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

class ApplicationController < ActionController::Base
    before_filter :user_session, :set_current_locale
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    helper_method :user_session, :default_url_options, :set_current_locale

    def change_lang
        url            = request.referer
        uri            = URI::parse(url)
        route          = Rails.application.routes.recognize_path(uri.path)
        route[:locale] = params[:locale]
        I18n.locale    = params[:locale] || I18n.default_locale
        redirect_to route
    end

    def user_session
        @user_session              ||= UserSession.new(session)
        IntakeCalculations.session = @user_session
        @user_session
    end

    def set_current_locale
        I18n.locale = params[:locale]
    end

    def default_url_options(options = {})
        { locale: I18n.locale }
    end

    # authentication with sorcery
    def not_authenticated
        redirect_to login_url, alert: "First login to access this page."
    end

    private :user_session, :set_current_locale, :default_url_options
end
