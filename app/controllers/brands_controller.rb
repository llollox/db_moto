class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]

  # GET /brands
  # GET /brands.json
  def index
    @brands, @alphaParams = Brand.all.alpha_paginate(params[:letter], {:js => true, :bootstrap3 => true}){|brand| brand.name}

    # @brands.each do |brand|
    #  brand["logo_url"] = brand.logo.url if brand.logo
    # end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @brands }
    end
  end

  # GET /brands/1
  # GET /brands/1.json
  def show
    @models = @brand.models.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /brands/new
  def new
    @brand = Brand.new

    respond_to do |format|
      format.html { render "forms/new_edit", :locals => {:object => @brand} }
      format.json { render json: @brand }
    end
  end

  # GET /brands/1/edit
  def edit
    respond_to do |format|
      format.html { render "forms/new_edit", :locals => {:object => @brand}}
      format.json { render json: @brand }
    end
  end

  # POST /brands
  # POST /brands.json
  def create
    @brand = Brand.new(brand_params)

    respond_to do |format|
      if @brand.save
        format.html { redirect_to @brand, notice: 'Brand was successfully created.' }
        format.json { render :show, status: :created, location: @brand }
      else
        format.html { render "forms/new_edit", :locals => {:object => @brand} }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /brands/1
  # PATCH/PUT /brands/1.json
  def update
    respond_to do |format|
      if @brand.update(brand_params)
        format.html { redirect_to @brand, notice: 'Brand was successfully updated.' }
        format.json { render :show, status: :ok, location: @brand }
      else
        format.html { render "forms/new_edit", :locals => {:object => @brand} }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.json
  def destroy
    @brand.destroy
    respond_to do |format|
      format.html { redirect_to brands_url, notice: 'Brand was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brand
      @brand = Brand.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brand_params
      params.require(:brand).permit(
        :logo,
        :logo_url, 
        :name)
    end
end
