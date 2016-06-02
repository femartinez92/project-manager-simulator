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

ActiveRecord::Schema.define(version: 20160602001722) do

  create_table "budgets", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "activities_cost"
    t.integer  "activities_reserve"
    t.integer  "contingency_reserve"
    t.integer  "managment_reserve"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "profit"
    t.integer  "activities_cost_used"
    t.integer  "activities_reserve_used"
    t.integer  "contingency_reserve_used"
    t.integer  "managment_reserve_used"
  end

  create_table "cost_lines", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "amount"
    t.integer  "real_amount"
    t.integer  "payment_week"
    t.integer  "real_payment_week"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "cost_payment_plan_id"
    t.string   "status"
    t.integer  "task_id"
    t.string   "funding_source"
  end

  create_table "cost_payment_plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "project_id"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "human_resources", force: :cascade do |t|
    t.string   "name"
    t.integer  "project_id"
    t.boolean  "is_from_admin"
    t.integer  "experience"
    t.integer  "salary"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "resource_type"
  end

  create_table "milestones", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.date     "due_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "project_id"
    t.boolean  "is_admin_milestone"
    t.boolean  "fake"
  end

  create_table "precedents", force: :cascade do |t|
    t.integer  "predecessor_id"
    t.integer  "dependent_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "project_id"
  end

  create_table "project_managers", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "student_number"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "project_type_id"
  end

  add_index "project_managers", ["email"], name: "index_project_managers_on_email", unique: true
  add_index "project_managers", ["reset_password_token"], name: "index_project_managers_on_reset_password_token", unique: true

  create_table "project_managers_roles", id: false, force: :cascade do |t|
    t.integer "project_manager_id"
    t.integer "role_id"
  end

  add_index "project_managers_roles", ["project_manager_id", "role_id"], name: "index_project_managers_roles_on_project_manager_id_and_role_id"

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.integer  "actual_week"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "project_manager_id"
    t.string   "status"
    t.boolean  "is_admin_project"
    t.date     "start_date"
    t.text     "strategic_objective"
  end

  create_table "requirements", force: :cascade do |t|
    t.string   "requirement_id"
    t.string   "name"
    t.string   "description"
    t.integer  "project_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.boolean  "is_present"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "stakeholders", force: :cascade do |t|
    t.string   "name"
    t.integer  "commitment_level"
    t.integer  "influence"
    t.integer  "power"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "project_id"
    t.boolean  "is_admin_stakeholder"
  end

  create_table "task_trees", force: :cascade do |t|
    t.integer  "father_id"
    t.integer  "child_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "min_duration"
    t.integer  "most_probable_duration"
    t.integer  "max_duration"
    t.integer  "pm_duration_estimation"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "milestone_id"
    t.boolean  "is_admin_task"
    t.boolean  "fake"
    t.integer  "admin_duration_estimation"
  end

end
