class CollectionsController < ApplicationController
  def new
  	@collection = Collection.new(params[:collection_params])
  end

  def create
  	if @collection.save 
  		redirect back
  		flash[:success] = "You've added the item to the collection"
  	else
  		redirect back
  		flash[:warning] = "Something went wrong"
  	end
  end

  def show
  	@collection = Collection.find_by_id(params[:id])
  end

def create_line_item
    @line_item = LineItem.new
    @line_item.price = @product.price
    @line_item.brand = @product.brand
    @line_item.description = @product.description
    @line_item.sale = @product.sale
    @line_item.sale_price = @product.sale_price
    @line_item.image = @product.image
    @line_item.save
end

  def add_to_collection 
  	product_id = params[:product_id]
  	@product = Product.find_by_id(product_id)
    @user = User.find_by_id(current_user.id)
    @collection = Collection.create(params[:collection_params])
    @collection.user_id = current_user.id
    create_line_item()
    @collection.line_items << [@line_item]
    @collection.save
  	redirect_to products_path
    flash[:success] = "You successfully added the item into the collection"
  end

  def update
  	@collection = Collection.find_by_id(params[:id])
  	@collection.save
  	redirect back
  	flash[:success] = "You successfully added the item into the collection"
  end

  def index
  	@collections = current_user.collections
  	@collection = Collection.find_by_id(params[:id])
    @line_items = LineItem.all
  end


  def destroy_line_item
    @line_item = LineItem.find_by_id(params[:id])
    p @line_item
    @line_item.destroy
    @collection = Collection.find_by_id(params[:id])
    p @collection
    @collection.destroy
    flash[:success] = "Item deleted"
    redirect_to collections_path
  end

  private

  def collection_params
  	params.require(:collection).permit(:client, :line_items)
  end
end
