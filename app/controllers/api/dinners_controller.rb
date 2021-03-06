class Api::DinnersController < Api::ApiController


	def index
		
		if (params[:id])
			@dinner=Dinner.find(params[:id])
			@meals = @dinner.meals.includes(:user_meal_likeships,:styles)
			if current_user
				my_like_meal_ids = current_user.user_meal_likeships.pluck(:meal_id)
				render :json => {
					:data => @dinner.meals.includes(:user_meal_likeships,:users,:photos,:style).map{|meal| 
						h = meal.return_json
						h[:liked] = my_like_meal_ids.include?(meal.id)
						h
					}
				}

			else
			render :json => {
				:data => @dinner.meals.map{|meal| meal.return_json}
			}				
			end
			
		else
			@dinners=Dinner.all
			render :json => {
				:data => @dinners.map{|d| d.return_json}
			}
		
		end		
	end	

	def show
		@dinner=Dinner.find(params[:id])
			render :json => {
				:data => @dinner.return_json
			}
	end
		# return json return_json(@dinners)
	
	def create
		@dinner=Dinner.new(dinner_params)
		@dinner.save

		render :json => {
				:data => "OK"
			}
	end

	def destroy
		@dinner=Dinner.find(params[:id])
		@dinner.destroy
		
		render :json => {
				:data => "OK"
			}		
	end
	
	private


	def dinner_params
		params.require(:dinner).permit(:name,:zip,:district,:address,:lat,:lng,:style,:price_level,:style_id,:avatar,photos_attributes: [:avatar])
	end
end
