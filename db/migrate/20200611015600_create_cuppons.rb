class CreateCuppons < ActiveRecord::Migration[5.2]
  def change
    create_table :cuppons do |t|
      t.string :kind
      t.references :user, foreign_key: true
      t.integer :discount
      t.float :amount
      t.integer :used_count, default: 0

      t.timestamps
    end
  end
end
