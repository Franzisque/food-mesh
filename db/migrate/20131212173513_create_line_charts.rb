class CreateLineCharts < ActiveRecord::Migration
    def change
        create_table :line_charts do |t|

            t.timestamps
        end
    end
end
