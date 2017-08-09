class CartItemsController < ApplicationController
  before_action :set_cart_item, only: [:show, :edit, :update, :destroy]

  # GET /cart_items
  # GET /cart_items.json
  def index
    @cart_items = CartItem.all
  end

  # GET /cart_items/1
  # GET /cart_items/1.json
  def show
  end

  # GET /cart_items/new
  def new
    @cart_item = CartItem.new
  end

  # GET /cart_items/1/edit
  def edit
  end

  # POST /cart_items
  # POST /cart_items.json
  def create
    @cart_item = CartItem.new(cart_item_params)

    respond_to do |format|
      if @cart_item.save
        format.html { redirect_to @cart_item, notice: 'Cart item was successfully created.' }
        format.json { render :show, status: :created, location: @cart_item }
      else
        format.html { render :new }
        format.json { render json: @cart_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cart_items/1
  # PATCH/PUT /cart_items/1.json
  def update
        # byebug
    current_cart_copy=Cart.where(user_id:current_user.id).first
    newps=params.require(:cart_item).permit(:cart_id, :product_id, :item_quantity)
    current_cart=Cart.find(newps[:cart_id].to_i)
    if current_cart_copy.id==newps[:cart_id].to_i && current_cart.user_id==current_user.id
      product=params[:product];
      unit_product_cost=Product.find(newps[:product_id]).product_cost
      new_total_price=newps[:item_quantity].to_i*unit_product_cost
      newps[:total_price_item]=new_total_price
      respond_to do |format|
        if @cart_item.update(newps)
          format.html { redirect_to carts_url, notice: 'Cart item was successfully updated.' }
          format.json { render :show, status: :ok, location: @cart_item }
        else
          format.html { render :edit }
          format.json { render json: @cart_item.errors, status: :unprocessable_entity }
        end
      end
      Cart.new_subtotal_price current_cart
    else
      # byebug
      # byebug
      render_404
    end
  end

  # DELETE /cart_items/1
  # DELETE /cart_items/1.json
  def destroy
    current_cart=CartItem.find(params[:id]).cart
    # byebug
    if current_cart
      @cart_item.destroy
      new_sub_total_price=Cart.calculate_sub_total_price(current_cart.id)
      respond_to do |format|
        format.html { redirect_to carts_url, notice: 'Cart item was successfully destroyed.' }
        format.json { head :no_content }
      end
      Cart.new_subtotal_price current_cart
    end
  end

  def add_to_cart
    product_id=params[:product_id].to_i
    # byebug
    current_cart=Cart.where(user_id:current_user.id).first
    if current_cart.nil?
      # redirect_to url_for(controller: :carts,action: :create,user_id:current_user.id) and return
      # current_cart=Cart.where(user_id:current_user.id).first
      subtotal_price=0
      total_price=0
      current_cart=Cart.create(user_id:current_user.id, subtotal_price:subtotal_price, total_price:total_price)
    end
    ca_rt=CartItem.where(product_id:product_id,cart_id:current_cart.id).first
    if ca_rt
      # byebug
      @cart_item=ca_rt
      new_quantity=@cart_item.item_quantity+1
      new_price=Product.find(product_id).product_cost*new_quantity
      newps={product_id:product_id,cart_id:current_cart.id,item_quantity:new_quantity,
            total_price_item:new_price}
      respond_to do |format|
        if @cart_item.update(newps)
          # byebug
          new_sub_total_price=Cart.calculate_sub_total_price(current_cart.id)
          format.html { redirect_to carts_url, notice: 'Another item added to cart' }
          # format.html { redirect_to @cart_item, notice: 'Another item added to cart' }
          format.json { render :show, status: :ok, location: @cart_item }
        else
          format.html { render :edit }
          format.json { render json: @cart_item.errors, status: :unprocessable_entity }
        end
      end
    else
        @cart_item = CartItem.new
      @cart_item.cart_id=current_cart.id
      @cart_item.product_id=product_id
      @cart_item.item_quantity=1
      @cart_item.total_price_item=Product.find(product_id).product_cost
      # @cart_item.subtotal_price=@cart_item.item_quantity*@cart_item.total_price_item
      respond_to do |format|
        if @cart_item.save
          # byebug
          new_sub_total_price=Cart.calculate_sub_total_price(@cart_item.cart_id)
          format.html { redirect_to carts_url, notice: 'Cart was successfully created.' }
          format.json { render :show, status: :created, location: @cart_item }
        else
          format.html { render :new }
          format.json { render json: @cart_item.errors, status: :unprocessable_entity }
        end
      end
    end
    Cart.new_subtotal_price current_cart
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart_item
      @cart_item = CartItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_item_params
      params.require(:cart_item).permit(:cart_id, :product_id, :item_quantity, :total_price_item)
    end
end
