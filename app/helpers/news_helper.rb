module NewsHelper
  def link_to_news tag
    if request.fullpath == news_index_path(news_tag_id: tag[1])
      link_to tag[0],news_index_path(news_tag_id: tag[1]), {:class => "tab-btn active"}
    else
      link_to tag[0],news_index_path(news_tag_id: tag[1]), {:class => "tab-btn"}
    end
  end
end
