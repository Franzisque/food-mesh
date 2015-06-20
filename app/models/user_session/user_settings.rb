##
# user_settings.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

module UserSettings
    def fetch_user_settings
        @session[:user_settings]
    end

    def change_user_settings(params)
        @session[:user_settings] = {
            weight: params[:user_settings][:user_settings_weight],
            height: params[:user_settings][:user_settings_height],
            age:    params[:user_settings][:user_settings_age],
            sex:    params[:user_settings][:user_settings_sex]
        }
    end
end
