class PicturesController < ApplicationController
  
  # GET /bikes
  # GET /bikes.json

  #before_render :global_item, :except => [:destroy, :index]

  def index
    # @model = Model.find(params[:model_id])
    # @bikes = Bike.where(:model_id => params[:model_id])
    # binding.pry

    # @bike = Bike.find(params[:bike_id])
    # @pictures = Picture.where(:picturable_id => params[:bike_id])

    # match = request.url.scan(/bikes|brands/)[0]
    # _class = match.singularize.capitalize.constantize

    @pictures = Bike.find(params[:bike_id].to_i).pictures
    # @pictures.each do |picture|
    #  picture["photo_url"] = picture.photo.url 
    # end

    respond_to do |format|
      format.json { render json: @pictures }
    end
  end

  # GET /bikes/1
  # GET /bikes/1.json
  # def show
  #   @bike = Bike.find(params[:id])

  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @bike }
  #   end
  # end

  # GET /bikes/new
  # GET /bikes/new.json
  # def new
  #   @bike = Bike.new
  #   @model = Model.find(params[:model_id])
  #   @bike.model_id = @model.id
  #   @bike.brand_id = @model.brand.id
  #   @models = @model.brand.models.alphabetically

  #   respond_to do |format|
  #     format.html { render "forms/new_edit"}
  #     format.json { render json: @bike }
  #   end
  # end

  # GET /bikes/1/edit
  # def edit
  #   @bike = Bike.find(params[:id])

  #   respond_to do |format|
  #     format.html { render "forms/new_edit"}
  #     format.json { render json: @bike }
  #   end
    
  # end

  # POST /bikes
  # POST /bikes.json
  # def create
  #   @bike = Bike.new(params[:bike])
  #   @model = Model.find(params[:model_id])

  #   # if equipment_name is not setted the for example equal then model name
  #   if @bike.valid? && (@bike.equipment_name == "" || @bike.equipment_name == nil)
  #     @bike.equipment_name = @bike.model.name
  #   end

  #   respond_to do |format|
  #     if @bike.save
  #       format.html { redirect_to @bike, flash: {success: _('Moto creata con successo!')} }
  #       format.json { render json: @bike, status: :created, location: @bike }
  #     else
  #       format.html { render "forms/new_edit" }
  #       format.json { render json: @bike.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PUT /bikes/1
  # PUT /bikes/1.json
  # def update
  #   @bike = Bike.find(params[:id])

  #   respond_to do |format|
  #     if @bike.update_attributes(params[:bike])
  #       format.html { redirect_to @bike, flash: {success: _('Moto modificata con successo!')} }
  #       format.json { head :no_content }
  #     else
  #       format.html { render "forms/new_edit" }
  #       format.json { render json: @bike.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /bikes/1
  # DELETE /bikes/1.json
  # def destroy
  #   @bike = Bike.find(params[:id])
  #   model = @bike.model
  #   brand = @bike.brand

  #   @bike.destroy

  #   if model.bikes.size == 0
  #     # if there aren't any bikes for
  #     # that model, destroy it!
  #     model.destroy
  #     model = nil
  #   end

  #   respond_to do |format|
  #     if model
  #       # redirect to show model which show the
  #       # list of bikes for this model
  #       format.html { redirect_to model, flash: {success: _('Moto cancellata con successo!')} }
  #     else
  #       # no longer the model -> redirect to brand
  #       format.html { redirect_to brand, flash: {success: _('Moto cancellata con successo!')} }
  #     end
  #     format.json { head :no_content }
  #   end
  # end

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
