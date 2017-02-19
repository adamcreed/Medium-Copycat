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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170218202853) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string   "author"
    t.string   "description"
    t.string   "title"
    t.string   "url"
    t.string   "url_to_image"
    t.string   "published_at"
    t.string   "source_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["source_id"], name: "index_articles_on_source_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.string   "author_name"
    t.text     "content"
    t.integer  "parent_comment_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "article_id"
    t.index ["article_id"], name: "index_comments_on_article_id", using: :btree
  end

  create_table "marks", force: :cascade do |t|
    t.boolean  "favorited"
    t.boolean  "bookmarked"
    t.integer  "comment_id"
    t.integer  "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_marks_on_article_id", using: :btree
    t.index ["comment_id"], name: "index_marks_on_comment_id", using: :btree
  end

  create_table "sources", id: :string, force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.string   "category"
    t.string   "language"
    t.string   "country"
    t.string   "url_to_logo"
    t.string   "sort_bys"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "comments", "articles"
  add_foreign_key "marks", "articles"
  add_foreign_key "marks", "comments"
end
