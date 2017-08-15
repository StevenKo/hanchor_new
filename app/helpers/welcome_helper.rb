module WelcomeHelper
  def link_to_contact path,text
    if request.fullpath == path
      link_to text, path, {:class => "tab-btn active"}
    else
      link_to text, path, {:class => "tab-btn"}
    end
  end
end
