class CollectionsController < ApplicationController
  def new
  	@collection = Collection.new(params[:collection_params])
  end

  def index
    if current_user != nil 
    @collections = current_user.collections
    render json: @collections
  else
    @collections = []
    render json: @collections
  end
  end

  def create
  	@collection = Collection.new(params[:collection_params])
    @line_item = LineItem.new
   p "$"*65, params[:collection]
   
  		flash[:success] = "You've added the item to the collection"
      @collection.save 
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
    @line_item.remote_image_url = @product.original_image_url
    @line_item.save
end

  def add_to_collection 
  	@product = Product.find_by_id(params[:product_id])
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
    if current_user != nil
  	@collections = current_user.collections
  	@collection = Collection.find_by_id(params[:id])
    @line_items = LineItem.all
    else
    @line_items & @collections = [] 
  end
  end


  def destroy_line_item
    @line_item = LineItem.find_by_id(params[:id])
    @line_item.destroy
    flash[:success] = "Item deleted"
  end

  private

  def collection_params
  	params.require(:collection).permit(:client, :line_items)
  end
end
