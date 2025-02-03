if Rails.env.development?
  Rails.application.config.after_initialize do
    require "rake"
    Rails.application.load_tasks
    unless ActiveRecord::Base.connection.data_source_exists?("schema_migrations")
      Rake::Task["db:create"].invoke
      Rake::Task["db:migrate"].invoke
      Rake::Task["db:seed:replant"].invoke
    end
  end
end

if Rails.env.test?
  Rails.application.config.after_initialize do
    require "rake"
    Rails.application.load_tasks
    unless ActiveRecord::Base.connection.data_source_exists?("schema_migrations")
      Rake::Task["db:create"].invoke
      Rake::Task["db:migrate"].invoke
    end
  end
end
