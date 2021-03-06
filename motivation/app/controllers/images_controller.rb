class ImagesController < ApplicationController
	before_action :check_admin, only: [:create, :destroy]
	
	def index
		@best_images = Image.order('favorite_images_count desc').paginate(page: params[:page], per_page: 6, total_entries: 12)
		@user = current_user if current_user
		@favorite = @user.favorite_images.build() if current_user
	end

	def show
		if current_user
			@user = current_user
			@unmotivational_images = @user.find_unmotivational_image_ids
			@image = Image.find_random_image_with_type_and_unmotivational(params[:type], @unmotivational_images)
			@favorite = @user.favorite_images.build()
			@unmotivational_image = @user.unmotivational_images.build()
		else
			@image = Image.find_random_image_with_type(params[:type]) if params[:type]
		end

		if params[:format]
			@image = Image.find(params[:format])
			@best_image = true if params[:format]
		end
		
		@image_count = @image.favorite_images_count
		@unmotivational_count = UnmotivationalImage.where(image_id: @image.id).count
		@type = params[:type]
		@error_type = params[:type].split("I")[0].downcase  if params[:type]
	end

	def categories
		@background = "images-background"
	end

	def random
		@random_image =  Image.find_random_image
		if current_user
			@user = current_user 
			@unmotivational_images = @user.find_unmotivational_image_ids
			@random_image = Image.find_random_image_with_unmotivational(@unmotivational_images)
			@favorite = @user.favorite_images.build()
			@unmotivational_image = @user.unmotivational_images.build()
		end
		if @random_image
			@image_count = @random_image.favorite_images_count
			@unmotivational_count = UnmotivationalImage.where(image_id: @random_image.id).count
		end
		random_image_or_video()
		@error_type = "every category"
	end

	def create 
	  	@image = Image.new(images_params)
	  	if !Image.exists?(url: @image.url) && @image.save
	  		flash[:notice] = "Image successfully added"
	  		redirect_to user_submitted_motivations_url
	  	else
	  		flash[:notice] = "Failed to add image. It may have already be added."
	      	redirect_to user_submitted_motivations_url
	  	end
	end


	def destroy
	end

	private

	def images_params
		params.require(:image).permit(:url, :type)
	end

    def check_admin
        unless current_user.admin == true
          flash[:notice] = "Nice try. You do not have permission to access that"
          redirect_to '/'
        end
    end

end
