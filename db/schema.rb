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

ActiveRecord::Schema.define(:version => 20120215095925) do

  create_table "achievements", :force => true do |t|
    t.integer  "activity_id"
    t.integer  "achievements_type_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "achievements_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activities", :force => true do |t|
    t.string   "title"
    t.string   "description",               :limit => 5000
    t.datetime "start_date"
    t.string   "duration"
    t.string   "location"
    t.integer  "required_volunteers_count"
    t.string   "volunteers_skills",         :limit => 2000
    t.boolean  "facebook_announce"
    t.boolean  "email_notifications"
    t.boolean  "disclose_volunteers"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                                    :default => 1
    t.string   "rejection_reason",          :limit => 500
    t.integer  "volunteers_count",                          :default => 0
    t.string   "duration_type"
    t.integer  "volunteers_hours",                          :default => 0
    t.text     "summary",                                   :default => ""
    t.string   "album_id"
    t.boolean  "requires_approval",                         :default => false
    t.integer  "total_volunteers_count",                    :default => 0
    t.integer  "front_photo_id"
    t.string   "facebook_post_message",     :limit => 2000
    t.boolean  "reminder_sent",                             :default => false
  end

  create_table "activities_activity_categories", :id => false, :force => true do |t|
    t.integer "activity_id"
    t.integer "activity_category_id"
  end

  create_table "activities_branches", :id => false, :force => true do |t|
    t.integer "branch_id"
    t.integer "activity_id"
  end

  create_table "activities_media", :id => false, :force => true do |t|
    t.integer "activity_id"
    t.integer "media_id"
  end

  create_table "activities_requests", :force => true do |t|
    t.integer "activity_id"
    t.integer "volunteer_id"
    t.integer "status",        :default => 1
    t.string  "reject_reason"
  end

  create_table "activity_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_description", :limit => 600
    t.integer  "front_photo_id"
    t.integer  "legacy_id"
    t.integer  "position",                         :default => 0
    t.boolean  "donatable",                        :default => true
  end

  create_table "activity_categories_articles", :id => false, :force => true do |t|
    t.integer "activity_category_id"
    t.integer "article_id"
  end

  add_index "activity_categories_articles", ["activity_category_id"], :name => "index_activity_categories_articles_on_activity_category_id"
  add_index "activity_categories_articles", ["article_id"], :name => "index_activity_categories_articles_on_article_id"

  create_table "activity_categories_branches", :id => false, :force => true do |t|
    t.integer "branch_id"
    t.integer "activity_category_id"
  end

  add_index "activity_categories_branches", ["branch_id"], :name => "index_activity_categories_branches_on_branch_id"

  create_table "activity_categories_donation_requests", :id => false, :force => true do |t|
    t.integer "activity_category_id"
    t.integer "donation_request_id"
  end

  create_table "activity_categories_media", :id => false, :force => true do |t|
    t.integer "activity_category_id"
    t.integer "media_id"
  end

  add_index "activity_categories_media", ["activity_category_id"], :name => "index_activity_categories_media_on_activity_category_id"

  create_table "activity_categories_volunteers", :id => false, :force => true do |t|
    t.integer "volunteer_id"
    t.integer "activity_category_id"
  end

  create_table "article_categories", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "article_categories", ["name"], :name => "index_article_categories_on_name"

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "article_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "views_count",         :default => 0
    t.string   "facebook_post_id"
    t.integer  "legacy_id"
    t.integer  "front_photo_id"
    t.string   "album_id"
  end

  add_index "articles", ["article_category_id"], :name => "index_articles_on_article_category_id"

  create_table "articles_branches", :id => false, :force => true do |t|
    t.integer "article_id"
    t.integer "branch_id"
  end

  create_table "articles_media", :id => false, :force => true do |t|
    t.integer "article_id"
    t.integer "media_id"
  end

  add_index "articles_media", ["article_id"], :name => "index_articles_media_on_article_id"

  create_table "branches", :force => true do |t|
    t.string   "name",                        :null => false
    t.string   "description", :limit => 2000
    t.string   "address"
    t.string   "phones"
    t.integer  "city_id"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  add_index "branches", ["city_id"], :name => "index_branches_on_city_id"

  create_table "branches_media", :id => false, :force => true do |t|
    t.integer "branch_id"
    t.integer "media_id"
  end

  add_index "branches_media", ["branch_id"], :name => "index_branches_media_on_branch_id"

  create_table "cities", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donation_requests", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "email"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reviewed",      :default => false
    t.string   "mobile"
    t.string   "amount"
    t.string   "amount_period"
    t.string   "notes"
  end

  create_table "donations", :force => true do |t|
    t.string   "donator_name"
    t.integer  "amount",                              :null => false
    t.integer  "status",               :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_category_id"
    t.string   "phone"
    t.string   "email"
  end

  create_table "media", :force => true do |t|
    t.string   "fb_id"
    t.string   "media_type",                                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail"
    t.string   "media_upload_type",  :default => "Facebook"
    t.integer  "status",             :default => 2
    t.boolean  "processed",          :default => true
    t.string   "media_file_name"
    t.string   "media_content_type"
    t.integer  "media_file_size"
    t.datetime "media_updated_at"
    t.string   "desc",               :default => ""
  end

  add_index "media", ["media_type"], :name => "index_media_on_media_type"

  create_table "newsletter_subscribers", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "token"
    t.boolean  "confirmed",  :default => false
  end

  create_table "payment_settings", :force => true do |t|
    t.string "key",                                       :null => false
    t.string "virtualPaymentClientURL",                   :null => false
    t.string "vpc_AccessCode",                            :null => false
    t.string "vpc_Merchant",                              :null => false
    t.string "vpc_Locale",              :default => "ar", :null => false
    t.string "secure_key_key"
    t.binary "secure_key"
  end

  create_table "questions", :force => true do |t|
    t.string   "question",             :limit => 1000,                :null => false
    t.text     "answer",                                              :null => false
    t.integer  "position",                             :default => 0
    t.integer  "activity_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["position"], :name => "index_questions_on_position"

  create_table "testimonials", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "source"
    t.string   "url",             :limit => 2000
    t.date     "disclosure_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "legacy_id"
    t.integer  "photo_id"
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image"
    t.string   "provider_token"
    t.string   "provider_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "facebook_page_admin",                :default => false
    t.string   "type"
    t.string   "email"
    t.string   "gender"
    t.date     "date_of_birth"
    t.boolean  "post_updates_to_facebook",           :default => true
    t.integer  "branch_id"
    t.string   "mobile"
    t.boolean  "graduated"
    t.string   "profession"
    t.string   "company"
    t.string   "university"
    t.string   "school_year"
    t.boolean  "blood_donation",                     :default => false
    t.string   "blood_type"
    t.text     "bio"
    t.boolean  "get_activities_updates",             :default => false
    t.integer  "available_days",                     :default => 0
    t.boolean  "suspended",                          :default => false
    t.integer  "activities_authority_status"
    t.string   "request_activities"
    t.string   "existing_role"
    t.integer  "accepted_activities_requests_count", :default => 0
    t.integer  "activities_hours",                   :default => 0
    t.boolean  "limited_days",                       :default => false
    t.string   "pending_notifications"
    t.boolean  "has_pending_notifications",          :default => false
    t.boolean  "irregular_mobile",                   :default => false
  end

  add_index "users", ["type", "uid", "provider"], :name => "by_uid_type_provider", :unique => true

end
