namespace :scratcher do
  desc 'Start scratching startups from angel.co'
  task startups: :environment do
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
            puts "Thread #{index} ERROR: #{ e.message }"
            Thread.current[:exception] = e
            break
          ensure
            ActiveRecord::Base.connection_pool.release_connection
          end
        end
        puts "Thread #{index}: Done"
      end
    end

    threads.each do |thread|
      thread.join
    end
  end

  desc 'Start scratching profiles from angel.co'
  task profiles: :environment do
    require "#{Rails.root}/lib/assets/scratcher.rb"

    scratcher = Scratcher.new

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
            profiles = {}
            lock.synchronize do
              founders = Founder.where(parsed_at: nil)
                                .where.not(id: busy_ids)
              count = founders.count
              profiles = founders.limit(10).pluck(:id, :profile).to_h
              busy_ids += profiles.keys
              puts "Thread #{index}: #{count} - Taken [#{profiles.keys.join(', ')}]"
            end
            break if profiles.empty?
            scratcher.update_profiles(profiles)
          rescue Exception => e
            puts "Thread #{index} ERROR: #{ e.message }"
            Thread.current[:exception] = e
            break
          ensure
            ActiveRecord::Base.connection_pool.release_connection
          end
        end
        puts "Thread #{index}: Done"
      end
    end

    threads.each do |thread|
      thread.join
    end
  end
end
