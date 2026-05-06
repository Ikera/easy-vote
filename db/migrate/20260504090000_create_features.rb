class CreateFeatures < ActiveRecord::Migration[8.1]
  def change
    create_table :features, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :title, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
