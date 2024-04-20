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

ActiveRecord::Schema[7.0].define(version: 2024_04_20_070438) do
  create_table "loan_requests", force: :cascade do |t|
    t.float "amount"
    t.integer "term"
    t.integer "user_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "remaining_amount"
  end

  create_table "repayment_schecules", force: :cascade do |t|
    t.integer "amount"
    t.datetime "due_date", precision: nil
    t.integer "loan_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_id"], name: "index_repayment_schecules_on_loan_id"
  end

  create_table "repayment_schedules", force: :cascade do |t|
    t.float "amount"
    t.datetime "due_date", precision: nil
    t.integer "loan_request_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_request_id"], name: "index_repayment_schedules_on_loan_request_id"
  end

  add_foreign_key "repayment_schecules", "loans"
  add_foreign_key "repayment_schedules", "loan_requests"
end
