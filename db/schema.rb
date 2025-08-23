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

ActiveRecord::Schema[8.0].define(version: 0) do
  create_schema "auth"
  create_schema "extensions"
  create_schema "graphql"
  create_schema "graphql_public"
  create_schema "pgbouncer"
  create_schema "realtime"
  create_schema "storage"
  create_schema "supabase_migrations"
  create_schema "vault"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"
  enable_extension "vault.supabase_vault"

  create_table "Order", id: :text, force: :cascade do |t|
    t.text "status", default: "draft", null: false
    t.datetime "createdAt", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text "userId", null: false
  end

  create_table "User", id: :text, force: :cascade do |t|
    t.text "email", null: false
    t.text "password", null: false
    t.text "name"
    t.text "role", default: "user", null: false
    t.datetime "createdAt", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updatedAt", precision: 3, null: false
    t.index ["email"], name: "User_email_key", unique: true
  end

  create_table "api_errors", id: :uuid, default: nil, force: :cascade do |t|
    t.text "method", null: false
    t.text "request_uri", null: false
    t.text "status", null: false
    t.datetime "occurred_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text "original_timestamp_text"
    t.text "message", null: false
    t.text "debug_message", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["method"], name: "ix_api_errors_method"
    t.index ["occurred_at"], name: "ix_api_errors_when"
    t.index ["status"], name: "ix_api_errors_status"
  end

  create_table "api_validation_errors", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid "api_error_id", null: false
    t.text "field", null: false
    t.text "rejected_value", null: false
    t.text "message", null: false
    t.index ["api_error_id"], name: "ix_api_validation_errors_parent"
    t.index ["field"], name: "ix_api_validation_errors_field"
  end

  create_table "available_location_set_collection_locations", primary_key: ["set_id", "location_id"], force: :cascade do |t|
    t.uuid "set_id", null: false
    t.uuid "location_id", null: false
  end

  create_table "available_location_set_delivery_locations", primary_key: ["set_id", "location_id"], force: :cascade do |t|
    t.uuid "set_id", null: false
    t.uuid "location_id", null: false
  end

  create_table "available_location_sets", id: :uuid, default: nil, force: :cascade do |t|
    t.text "message", null: false
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "carrier_locations", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "Carrier-specific properties for ref locations (RKTS/RKST/timezone/aliases)", force: :cascade do |t|
    t.uuid "ref_location_id"
    t.string "carrier_geo_id", limit: 13
    t.string "carrier_country_geo_id", limit: 13
    t.text "carrier_rkts_code"
    t.text "carrier_rkst_code"
    t.text "time_zone_id"
    t.text "alternate_aliases", default: [], array: true
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.index ["alternate_aliases"], name: "gin_carrier_locations_aliases", using: :gin
    t.index ["carrier_country_geo_id"], name: "ix_carrier_locations_country_geo"
    t.index ["carrier_geo_id"], name: "ix_carrier_locations_geo"
    t.index ["ref_location_id"], name: "ux_carrier_locations_ref", unique: true
    t.check_constraint "carrier_country_geo_id IS NULL OR carrier_country_geo_id::text ~ '^[0-9A-Za-z]{13}$'::text", name: "carrier_locations_country_geo_chk"
    t.check_constraint "carrier_geo_id IS NULL OR carrier_geo_id::text ~ '^[0-9A-Za-z]{13}$'::text", name: "carrier_locations_geo_chk"
  end

  create_table "facilities", id: :uuid, default: nil, force: :cascade do |t|
    t.text "carrier_site_geo_id"
    t.text "location_type"
    t.text "location_name"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "locations", id: :uuid, default: nil, force: :cascade do |t|
    t.text "carrier_city_geo_id"
    t.string "un_location_code", limit: 10
    t.string "country_code", limit: 2, null: false
    t.text "city_name", null: false
    t.string "un_region_code", limit: 10
    t.text "carrier_site_geo_id"
    t.text "location_type"
    t.text "location_name"
    t.string "city_un_location_code", limit: 10
    t.string "site_un_location_code", limit: 10
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["city_un_location_code"], name: "ix_locations_city_code"
    t.index ["country_code"], name: "ix_locations_country"
    t.index ["site_un_location_code"], name: "ix_locations_site_code"
  end

  create_table "ocean_products", id: :uuid, default: nil, force: :cascade do |t|
    t.text "vessel_operator_carrier_code"
    t.text "carrier_product_id"
    t.text "carrier_product_sequence_id"
    t.date "product_valid_from_date"
    t.date "product_valid_to_date"
    t.integer "number_of_product_links"
    t.text "number_of_product_links_text"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "ref_locations", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "Maersk Reference Locations (searchable by country/city/UNLOCODE/GeoID)", force: :cascade do |t|
    t.string "carrier_geo_id", limit: 13
    t.string "country_code", limit: 2
    t.text "country_name"
    t.string "un_location_code", limit: 5
    t.text "city_name"
    t.string "un_region_code", limit: 3
    t.text "un_region_name"
    t.text "location_type"
    t.text "location_name"
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.index ["carrier_geo_id"], name: "ix_ref_locations_geo"
    t.index ["city_name"], name: "gin_ref_locations_city_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["country_code"], name: "ix_ref_locations_ccode"
    t.index ["country_name"], name: "gin_ref_locations_country_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["location_name"], name: "gin_ref_locations_loc_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["location_type"], name: "ix_ref_locations_ltype"
    t.index ["un_location_code"], name: "ix_ref_locations_unlc"
    t.check_constraint "carrier_geo_id IS NULL OR carrier_geo_id::text ~ '^[0-9A-Za-z]{13}$'::text", name: "ref_locations_geo_chk"
    t.check_constraint "country_code IS NULL OR country_code ~ '^[A-Za-z]{2}$'::text", name: "ref_locations_country_code_chk"
    t.check_constraint "un_location_code IS NULL OR un_location_code::text ~ '^[A-Za-z]{2}[A-Za-z0-9]{3}$'::text", name: "ref_locations_unlc_chk"
    t.unique_constraint ["carrier_geo_id"], name: "ref_locations_carrier_geo_id_key"
  end

  create_table "ref_locations_raw", force: :cascade do |t|
    t.timestamptz "fetched_at", default: -> { "now()" }, null: false
    t.jsonb "request_qs", null: false
    t.jsonb "response", null: false
    t.integer "http_status", null: false
    t.index ["fetched_at"], name: "ix_ref_locations_raw_fetched_at", order: :desc
  end

  create_table "transport_legs", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid "transport_schedule_id", null: false
    t.integer "sequence_no", null: false
    t.datetime "departure_datetime", precision: 3, null: false
    t.datetime "arrival_datetime", precision: 3, null: false
    t.text "vessel_imo_text"
    t.integer "vessel_imo_number"
    t.string "carrier_vessel_code", limit: 3
    t.string "vessel_name", limit: 35
    t.text "transport_mode", null: false
    t.text "carrier_trade_lane_name"
    t.string "carrier_departure_voyage_number", limit: 10
    t.boolean "inducement_link_flag"
    t.text "inducement_link_flag_text"
    t.string "carrier_service_code", limit: 3
    t.text "carrier_service_name"
    t.text "link_direction"
    t.text "carrier_code"
    t.text "routing_type"
    t.uuid "start_location_id"
    t.uuid "end_location_id"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["arrival_datetime"], name: "ix_tl_arr"
    t.index ["departure_datetime"], name: "ix_tl_dep"
    t.index ["transport_mode"], name: "ix_tl_mode"
    t.index ["transport_schedule_id", "sequence_no"], name: "ux_tl_schedule_seq", unique: true
  end

  create_table "transport_schedules", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid "ocean_product_id"
    t.datetime "departure_datetime", precision: 3, null: false
    t.datetime "arrival_datetime", precision: 3, null: false
    t.text "first_departure_vessel_imo_text"
    t.integer "first_departure_vessel_imo_number"
    t.string "first_departure_carrier_vessel_code", limit: 3
    t.string "first_departure_vessel_name", limit: 35
    t.integer "transit_time_minutes"
    t.text "transit_time_text"
    t.uuid "collection_origin_location_id"
    t.uuid "delivery_destination_location_id"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["arrival_datetime"], name: "ix_ts_arrival"
    t.index ["departure_datetime"], name: "ix_ts_departure"
    t.index ["ocean_product_id"], name: "ix_ts_ocean_product"
  end

  create_table "un_location_codes", id: :uuid, default: nil, force: :cascade do |t|
    t.string "un_location_code", limit: 10
    t.string "city_un_location_code", limit: 10
    t.string "site_un_location_code", limit: 10
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "vessels", id: :uuid, default: nil, force: :cascade do |t|
    t.integer "vessel_imo_number", null: false
    t.string "carrier_vessel_code", limit: 3, null: false
    t.string "vessel_short_name", limit: 18, null: false
    t.string "vessel_long_name", limit: 35, null: false
    t.string "vessel_flag_code", limit: 2
    t.integer "vessel_built_year"
    t.string "vessel_call_sign", limit: 16
    t.integer "vessel_capacity_teu"
    t.datetime "created_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 3, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["carrier_vessel_code"], name: "vessels_carrier_vessel_code_key", unique: true
    t.index ["vessel_imo_number"], name: "vessels_vessel_imo_number_key", unique: true
  end

  create_table "vessels_raw", force: :cascade do |t|
    t.timestamptz "fetched_at", default: -> { "now()" }, null: false
    t.jsonb "request_qs", null: false
    t.jsonb "response", null: false
    t.integer "http_status", null: false
    t.text "error_message"
    t.text "processing_status", default: "pending"
    t.timestamptz "processed_at"
    t.index ["fetched_at"], name: "ix_vessels_raw_fetched_at", order: :desc
    t.index ["http_status", "fetched_at"], name: "ix_vessels_raw_http_status", order: { fetched_at: :desc }
    t.index ["processing_status", "fetched_at"], name: "ix_vessels_raw_status", order: { fetched_at: :desc }
    t.check_constraint "processing_status = ANY (ARRAY['pending'::text, 'processing'::text, 'processed'::text, 'failed'::text])", name: "vessels_raw_processing_status_check"
  end

  add_foreign_key "Order", "User", column: "userId", name: "Order_userId_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "api_validation_errors", "api_errors", name: "api_validation_errors_api_error_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "available_location_set_collection_locations", "available_location_sets", column: "set_id", name: "available_location_set_collection_locations_set_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "available_location_set_collection_locations", "locations", name: "available_location_set_collection_locations_location_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "available_location_set_delivery_locations", "available_location_sets", column: "set_id", name: "available_location_set_delivery_locations_set_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "available_location_set_delivery_locations", "locations", name: "available_location_set_delivery_locations_location_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "carrier_locations", "ref_locations", name: "carrier_locations_ref_location_id_fkey", on_delete: :cascade
  add_foreign_key "transport_legs", "locations", column: "end_location_id", name: "transport_legs_end_location_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "transport_legs", "locations", column: "start_location_id", name: "transport_legs_start_location_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "transport_legs", "transport_schedules", name: "transport_legs_transport_schedule_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "transport_legs", "vessels", column: "vessel_imo_number", primary_key: "vessel_imo_number", name: "transport_legs_vessel_imo_number_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "transport_schedules", "locations", column: "collection_origin_location_id", name: "transport_schedules_collection_origin_location_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "transport_schedules", "locations", column: "delivery_destination_location_id", name: "transport_schedules_delivery_destination_location_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "transport_schedules", "ocean_products", name: "transport_schedules_ocean_product_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "transport_schedules", "vessels", column: "first_departure_vessel_imo_number", primary_key: "vessel_imo_number", name: "transport_schedules_first_departure_vessel_imo_number_fkey", on_update: :cascade, on_delete: :nullify
end
