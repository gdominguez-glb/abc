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

ActiveRecord::Schema.define(version: 20171127104137) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.integer  "item_id"
    t.string   "item_type"
    t.string   "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "activities", ["action"], name: "index_activities_on_action", using: :btree
  add_index "activities", ["item_id"], name: "index_activities_on_item_id", using: :btree
  add_index "activities", ["item_type"], name: "index_activities_on_item_type", using: :btree
  add_index "activities", ["updated_at"], name: "index_activities_on_updated_at", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.text     "content"
    t.integer  "position"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "content_draft"
  end

  create_table "articles", force: :cascade do |t|
    t.integer  "blog_id"
    t.string   "title"
    t.text     "body"
    t.text     "body_draft"
    t.integer  "publish_status",                    default: 0
    t.integer  "draft_status",                      default: 0
    t.datetime "archived_at"
    t.boolean  "archived",                          default: false
    t.boolean  "display",                           default: false
    t.string   "slug"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "jumbotron_background_file_name"
    t.string   "jumbotron_background_content_type"
    t.integer  "jumbotron_background_file_size"
    t.datetime "jumbotron_background_updated_at"
    t.integer  "user_id"
    t.date     "publish_date"
    t.datetime "published_at"
    t.string   "created_by"
    t.string   "mailchimp_campaign_id"
    t.string   "external_link"
    t.boolean  "campaign_created",                  default: false
  end

  create_table "blogs", force: :cascade do |t|
    t.string   "title"
    t.integer  "blog_type"
    t.integer  "position"
    t.boolean  "display"
    t.string   "slug"
    t.string   "header"
    t.text     "description"
    t.integer  "page_id"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "jumbotron_background_file_name"
    t.string   "jumbotron_background_content_type"
    t.integer  "jumbotron_background_file_size"
    t.datetime "jumbotron_background_updated_at"
    t.string   "mandrill_subscription_template_slug"
    t.integer  "mailchimp_post_template_id"
    t.string   "mailchimp_list_id"
    t.boolean  "enable_notification",                 default: true
  end

  create_table "contact_topics", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "email"
    t.text     "message"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "topic"
  end

  create_table "curriculum_mails", force: :cascade do |t|
    t.string   "curriculum"
    t.string   "subject"
    t.text     "content"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "curriculum_shops", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "curriculums", force: :cascade do |t|
    t.string   "name"
    t.integer  "position",   default: 0
    t.boolean  "visible",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "custom_csses", force: :cascade do |t|
    t.string   "name"
    t.integer  "page_id"
    t.integer  "custom_type"
    t.text     "content"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "custom_field_options", force: :cascade do |t|
    t.integer  "custom_field_id"
    t.string   "value"
    t.string   "label"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "position",        default: 0
    t.boolean  "display",         default: true
  end

  create_table "custom_field_values", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "custom_field_id"
    t.text     "value"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "custom_fields", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "field_type"
    t.string   "salesforce_field_name"
    t.string   "subject"
    t.string   "user_title"
    t.boolean  "display",               default: false
    t.integer  "position",              default: 0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.datetime "effect_at"
    t.datetime "expire_at"
  end

  create_table "document_taggings", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "tag_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "document_taggings", ["document_id"], name: "index_document_taggings_on_document_id", using: :btree
  add_index "document_taggings", ["tag_id"], name: "index_document_taggings_on_tag_id", using: :btree

  create_table "document_tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string   "name"
    t.string   "category"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "alt_text"
  end

  create_table "download_jobs", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "material_ids"
    t.string   "status"
    t.integer  "percent"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "download_pages", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "slug"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "download_products", force: :cascade do |t|
    t.integer  "download_page_id"
    t.integer  "product_id"
    t.integer  "position",         default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "event_pages", force: :cascade do |t|
    t.string   "title"
    t.integer  "page_id"
    t.boolean  "display",           default: false
    t.string   "regonline_filter"
    t.string   "slug"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "event_page_type",   default: 0
    t.text     "description"
    t.text     "description_draft"
    t.integer  "publish_status",    default: 0
    t.integer  "draft_status",      default: 0
    t.datetime "published_at"
    t.boolean  "archived",          default: false
    t.datetime "archived_at"
    t.boolean  "hide_dropdown",     default: false
  end

  create_table "event_training_headers", force: :cascade do |t|
    t.string   "name"
    t.integer  "position",                  default: 0
    t.integer  "training_type_category_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "event_training_headers", ["training_type_category_id"], name: "index_event_training_headers_on_training_type_category_id", using: :btree

  create_table "event_trainings", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.string   "training_type"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "position",                  default: 0
    t.string   "category"
    t.integer  "training_type_category_id"
    t.integer  "event_training_header_id"
  end

  create_table "fall_institute_pds", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "role"
    t.string   "email"
    t.string   "phone"
    t.string   "preferred_contact"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "famis_products", force: :cascade do |t|
    t.string   "record_id"
    t.string   "name"
    t.string   "image"
    t.text     "small_description"
    t.text     "description"
    t.decimal  "price"
    t.string   "grade"
    t.string   "isbn"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "faq_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.boolean  "display",                default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "faq_category_header_id"
  end

  create_table "faq_category_headers", force: :cascade do |t|
    t.string   "name"
    t.integer  "position",   default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "footer_links", force: :cascade do |t|
    t.integer  "footer_title_id"
    t.string   "name"
    t.string   "link"
    t.integer  "position",        default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "footer_titles", force: :cascade do |t|
    t.string   "title"
    t.string   "link"
    t.integer  "position",   default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "help_items", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "display",    default: false
    t.integer  "position",   default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "in_the_news", force: :cascade do |t|
    t.string   "call_to_action_button_link"
    t.string   "call_to_action_button_target"
    t.string   "call_to_action_button_text"
    t.string   "title"
    t.string   "author"
    t.string   "publisher"
    t.string   "slug"
    t.string   "image_url"
    t.datetime "article_date"
    t.string   "description"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "display"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "position"
    t.text     "content_draft"
    t.integer  "publish_status", default: 0
    t.integer  "draft_status",   default: 0
    t.datetime "published_at"
    t.boolean  "archived",       default: false
    t.datetime "archived_at"
  end

  create_table "legacy_licenses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "expiration_date"
    t.integer  "ee_id"
    t.string   "mapped_name"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "order_id"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "from_email"
    t.integer  "from_user_id"
    t.boolean  "is_migrated",     default: false
  end

  create_table "legacy_users", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_school_admin", default: false
    t.boolean  "is_sub_admin",    default: false
    t.integer  "parent_admin_id"
    t.datetime "imported_at"
    t.integer  "ee_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "link_files", force: :cascade do |t|
    t.string   "slug"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "medium_publications", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.string   "blog_type"
    t.integer  "position"
    t.boolean  "display"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "slug"
    t.integer  "page_id"
    t.string   "header"
    t.text     "description"
  end

  create_table "notification_triggers", force: :cascade do |t|
    t.string   "target_type"
    t.string   "user_type"
    t.text     "user_ids"
    t.integer  "school_district_admin_user_id"
    t.text     "content"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "single_user_id"
    t.datetime "notify_at"
    t.string   "status",                        default: "pending"
    t.boolean  "email",                         default: false
    t.boolean  "dashboard",                     default: false
    t.integer  "curriculum_id"
    t.integer  "product_id"
    t.datetime "expire_at"
    t.text     "zip_codes"
    t.text     "product_ids"
    t.string   "curriculum_type"
    t.date     "sign_up_started_at"
    t.date     "sign_up_ended_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "notification_trigger_id"
    t.text     "content"
    t.boolean  "read",                    default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.datetime "expire_at"
    t.boolean  "viewed",                  default: false
  end

  add_index "notifications", ["created_at"], name: "index_notifications_on_created_at", using: :btree
  add_index "notifications", ["expire_at"], name: "index_notifications_on_expire_at", using: :btree
  add_index "notifications", ["read"], name: "index_notifications_on_read", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "opportunities", force: :cascade do |t|
    t.string   "salesforce_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "po_number"
    t.string   "opportunity_id_sf"
    t.text     "data"
  end

  create_table "opportunity_attachments", force: :cascade do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "opportunity_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "category"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.text     "seo_content"
    t.string   "slug",                           null: false
    t.string   "group_name"
    t.string   "sub_group_name"
    t.integer  "position",       default: 0
    t.string   "layout"
    t.text     "body"
    t.boolean  "visible",        default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "show_in_nav",    default: true
    t.boolean  "show_in_footer", default: false
    t.boolean  "group_root",     default: false
    t.integer  "curriculum_id"
    t.text     "tiles"
    t.string   "keywords"
    t.string   "description"
    t.integer  "publish_status", default: 0
    t.integer  "draft_status",   default: 0
    t.datetime "published_at"
    t.text     "body_draft"
    t.boolean  "archived",       default: false
    t.datetime "archived_at"
    t.text     "seo_data"
    t.string   "render",         default: ""
    t.text     "data"
    t.boolean  "hubspot"
  end

  create_table "popups", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.string   "slug"
    t.string   "button_link"
    t.string   "button_text"
    t.string   "text_color"
    t.string   "background_color"
    t.datetime "starts_at"
    t.datetime "expires_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "medium_publication_id"
    t.string   "title"
    t.string   "subtitle"
    t.datetime "published_at"
    t.string   "medium_id"
    t.text     "body"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.text     "preview_content"
    t.string   "slug"
  end

  create_table "product_tracks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "material_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "products_recommendations", id: false, force: :cascade do |t|
    t.integer "product_id"
    t.integer "recommendation_id"
  end

  create_table "products_whats_news", force: :cascade do |t|
    t.integer "product_id"
    t.integer "whats_new_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string   "title"
    t.integer  "position"
    t.boolean  "display",         default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "faq_category_id"
    t.integer  "publish_status",  default: 0
    t.integer  "draft_status",    default: 0
    t.datetime "published_at"
    t.boolean  "archived",        default: false
    t.datetime "archived_at"
    t.string   "slug"
  end

  create_table "recommendations", force: :cascade do |t|
    t.string   "title"
    t.text     "sub_header"
    t.string   "call_to_action_button_text"
    t.string   "call_to_action_button_link"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "subject"
    t.string   "icon"
    t.boolean  "display",                      default: false
    t.string   "user_title"
    t.integer  "position",                     default: 0
    t.string   "call_to_action_button_target"
    t.integer  "views",                        default: 0
    t.integer  "clicks",                       default: 0
    t.string   "zip_codes"
    t.text     "image_url"
    t.boolean  "image_contain"
    t.datetime "expire_at"
  end

  create_table "regonline_event_headers", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "event_page_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "regonline_events", force: :cascade do |t|
    t.string   "regonline_id"
    t.string   "title"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "active_date"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "postal_code"
    t.string   "location_name"
    t.string   "location_room"
    t.string   "location_building"
    t.string   "location_address1"
    t.string   "location_address2"
    t.decimal  "latitude",                  precision: 10, scale: 6
    t.decimal  "longitude",                 precision: 10, scale: 6
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.string   "client_event_id"
    t.text     "description"
    t.string   "download_url"
    t.string   "grade_bands"
    t.text     "session_types"
    t.boolean  "display",                                            default: false
    t.date     "invisible_at"
    t.string   "curriculums"
    t.date     "deadline_date"
    t.integer  "regonline_event_header_id"
  end

  add_index "regonline_events", ["regonline_event_header_id"], name: "index_regonline_events_on_regonline_event_header_id", using: :btree

  create_table "salesforce_references", force: :cascade do |t|
    t.string   "id_in_salesforce",                 limit: 30
    t.integer  "local_object_id",                             null: false
    t.string   "local_object_type",                limit: 50, null: false
    t.datetime "last_modified_in_salesforce_at"
    t.datetime "last_imported_from_salesforce_at"
    t.text     "object_properties"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "salesforce_references", ["id_in_salesforce"], name: "index_salesforce_references_on_id_in_salesforce", using: :btree
  add_index "salesforce_references", ["local_object_id", "local_object_type"], name: "index_salesforce_references_on_local_object_reference", using: :btree

  create_table "school_districts", force: :cascade do |t|
    t.string   "name"
    t.integer  "state_id"
    t.string   "place_type"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "country_id"
    t.string   "city"
    t.boolean  "sf_is_deleted", default: false
    t.boolean  "sf_verified",   default: false
    t.datetime "sf_created_at"
  end

  add_index "school_districts", ["name"], name: "index_school_districts_on_name", using: :btree
  add_index "school_districts", ["sf_created_at"], name: "index_school_districts_on_sf_created_at", using: :btree
  add_index "school_districts", ["sf_is_deleted"], name: "index_school_districts_on_sf_is_deleted", using: :btree
  add_index "school_districts", ["sf_verified"], name: "index_school_districts_on_sf_verified", using: :btree
  add_index "school_districts", ["state_id"], name: "index_school_districts_on_state_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "spree_addresses", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "state_name"
    t.string   "alternative_phone"
    t.string   "company"
    t.integer  "state_id"
    t.integer  "country_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "spree_addresses", ["country_id"], name: "index_spree_addresses_on_country_id", using: :btree
  add_index "spree_addresses", ["firstname"], name: "index_addresses_on_firstname", using: :btree
  add_index "spree_addresses", ["lastname"], name: "index_addresses_on_lastname", using: :btree
  add_index "spree_addresses", ["state_id"], name: "index_spree_addresses_on_state_id", using: :btree

  create_table "spree_adjustments", force: :cascade do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "adjustable_id"
    t.string   "adjustable_type"
    t.decimal  "amount",          precision: 10, scale: 2
    t.string   "label"
    t.boolean  "mandatory"
    t.boolean  "eligible",                                 default: true
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.string   "state"
    t.integer  "order_id"
    t.boolean  "included",                                 default: false
  end

  add_index "spree_adjustments", ["adjustable_id", "adjustable_type"], name: "index_spree_adjustments_on_adjustable_id_and_adjustable_type", using: :btree
  add_index "spree_adjustments", ["adjustable_id"], name: "index_adjustments_on_order_id", using: :btree
  add_index "spree_adjustments", ["eligible"], name: "index_spree_adjustments_on_eligible", using: :btree
  add_index "spree_adjustments", ["order_id"], name: "index_spree_adjustments_on_order_id", using: :btree
  add_index "spree_adjustments", ["source_id", "source_type"], name: "index_spree_adjustments_on_source_id_and_source_type", using: :btree

  create_table "spree_assets", force: :cascade do |t|
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.integer  "attachment_width"
    t.integer  "attachment_height"
    t.integer  "attachment_file_size"
    t.integer  "position"
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.string   "type",                    limit: 75
    t.datetime "attachment_updated_at"
    t.text     "alt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_assets", ["viewable_id"], name: "index_assets_on_viewable_id", using: :btree
  add_index "spree_assets", ["viewable_type", "type"], name: "index_assets_on_viewable_type_and_type", using: :btree

  create_table "spree_bookmarks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "bookmarkable_id"
    t.string   "bookmarkable_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "spree_calculators", force: :cascade do |t|
    t.string   "type"
    t.integer  "calculable_id"
    t.string   "calculable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "preferences"
  end

  add_index "spree_calculators", ["calculable_id", "calculable_type"], name: "index_spree_calculators_on_calculable_id_and_calculable_type", using: :btree
  add_index "spree_calculators", ["id", "type"], name: "index_spree_calculators_on_id_and_type", using: :btree

  create_table "spree_countries", force: :cascade do |t|
    t.string   "iso_name"
    t.string   "iso"
    t.string   "iso3"
    t.string   "name"
    t.integer  "numcode"
    t.boolean  "states_required", default: false
    t.datetime "updated_at"
  end

  create_table "spree_coupon_codes", force: :cascade do |t|
    t.string   "code"
    t.integer  "total_quantity"
    t.integer  "used_quantity"
    t.integer  "school_district_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "sf_order_id"
    t.boolean  "sync_specified_order"
    t.text     "school_lists"
  end

  create_table "spree_coupon_codes_products", force: :cascade do |t|
    t.integer  "coupon_code_id",             null: false
    t.integer  "product_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",       default: 0
    t.integer  "used_quantity",  default: 0
  end

  create_table "spree_credit_cards", force: :cascade do |t|
    t.string   "month"
    t.string   "year"
    t.string   "cc_type"
    t.integer  "address_id"
    t.string   "gateway_customer_profile_id"
    t.string   "gateway_payment_profile_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "name"
    t.integer  "user_id"
    t.integer  "payment_method_id"
    t.boolean  "default",                     default: false, null: false
  end

  add_index "spree_credit_cards", ["address_id"], name: "index_spree_credit_cards_on_address_id", using: :btree
  add_index "spree_credit_cards", ["payment_method_id"], name: "index_spree_credit_cards_on_payment_method_id", using: :btree
  add_index "spree_credit_cards", ["user_id"], name: "index_spree_credit_cards_on_user_id", using: :btree

  create_table "spree_curriculums", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.integer  "position"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "spree_customer_returns", force: :cascade do |t|
    t.string   "number"
    t.integer  "stock_location_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "spree_digital_links", force: :cascade do |t|
    t.integer  "digital_id"
    t.integer  "line_item_id"
    t.string   "secret"
    t.integer  "access_counter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_digital_links", ["digital_id"], name: "index_spree_digital_links_on_digital_id", using: :btree
  add_index "spree_digital_links", ["line_item_id"], name: "index_spree_digital_links_on_line_item_id", using: :btree
  add_index "spree_digital_links", ["secret"], name: "index_spree_digital_links_on_secret", using: :btree

  create_table "spree_digitals", force: :cascade do |t|
    t.integer  "variant_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wistia_id"
    t.string   "wistia_hashed_id"
    t.string   "wistia_status"
  end

  add_index "spree_digitals", ["variant_id"], name: "index_spree_digitals_on_variant_id", using: :btree

  create_table "spree_gateways", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      default: true
    t.string   "environment", default: "development"
    t.string   "server",      default: "test"
    t.boolean  "test_mode",   default: true
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "preferences"
  end

  add_index "spree_gateways", ["active"], name: "index_spree_gateways_on_active", using: :btree
  add_index "spree_gateways", ["test_mode"], name: "index_spree_gateways_on_test_mode", using: :btree

  create_table "spree_grade_units", force: :cascade do |t|
    t.integer  "grade_id"
    t.string   "name"
    t.integer  "position",   default: 0
    t.datetime "deleted_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "spree_grades", force: :cascade do |t|
    t.string   "name"
    t.string   "abbr"
    t.string   "school"
    t.integer  "position",   default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "deleted_at"
  end

  create_table "spree_grades_products", id: false, force: :cascade do |t|
    t.integer "grade_id",   null: false
    t.integer "product_id", null: false
  end

  create_table "spree_group_items", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "position"
  end

  create_table "spree_inkling_codes", force: :cascade do |t|
    t.integer  "product_id"
    t.text     "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spree_inventory_units", force: :cascade do |t|
    t.string   "state"
    t.integer  "variant_id"
    t.integer  "order_id"
    t.integer  "shipment_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "pending",      default: true
    t.integer  "line_item_id"
  end

  add_index "spree_inventory_units", ["line_item_id"], name: "index_spree_inventory_units_on_line_item_id", using: :btree
  add_index "spree_inventory_units", ["order_id"], name: "index_inventory_units_on_order_id", using: :btree
  add_index "spree_inventory_units", ["shipment_id"], name: "index_inventory_units_on_shipment_id", using: :btree
  add_index "spree_inventory_units", ["variant_id"], name: "index_inventory_units_on_variant_id", using: :btree

  create_table "spree_library_items", force: :cascade do |t|
    t.integer  "library_leaf_id"
    t.string   "name"
    t.integer  "position"
    t.text     "inkling_code"
    t.integer  "item_type"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "spree_library_leafs", force: :cascade do |t|
    t.string   "name"
    t.integer  "product_id"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spree_licensed_products", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "order_id"
    t.datetime "expire_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "quantity",                default: 0
    t.string   "email"
    t.integer  "product_distribution_id"
    t.boolean  "can_be_distributed",      default: false
    t.datetime "fulfillment_at"
    t.integer  "admin_user_id"
    t.integer  "coupon_code_id"
    t.string   "school_name_from_coupon"
  end

  add_index "spree_licensed_products", ["can_be_distributed"], name: "index_spree_licensed_products_on_can_be_distributed", using: :btree
  add_index "spree_licensed_products", ["expire_at"], name: "index_spree_licensed_products_on_expire_at", using: :btree
  add_index "spree_licensed_products", ["fulfillment_at"], name: "index_spree_licensed_products_on_fulfillment_at", using: :btree
  add_index "spree_licensed_products", ["product_id"], name: "index_spree_licensed_products_on_product_id", using: :btree
  add_index "spree_licensed_products", ["quantity"], name: "index_spree_licensed_products_on_quantity", using: :btree
  add_index "spree_licensed_products", ["user_id"], name: "index_spree_licensed_products_on_user_id", using: :btree

  create_table "spree_line_items", force: :cascade do |t|
    t.integer  "variant_id"
    t.integer  "order_id"
    t.integer  "quantity",                                                    null: false
    t.decimal  "price",                precision: 10, scale: 2,               null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "currency"
    t.decimal  "cost_price",           precision: 10, scale: 2
    t.integer  "tax_category_id"
    t.decimal  "adjustment_total",     precision: 10, scale: 2, default: 0.0
    t.decimal  "additional_tax_total", precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",          precision: 10, scale: 2, default: 0.0
    t.decimal  "included_tax_total",   precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "pre_tax_amount",       precision: 8,  scale: 2, default: 0.0
  end

  add_index "spree_line_items", ["order_id"], name: "index_spree_line_items_on_order_id", using: :btree
  add_index "spree_line_items", ["tax_category_id"], name: "index_spree_line_items_on_tax_category_id", using: :btree
  add_index "spree_line_items", ["variant_id"], name: "index_spree_line_items_on_variant_id", using: :btree

  create_table "spree_log_entries", force: :cascade do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.text     "details"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "spree_log_entries", ["source_id", "source_type"], name: "index_spree_log_entries_on_source_id_and_source_type", using: :btree

  create_table "spree_material_files", force: :cascade do |t|
    t.integer  "material_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "spree_material_import_jobs", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "spree_materials", force: :cascade do |t|
    t.string   "name"
    t.integer  "product_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth",                default: 0
    t.integer  "children_count",       default: 0
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "position",             default: 0
    t.integer  "material_files_count", default: 0
    t.string   "link"
    t.string   "link_icon",            default: "open_in_browser"
  end

  create_table "spree_option_types", force: :cascade do |t|
    t.string   "name",         limit: 100
    t.string   "presentation", limit: 100
    t.integer  "position",                 default: 0, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "spree_option_types", ["position"], name: "index_spree_option_types_on_position", using: :btree

  create_table "spree_option_types_prototypes", id: false, force: :cascade do |t|
    t.integer "prototype_id"
    t.integer "option_type_id"
  end

  create_table "spree_option_values", force: :cascade do |t|
    t.integer  "position"
    t.string   "name"
    t.string   "presentation"
    t.integer  "option_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "spree_option_values", ["option_type_id"], name: "index_spree_option_values_on_option_type_id", using: :btree
  add_index "spree_option_values", ["position"], name: "index_spree_option_values_on_position", using: :btree

  create_table "spree_option_values_variants", id: false, force: :cascade do |t|
    t.integer "variant_id"
    t.integer "option_value_id"
  end

  add_index "spree_option_values_variants", ["variant_id", "option_value_id"], name: "index_option_values_variants_on_variant_id_and_option_value_id", using: :btree
  add_index "spree_option_values_variants", ["variant_id"], name: "index_spree_option_values_variants_on_variant_id", using: :btree

  create_table "spree_orders", force: :cascade do |t|
    t.string   "number",                     limit: 32
    t.decimal  "item_total",                            precision: 10, scale: 2, default: 0.0,     null: false
    t.decimal  "total",                                 precision: 10, scale: 2, default: 0.0,     null: false
    t.string   "state"
    t.decimal  "adjustment_total",                      precision: 10, scale: 2, default: 0.0,     null: false
    t.integer  "user_id"
    t.datetime "completed_at"
    t.integer  "bill_address_id"
    t.integer  "ship_address_id"
    t.decimal  "payment_total",                         precision: 10, scale: 2, default: 0.0
    t.integer  "shipping_method_id"
    t.string   "shipment_state"
    t.string   "payment_state"
    t.string   "email"
    t.text     "special_instructions"
    t.datetime "created_at",                                                                       null: false
    t.datetime "updated_at",                                                                       null: false
    t.string   "currency"
    t.string   "last_ip_address"
    t.integer  "created_by_id"
    t.decimal  "shipment_total",                        precision: 10, scale: 2, default: 0.0,     null: false
    t.decimal  "additional_tax_total",                  precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",                           precision: 10, scale: 2, default: 0.0
    t.string   "channel",                                                        default: "spree"
    t.decimal  "included_tax_total",                    precision: 10, scale: 2, default: 0.0,     null: false
    t.integer  "item_count",                                                     default: 0
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.boolean  "confirmation_delivered",                                         default: false
    t.boolean  "considered_risky",                                               default: false
    t.string   "guest_token"
    t.datetime "canceled_at"
    t.integer  "canceler_id"
    t.integer  "store_id"
    t.integer  "state_lock_version",                                             default: 0,       null: false
    t.boolean  "terms_and_conditions"
    t.string   "license_admin_email"
    t.integer  "school_district_id"
    t.integer  "source",                                                         default: 0
    t.integer  "admin_user_id"
    t.string   "sf_contact_id"
    t.date     "fulfillment_at"
    t.boolean  "enable_single_distribution",                                     default: false
    t.integer  "coupon_code_id"
  end

  add_index "spree_orders", ["approver_id"], name: "index_spree_orders_on_approver_id", using: :btree
  add_index "spree_orders", ["bill_address_id"], name: "index_spree_orders_on_bill_address_id", using: :btree
  add_index "spree_orders", ["completed_at"], name: "index_spree_orders_on_completed_at", using: :btree
  add_index "spree_orders", ["confirmation_delivered"], name: "index_spree_orders_on_confirmation_delivered", using: :btree
  add_index "spree_orders", ["considered_risky"], name: "index_spree_orders_on_considered_risky", using: :btree
  add_index "spree_orders", ["created_by_id"], name: "index_spree_orders_on_created_by_id", using: :btree
  add_index "spree_orders", ["guest_token"], name: "index_spree_orders_on_guest_token", using: :btree
  add_index "spree_orders", ["number"], name: "index_spree_orders_on_number", using: :btree
  add_index "spree_orders", ["ship_address_id"], name: "index_spree_orders_on_ship_address_id", using: :btree
  add_index "spree_orders", ["shipping_method_id"], name: "index_spree_orders_on_shipping_method_id", using: :btree
  add_index "spree_orders", ["user_id", "created_by_id"], name: "index_spree_orders_on_user_id_and_created_by_id", using: :btree
  add_index "spree_orders", ["user_id"], name: "index_spree_orders_on_user_id", using: :btree

  create_table "spree_orders_promotions", id: false, force: :cascade do |t|
    t.integer "order_id"
    t.integer "promotion_id"
  end

  add_index "spree_orders_promotions", ["order_id", "promotion_id"], name: "index_spree_orders_promotions_on_order_id_and_promotion_id", using: :btree

  create_table "spree_parts", force: :cascade do |t|
    t.integer  "bundle_id",  null: false
    t.integer  "product_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_parts", ["bundle_id"], name: "index_spree_parts_on_bundle_id", using: :btree
  add_index "spree_parts", ["product_id"], name: "index_spree_parts_on_product_id", using: :btree

  create_table "spree_payment_capture_events", force: :cascade do |t|
    t.decimal  "amount",     precision: 10, scale: 2, default: 0.0
    t.integer  "payment_id"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "spree_payment_capture_events", ["payment_id"], name: "index_spree_payment_capture_events_on_payment_id", using: :btree

  create_table "spree_payment_methods", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "active",       default: true
    t.datetime "deleted_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "display_on"
    t.boolean  "auto_capture"
    t.text     "preferences"
  end

  add_index "spree_payment_methods", ["id", "type"], name: "index_spree_payment_methods_on_id_and_type", using: :btree

  create_table "spree_payments", force: :cascade do |t|
    t.decimal  "amount",               precision: 10, scale: 2, default: 0.0, null: false
    t.integer  "order_id"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "payment_method_id"
    t.string   "state"
    t.string   "response_code"
    t.string   "avs_response"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "number"
    t.string   "cvv_response_code"
    t.string   "cvv_response_message"
  end

  add_index "spree_payments", ["order_id"], name: "index_spree_payments_on_order_id", using: :btree
  add_index "spree_payments", ["payment_method_id"], name: "index_spree_payments_on_payment_method_id", using: :btree
  add_index "spree_payments", ["source_id", "source_type"], name: "index_spree_payments_on_source_id_and_source_type", using: :btree

  create_table "spree_preferences", force: :cascade do |t|
    t.text     "value"
    t.string   "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "spree_preferences", ["key"], name: "index_spree_preferences_on_key", unique: true, using: :btree

  create_table "spree_prices", force: :cascade do |t|
    t.integer  "variant_id",                          null: false
    t.decimal  "amount",     precision: 10, scale: 2
    t.string   "currency"
    t.datetime "deleted_at"
  end

  add_index "spree_prices", ["deleted_at"], name: "index_spree_prices_on_deleted_at", using: :btree
  add_index "spree_prices", ["variant_id", "currency"], name: "index_spree_prices_on_variant_id_and_currency", using: :btree

  create_table "spree_product_agreements", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spree_product_distributions", force: :cascade do |t|
    t.integer  "licensed_product_id"
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.integer  "quantity"
    t.string   "email"
    t.integer  "product_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.datetime "expire_at"
    t.string   "from_email"
  end

  create_table "spree_product_option_types", force: :cascade do |t|
    t.integer  "position"
    t.integer  "product_id"
    t.integer  "option_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "spree_product_option_types", ["option_type_id"], name: "index_spree_product_option_types_on_option_type_id", using: :btree
  add_index "spree_product_option_types", ["position"], name: "index_spree_product_option_types_on_position", using: :btree
  add_index "spree_product_option_types", ["product_id"], name: "index_spree_product_option_types_on_product_id", using: :btree

  create_table "spree_product_properties", force: :cascade do |t|
    t.string   "value"
    t.integer  "product_id"
    t.integer  "property_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "position",    default: 0
  end

  add_index "spree_product_properties", ["position"], name: "index_spree_product_properties_on_position", using: :btree
  add_index "spree_product_properties", ["product_id"], name: "index_product_properties_on_product_id", using: :btree
  add_index "spree_product_properties", ["property_id"], name: "index_spree_product_properties_on_property_id", using: :btree

  create_table "spree_products", force: :cascade do |t|
    t.string   "name",                 default: "",    null: false
    t.text     "description"
    t.datetime "available_on"
    t.datetime "deleted_at"
    t.string   "slug"
    t.text     "meta_description"
    t.string   "meta_keywords"
    t.integer  "tax_category_id"
    t.integer  "shipping_category_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "promotionable",        default: true
    t.string   "meta_title"
    t.integer  "license_length"
    t.text     "license_text"
    t.string   "redirect_url"
    t.integer  "curriculum_id"
    t.integer  "grade_id"
    t.integer  "grade_unit_id"
    t.string   "product_type"
    t.datetime "expiration_date"
    t.string   "access_url"
    t.string   "learn_more_url"
    t.boolean  "is_grades_product",    default: false
    t.boolean  "can_be_part",          default: false, null: false
    t.boolean  "individual_sale",      default: true,  null: false
    t.integer  "video_group_id"
    t.datetime "fulfillment_date"
    t.boolean  "for_sale",             default: false
    t.string   "sf_id_product"
    t.string   "sf_id_pricebook"
    t.boolean  "show_in_storefront",   default: false
    t.boolean  "purchase_once",        default: false
    t.text     "short_description"
    t.string   "get_in_touch_url"
    t.boolean  "archived",             default: false
    t.datetime "archived_at"
    t.integer  "position"
    t.boolean  "is_beta",              default: false
    t.string   "internal_name"
    t.text     "meta_text"
    t.boolean  "leaving_site_warning", default: true
  end

  add_index "spree_products", ["available_on"], name: "index_spree_products_on_available_on", using: :btree
  add_index "spree_products", ["deleted_at"], name: "index_spree_products_on_deleted_at", using: :btree
  add_index "spree_products", ["expiration_date"], name: "index_spree_products_on_expiration_date", using: :btree
  add_index "spree_products", ["meta_text"], name: "index_spree_products_on_meta_text", using: :btree
  add_index "spree_products", ["name"], name: "index_spree_products_on_name", using: :btree
  add_index "spree_products", ["shipping_category_id"], name: "index_spree_products_on_shipping_category_id", using: :btree
  add_index "spree_products", ["slug"], name: "index_spree_products_on_slug", unique: true, using: :btree
  add_index "spree_products", ["tax_category_id"], name: "index_spree_products_on_tax_category_id", using: :btree

  create_table "spree_products_promotion_rules", id: false, force: :cascade do |t|
    t.integer "product_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_products_promotion_rules", ["product_id"], name: "index_products_promotion_rules_on_product_id", using: :btree
  add_index "spree_products_promotion_rules", ["promotion_rule_id"], name: "index_products_promotion_rules_on_promotion_rule_id", using: :btree

  create_table "spree_products_taxons", force: :cascade do |t|
    t.integer "product_id"
    t.integer "taxon_id"
    t.integer "position"
  end

  add_index "spree_products_taxons", ["position"], name: "index_spree_products_taxons_on_position", using: :btree
  add_index "spree_products_taxons", ["product_id"], name: "index_spree_products_taxons_on_product_id", using: :btree
  add_index "spree_products_taxons", ["taxon_id"], name: "index_spree_products_taxons_on_taxon_id", using: :btree

  create_table "spree_promotion_action_line_items", force: :cascade do |t|
    t.integer "promotion_action_id"
    t.integer "variant_id"
    t.integer "quantity",            default: 1
  end

  add_index "spree_promotion_action_line_items", ["promotion_action_id"], name: "index_spree_promotion_action_line_items_on_promotion_action_id", using: :btree
  add_index "spree_promotion_action_line_items", ["variant_id"], name: "index_spree_promotion_action_line_items_on_variant_id", using: :btree

  create_table "spree_promotion_actions", force: :cascade do |t|
    t.integer  "promotion_id"
    t.integer  "position"
    t.string   "type"
    t.datetime "deleted_at"
  end

  add_index "spree_promotion_actions", ["deleted_at"], name: "index_spree_promotion_actions_on_deleted_at", using: :btree
  add_index "spree_promotion_actions", ["id", "type"], name: "index_spree_promotion_actions_on_id_and_type", using: :btree
  add_index "spree_promotion_actions", ["promotion_id"], name: "index_spree_promotion_actions_on_promotion_id", using: :btree

  create_table "spree_promotion_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code"
  end

  create_table "spree_promotion_rules", force: :cascade do |t|
    t.integer  "promotion_id"
    t.integer  "user_id"
    t.integer  "product_group_id"
    t.string   "type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "code"
    t.text     "preferences"
  end

  add_index "spree_promotion_rules", ["product_group_id"], name: "index_promotion_rules_on_product_group_id", using: :btree
  add_index "spree_promotion_rules", ["promotion_id"], name: "index_spree_promotion_rules_on_promotion_id", using: :btree
  add_index "spree_promotion_rules", ["user_id"], name: "index_promotion_rules_on_user_id", using: :btree

  create_table "spree_promotion_rules_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_promotion_rules_users", ["promotion_rule_id"], name: "index_promotion_rules_users_on_promotion_rule_id", using: :btree
  add_index "spree_promotion_rules_users", ["user_id"], name: "index_promotion_rules_users_on_user_id", using: :btree

  create_table "spree_promotions", force: :cascade do |t|
    t.string   "description"
    t.datetime "expires_at"
    t.datetime "starts_at"
    t.string   "name"
    t.string   "type"
    t.integer  "usage_limit"
    t.string   "match_policy",          default: "all"
    t.string   "code"
    t.boolean  "advertise",             default: false
    t.string   "path"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "promotion_category_id"
  end

  add_index "spree_promotions", ["advertise"], name: "index_spree_promotions_on_advertise", using: :btree
  add_index "spree_promotions", ["code"], name: "index_spree_promotions_on_code", using: :btree
  add_index "spree_promotions", ["expires_at"], name: "index_spree_promotions_on_expires_at", using: :btree
  add_index "spree_promotions", ["id", "type"], name: "index_spree_promotions_on_id_and_type", using: :btree
  add_index "spree_promotions", ["promotion_category_id"], name: "index_spree_promotions_on_promotion_category_id", using: :btree
  add_index "spree_promotions", ["starts_at"], name: "index_spree_promotions_on_starts_at", using: :btree

  create_table "spree_properties", force: :cascade do |t|
    t.string   "name"
    t.string   "presentation", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "spree_properties_prototypes", id: false, force: :cascade do |t|
    t.integer "prototype_id"
    t.integer "property_id"
  end

  create_table "spree_prototypes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spree_purchase_orders", force: :cascade do |t|
    t.integer  "payment_method_id"
    t.integer  "user_id"
    t.string   "po_number"
    t.string   "person_to_receive_license"
    t.boolean  "default",                   default: false, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "spree_refund_reasons", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active",     default: true
    t.boolean  "mutable",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "spree_refunds", force: :cascade do |t|
    t.integer  "payment_id"
    t.decimal  "amount",           precision: 10, scale: 2, default: 0.0, null: false
    t.string   "transaction_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "refund_reason_id"
    t.integer  "reimbursement_id"
  end

  add_index "spree_refunds", ["refund_reason_id"], name: "index_refunds_on_refund_reason_id", using: :btree

  create_table "spree_reimbursement_credits", force: :cascade do |t|
    t.decimal "amount",           precision: 10, scale: 2, default: 0.0, null: false
    t.integer "reimbursement_id"
    t.integer "creditable_id"
    t.string  "creditable_type"
  end

  create_table "spree_reimbursement_types", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active",     default: true
    t.boolean  "mutable",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "type"
  end

  add_index "spree_reimbursement_types", ["type"], name: "index_spree_reimbursement_types_on_type", using: :btree

  create_table "spree_reimbursements", force: :cascade do |t|
    t.string   "number"
    t.string   "reimbursement_status"
    t.integer  "customer_return_id"
    t.integer  "order_id"
    t.decimal  "total",                precision: 10, scale: 2
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "spree_reimbursements", ["customer_return_id"], name: "index_spree_reimbursements_on_customer_return_id", using: :btree
  add_index "spree_reimbursements", ["order_id"], name: "index_spree_reimbursements_on_order_id", using: :btree

  create_table "spree_relation_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "applies_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_relations", force: :cascade do |t|
    t.integer  "relation_type_id"
    t.integer  "relatable_id"
    t.string   "relatable_type"
    t.integer  "related_to_id"
    t.string   "related_to_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "discount_amount",  precision: 8, scale: 2, default: 0.0
    t.integer  "position"
  end

  create_table "spree_return_authorization_reasons", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active",     default: true
    t.boolean  "mutable",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "spree_return_authorizations", force: :cascade do |t|
    t.string   "number"
    t.string   "state"
    t.integer  "order_id"
    t.text     "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_location_id"
    t.integer  "return_authorization_reason_id"
  end

  add_index "spree_return_authorizations", ["return_authorization_reason_id"], name: "index_return_authorizations_on_return_authorization_reason_id", using: :btree

  create_table "spree_return_items", force: :cascade do |t|
    t.integer  "return_authorization_id"
    t.integer  "inventory_unit_id"
    t.integer  "exchange_variant_id"
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.decimal  "pre_tax_amount",                  precision: 12, scale: 4, default: 0.0,  null: false
    t.decimal  "included_tax_total",              precision: 12, scale: 4, default: 0.0,  null: false
    t.decimal  "additional_tax_total",            precision: 12, scale: 4, default: 0.0,  null: false
    t.string   "reception_status"
    t.string   "acceptance_status"
    t.integer  "customer_return_id"
    t.integer  "reimbursement_id"
    t.integer  "exchange_inventory_unit_id"
    t.text     "acceptance_status_errors"
    t.integer  "preferred_reimbursement_type_id"
    t.integer  "override_reimbursement_type_id"
    t.boolean  "resellable",                                               default: true, null: false
  end

  add_index "spree_return_items", ["customer_return_id"], name: "index_return_items_on_customer_return_id", using: :btree
  add_index "spree_return_items", ["exchange_inventory_unit_id"], name: "index_spree_return_items_on_exchange_inventory_unit_id", using: :btree

  create_table "spree_roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "spree_roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "spree_roles_users", ["role_id"], name: "index_spree_roles_users_on_role_id", using: :btree
  add_index "spree_roles_users", ["user_id"], name: "index_spree_roles_users_on_user_id", using: :btree

  create_table "spree_shipments", force: :cascade do |t|
    t.string   "tracking"
    t.string   "number"
    t.decimal  "cost",                 precision: 10, scale: 2, default: 0.0
    t.datetime "shipped_at"
    t.integer  "order_id"
    t.integer  "address_id"
    t.string   "state"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.integer  "stock_location_id"
    t.decimal  "adjustment_total",     precision: 10, scale: 2, default: 0.0
    t.decimal  "additional_tax_total", precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",          precision: 10, scale: 2, default: 0.0
    t.decimal  "included_tax_total",   precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "pre_tax_amount",       precision: 8,  scale: 2, default: 0.0
  end

  add_index "spree_shipments", ["address_id"], name: "index_spree_shipments_on_address_id", using: :btree
  add_index "spree_shipments", ["number"], name: "index_shipments_on_number", using: :btree
  add_index "spree_shipments", ["order_id"], name: "index_spree_shipments_on_order_id", using: :btree
  add_index "spree_shipments", ["stock_location_id"], name: "index_spree_shipments_on_stock_location_id", using: :btree

  create_table "spree_shipping_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spree_shipping_method_categories", force: :cascade do |t|
    t.integer  "shipping_method_id",   null: false
    t.integer  "shipping_category_id", null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "spree_shipping_method_categories", ["shipping_category_id", "shipping_method_id"], name: "unique_spree_shipping_method_categories", unique: true, using: :btree
  add_index "spree_shipping_method_categories", ["shipping_method_id"], name: "index_spree_shipping_method_categories_on_shipping_method_id", using: :btree

  create_table "spree_shipping_methods", force: :cascade do |t|
    t.string   "name"
    t.string   "display_on"
    t.datetime "deleted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "tracking_url"
    t.string   "admin_name"
    t.integer  "tax_category_id"
    t.string   "code"
  end

  add_index "spree_shipping_methods", ["deleted_at"], name: "index_spree_shipping_methods_on_deleted_at", using: :btree
  add_index "spree_shipping_methods", ["tax_category_id"], name: "index_spree_shipping_methods_on_tax_category_id", using: :btree

  create_table "spree_shipping_methods_zones", id: false, force: :cascade do |t|
    t.integer "shipping_method_id"
    t.integer "zone_id"
  end

  create_table "spree_shipping_rates", force: :cascade do |t|
    t.integer  "shipment_id"
    t.integer  "shipping_method_id"
    t.boolean  "selected",                                   default: false
    t.decimal  "cost",               precision: 8, scale: 2, default: 0.0
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.integer  "tax_rate_id"
  end

  add_index "spree_shipping_rates", ["selected"], name: "index_spree_shipping_rates_on_selected", using: :btree
  add_index "spree_shipping_rates", ["shipment_id", "shipping_method_id"], name: "spree_shipping_rates_join_index", unique: true, using: :btree
  add_index "spree_shipping_rates", ["tax_rate_id"], name: "index_spree_shipping_rates_on_tax_rate_id", using: :btree

  create_table "spree_skrill_transactions", force: :cascade do |t|
    t.string   "email"
    t.float    "amount"
    t.string   "currency"
    t.integer  "transaction_id"
    t.integer  "customer_id"
    t.string   "payment_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_state_changes", force: :cascade do |t|
    t.string   "name"
    t.string   "previous_state"
    t.integer  "stateful_id"
    t.integer  "user_id"
    t.string   "stateful_type"
    t.string   "next_state"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "spree_state_changes", ["stateful_id", "stateful_type"], name: "index_spree_state_changes_on_stateful_id_and_stateful_type", using: :btree
  add_index "spree_state_changes", ["user_id"], name: "index_spree_state_changes_on_user_id", using: :btree

  create_table "spree_states", force: :cascade do |t|
    t.string   "name"
    t.string   "abbr"
    t.integer  "country_id"
    t.datetime "updated_at"
  end

  add_index "spree_states", ["country_id"], name: "index_spree_states_on_country_id", using: :btree

  create_table "spree_stock_items", force: :cascade do |t|
    t.integer  "stock_location_id"
    t.integer  "variant_id"
    t.integer  "count_on_hand",     default: 0,     null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "backorderable",     default: false
    t.datetime "deleted_at"
  end

  add_index "spree_stock_items", ["backorderable"], name: "index_spree_stock_items_on_backorderable", using: :btree
  add_index "spree_stock_items", ["deleted_at"], name: "index_spree_stock_items_on_deleted_at", using: :btree
  add_index "spree_stock_items", ["stock_location_id", "variant_id"], name: "stock_item_by_loc_and_var_id", using: :btree
  add_index "spree_stock_items", ["stock_location_id"], name: "index_spree_stock_items_on_stock_location_id", using: :btree
  add_index "spree_stock_items", ["variant_id"], name: "index_spree_stock_items_on_variant_id", using: :btree

  create_table "spree_stock_locations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "default",                default: false, null: false
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "state_name"
    t.integer  "country_id"
    t.string   "zipcode"
    t.string   "phone"
    t.boolean  "active",                 default: true
    t.boolean  "backorderable_default",  default: false
    t.boolean  "propagate_all_variants", default: true
    t.string   "admin_name"
  end

  add_index "spree_stock_locations", ["active"], name: "index_spree_stock_locations_on_active", using: :btree
  add_index "spree_stock_locations", ["backorderable_default"], name: "index_spree_stock_locations_on_backorderable_default", using: :btree
  add_index "spree_stock_locations", ["country_id"], name: "index_spree_stock_locations_on_country_id", using: :btree
  add_index "spree_stock_locations", ["propagate_all_variants"], name: "index_spree_stock_locations_on_propagate_all_variants", using: :btree
  add_index "spree_stock_locations", ["state_id"], name: "index_spree_stock_locations_on_state_id", using: :btree

  create_table "spree_stock_movements", force: :cascade do |t|
    t.integer  "stock_item_id"
    t.integer  "quantity",        default: 0
    t.string   "action"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "originator_id"
    t.string   "originator_type"
  end

  add_index "spree_stock_movements", ["stock_item_id"], name: "index_spree_stock_movements_on_stock_item_id", using: :btree

  create_table "spree_stock_transfers", force: :cascade do |t|
    t.string   "type"
    t.string   "reference"
    t.integer  "source_location_id"
    t.integer  "destination_location_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "number"
  end

  add_index "spree_stock_transfers", ["destination_location_id"], name: "index_spree_stock_transfers_on_destination_location_id", using: :btree
  add_index "spree_stock_transfers", ["number"], name: "index_spree_stock_transfers_on_number", using: :btree
  add_index "spree_stock_transfers", ["source_location_id"], name: "index_spree_stock_transfers_on_source_location_id", using: :btree

  create_table "spree_stores", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.text     "meta_description"
    t.text     "meta_keywords"
    t.string   "seo_title"
    t.string   "mail_from_address"
    t.string   "default_currency"
    t.string   "code"
    t.boolean  "default",           default: false, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "spree_stores", ["code"], name: "index_spree_stores_on_code", using: :btree
  add_index "spree_stores", ["default"], name: "index_spree_stores_on_default", using: :btree
  add_index "spree_stores", ["url"], name: "index_spree_stores_on_url", using: :btree

  create_table "spree_tax_categories", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "is_default",  default: false
    t.datetime "deleted_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "tax_code"
  end

  add_index "spree_tax_categories", ["deleted_at"], name: "index_spree_tax_categories_on_deleted_at", using: :btree
  add_index "spree_tax_categories", ["is_default"], name: "index_spree_tax_categories_on_is_default", using: :btree

  create_table "spree_tax_rates", force: :cascade do |t|
    t.decimal  "amount",             precision: 8, scale: 5
    t.integer  "zone_id"
    t.integer  "tax_category_id"
    t.boolean  "included_in_price",                          default: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.string   "name"
    t.boolean  "show_rate_in_label",                         default: true
    t.datetime "deleted_at"
  end

  add_index "spree_tax_rates", ["deleted_at"], name: "index_spree_tax_rates_on_deleted_at", using: :btree
  add_index "spree_tax_rates", ["included_in_price"], name: "index_spree_tax_rates_on_included_in_price", using: :btree
  add_index "spree_tax_rates", ["show_rate_in_label"], name: "index_spree_tax_rates_on_show_rate_in_label", using: :btree
  add_index "spree_tax_rates", ["tax_category_id"], name: "index_spree_tax_rates_on_tax_category_id", using: :btree
  add_index "spree_tax_rates", ["zone_id"], name: "index_spree_tax_rates_on_zone_id", using: :btree

  create_table "spree_taxonomies", force: :cascade do |t|
    t.string   "name",                                           null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "position",                       default: 0
    t.boolean  "allow_multiple_taxons_selected", default: true
    t.boolean  "show_in_store",                  default: true
    t.boolean  "show_in_video",                  default: true
    t.boolean  "top_level_in_video",             default: false
  end

  add_index "spree_taxonomies", ["position"], name: "index_spree_taxonomies_on_position", using: :btree

  create_table "spree_taxons", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "position",          default: 0
    t.string   "name",                          null: false
    t.string   "permalink"
    t.integer  "taxonomy_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.text     "description"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.integer  "depth"
  end

  add_index "spree_taxons", ["parent_id"], name: "index_taxons_on_parent_id", using: :btree
  add_index "spree_taxons", ["permalink"], name: "index_taxons_on_permalink", using: :btree
  add_index "spree_taxons", ["position"], name: "index_spree_taxons_on_position", using: :btree
  add_index "spree_taxons", ["taxonomy_id"], name: "index_taxons_on_taxonomy_id", using: :btree

  create_table "spree_taxons_promotion_rules", force: :cascade do |t|
    t.integer "taxon_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_taxons_promotion_rules", ["promotion_rule_id"], name: "index_spree_taxons_promotion_rules_on_promotion_rule_id", using: :btree
  add_index "spree_taxons_promotion_rules", ["taxon_id"], name: "index_spree_taxons_promotion_rules_on_taxon_id", using: :btree

  create_table "spree_taxons_prototypes", force: :cascade do |t|
    t.integer "taxon_id"
    t.integer "prototype_id"
  end

  add_index "spree_taxons_prototypes", ["prototype_id"], name: "index_spree_taxons_prototypes_on_prototype_id", using: :btree
  add_index "spree_taxons_prototypes", ["taxon_id"], name: "index_spree_taxons_prototypes_on_taxon_id", using: :btree

  create_table "spree_taxons_videos", force: :cascade do |t|
    t.integer "video_id"
    t.integer "taxon_id"
    t.integer "position"
  end

  add_index "spree_taxons_videos", ["position"], name: "index_spree_taxons_videos_on_position", using: :btree
  add_index "spree_taxons_videos", ["taxon_id"], name: "index_spree_taxons_videos_on_taxon_id", using: :btree
  add_index "spree_taxons_videos", ["video_id"], name: "index_spree_taxons_videos_on_video_id", using: :btree

  create_table "spree_trackers", force: :cascade do |t|
    t.string   "analytics_id"
    t.boolean  "active",       default: true
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "spree_trackers", ["active"], name: "index_spree_trackers_on_active", using: :btree

  create_table "spree_users", force: :cascade do |t|
    t.string   "encrypted_password",         limit: 128
    t.string   "password_salt",              limit: 128
    t.string   "email"
    t.string   "remember_token"
    t.string   "persistence_token"
    t.string   "reset_password_token"
    t.string   "perishable_token"
    t.integer  "sign_in_count",                          default: 0,     null: false
    t.integer  "failed_attempts",                        default: 0,     null: false
    t.datetime "last_request_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "login"
    t.integer  "ship_address_id"
    t.integer  "bill_address_id"
    t.string   "authentication_token"
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "spree_api_key",              limit: 48
    t.datetime "remember_created_at"
    t.datetime "deleted_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "address"
    t.string   "interested_grade_level"
    t.boolean  "receive_newsletter"
    t.string   "school_name"
    t.string   "heard_from"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "school_district_id"
    t.string   "preference_video_player"
    t.string   "title"
    t.string   "phone"
    t.boolean  "allow_communication",                    default: true
    t.text     "interested_subjects"
    t.integer  "delegate_user_id"
    t.boolean  "tour_showed_dashboard",                  default: false
    t.string   "manual_title"
    t.boolean  "tour_showed_licenses",                   default: false
    t.boolean  "tour_showed_licenses_users",             default: false
    t.boolean  "accepted_terms",                         default: false
    t.string   "zip_code"
    t.text     "grades"
    t.string   "city",                                   default: ""
    t.string   "state",                                  default: ""
    t.string   "referral"
  end

  add_index "spree_users", ["deleted_at"], name: "index_spree_users_on_deleted_at", using: :btree
  add_index "spree_users", ["email"], name: "email_idx_unique", unique: true, using: :btree
  add_index "spree_users", ["spree_api_key"], name: "index_spree_users_on_spree_api_key", using: :btree

  create_table "spree_variants", force: :cascade do |t|
    t.string   "sku",                                        default: "",    null: false
    t.decimal  "weight",            precision: 8,  scale: 2, default: 0.0
    t.decimal  "height",            precision: 8,  scale: 2
    t.decimal  "width",             precision: 8,  scale: 2
    t.decimal  "depth",             precision: 8,  scale: 2
    t.datetime "deleted_at"
    t.boolean  "is_master",                                  default: false
    t.integer  "product_id"
    t.decimal  "cost_price",        precision: 10, scale: 2
    t.integer  "position"
    t.string   "cost_currency"
    t.boolean  "track_inventory",                            default: true
    t.integer  "tax_category_id"
    t.datetime "updated_at"
    t.integer  "stock_items_count",                          default: 0,     null: false
  end

  add_index "spree_variants", ["deleted_at"], name: "index_spree_variants_on_deleted_at", using: :btree
  add_index "spree_variants", ["is_master"], name: "index_spree_variants_on_is_master", using: :btree
  add_index "spree_variants", ["position"], name: "index_spree_variants_on_position", using: :btree
  add_index "spree_variants", ["product_id"], name: "index_spree_variants_on_product_id", using: :btree
  add_index "spree_variants", ["sku"], name: "index_spree_variants_on_sku", using: :btree
  add_index "spree_variants", ["tax_category_id"], name: "index_spree_variants_on_tax_category_id", using: :btree
  add_index "spree_variants", ["track_inventory"], name: "index_spree_variants_on_track_inventory", using: :btree

  create_table "spree_video_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spree_videos", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "product_id"
    t.boolean  "is_free",                           default: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size",          limit: 8
    t.datetime "file_updated_at"
    t.string   "vimeo_uri"
    t.integer  "wistia_id"
    t.string   "wistia_hashed_id"
    t.string   "wistia_status"
    t.string   "wistia_thumbnail_url"
    t.integer  "video_group_id"
    t.string   "preview_image_url"
    t.string   "vimeo_id"
    t.string   "screenshot_file_name"
    t.string   "screenshot_content_type"
    t.integer  "screenshot_file_size"
    t.datetime "screenshot_updated_at"
    t.integer  "grade_order"
    t.integer  "module_order"
    t.integer  "lesson_order"
    t.integer  "custom_order"
  end

  create_table "spree_zone_members", force: :cascade do |t|
    t.integer  "zoneable_id"
    t.string   "zoneable_type"
    t.integer  "zone_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "spree_zone_members", ["zone_id"], name: "index_spree_zone_members_on_zone_id", using: :btree
  add_index "spree_zone_members", ["zoneable_id", "zoneable_type"], name: "index_spree_zone_members_on_zoneable_id_and_zoneable_type", using: :btree

  create_table "spree_zones", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "default_tax",        default: false
    t.integer  "zone_members_count", default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "kind"
  end

  add_index "spree_zones", ["default_tax"], name: "index_spree_zones_on_default_tax", using: :btree
  add_index "spree_zones", ["kind"], name: "index_spree_zones_on_kind", using: :btree

  create_table "staffs", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.text     "description"
    t.integer  "position",             default: 0
    t.boolean  "display",              default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "staff_type",           default: 0
  end

  create_table "subscription_notifications", force: :cascade do |t|
    t.integer  "subscription_id"
    t.integer  "article_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "blog_id"
    t.integer  "user_id"
    t.integer  "subscribe_status"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "training_type_categories", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "is_default",  default: false
    t.string   "slug"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "vanity_urls", force: :cascade do |t|
    t.string   "url"
    t.string   "redirect_url"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "category"
  end

  create_table "whats_news", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.string   "call_to_action_button_text"
    t.string   "call_to_action_button_link"
    t.string   "call_to_action_button_target"
    t.boolean  "display"
    t.string   "user_title"
    t.string   "subject"
    t.string   "icon"
    t.integer  "views",                        default: 0
    t.integer  "clicks",                       default: 0
    t.text     "zip_codes"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.text     "sub_header"
  end

  add_foreign_key "regonline_events", "regonline_event_headers"
end
