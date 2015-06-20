class CreatePieChartCreators < ActiveRecord::Migration
    def change
        create_table :pie_chart_creators do |t|

            t.timestamps
        end
    end
end
