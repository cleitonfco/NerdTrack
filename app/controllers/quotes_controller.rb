class QuotesController < ApplicationController
  layout "geral"
  
  #Block other pages for now
  before_filter :authorize, :only => [:index, :show, :destroy]
  
  # GET /quotes
  # GET /quotes.xml
  def index
    @quotes = Quote.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quotes }
    end
  end

  # GET /quotes/1
  # GET /quotes/1.xml
  def show
    @quote = Quote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quote }
    end
  end

  # GET /quotes/new
  # GET /quotes/new.xml
  def new
    @quote = Quote.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @quote }
    end
  end

  # GET /quotes/1/edit
  def edit
    @quote = Quote.find(params[:id])
    
    if current_user.nil? || current_user.id != @quote.user.id
      render_unauth
    end
  end

  # POST /quotes
  # POST /quotes.xml
  def create
    @quote = Quote.new(params[:quote])

    @quote.user_id = current_user.id

    respond_to do |format|
      if @quote.save
        flash[:notice] = 'Frase adicionada com sucesso!'
        format.html { redirect_to :controller => "episodios", :action => 'show', :id => @quote.episodio.to_param }
        format.xml  { render :xml => @quote, :status => :created, :location => @quote }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @quote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /quotes/1
  # PUT /quotes/1.xml
  def update
    @quote = Quote.find(params[:id])
    
    if current_user.nil? || current_user.id != @quote.user.id
      render_unauth
    end

    respond_to do |format|
      if @quote.update_attributes(params[:quote])
        flash[:notice] = 'Quote was successfully updated.'
        format.html { redirect_to :controller => "episodios", :action => 'show', :id => @quote.episodio.to_param }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.xml
  def destroy
    @quote = Quote.find(params[:id])
    @quote.destroy

    respond_to do |format|
      format.html { redirect_to(quotes_url) }
      format.xml  { head :ok }
    end
  end
end
