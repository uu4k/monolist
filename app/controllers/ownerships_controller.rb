class OwnershipsController < ApplicationController
  before_action :logged_in_user

  def create
    if params[:asin]
      @item = Item.find_or_initialize_by(asin: params[:asin])
    else
      @item = Item.find(params[:item_id])
    end

    # itemsテーブルに存在しない場合はAmazonのデータを登録する。
    if @item.new_record?
      begin
        response = Amazon::Ecs.item_lookup(@item.asin,response_group:'Medium', country:'jp')
      rescue Amazon::RequestError => e
        return render :js => "alert('#{e.message}')"
      end

      @item = amazonEcsItemToItem(response.items.first)
      @item.save!
    end

    case params[:type]
    when "Want" then
      current_user.want(@item)
    when "Have" then
      current_user.have(@item)
    end

  end

  def destroy
    if params[:asin]
      @item = Item.find_or_initialize_by(asin: params[:asin])
    else
      @item = Item.find(params[:item_id])
    end

    case params[:type]
    when "Want" then
      current_user.unwant(@item)
    when "Have" then
      current_user.unhave(@item)
    end
  end
end
