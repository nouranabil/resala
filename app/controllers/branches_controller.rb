class BranchesController < ApplicationController
  # caches_action :show, :layout=>true, :expires_in=>CACHE_EXPIRES_IN.call
  # caches_action :index, :layout=>true, :cache_path => :cache_path.to_proc, :expires_in=>CACHE_EXPIRES_IN.call
  
  def show
    @branch = Branch.find params[:id]
    @branch_activity_categories = @branch.activity_categories
    @query = Media.construct_query(:media_type=>'photos',:owner_id=>@branch.id,:owner_type=>'branch',:page=>1)
    
    respond_to do |format|
      format.html{ redirect_to branches_path(:branch_id=>@branch.id) }
      format.js { render :status => :ok }
    end
  end
  
  def index
    # if params[:city_id]
    #   @city_branches = City.find(params[:city_id]).branches.order("name")
    #   @select_tag_name = "volunteer[branch_id]"
    # else
    @branches = Branch.order("city_id asc")
    @cities = City.order("name asc")
    @city_branches = Branch.branches_list
    # end
    
    unless params[:branch_id].blank?
      @branch = Branch.find(params[:branch_id])
      @branch_activity_categories = @branch.activity_categories
      @query = Media.construct_query(:media_type=>'photos',:owner_id=>@branch.id,:owner_type=>'branch',:page=>1)
    else 
      @branch = Branch.new
    end
    
    respond_to do |format|
      format.html
      format.js { render :status => :ok }
    end
  end
  
  # def cache_path
  #   {:city_id => (params[:city_id] || 0)}
  # end
end