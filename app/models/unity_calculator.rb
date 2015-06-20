class UnityCalculator
    def self.recalculate(from, to, value)
        # instance = UnityCalculator.new
    end
    def initialize
        @possible_values = {
            liquids: [
                {
                    name:   'ml',
                    factor: 100
                }
            ],
            weights: [
                {
                    name:   'g',
                    factor: 100
                }
            ]
        }
    end

    def recalculate
    end
end
