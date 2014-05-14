class GlnsController < ApplicationController
  # GET /glns
  # GET /glns.json
  def index
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: GlnsDatatable.new(view_context)}
    end
  end

  # GET /glns/1
  # GET /glns/1.json
  def show
    @gln = Gln.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gln }
    end
  end

  # GET /glns/new
  # GET /glns/new.json
  def new

    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    @gln = @empresa.gln.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gln }
    end
  end

  # GET /glns/1/edit
  def edit
    @empresa = Empresa.find(:first, :conditions => ["prefijo = ?", params[:empresa_id]])
    @gln = Gln.find(params[:id])
  end

  # POST /glns
  # POST /glns.json
  def create
    @gln = Gln.new(params[:gln])

    respond_to do |format|
      if @gln.save
        format.html { redirect_to @gln, notice: 'Gln was successfully created.' }
        format.json { render json: @gln, status: :created, location: @gln }
      else
        format.html { render action: "new" }
        format.json { render json: @gln.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /glns/1
  # PUT /glns/1.json
  def update

    @gln = Gln.find(params[:id])
    respond_to do |format|
      if @gln.update_attributes(params[:gln])
        format.html { redirect_to empresa_glns_path, notice: "EL GLN fue modificado correctamente." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gln.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /glns/1
  # DELETE /glns/1.json
  def destroy
    @gln = Gln.find(params[:id])
    @gln.destroy

    respond_to do |format|
      format.html { redirect_to glns_url }
      format.json { head :no_content }
    end
  end
end
