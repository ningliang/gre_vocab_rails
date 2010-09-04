class CreateWordSets < ActiveRecord::Migration
  def self.up
    create_table :word_sets do |t|
      t.string :title
      t.string :set_type
      t.integer :count
      t.timestamps
    end
  end

  def self.down
    drop_table :word_sets
  end
end
