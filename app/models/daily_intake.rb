##
# daily_intake.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

class DailyIntake
    include Mongoid::Document
    field :key, type: String
    field :value, type: Float
    field :unit, type: String
    field :category, type: String

    validates :key, :value, :unit, :category, presence: true
    validates :key, uniqueness: true
    validates :category, inclusion: { in:  %w( selection general vitamin mineral ) }
    validates :unit, inclusion: { in: %w( g mg kcal l ) }

    def self.find_element(key)
        DailyIntake.where(key: key).first
    end
end
