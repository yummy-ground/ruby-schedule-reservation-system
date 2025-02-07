require "rake"

if Rails.env.development?
  Rails.application.config.after_initialize do
    Rails.application.load_tasks
    Rake::Task["db:create"].invoke
    unless ActiveRecord::Base.connection.data_source_exists?("schema_migrations")
      Rake::Task["db:setup"].invoke
    end
    Rake::Task["jwt:generate_for_user"].invoke
    Rake::Task["jwt:generate_for_admin"].invoke
  end
end

if Rails.env.test?
  Rails.application.config.after_initialize do
    Rails.application.load_tasks
    unless ActiveRecord::Base.connection.data_source_exists?("schema_migrations")
      Rake::Task["db:create"].invoke
      Rake::Task["db:migrate"].invoke
    end
  end
end
