module ApplicationHelper
    def print_nutrition_element?(key)
        IntakeCalculations.instance.key_valid? key
    end
end
