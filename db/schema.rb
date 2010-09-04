# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100904082012) do

  create_table "word_sets", :force => true do |t|
    t.string   "title"
    t.string   "set_type"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "word_sets_words", :id => false, :force => true do |t|
    t.integer "word_set_id"
    t.integer "word_id"
  end

  add_index "word_sets_words", ["word_set_id", "word_id"], :name => "index_word_sets_words_on_word_set_id_and_word_id"

  create_table "words", :force => true do |t|
    t.string   "word"
    t.string   "definition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
