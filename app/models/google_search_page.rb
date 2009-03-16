class GoogleSearchPage < Page
  #TODO: Put description
  
  #TODO: Implement search page tags
  
  #TODO: Implement search behavior
end

module GoogleSearchTags
  include Radiant::Taggable
  extend Page
  
  desc 'The namespace for all Google search tags'
  tag 'google-search' do |tag|
    tag.expand
  end
  
  #TODO: Implement search form tag
end