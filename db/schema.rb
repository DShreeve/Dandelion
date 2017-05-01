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

ActiveRecord::Schema.define(version: 20170501145258) do

  create_table "data_types", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "fields", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "table_id"
    t.integer  "data_type_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "fields", ["table_id"], name: "index_fields_on_table_id"

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "tables", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "project_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tables", ["project_id"], name: "index_tables_on_project_id"

  create_table "validation_assignments", force: :cascade do |t|
    t.integer  "field_id"
    t.integer  "validation_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "validation_assignments", ["field_id"], name: "index_validation_assignments_on_field_id"
  add_index "validation_assignments", ["validation_id"], name: "index_validation_assignments_on_validation_id"

  create_table "validations", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "rule"
    t.integer  "field_data_type_id"
    t.integer  "value_data_type_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "values", force: :cascade do |t|
    t.string   "value"
    t.integer  "data_type_id"
    t.integer  "validation_assignment_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "values", ["validation_assignment_id"], name: "index_values_on_validation_assignment_id"

end
