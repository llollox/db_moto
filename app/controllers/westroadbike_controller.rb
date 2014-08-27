class WestroadbikeController < ApplicationController
  def find_customers_by_category
    category_bike_ids = Category.find(params[:category_id].to_i).bikes.pluck(:id)

    customers_hash = JSON.parse(request.body.read)
    result = []
    customers_hash.each do |customer|
      customer_id = customer["customer_id"]
      bike_ids = customer["bikes"]
      bike_ids.each do |bike_id|
        if category_bike_ids.include?(bike_id)
          result = result << customer_id 
          break
        end
      end
    end
    render json: result
  end
end
