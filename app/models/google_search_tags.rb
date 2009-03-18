module GoogleSearchTags
  include Radiant::Taggable
  
  desc 'The namespace for all Google search tags'
  tag 'gsearch' do |tag|
    tag.expand
  end
  
  #TODO: Implement search form tag
end