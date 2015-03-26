rails_root = ENV['Rails.root'] || File.expand_path('../../..', __FILE__)
rails_env  = ENV['RAILS_ENV']  || 'development'

redis_path = YAML.load_file(rails_root + '/config/resque/resque.yml')[rails_env]

host,port = redis_path.split(':')

$redis = Redis.new(:host => host, :port => port)
