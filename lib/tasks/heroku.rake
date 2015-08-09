# A simple collection of convenient rake tasks for heroku deployed applications
namespace :heroku do
  namespace :maintenance do
    task :on do
      app = ENV['APPLICATION_NAME']
      puts `heroku maintenance:on -a #{app}`
      puts `heroku ps:scale worker=0 urgent=0 clock=0 -a #{app}`
    end

    task :off do
      app = ENV['APPLICATION_NAME']
      puts `heroku maintenance:off -a #{app}`
      puts `heroku ps:scale worker=2 urgent=2 clock=1 -a #{app}`
    end
  end
end
