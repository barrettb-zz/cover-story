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

ActiveRecord::Schema.define(version: 20140313090436) do

  create_table "analyses", force: true do |t|
    t.decimal  "percentage_covered",   precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "analysis_type"
    t.integer  "import_collection_id"
  end

  create_table "analyzed_route_controllers", force: true do |t|
    t.integer  "analysis_id"
    t.string   "controller"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "analyzed_route_controllers", ["analysis_id"], name: "index_analyzed_route_controllers_on_analysis_id", using: :btree

  create_table "analyzed_route_paths", force: true do |t|
    t.integer  "analysis_id"
    t.text     "path"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "completed_lines", force: true do |t|
    t.integer "request_id"
    t.integer "source_id"
    t.integer "lineno"
    t.integer "status"
    t.float   "duration"
    t.float   "view"
    t.float   "db"
  end

  add_index "completed_lines", ["request_id"], name: "index_completed_lines_on_request_id", using: :btree
  add_index "completed_lines", ["source_id"], name: "index_completed_lines_on_source_id", using: :btree

  create_table "failure_lines", force: true do |t|
    t.integer "request_id"
    t.integer "source_id"
    t.integer "lineno"
    t.string  "error"
    t.string  "message"
    t.integer "line"
    t.string  "file"
  end

  add_index "failure_lines", ["request_id"], name: "index_failure_lines_on_request_id", using: :btree
  add_index "failure_lines", ["source_id"], name: "index_failure_lines_on_source_id", using: :btree

  create_table "import_collections", force: true do |t|
    t.string   "bundle_file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "ignore"
  end

  create_table "parameters_lines", force: true do |t|
    t.integer "request_id"
    t.integer "source_id"
    t.integer "lineno"
    t.text    "params"
  end

  add_index "parameters_lines", ["request_id"], name: "index_parameters_lines_on_request_id", using: :btree
  add_index "parameters_lines", ["source_id"], name: "index_parameters_lines_on_source_id", using: :btree

  create_table "processing_lines", force: true do |t|
    t.integer "request_id"
    t.integer "source_id"
    t.integer "lineno"
    t.string  "controller"
    t.string  "action"
    t.string  "format"
  end

  add_index "processing_lines", ["request_id"], name: "index_processing_lines_on_request_id", using: :btree
  add_index "processing_lines", ["source_id"], name: "index_processing_lines_on_source_id", using: :btree

  create_table "rendered_lines", force: true do |t|
    t.integer "request_id"
    t.integer "source_id"
    t.integer "lineno"
    t.string  "rendered_file"
    t.float   "partial_duration"
  end

  add_index "rendered_lines", ["request_id"], name: "index_rendered_lines_on_request_id", using: :btree
  add_index "rendered_lines", ["source_id"], name: "index_rendered_lines_on_source_id", using: :btree

  create_table "requests", force: true do |t|
    t.integer "first_lineno"
    t.integer "last_lineno"
  end

  create_table "revisions", force: true do |t|
    t.integer  "import_collection_id"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "route_histories", force: true do |t|
    t.integer  "route_id"
    t.boolean  "activated"
    t.boolean  "inactivated"
    t.text     "preformatted_path"
    t.string   "name"
    t.text     "original_route_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routes", force: true do |t|
    t.string   "method"
    t.string   "controller"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "path"
    t.string   "controller_association"
    t.boolean  "inactive"
    t.string   "source"
  end

  create_table "routing_errors_lines", force: true do |t|
    t.integer "request_id"
    t.integer "source_id"
    t.integer "lineno"
    t.string  "missing_resource_method"
    t.string  "missing_resource"
  end

  add_index "routing_errors_lines", ["request_id"], name: "index_routing_errors_lines_on_request_id", using: :btree
  add_index "routing_errors_lines", ["source_id"], name: "index_routing_errors_lines_on_source_id", using: :btree

  create_table "sources", force: true do |t|
    t.string   "filename"
    t.datetime "mtime"
    t.integer  "filesize"
    t.string   "file_type"
    t.string   "env"
    t.boolean  "ignore"
    t.integer  "import_collection_id"
  end

  add_index "sources", ["env"], name: "index_sources_on_env", using: :btree

  create_table "started_lines", force: true do |t|
    t.integer  "request_id"
    t.integer  "source_id"
    t.integer  "lineno"
    t.string   "UUID"
    t.string   "employer"
    t.string   "session"
    t.string   "method"
    t.text     "path"
    t.string   "ip"
    t.datetime "timestamp"
    t.string   "formatted_path"
    t.string   "model"
  end

  add_index "started_lines", ["request_id"], name: "index_started_lines_on_request_id", using: :btree
  add_index "started_lines", ["source_id"], name: "index_started_lines_on_source_id", using: :btree

  create_table "warnings", force: true do |t|
    t.string  "warning_type", limit: 30, null: false
    t.string  "message"
    t.integer "source_id"
    t.integer "lineno"
  end

end
