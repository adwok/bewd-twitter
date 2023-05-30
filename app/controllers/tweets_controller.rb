class TweetsController < ApplicationController

  def create
    @tweet = Tweet.new(tweet_params)
    token = cookies.permanent.signed[:twitter_session_token]
    session = Session.find_by(token: token)

    if session
      @user = session.user
      if @tweet.save
        render json: {
          tweet: {
            username: @user.username,
            message: @tweet.message
          }
        }
      end
    end
  end

  def destroy
    token = cookies.permanent.signed[:twitter_session_token]
    session = Session.find_by(token: token)
    @tweet = Tweet.find_by(id: params[:id])
    if session
      if @tweet and @tweet.destroy
        render json: { success: true }
      else
        render json: { success: false }
      end
    else 
      render json: { success: false }
    end
  end

  def index
    @tweets = Tweet.all.sort.reverse
  end

  def index_by_user
    @user = User.find_by(username: params[:username])
    @tweets = @user.tweets
  end
    
  private

    def tweet_params
      params.require(:tweet).permit(:message)
    end

end
