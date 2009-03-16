class GoogleSearchExtension < Radiant::Extension
  version "0.1"
  description "Get search results from the Google AJAX/REST search API to display in your Radiant pages"
  url "http://github.com/edgerunner/radiant-google-search-extension"
  
  def activate
    Page.send :include, GoogleSearchTags
  end
  
  def deactivate
  end
  
end
