class Api::V1::CategoriesController < ApplicationController

    def index
        #gets posting users categories only need params to include user ID
        user = current_user
        categories = user.categories
        render json: {categories: categories}
    end

    def show
        category = Category.find(cat_id)
        render json: {category: category}
    end

    # def create
    #     category = Category.create()
    #     if category.valid?
    #       render json: { category: category} status: :created
    #     else
    #       render json: { error: 'failed to create categories' }, status: :not_acceptable
    #     end
    # end

    def createbase
        user = current_user
        if user.categories.empty?
          timeframe = all_params["timeframe"]
          categories = Category.create_multiple_categories(hash: all_params["budgetCat"], timeframe: all_params["timeframe"], user_id: user.id)
          render json: { budgetCat: categories, timeframe: timeframe }, status: :created
        else
          render json: { error: 'failed to create categories' }, status: :not_acceptable
        end
    end

    def update
        user = current_user
        categories = user.categories
        all_params[:budgetCat].each{|cat_name, amount| 
            curr_cat = categories.find_by_name(cat_name)
            Category.update(curr_cat.id, budget_amount: amount, budget_timeframe: all_params[:timeFrame] )
        }
        render json: { budgetCat: categories }, status: :updated

    end

    private
    def all_params
        params.require(:budgetObj).permit!
    end

    # def timeframe_params
    #     params.require(:budgetObj).permit(:timeframe)
    # end

end
