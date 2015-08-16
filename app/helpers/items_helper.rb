module ItemsHelper
  def amazonEcsItemToItem(amazon_item)
    item = Item.find_or_initialize_by(asin: amazon_item.get('ASIN'))
    if item.new_record?
      item.title        = amazon_item.get('ItemAttributes/Title')
      item.small_image  = amazon_item.get("SmallImage/URL")
      item.medium_image = amazon_item.get("MediumImage/URL")
      item.large_image  = amazon_item.get("LargeImage/URL")
      item.detail_page_url = amazon_item.get("DetailPageURL")
      item.raw_info        = amazon_item.get_hash
    end
    
    return item
  end
  
  def amazonEcsResponseToItems(response)
    items = []
    response.items.each { |amazon_item|
      items << amazonEcsItemToItem(amazon_item)
    }
    
    return items
  end
end
