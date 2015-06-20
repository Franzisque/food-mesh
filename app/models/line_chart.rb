require 'set'
class LineChart
    attr_reader :nutritions_in_items, :space, :dimensions

    def self.fetch_chart(items)
        ap items
        @chart = LineChart.new items
        { dimensions:   @chart.dimensions,
          items:        @chart.build_chart,
          labels:       @chart.nutritions_in_items,
          label_space:  @chart.space,
          colors:       %w[#2BA772 #1C7F60 #19436B #50B694 #66A4D1 #205779 #3997CF #2BA772']
        }
    end

    def initialize(items, window_width = 1000, window_height = 500)
        @dimensions          = {
            width:   window_width,
            height:  window_height
        }
        @items               = items
        @nutritions_in_items = combine_items
        @space               = @dimensions[:width] / @nutritions_in_items.length
    end

    def build_chart
        paths = []
        @items.each do |item|
            paths << ({
                id:   item['_id'],
                path: (draw_function item['nutritions'])
            })
        end
        paths
    end

    def draw_function(ingredients)
        path = "M 0 #{@dimensions[:height]}"

        @nutritions_in_items.each_with_index do |nutrition, i|
            value = (ingredients[nutrition].presence || 0)
            value = calculate_daily_intake nutrition, value

            path << (" L #{i * @space}  #{@dimensions[:height] - value} ") unless value.nil?
        end
        path
    end

    def combine_items
        nutritions_in_items = SortedSet.new
        @items.each do |item|
            item['nutritions'].each do |key, value|
                nutritions_in_items.add key if value > 0
            end
        end
        nutritions_in_items
    end

    def calculate_daily_intake(key, value)
        intake = DailyIntake.find_element(key)
        unless intake.nil?
            val = value.to_f / intake['value']
            val = calc_over_daily_amount val if val > 1
            val *= (@dimensions[:height] * 0.6)
            return val
        end
        0
    end

    def calc_over_daily_amount(val)
        1 + ((val - 1)**(1 / 5)) # calculates cubic root
    end

    private :combine_items, :calculate_daily_intake, :calc_over_daily_amount
end
