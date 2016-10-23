class LineItemsController < ApplicationController
  def new
  	@line_item = LineItem.new(params[:line_item_params])
  end

  def create
  end

  def destroy
  end

  def show
  end

  private

  def line_item_params
  	params.require(:line_item_params).permit(:image, :price, :brand, :description, :sale, :sale_price)
  end
  	
end
