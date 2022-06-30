class ReviewController < ApplicationController

    get '/reviews' do 
        if logged_in?(session)
            @current_user = current_user(session)
            @sorted_reviews = sorted
            @last5_reviews = recent_reviews_by_others(@current_user, 5)
            @top3_movies = most_reviewed_movies(3)
            erb :'reviews/index'
        else 
            flash[:message] = "You must log in to see your reviews."
            redirect '/login'
        end 
    end 

    get 'reviews/new' do 
        if logged_in?(session)
            erb :'reviews/new'
        else 
             flash[:message] = "You must be logged in to enter a new review."
            redirect '/login'
        end 
    end 

    post '/reviews/new' do 
        user =  current_user(session)
        new_review = Review.find_by(movie_id: params[:movie_id], user_id: user.id)
        new_review.review_content = params[:review_content]
        new_review.star_rating = params[:star_rating]
        user.reviews << new_review
        redirect '/reviews'
    end 
 
    get '/reviews/:id' do 
        
            @review = Review.find_by(id: params[:id])
            @movie = @review.movie 
            @critic = @review.user 
            @user =  current_user(session)
            # @movie = Movie.find_by(id: @review.movie_id)
            # @critic = User.find_by(id: @review.user_id)

            erb :'reviews/show'
    end 

    get "/reviews/:id/edit" do

        if  logged_in?(session)
            @user =  current_user(session)
          @review = Review.find_by(id: params[:id])
          if @review.user_id == @user.id
            erb :"/reviews/edit"
          else
            flash[:message] = "Only the user who entered this review is allowed to delete it."
            redirect '/reviews'
          end
        else
            flash[:message] = "You must be logged in to edit or delete."
            redirect '/reviews'
        end
      end

      patch "/reviews/:id" do
        @user =  current_user(session)

        @review = Review.find_by(id: params[:id])
        if @review.user_id != @user.id
            flash[:message] = "Only the user who entered this review is allowed to update it."
            redirect '/reviews'
        end


        if params[:review_content].empty? || params[:star_rating].empty?    
             redirect "/reviews/#{params[:id]}/edit"
        else
           # @review = Review.find_by(id: params[:id])
            @review.review_content = params[:review_content]
            @review.star_rating = params[:star_rating]
            @review.save
            redirect "/reviews/#{@review.id}"
        end
      end

    delete "/reviews/:id" do

        if !logged_in?(session)
            flash[:message] = "You must be logged in to edit or delete."
            redirect '/reviews'
        else
            @user =  current_user(session)

            @review = Review.find_by(id: params[:id])
            if @review.user_id == @user.id
                @review.destroy
                redirect '/reviews'
            else
                flash[:message] = "Only the user who entered this review is allowed to delete it."
                redirect '/reviews'
            end
        end
    end 

    def sorted 
        #@current_user = current_user(session)
        sort = current_user(session).reviews.sort_by(&:updated_at).reverse
        #binding.pry 
        # sort.reverse.each do |review|  
        #     Movie.find_by(id: review.movie_id).title 
        # end
    end 

    def recent_reviews_by_others(user, n)
        #Review.where.not(user_id: user.id).reverse.first(n)
        #binding.pry
        sort = Review.where.not(user_id: user.id).sort_by &:updated_at 
        sort.reverse.first(n)
    end 

    def most_reviewed_movies(n)
        counts = Hash.new 0 

        # Review.all.each do |review| 
        #     counts[review.movie_id] += 1 
        # end 

        #return top n most reviewed movies 
        #[[movie_id,  review count], [movie_id, review count],[movie_id, review count]]
        # sort = counts.sort_by {|_key, value| value}.reverse
        # sort.first(n)

        counts = Review.group(:movie_id).count.sort_by {|_key, value| value}.reverse.first(n)
        most_reviewed_movies = counts.map do |movie|
            Movie.find(movie[0])
        end 
        
        most_reviewed_movies

    end 
        

end 