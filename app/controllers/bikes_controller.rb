class BikesController < ApplicationController
  
  before_action :set_bike, only: [:show, :edit, :update, :destroy]

  # GET /bikes
  # GET /bikes.json

  # before_render :global_item, :except => [:destroy, :index]

  def find_bikes_by_category
    @bikes = Category.find(params[:id]).bikes

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bikes }
    end
  end

  # Optimized method to select2 in clients app!
  def contains
    @bikes = []

    Brand.alphabetically.each do |brand|
      bike_group = []
      brand.bikes.each do |bike|
        if bike.equipment_name.downcase.match(/#{params[:name].downcase}/)
          bike_hash = Hash.new
          bike_hash["id"] = bike.id
          bike_hash["text"] = bike.equipment_name
          bike_group = bike_group << bike_hash 
        end
      end

      if !bike_group.empty?
        brand_group = Hash.new
        brand_group["text"] = brand.name
        brand_group["children"] = bike_group
        @bikes = @bikes << brand_group
      end
    end

    respond_to do |format|
      format.json { render json: @bikes }
    end
  end

  def index
    @model = Model.find(params[:model_id])
    @bikes = @model.bikes

    respond_to do |format|
      format.html { redirect_to @model}
      format.json { render json: @bikes }
    end
  end

  # GET /bikes/1
  # GET /bikes/1.json
  def show
    @bike = Bike.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bike }
    end
  end

  # GET /bikes/new
  # GET /bikes/new.json
  def new
    @bike = Bike.new
    @model = Model.find(params[:model_id])
    @bike.model_id = @model.id
    @bike.brand_id = @model.brand.id
    @models = @model.brand.models.alphabetically

    respond_to do |format|
      format.html { render "forms/new_edit", :locals => {:object => [@bike.brand, @bike.model, @bike]}}
      format.json { render json: @bike }
    end
  end

  # GET /bikes/1/edit
  def edit

    respond_to do |format|
      format.html { render "forms/new_edit", :locals => {:object => @bike}}
      format.json { render json: @bike }
    end
    
  end

  # POST /bikes
  # POST /bikes.json
  def create
    @bike = Bike.new(bike_params)
    # @model = Model.find(params[:model_id])

    # if equipment_name is not setted the for example equal then model name
    if @bike.valid? && (@bike.equipment_name == "" || @bike.equipment_name == nil)
      @bike.equipment_name = @bike.model.name
    end

    respond_to do |format|
      if @bike.save
        format.html { redirect_to @bike, flash: {success: _('Moto creata con successo!')} }
        format.json { render json: @bike, status: :created, location: @bike }
      else
        format.html { render "forms/new_edit" }
        format.json { render json: @bike.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bikes/1
  # PUT /bikes/1.json
  def update
    respond_to do |format|
      if @bike.update(bike_params)
        format.html { redirect_to @bike, flash: {success: _('Moto modificata con successo!')} }
        format.json { head :no_content }
      else
        format.html { render "forms/new_edit" }
        format.json { render json: @bike.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bikes/1
  # DELETE /bikes/1.json
  def destroy
    @bike = Bike.find(params[:id])
    model = @bike.model
    brand = @bike.brand

    @bike.destroy

    if model.bikes.size == 0
      # if there aren't any bikes for
      # that model, destroy it!
      model.destroy
      model = nil
    end

    respond_to do |format|
      if model
        # redirect to show model which show the
        # list of bikes for this model
        format.html { redirect_to model, flash: {success: _('Moto cancellata con successo!')} }
      else
        # no longer the model -> redirect to brand
        format.html { redirect_to brand, flash: {success: _('Moto cancellata con successo!')} }
      end
      format.json { head :no_content }
    end
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_bike
    @bike = Bike.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bike_params
    params.require(:bike).permit(
      :brand_id,
      :model_id,
      :stroke,
      :cylinders,
      :displacement,
      :cooling_system,
      :power,
      :torque,
      :brakes,
      :brake_measures,
      :wheel_measures,
      :anti_pollution_legislation,
      :weight,
      :length,
      :seat_height,
      :fuel_capacity,
      :price,
      :motoit_code,
      :equipment_name,
      :category_id,
      :pictures,
      pictures_attributes:[:photo, :_destroy, :id])
  end

  # def filtered
  #   @bikes = Bike.where(:model_id => params[:model_id].to_i)
  #   respond_to do |format|
  #     format.html { render 'filtered', :layout => false }
  #   end
  # end

  # private

  # def global_item
  #   @object = @bike

  #   if action_name == "new" || action_name == "create"
  #     @object_with_path = [@model, @bike]
  #   else
  #     @object_with_path = @bike
  #   end
  # end
  
end
