module GoogleSearchTags
  include Radiant::Taggable
  include ActionView::Helpers::FormTagHelper
  
  desc 'The namespace for all Google search tags'
  tag 'gsearch' do |tag|
    tag.expand
  end
  
  desc 'Renders a search form. Targets the first Google Search page in the database by default or the given @url@ attribute.'
  tag 'gsearch:form' do |tag|
    form_url = tag.attr.delete('url') || GoogleSearchPage.first.url
    submit_label = tag.attr.delete('submit') || 'Search' 
    form_attrs = tag.attr.to_a.map{|a| "#{a[0]}=\"#{a[1]}\"" }.join(' ')
    %Q{
      <form action="#{form_url}" method="get" #{form_attrs}>
        <input type="text" name="q" />
        <input type="submit" value="#{submit_label}" />
      </form>
    }
  end
end