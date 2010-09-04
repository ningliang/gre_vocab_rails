require File.expand_path('../../../config/environment',  __FILE__)
require "yaml"
require "json"

# Constants
SET_COUNT = 200
BUCKET_SIZE = 3
BUCKET_COUNT = 5

ALPHABETICAL = "alpha"
LENGTH = "length"
KAPLAN = "kaplan"


# File paths
ALL_WORDS = File.expand_path("words.json", File.dirname(__FILE__))
KAPLAN_WORDS = File.expand_path("kaplan_500.txt", File.dirname(__FILE__))

# Set logger
ActiveRecord::Base.logger = Logger.new(STDOUT)

# Ar's
Word = Class.new(ActiveRecord::Base)
WordSet = Class.new(ActiveRecord::Base)
WordSetWord = Class.new(ActiveRecord::Base) do
  set_table_name :word_sets_words
end

words = JSON.parse(IO.read(ALL_WORDS))
word_ars = words.map { |word| Word.create(word) }

# create sets by alphabetical
by_alpha_words = word_ars.dup
by_alpha_words.in_groups_of(SET_COUNT) do |group|
  group_words = group.compact
  set = WordSet.create(
    :title => "#{group_words.first.word.downcase} to #{group_words.last.word.downcase}",
    :count => group.size,
    :set_type => ALPHABETICAL
  )
  group_words.each do |word|
    WordSetWord.create(
      :word_set_id => set.id,
      :word_id => word.id
    )
  end
end

# Sets - bucket by length
buckets = []
BUCKET_COUNT.times do |i|
  buckets.push([])
end

word_ars.each do |word|
  length = word.word.length
  bucket_index = [(length.to_f / BUCKET_SIZE.to_f).ceil - 1, BUCKET_COUNT - 1].min
  buckets[bucket_index].push word
end

buckets.each_index do |index|
  bucket = buckets[index]
  if bucket.size > 0
    low = (index * BUCKET_SIZE) + 1
    high = (index < BUCKET_COUNT - 1) ? ((index + 1) * BUCKET_SIZE) : nil
    title = high.nil? ? "#{low}+ characters" : "#{low} to #{high} characters"
    set = WordSet.create(
      :title => title,
      :count => bucket.size.to_s,
      :set_type => LENGTH
    )
    bucket.each do |word|
      WordSetWord.create(
        :word_set_id => set.id,
        :word_id => word.id
      )
    end
  end
end

# Kaplan 500 set
kaplan_txt = IO.read(KAPLAN_WORDS)
kaplan_words = kaplan_txt.split("\n").map { |line| line.split("\t") }
kaplan_dictionary = kaplan_words.inject({}) { |dict, (word, definition)| dict[word.downcase] = definition; dict }

kaplan_word_ars = []
kaplan_dictionary.keys.each do |word|
  word_ar = Word.find_or_create_by_word(word)
  word_ar.definition = kaplan_dictionary[word]
  word_ar.save!
  kaplan_word_ars.push(word_ar)
end

kaplan_set = WordSet.create(
  :title => "Kaplan Top 500 GRE Words",
  :count => kaplan_word_ars.size,
  :set_type => KAPLAN
)

kaplan_word_ars.each do |word|
  WordSetWord.create(
    :word_set_id => kaplan_set.id,
    :word_id => word.id
  )
end