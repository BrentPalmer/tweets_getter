class TweetsController < ApplicationController
  before_filter :authenticate_user!
  include TwitterModule


  def index
    @twitter_handle = params[:twitter_handle]
    @tweets = get_tweets(@twitter_handle)
  end
end