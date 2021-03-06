class FavoriteImagesController < ApplicationController
	before_action :check_current_user, only:[:create, :destroy]

	def new
		@favorite = FavoriteImage.new
	end

	def create 
		if current_user 
			@user = User.find_by(id: current_user.id)
		else
			@user = nil
			redirect_to root_url
			flash[:notice] = "You must sign in to add favorites"
		end
		@favorite = FavoriteImage.new(favorite_images_params)
		if !(FavoriteImage.find_by(image_id: @favorite.image_id, user_id: @favorite.user_id)) && @favorite.save
			redirect_to image_categories_path
			flash[:notice] = "Image saved to your favorites"
		else
			redirect_to image_categories_path
			flash[:notice] = "That image is already in your favorites"
		end
	end

	def index
		@favorite_images = current_user.favorite_images.where(user_id: current_user.id)
	end

	def show
		@user = current_user
		@favorite_image = FavoriteImage.find_by(user_id: params[:user_id], image_id: params[:id])
		@image_count = @favorite_image.image.favorite_images_count
		@unmotivational_count = UnmotivationalImage.where(image_id: @favorite_image.image_id).count

	end

	def destroy
		FavoriteImage.find_by(id: params[:id]).destroy
		flash[:notice] = "Favorite Image deleted!" 
		redirect_to user_favorite_images_path
	end

	private

	def favorite_images_params
		params.require(:favorite_image).permit(:url, :image_id, :user_id)
	end

	def check_current_user
		@user = User.find(params[:user_id])
		unless current_user?(@user)
			redirect_to(root_url)
			flash[:notice] = "You need to be signed in as that user to perform that action." 
		end
	end

end
