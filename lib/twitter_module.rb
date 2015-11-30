module TwitterModule
  require 'twitter-text'
  include Twitter::Autolink


  def get_tweets(twitter_handle)

    unless twitter_handle == nil
      tweets = Rails.cache.fetch(twitter_handle, :expires_in => 5*60) do
        twitter_client.user_timeline(twitter_handle, count: 25)
      end

      tweet_text_with_links(tweets)
      tweet_dates(tweets)
      combine_date_and_text(@tweet_text, @tweet_dates)
    end
  end

  def tweet_text_with_links(tweets)
    @tweet_text = []
    
    tweets.each do |tweet|
      @tweet_text << auto_link(tweet.text).html_safe
    end
  end

  def tweet_dates(tweets)
    @tweet_dates = []

    tweets.each do |tweet|
      @tweet_dates << tweet.created_at.strftime("%m/%d/%Y %l:%M%P")
    end
  end

  def combine_date_and_text(texts, dates)
    @tweets = {}

    @tweets = Hash[texts.zip(dates)]
  end

private

  def twitter_client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["twitter_consumer_key"]
      config.consumer_secret     = ENV["twitter_consumer_secret"]
      config.access_token        = ENV["twitter_access_token"]
      config.access_token_secret = ENV["twitter_access_token_secret"]
    end
  end
end