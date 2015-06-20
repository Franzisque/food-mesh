class CreatePieCharts < ActiveRecord::Migration
    def change
        create_table :pie_charts do |t|

            t.timestamps
        end
    end
end
