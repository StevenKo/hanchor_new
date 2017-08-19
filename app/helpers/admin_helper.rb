module AdminHelper
  def link_to_menu path,text
    if request.fullpath == path
      link_to "<h2>#{text}</h2>".html_safe,path, {:class => "layer-1 menu-line active"}
    else
      link_to "<h2>#{text}</h2>".html_safe,path, {:class => "layer-1 menu-line"}
    end
  end
end
