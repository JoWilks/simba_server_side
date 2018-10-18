class Category < ApplicationRecord
    belongs_to :user

    def self.create_base_categories(user_id)
        base_categories = {
            eating_out: 0,
            transport: 0,
            groceries: 0,
            shopping: 0,
            personal_care: 0,
            bills: 0,
            finances: 0,
            entertainment: 0,
            expenses: 0,
            family: 0,
            general: 0,
            holidays: 0
      }
        base_categories.each{ |cat_name, amount | Category.create(name: cat_name, budget_amount: amount, budget_timeframe: 'weekly basis', user_id: user_id ) }
    end

    def self.create_multiple_categories(hash: , timeframe: , user_id:)
        hash.each{ |cat_name, amount | Category.create(name: cat_name, budget_amount: amount, budget_timeframe: timeframe, user_id: user_id ) }
    end
 
end
