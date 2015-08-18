class RankingController < ApplicationController
  def index
    @type = params[:type]
    @items = []
    case @type
    when "Want" then
      Want.group(:item_id).order('count_item_id desc').limit(10).count(:item_id).keys.each { |id|
        @items << Item.find(id)
      }
    when "Have" then
      Have.group(:item_id).order('count_item_id desc').limit(10).count(:item_id).keys.each { |id|
        @items << Item.find(id)
      }
    end
  end
end
