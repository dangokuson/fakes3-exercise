require 'tmpdir'
require 'glint'

RSpec.configure do |config|
  config.before :suite do
    rootdir = Dir.mktmpdir
    server = Glint::Server.new(nil, signals: [:INT]) do |port|
      exec "bundle exec fakes3 -p #{port} -r #{rootdir}", err: '/dev/null'
      exit 0
    end
    server.start

    Glint::Server.info[:fakes3] = {
      address: "127.0.0.1:#{server.port}",
      root: rootdir
    }
  end

  config.after :suite do
    if Dir.exists? Glint::Server.info[:fakes3][:root]
      FileUtils.remove_entry_secure(Glint::Server.info[:fakes3][:root])
    end
  end
end
