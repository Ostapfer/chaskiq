# This migration comes from chaskiq (originally 20150318021239)
class CreateChaskiqTemplates < ActiveRecord::Migration
  def change
    create_table :chaskiq_templates do |t|
      t.string :name
      t.text :body
      t.text :html_content
      t.string :screenshot

      t.timestamps null: false
    end
  end
end
