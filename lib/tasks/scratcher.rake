namespace :scratcher do
  desc 'Start scratching angel.co'
  task start: :environment do
    require "#{Rails.root}/lib/assets/scratcher.rb"

    scratcher = Scratcher.new

    # print 'Getting startup ids'
    # ids = scratcher.ids
    # puts " - received (#{ids.count})"
    # print 'Adding to database'
    # count = Startup.add(ids)
    # puts " - added (#{count})"

    # ---------
    filename = "#{Rails.root}/tmp/startups.html"
    # html = scratcher.startups_by_ids(["3975161", "3975152"])
    # File.open(filename, 'wb') { |file| file.write(html) }
    html = File.read(filename)
    startups = scratcher.startups_from_html(html)
    scratcher.batch_update(startups)
  end
end
