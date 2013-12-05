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

ActiveRecord::Schema.define(version: 20131205203649) do

  create_table "completed_lines", force: true do |t|
    t.integer "request_id"
    t.integer "source_id"
    t.integer "lineno"
    t.integer "status"
    t.float   "duration"
    t.float   "view"
    t.float   "db"
  end

  add_index "completed_lines", ["request_id"], name: "index_completed_lines_on_request_id"
  add_index "completed_lines", ["source_id"], name: "index_completed_lines_on_source_id"

  create_table "failure_lines", force: true do |t|
    t.integer "request_id"
    t.integer "source_id"
    t.integer "lineno"
    t.string  "error"
    t.string  "message"
    t.integer "line"
    t.string  "file"
  end

  add_index "failure_lines", ["request_id"], name: "index_failure_lines_on_request_id"
  add_index "failure_lines", ["source_id"], name: "index_failure_lines_on_source_id"

  create_table "parameters_lines", force: true do |t|
    t.integer "request_id"
    t.integer "source_id"
    t.integer "lineno"
    t.string  "params"
  end

  add_index "parameters_lines", ["request_id"], name: "index_parameters_lines_on_request_id"
  add_index "parameters_lines", ["source_id"], name: "index_parameters_lines_on_source_id"

  create_table "processing_lines", force: true do |t|
    t.integer "request_id"
    t.integer "source_id"
    t.integer "lineno"
    t.string  "controller"
    t.string  "action"
    t.string  "format"
  end

  add_index "processing_lines", ["request_id"], name: "index_processing_lines_on_request_id"
  add_index "processing_lines", ["source_id"], name: "index_processing_lines_on_source_id"

  create_table "rendered_lines", force: true do |t|
    t.integer "request_id"
    t.integer "source_id"
    t.integer "lineno"
    t.string  "rendered_file"
    t.float   "partial_duration"
  end

  add_index "rendered_lines", ["request_id"], name: "index_rendered_lines_on_request_id"
  add_index "rendered_lines", ["source_id"], name: "index_rendered_lines_on_source_id"

  create_table "requests", force: true do |t|
    t.integer "first_lineno"
    t.integer "last_lineno"
  end

  create_table "routes", force: true do |t|
    t.string   "name"
    t.string   "method"
    t.string   "path"
    t.string   "action_path"
    t.string   "action"
    t.text     "original_route_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "routes_import_id"
    t.string   "formatted_path"
  end

  add_index "routes", ["routes_import_id"], name: "index_routes_on_routes_import_id"

  create_table "routes_imports", force: true do |t|
    t.string   "import_timestamp"
    t.string   "route_type"
    t.string   "file_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routing_errors_lines", force: true do |t|
    t.integer "request_id"
    t.integer "source_id"
    t.integer "lineno"
    t.string  "missing_resource_method"
    t.string  "missing_resource"
  end

  add_index "routing_errors_lines", ["request_id"], name: "index_routing_errors_lines_on_request_id"
  add_index "routing_errors_lines", ["source_id"], name: "index_routing_errors_lines_on_source_id"

  create_table "sources", force: true do |t|
    t.string   "filename"
    t.datetime "mtime"
    t.integer  "filesize"
    t.string   "file_type"
    t.string   "env"
  end

  add_index "sources", ["env"], name: "index_sources_on_env"

  create_table "started_lines", force: true do |t|
    t.integer  "request_id"
    t.integer  "source_id"
    t.integer  "lineno"
    t.string   "UUID"
    t.string   "employer"
    t.string   "session"
    t.string   "method"
    t.string   "path"
    t.string   "ip"
    t.datetime "timestamp"
    t.string   "formatted_path"
  end

  add_index "started_lines", ["request_id"], name: "index_started_lines_on_request_id"
  add_index "started_lines", ["source_id"], name: "index_started_lines_on_source_id"

  create_table "warnings", force: true do |t|
    t.string  "warning_type", limit: 30, null: false
    t.string  "message"
    t.integer "source_id"
    t.integer "lineno"
  end

end
