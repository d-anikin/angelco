namespace :scratcher do
  desc 'Start scratching angel.co'
  task start: :environment do
    require "#{Rails.root}/lib/assets/scratcher.rb"

    scratcher = Scratcher.new

    print 'Getting startup ids'
    ids = scratcher.ids
    puts " - received (#{ids.count})"
    print 'Adding to database'
    count = Startup.add(ids)
    puts " - added (#{count})"
  end
end
