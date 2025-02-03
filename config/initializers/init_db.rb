if Rails.env.development?
  Rails.application.config.after_initialize do
    require "rake"
    Rails.application.load_tasks
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed:replant"].invoke
  end
end
