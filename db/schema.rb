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

ActiveRecord::Schema.define(version: 20180111045127) do

  create_table "announcements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "message"
    t.string "link"
    t.integer "sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banners", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "pic"
    t.string "link"
    t.integer "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cart_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "product_id"
    t.integer "quantity"
    t.integer "price"
    t.integer "cart_id"
    t.integer "product_color_id"
    t.integer "product_size_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_color_id"], name: "index_cart_items_on_product_color_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
    t.index ["product_size_id"], name: "index_cart_items_on_product_size_id"
  end

  create_table "carts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "countries", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "currencies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "symbol"
    t.float "cash_buy", limit: 24
    t.float "cash_sell", limit: 24
    t.float "buy", limit: 24
    t.float "sell", limit: 24
    t.string "show_symbol"
    t.index ["symbol"], name: "index_currencies_on_symbol"
  end

  create_table "faqs", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.text "context"
    t.integer "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "purpose"
    t.index ["purpose"], name: "index_faqs_on_purpose"
  end

  create_table "friendly_id_slugs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "news", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "title"
    t.text "content"
    t.string "pic"
    t.integer "sort"
    t.integer "sort_en"
    t.boolean "is_tw"
    t.boolean "is_en"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "release_date"
    t.string "slug"
    t.index ["release_date"], name: "index_news_on_release_date"
    t.index ["slug"], name: "index_news_on_slug"
  end

  create_table "news_tags", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.string "name_en"
  end

  create_table "news_tags_relations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "news_id"
    t.integer "news_tag_id"
  end

  create_table "order_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "product_id"
    t.integer "order_id"
    t.integer "quantity"
    t.integer "price"
    t.integer "product_size_id"
    t.integer "product_color_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "shipping_address"
    t.string "billing_address"
    t.string "receiver"
    t.string "phone"
    t.string "zip_code"
    t.string "city"
    t.string "state"
    t.string "country"
    t.integer "user_id"
    t.integer "shipping_cost_id"
    t.string "shipping_name"
    t.string "shipping_store"
    t.integer "total"
    t.text "memo"
    t.string "payment"
    t.string "bank"
    t.string "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_payed", default: false
    t.string "code"
    t.boolean "is_show"
    t.index ["shipping_cost_id"], name: "index_orders_on_shipping_cost_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_categories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.boolean "is_visible", default: true
    t.integer "parent_id"
    t.integer "sort"
    t.string "name_en"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["parent_id"], name: "index_product_categories_on_parent_id"
  end

  create_table "product_category_ships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_id"
    t.integer "product_category_id"
    t.index ["product_category_id"], name: "index_product_category_ships_on_product_category_id"
    t.index ["product_id"], name: "index_product_category_ships_on_product_id"
  end

  create_table "product_colors", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "product_id"
    t.string "color"
    t.string "color_en"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_delete", default: false
    t.string "rgb", default: "#1c1c1b"
    t.string "pic"
    t.index ["product_id"], name: "index_product_colors_on_product_id"
  end

  create_table "product_infos", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.string "weight"
    t.string "material"
    t.string "capacity"
    t.text "quick_overview"
    t.string "dimension"
    t.integer "price"
    t.integer "special_price"
    t.text "feature"
    t.boolean "is_visible", default: false
    t.integer "product_id"
    t.integer "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "shipping"
    t.index ["country_id"], name: "index_product_infos_on_country_id"
    t.index ["product_id"], name: "index_product_infos_on_product_id"
  end

  create_table "product_pics", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "product_id"
    t.string "description"
    t.string "pic"
    t.integer "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["product_id"], name: "index_product_pics_on_product_id"
  end

  create_table "product_quantities", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "product_id"
    t.integer "product_color_id"
    t.integer "product_size_id"
    t.integer "quantity", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["product_color_id"], name: "index_product_quantities_on_product_color_id"
    t.index ["product_id"], name: "index_product_quantities_on_product_id"
    t.index ["product_size_id"], name: "index_product_quantities_on_product_size_id"
  end

  create_table "product_sizes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "product_id"
    t.string "size"
    t.string "size_en"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_delete", default: false
    t.index ["product_id"], name: "index_product_sizes_on_product_id"
  end

  create_table "products", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "no"
    t.integer "product_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "sort", default: 0
    t.integer "views", default: 0
    t.boolean "is_show_at_index", default: false
    t.string "slug"
    t.boolean "is_visible", default: true
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
    t.index ["slug"], name: "index_products_on_slug"
    t.index ["sort"], name: "index_products_on_sort"
    t.index ["views"], name: "index_products_on_views"
  end

  create_table "recommend_ships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_id"
    t.integer "recommend_id"
    t.integer "sort", default: 0
    t.index ["product_id"], name: "index_recommend_ships_on_product_id"
    t.index ["recommend_id"], name: "index_recommend_ships_on_recommend_id"
    t.index ["sort"], name: "index_recommend_ships_on_sort"
  end

  create_table "shipping_costs", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "cost"
    t.string "description"
    t.integer "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["country_id"], name: "index_shipping_costs_on_country_id"
  end

  create_table "subscriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email"
    t.boolean "is_registered", default: false
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "shipping_address"
    t.string "billing_address"
    t.string "receiver"
    t.string "phone"
    t.string "zip_code"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "avatar"
    t.datetime "last_sign_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "role"
    t.string "token"
    t.string "provider"
    t.string "gender"
    t.string "uid"
  end

  create_table "videos", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "link"
    t.text "intro"
    t.integer "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
