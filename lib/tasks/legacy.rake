namespace :legacy do
  desc "Migrate news"
  task(:migrate_news => :environment) do
    Legacy::News.all.each do |item|
      puts "Migrating #{item.ID}..."
      article = Article.new(:legacy_id => item.ID, :article_category_id => ArticleCategory.news.id, :title => item.Title, :description => "#{item.ShortDesc} #{item.Desc}", :created_at => item.Date)
      article.save!
    end
    puts "News migrated successfully."
  end
  
  desc "Migrate stories"
  task(:migrate_stories => :environment) do
    Legacy::Story.all.each do |item|
      puts "Migrating #{item.ID}..."
      article = Article.new(:legacy_id => item.ID, :article_category_id => ArticleCategory.stories.id, :title => item.Name, :description => "#{item.ShortDesc} #{item.Desc}")
      article.save!
    end
    puts "Stories migrated successfully."
  end
  
  desc "Migrate testimonials"
  task(:migrate_testimonials => :environment) do
    Legacy::Testimonial.all.each do |item|
      puts "Migrating #{item.ID}..."
      testimonial = Testimonial.new(:legacy_id => item.ID, :title => item.Name, :description => "#{item.ShortDesc} #{item.Desc}", :source => 'Testimonial', :disclosure_date => item.Date)
      testimonial.save!
    end
    puts "Testimonials migrated successfully."
  end
  
  desc "Migrate subscribers"
  task(:migrate_subscribers => :environment) do
    invalid_subscribers = []
    Legacy::Subscriber.all.each do |item|
      puts "Migrating #{item.ID}..."
      subscriber = NewsletterSubscriber.new(:name => item.Name, :email => item.Email, :created_at => item.Date)
      unless subscriber.save
        invalid_subscribers << "Email: #{subscriber.email} | Errors: #{subscriber.errors}"
      end
    end
    puts 'Logging invalid subscribers...'
    File.open('log/legacy_invalid_subscribers.log', 'w') {|f| f.puts invalid_subscribers }
    puts 'Invalid subscribers logged in log/legacy_invalid_subscribers.log'
    puts "Valid subscribers migrated successfully."
  end
end