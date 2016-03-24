namespace :URLShortener do
  desc "Removes Shortened Urls that haven't been accessed in 30 mins"
  task prune: :environment do
    puts "Pruning old Short Urls..."
    ShortenedUrl.prune
  end
end
