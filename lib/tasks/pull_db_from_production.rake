namespace :pull_db_from_production do
  desc "TODO"
  task run: :environment do
    %x{ heroku pg:backups capture }
    %x{ curl -o latest.dump `heroku pg:backups public-url` }
    %x{ rake db:drop }
    %x{ rake db:create }
    %x{ pg_restore --verbose --clean -d penny-stock-mailer_development latest.dump }
  end

end
