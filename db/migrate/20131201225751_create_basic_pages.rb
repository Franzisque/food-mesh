class CreateBasicPages < ActiveRecord::Migration
    def chang
        create_table :basic_pages do |t|
            t.text :title
            t.text :bo
            t.timestamps
        end
    end
end
