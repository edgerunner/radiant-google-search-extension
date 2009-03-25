module GoogleSearchTags
  include Radiant::Taggable
  
  desc 'The namespace for all Google search tags'
  tag 'gsearch' do |tag|
    tag.expand
  end
  
  desc 'Renders a search form. Targets the first Google Search page in the database by default or the given @url@ attribute. Use the @submit@ attribute to specify the text on the submit button. All other attributes are passed to the form tag. The contents of the tag are entered in the search box.'
  tag 'gsearch:form' do |tag|
    form_url = tag.attr.delete('url') || GoogleSearchPage.first.url
    submit_label = tag.attr.delete('submit') || 'Search' 
    form_attrs = tag.attr.to_a.map{|a| "#{a[0]}=\"#{a[1]}\"" }.join(' ')
    %Q{
      <form action="#{form_url}" method="get" #{form_attrs}>
        <input type="text" name="q" value="#{tag.expand}"/>
        <input type="submit" value="#{submit_label}" />
      </form>
    }
  end
end