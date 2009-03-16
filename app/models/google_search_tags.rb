class GoogleSearchPage < Page
  description 'A page to display search results obtained through the Google API'
  
  
  
  
end

module GoogleSearchCommonTags
  include Radiant::Taggable
  extend Page
  
  desc 'The namespace for all Google search tags'
  tag 'google-search' do |tag|
    tag.expand
  end
end