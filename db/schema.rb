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

ActiveRecord::Schema.define(version: 20161023083632) do

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.integer "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false

    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "collections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "line_items"
    t.integer  "user_id"
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.string   "brand"
    t.string   "price"
    t.string   "description"
    t.string   "sale_price"
    t.string   "type"
    t.boolean  "sale"
    t.integer  "collection_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "image"
    t.index ["collection_id"], name: "index_line_items_on_collection_id"
  end

  create_table "products", force: :cascade do |t|
    t.string   "price"
    t.string   "brand"
    t.string   "description"
    t.string   "color"
    t.string   "type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.boolean  "sale"
    t.string   "sale_price"
    t.integer  "collection_id"
    t.string   "image"
    t.string   "original_image_url"
    t.integer  "user_id"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "user_name"
    t.string   "password"
    t.string   "auth_token"
    t.string   "api_keys"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "products"
    t.string   "password_digest"
    t.text     "collections"
  end

end
