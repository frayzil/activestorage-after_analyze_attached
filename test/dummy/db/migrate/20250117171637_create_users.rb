class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.boolean :avatar_analyzed, default: false
      t.integer :pictures_analyzed, default: 0
      t.integer :documents_analyzed, default: 0
      t.timestamps
    end
  end
end
