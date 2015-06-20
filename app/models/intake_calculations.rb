require 'singleton'

class IntakeCalculations
    include Singleton

    @@session = nil

    def self.session=(session)
        @@session = session
    end

    def initialize
        @daily_intakes = DailyIntake.all
        @valid_keys    = parse_keys
    end

    def key_valid?(key)
        @valid_keys.include? key
    end

    def fetch_key(key)
        @valid_keys = fetch_individual_intake
        @valid_keys[key] if key_valid? key
    end

    def fetch_recalculated_infos(nutritions)
        nutritions  = nutritions.clone      # clone just for security propose so we don't overwrite anything
        n           = {}
        @valid_keys = fetch_individual_intake # call function just for security propose

        nutritions.each do |key, value|
            percent = recalculate_key key, value
            n[key] = ({
                value:    value,
                percent: percent
            }) unless percent.nil?
        end
        n
    end

    ##
    # returns the individual intake according to user settings
    def fetch_individual_intake
        smr               = fetch_smr
        individual_intake = {}

        @valid_keys.each do |key, value|
            case key
            when 'calories'
                individual_intake[key] = smr
            when 'carbohydrate'
                # carbohydrate
                # complete energy required * 55 % (KH) = kcal/day and the lot /4,1 = g /day
                individual_intake[key] = ((smr * 0.55) / 4.1).round(0)
            when 'fat'
                # fat
                # complete energy required * 30 % (fat) = kcal/day and the lot /9,3 = g /day
                individual_intake[key] = ((smr * 0.3) / 9.3).round(2)
            when key == 'protein'
                # complete energy required * 15 % (protein) = kcal/day and the lot /4,1 = g /day
                individual_intake[key] = ((smr * 0.15) / 4.1).round(2)
            else
                individual_intake[key] = value
            end
        end
        individual_intake
    end

    def recalculate_key(key, value)
        return (value / @valid_keys[key]).round(5) if key_valid? key
        nil
    end

    # calculates the smr according to his settings
    def fetch_smr
        settings = @@session.fetch_user_settings
        smr = smr_man settings if settings[:sex] == 'man'
        smr ||= smr_woman settings
        smr
    end

    ##
    # calculates the smr according to his settings
    def smr_man(settings)
        smr = 66.5 + (13.75 * settings[:weight].to_f)
        smr += (5.003 * settings[:height].to_f)
        smr - (6.775 * settings[:age].to_f)
    end

    #
    # basic metabolic rate (kcal) = 655.1 + (9.563 x kg) + (1.850 x cm) - (4.676 x age)
    def smr_woman(settings)
        smr = 655.1 + (9.563 * settings[:weight].to_f)
        smr += (1.850 * settings[:height].to_f)
        smr - (4.676 * settings[:age].to_f)
    end

    def parse_keys
        keys = {}
        @daily_intakes.each do |item|
            keys[item['key']] = item['value']
        end
        keys
    end
    private :recalculate_key, :fetch_smr, :smr_man, :smr_woman, :parse_keys
end
