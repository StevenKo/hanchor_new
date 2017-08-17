module ProductsHelper
  def link_to_category path,text,type_num
    if request.fullpath.split("?")[0] == path.split("?")[0]
      link_to text, path, {:class => "type-#{type_num} active"}
    else
      link_to text, path, {:class => "type-#{type_num}"}
    end
  end
end
