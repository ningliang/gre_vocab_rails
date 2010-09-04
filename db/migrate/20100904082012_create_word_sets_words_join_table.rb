class CreateWordSetsWordsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :word_sets_words, :id => false do |t|
      t.integer :word_set_id
      t.integer :word_id
    end
    add_index :word_sets_words, [:word_set_id, :word_id]
  end

  def self.down
    drop_table :word_sets_words
  end
end
