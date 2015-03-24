# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150321205815) do

  create_table "chaskiq_attachments", force: :cascade do |t|
    t.string   "image"
    t.string   "content_type"
    t.integer  "size"
    t.string   "name"
    t.integer  "campaign_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "chaskiq_attachments", ["campaign_id"], name: "index_chaskiq_attachments_on_campaign_id"

  create_table "chaskiq_campaigns", force: :cascade do |t|
    t.string   "subject"
    t.string   "from_name"
    t.string   "from_email"
    t.string   "reply_email"
    t.text     "plain_content"
    t.text     "html_content"
    t.text     "premailer"
    t.text     "description"
    t.string   "logo"
    t.string   "name"
    t.string   "query_string"
    t.datetime "scheduled_at"
    t.string   "timezone"
    t.string   "state"
    t.integer  "recipients_count"
    t.boolean  "sent"
    t.integer  "opens_count"
    t.integer  "clicks_count"
    t.integer  "parent_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "list_id"
    t.integer  "template_id"
  end

  add_index "chaskiq_campaigns", ["list_id"], name: "index_chaskiq_campaigns_on_list_id"
  add_index "chaskiq_campaigns", ["parent_id"], name: "index_chaskiq_campaigns_on_parent_id"
  add_index "chaskiq_campaigns", ["template_id"], name: "index_chaskiq_campaigns_on_template_id"

  create_table "chaskiq_lists", force: :cascade do |t|
    t.string   "name"
    t.string   "state"
    t.integer  "unsubscribe_count"
    t.integer  "bounced"
    t.integer  "active_count"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "chaskiq_metrics", force: :cascade do |t|
    t.integer  "trackable_id",   null: false
    t.string   "trackable_type", null: false
    t.integer  "campaign_id"
    t.string   "action"
    t.string   "host"
    t.string   "data"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "chaskiq_metrics", ["campaign_id"], name: "index_chaskiq_metrics_on_campaign_id"
  add_index "chaskiq_metrics", ["trackable_type", "trackable_id"], name: "index_chaskiq_metrics_on_trackable_type_and_trackable_id"

  create_table "chaskiq_settings", force: :cascade do |t|
    t.text     "config"
    t.integer  "campaign_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "chaskiq_settings", ["campaign_id"], name: "index_chaskiq_settings_on_campaign_id"

  create_table "chaskiq_subscribers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "state"
    t.string   "last_name"
    t.integer  "list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "chaskiq_subscribers", ["list_id"], name: "index_chaskiq_subscribers_on_list_id"

  create_table "chaskiq_templates", force: :cascade do |t|
    t.string   "name"
    t.text     "body"
    t.text     "html_content"
    t.string   "screenshot"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
