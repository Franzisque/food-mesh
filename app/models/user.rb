##
# user.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

class User
    include Mongoid::Document
    include Sorcery::Model
    include Sorcery::Model::Adapters::Mongoid
    authenticates_with_sorcery!

    validates :email, uniqueness: true
    validates :email,  presence: true
    validates :password,  presence: true, on: :create
    validates :password,  confirmation: true
end
