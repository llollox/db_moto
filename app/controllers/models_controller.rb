class ModelsController < ApplicationController
  before_action :set_model, only: [:show, :edit, :update, :destroy]
  # before_render :global_item, :except => [:destroy, :index]
  
  # GET /models
  # GET /models.json
  def index
    @brand = Brand.find(params[:brand_id])
    @models = @brand.models


    respond_to do |format|
      format.html {redirect_to @brand}
      format.json { render json: @models }
    end
  end

  # GET /models/1
  # GET /models/1.json
  def show
    @brand = @model.brand

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @model }
    end
  end

  # GET /models/new
  # GET /models/new.json
  def new
    @model = Model.new
    brand = Brand.find(params[:brand_id].to_i)
    @model.brand_id = brand.id

    respond_to do |format|
      format.html { render "forms/new_edit", :locals => {:object => [brand, @model]}}
      format.json { render json: @model }
    end
  end

  # GET /models/1/edit
  def edit
    respond_to do |format|
      format.html { render "forms/new_edit", :locals => {:object => @model}}
      format.json { render json: @model }
    end
  end

  # POST /models
  # POST /models.json
  def create
    @model = Model.new(model_params)

    respond_to do |format|
      if @model.save
        format.html { redirect_to @model.brand, flash: {success:_("Modello creato con successo!")} }
        format.json { render json: @model, status: :created, location: @model }
      else
        format.html { render "forms/new_edit" }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /models/1
  # PUT /models/1.json
  def update

    respond_to do |format|
      if @model.update(model_params)
        format.html { redirect_to @model, flash: {success:_("Modello modificato con successo!")} }
        format.json { head :no_content }
      else
        format.html { render "forms/new_edit" }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /models/1
  # DELETE /models/1.json
  def destroy
    @model = Model.find(params[:id])
    @brand = @model.brand
    @model.destroy

    respond_to do |format|
      format.html { redirect_to @brand, flash: {success:_("Modello cancellato con successo!")} }
      format.json { head :no_content }
    end
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_model
    @model = Model.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def model_params
    params.require(:model).permit(
      :brand_id,
      :name)
  end

  # def filtered
  #   @models = Model.where(:brand_id => params[:brand_id].to_i)
  #   respond_to do |format|
  #     format.html { render 'filtered', :layout => false }
  #   end
  # end

  # private

  # def global_item
  #   @object = @model

  #   if action_name == "new" || action_name == "create"
  #     @object_with_path = [@brand, @model]
  #   else
  #     @object_with_path = @model
  #   end
  # end
  
end
