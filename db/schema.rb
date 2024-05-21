# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_21_175432) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "context_type", ["job", "story", "comment", "poll", "pollopt"]

  create_table "items", force: :cascade do |t|
    t.boolean "deleted"
    t.string "by"
    t.integer "time"
    t.text "text"
    t.boolean "dead"
    t.integer "parent"
    t.integer "poll"
    t.text "url"
    t.integer "score"
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kids", default: [], array: true
    t.integer "parts", default: [], array: true
    t.integer "descendants", default: [], array: true
    t.enum "context", enum_type: "context_type"
  end

end
