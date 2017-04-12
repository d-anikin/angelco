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

    lock = Mutex.new
    threads = []
    busy_ids = []

    10.times do |index|
      threads << Thread.new(index) do |index|
        puts "Thread #{index}: Starting"
        scratcher = Scratcher.new
        loop do
          begin
            ids = []
            lock.synchronize do
              startups = Startup.where(parsed_at: nil)
                                .where.not(id: busy_ids)
              count = startups.count
              ids = startups.limit(10).ids
              busy_ids += ids
              puts "Thread #{index}: #{count} - Taken [#{ids.join(', ')}]"
            end
            break if ids.empty?
            startups = scratcher.startups_by_ids(ids)
            scratcher.batch_update(startups)
          rescue Exception => e
            Thread.current[:exception] = e
          ensure
            ActiveRecord::Base.connection_pool.release_connection
          end
        end
        puts "Thread #{index}: Done"
      end
    end

    threads.each do |thread|
      thread.join
      if thread[:exception]
        puts "Error: #{ thread[:exception].message }"
      end
    end
  end
end
