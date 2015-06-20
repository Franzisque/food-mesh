##
# pie_chart.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

require_dependency 'food_apis_module'

class PieChart
    def initialize(nutritions, width_height = 500)
        @nutritions   = nutritions
        @width_height = 1000

        @chart_center = @width_height / 2
        @chart_width  = width_height * 0.9

        @values      = create_chart
        @segments    = create_chart.length
        @inner_angle = 360 / @segments
        @radiant     = deg_to_rad(@inner_angle)
    end

    def fetch_pie_chart
        {
            values:        @values,
            chart_width:   @chart_width,
            chart_center:  @chart_center,
            coords:        fetch_coords,
            inner_angle:   @inner_angle,
            segments:      @segments,
            daily_kcal:    fetch_daily_calories_in_procent(@nutritions['calories']),
            chart_mask:    create_outer_mask,
            colors:        %w[#2BA772 #1C7F60 #19436B #F7B475 #50B694 #66A4D1 #205779 #3997CF #2BA772'],
            width_height:  @width_height,
            center:        @width_height / 2,
            line_coords:   fetch_line_coords
        }
    end

    def fetch_coords
        coords = {}

        coords['x1'] = Math.cos(@radiant).abs * (@chart_width)
        coords['y1'] = Math.sin(@radiant).abs * (@chart_width)

        coords['x2'] = @width_height
        coords['y2'] = @width_height / 2

        coords
    end

    def center
        @width_height / 2
    end

    def create_outer_mask
        mask = {}

        mask['inner'] = @width_height.to_f / (10 * 2)
        mask['outer'] = @chart_width.to_f * 0.95

        mask
    end

    def fetch_daily_calories_in_procent(calories)
        percent = calculate_daily_calories calories
        circumference percent
    end

    def circumference(percent)
        percent = percent.to_f

        circle        = {}
        circumference = calculate_circumference

        circle["line"]  = circumference * (percent / 100)
        circle["space"] = circumference * ((100 - percent) / 100)

        circle
    end

    def create_chart
        values = []
        @nutritions.each do |key, value|
            intake = calculate_daily_intake(key, value)
            values.push(
                            value:      value[:value],
                            radius:     intake,
                            percent:    value[:percent],
                            ingredient: key
                        ) unless intake.nil?
        end

        ap values

        values
    end

    def fetch_line_coords
        coords = []
        @segments.times do |i|
            coord =  {}
            rad   = deg_to_rad(@inner_angle * i)

            coord[:x] = Math.cos(rad) * (@chart_width / 2) + (@width_height / 2)
            coord[:y] = Math.sin(rad) * (@chart_width / 2) + (@width_height / 2)

            coords << coord
        end

        coords
    end

    def deg_to_rad(deg)
        Math::PI / 180 * deg
    end

    def calculate_circumference
        Math::PI * (@width_height)
    end

    def calculate_daily_calories(calories)
        calories[:percent] * 100
    end

    def calculate_daily_intake(key, value)
        value = value.clone
        return nil if key == 'calories'

        mask            = create_outer_mask
        value[:percent] *= (mask['outer'] - mask['inner'])
        value[:percent] + mask['inner']
    end

    private :create_chart,
            :fetch_line_coords,
            :deg_to_rad,
            :calculate_circumference,
            :calculate_daily_calories,
            :calculate_daily_intake
end
