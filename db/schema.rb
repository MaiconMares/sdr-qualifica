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

ActiveRecord::Schema[8.1].define(version: 2026_06_24_150204) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audit_logs", force: :cascade do |t|
    t.integer "action", null: false
    t.bigint "auditable_id"
    t.string "auditable_type"
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.jsonb "metadata", default: {}
    t.datetime "occurred_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id"
    t.index ["action"], name: "index_audit_logs_on_action"
    t.index ["auditable_type", "auditable_id"], name: "index_audit_logs_on_auditable_type_and_auditable_id"
    t.index ["occurred_at"], name: "index_audit_logs_on_occurred_at"
    t.index ["user_id", "occurred_at"], name: "index_audit_logs_on_user_id_and_occurred_at"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "call_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "duration_seconds"
    t.datetime "ended_at"
    t.bigint "lead_id", null: false
    t.datetime "started_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "work_session_id"
    t.index ["lead_id", "user_id"], name: "index_call_sessions_on_lead_id_and_user_id"
    t.index ["lead_id"], name: "index_call_sessions_on_lead_id"
    t.index ["started_at"], name: "index_call_sessions_on_started_at"
    t.index ["status"], name: "index_call_sessions_on_status"
    t.index ["user_id"], name: "index_call_sessions_on_user_id"
    t.index ["work_session_id"], name: "index_call_sessions_on_work_session_id"
  end

  create_table "imports", force: :cascade do |t|
    t.string "content_type"
    t.datetime "created_at", null: false
    t.text "error_message"
    t.jsonb "errors_detail", default: []
    t.integer "failed_rows", default: 0
    t.string "filename", null: false
    t.datetime "finished_at"
    t.integer "imported_rows", default: 0
    t.integer "processed_rows", default: 0
    t.integer "skipped_rows", default: 0
    t.datetime "started_at"
    t.integer "status", default: 0, null: false
    t.integer "total_rows", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["created_at"], name: "index_imports_on_created_at"
    t.index ["status"], name: "index_imports_on_status"
    t.index ["user_id"], name: "index_imports_on_user_id"
  end

  create_table "lead_assignments", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "assigned_at", null: false
    t.bigint "assigned_by_id"
    t.datetime "created_at", null: false
    t.bigint "lead_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["assigned_at"], name: "index_lead_assignments_on_assigned_at"
    t.index ["assigned_by_id"], name: "index_lead_assignments_on_assigned_by_id"
    t.index ["lead_id", "user_id"], name: "index_lead_assignments_on_lead_id_and_user_id", unique: true, where: "(active = true)"
    t.index ["lead_id"], name: "index_lead_assignments_on_lead_id"
    t.index ["user_id", "active"], name: "index_lead_assignments_on_user_id_and_active"
    t.index ["user_id", "position"], name: "index_lead_assignments_on_user_id_and_position"
    t.index ["user_id"], name: "index_lead_assignments_on_user_id"
  end

  create_table "lead_status_histories", force: :cascade do |t|
    t.datetime "changed_at", null: false
    t.bigint "changed_by_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "lead_id", null: false
    t.integer "new_status", null: false
    t.integer "previous_status"
    t.datetime "updated_at", null: false
    t.index ["changed_at"], name: "index_lead_status_histories_on_changed_at"
    t.index ["changed_by_id"], name: "index_lead_status_histories_on_changed_by_id"
    t.index ["lead_id", "changed_at"], name: "index_lead_status_histories_on_lead_id_and_changed_at"
    t.index ["lead_id"], name: "index_lead_status_histories_on_lead_id"
    t.index ["new_status"], name: "index_lead_status_histories_on_new_status"
  end

  create_table "leads", force: :cascade do |t|
    t.string "city"
    t.string "company_name", null: false
    t.string "contact_name"
    t.datetime "created_at", null: false
    t.string "email"
    t.bigint "import_id"
    t.datetime "last_interaction_at"
    t.text "notes"
    t.string "phone"
    t.bigint "revenue_range_id"
    t.string "state"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_leads_on_city"
    t.index ["company_name"], name: "index_leads_on_company_name"
    t.index ["created_at"], name: "index_leads_on_created_at"
    t.index ["email"], name: "index_leads_on_email"
    t.index ["import_id"], name: "index_leads_on_import_id"
    t.index ["last_interaction_at"], name: "index_leads_on_last_interaction_at"
    t.index ["phone", "email"], name: "index_leads_on_phone_and_email"
    t.index ["phone"], name: "index_leads_on_phone"
    t.index ["revenue_range_id"], name: "index_leads_on_revenue_range_id"
    t.index ["state"], name: "index_leads_on_state"
    t.index ["status"], name: "index_leads_on_status"
  end

  create_table "pauses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "duration_seconds"
    t.datetime "ended_at"
    t.integer "reason", null: false
    t.datetime "started_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "work_session_id", null: false
    t.index ["reason"], name: "index_pauses_on_reason"
    t.index ["user_id", "started_at"], name: "index_pauses_on_user_id_and_started_at"
    t.index ["user_id"], name: "index_pauses_on_user_id"
    t.index ["work_session_id"], name: "index_pauses_on_work_session_id"
  end

  create_table "revenue_ranges", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.decimal "max_value", precision: 15, scale: 2
    t.decimal "min_value", precision: 15, scale: 2
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_revenue_ranges_on_code", unique: true
    t.index ["position"], name: "index_revenue_ranges_on_position"
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "name", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.integer "session_timeout_minutes", default: 480, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_users_on_active"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "work_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "effective_duration_seconds"
    t.datetime "ended_at"
    t.integer "net_work_duration_seconds"
    t.datetime "paused_at"
    t.datetime "resumed_at"
    t.datetime "started_at", null: false
    t.integer "status", default: 0, null: false
    t.integer "total_pause_duration_seconds", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["started_at"], name: "index_work_sessions_on_started_at"
    t.index ["status"], name: "index_work_sessions_on_status"
    t.index ["user_id", "status"], name: "index_work_sessions_on_user_id_and_status"
    t.index ["user_id"], name: "index_work_sessions_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audit_logs", "users"
  add_foreign_key "call_sessions", "leads"
  add_foreign_key "call_sessions", "users"
  add_foreign_key "call_sessions", "work_sessions"
  add_foreign_key "imports", "users"
  add_foreign_key "lead_assignments", "leads"
  add_foreign_key "lead_assignments", "users"
  add_foreign_key "lead_assignments", "users", column: "assigned_by_id"
  add_foreign_key "lead_status_histories", "leads"
  add_foreign_key "lead_status_histories", "users", column: "changed_by_id"
  add_foreign_key "leads", "imports"
  add_foreign_key "leads", "revenue_ranges"
  add_foreign_key "pauses", "users"
  add_foreign_key "pauses", "work_sessions"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "work_sessions", "users"
end
