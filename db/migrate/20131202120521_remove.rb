class Remove < ActiveRecord::Migration
    def change
        drop_table :pie_chart_creators
        drop_table :pie_charts
    end
end
