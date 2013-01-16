class SearchesController < ApplicationController
  # GET /searches
  # GET /searches.json

  TERAPEAK_KEY = [put your terapeak api key here]
  EBAY_DEVID = [put your ebay developer id here]
  EBAY_APPID = [put your ebay app id here]
  EBAY_CERTID = [put your ebay cert id here]

  def prices
    search_id = session[:search_id]
    @searchedItem = Search.find_by_id(search_id)
    headline = Search.find_by_id(search_id).title
    @picture = Search.find_by_id(search_id).pictureUrl
    @keywords = Search.find_by_id(search_id).keyword
    @refId = Search.find_by_id(search_id).selectedRefID
    @upc = Search.find_by_id(search_id).selectedUPC
    @isbn = Search.find_by_id(search_id).selectedISBN
    @zip = Search.find_by_id(search_id).zipcode
    @distance = Search.find_by_id(search_id).distance

    # Execute former price search at Terapeak with UPC or keyword
      if @upc.blank?
        @searchterm = @keywords
      else
        @searchterm = @upc
      end
      @searchterm = @searchterm.to_s.tr('^A-Za-z0-9 ','')
      puts @searchterm

      api_key = TERAPEAK_KEY

      # Find new item prices
        @cond = 1
        results = Ebay::TeraPeak.new(api_key, @cond)
        @new_avg_price = results.average_price(@searchterm).to_i
        @new_max_price = results.max_price(@searchterm).to_i
        @new_min_price = results.min_price(@searchterm).to_i
        @new_median_price = results.median_price(@searchterm).to_i

      # Find used item prices
        @cond = 3
        results = Ebay::TeraPeak.new(api_key, @cond)
        @used_avg_price = results.average_price(@searchterm).to_i
        @used_max_price = results.max_price(@searchterm).to_i
        @used_min_price = results.min_price(@searchterm).to_i
        @used_median_price = results.median_price(@searchterm).to_i
    
    #Find current ebay new and used prices
      available = Ebay::FindProducts.new(EBAY_APPID)
      @info_array = available.item_array(@refId, @zip, @distance)
  end

  def index
    @searches = Search.last(10).reverse
    @search = Search.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @searches }
    end
  end

  def results
    keywords = session[:keyword].to_s
    @search_id = session[:search_id]

    item = Ebay::ListingInfo.new(EBAY_APPID)
    @info_array = item.item_array(keywords)
  end


  # GET /searches/1
  # GET /searches/1.json
  def show
    @search = Search.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @search }
    end
  end

  # GET /searches/new
  # GET /searches/new.json
  def new
    @search = Search.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @search }
    end
  end

  # GET /searches/1/edit
  def edit
    @search = Search.find(params[:id])
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new(params[:search])
    session[:keyword] = params[:search][:keyword]

    respond_to do |format|
      if @search.save
        session[:search_id] = Search.last.id
        format.html { redirect_to results_path, notice: 'Search was successfully created.' }
        format.json { render json: @search, status: :created, location: @search }
      else
        format.html { render action: "new" }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /searches/1
  # PUT /searches/1.json
  def update
    @search = Search.find(params[:id])
    @search.selectedRefID = params[:selectedRefID]
    @search.selectedUPC = params[:selectedUPC]
    @search.selectedISBN = params[:selectedISBN]
    @search.pictureUrl = params[:pictureUrl]
    @search.title = params[:title]

    respond_to do |format|
      if @search.update_attributes(params[:search])
        session[:search_id] = params[:id]
        format.html { redirect_to price_list_path, notice: 'Search was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "results" }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search = Search.find(params[:id])
    @search.destroy

    respond_to do |format|
      format.html { redirect_to searches_url }
      format.json { head :no_content }
    end
  end
end
