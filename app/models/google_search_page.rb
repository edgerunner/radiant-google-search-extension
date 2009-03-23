class GoogleSearchPage < Page
  
  description 'A page to display search results obtained through the Google API'
  
  desc 'Renders the passed query string'
  tag 'gsearch:query' do |tag|
    query
  end
  
  desc 'Renders its contents when there is no search executed yet'
  tag 'gsearch:clean' do |tag|
    tag.expand if query.blank?
  end
  
  desc 'Renders the error message when there is one'
  tag 'gsearch:error' do |tag|
    unless gsearch.response_status == 200
      "#{gsearch.response_status}: #{gsearch.response_details}"
    end
  end
  
  desc 'Renders its contents when there are no results'
  tag 'gsearch:no-results' do |tag|
    tag.expand unless query and gsearch.response_data.results.count.zero?
  end
  
  desc 'Renders its contents when there are results'
  tag 'gsearch:results' do |tag|
    tag.expand if gsearch and gsearch.response_data.results.count > 0
  end
  
  desc 'Renders the estimated result count'
  tag 'gsearch:results:count' do |tag|
    gsearch.response_data.cursor.estimated_result_count
  end
  
  desc 'Sets the context for each result in the set'
  tag 'gsearch:results:each' do |tag|
    output = ""
    gsearch.response_data.results.each do |result|
      tag.locals.result = result
      output << tag.expand
    end
    output
  end
  
  %w[title_no_formatting content visible_url url title unescaped_url cache_url].each do |sym|
    desc "Renders the <strong>#{sym.humanize}</strong> of the current result"
    tag "gsearch:results:each:#{sym}" do |tag|
      tag.locals.result.send sym
    end
  end
  
  desc 'Sets the context to the current page'
  tag "gsearch:pages:current" do |tag|
    page_index = gsearch.response_data.cursor.current_page_index.to_i
    tag.locals.gpage = gsearch.response_data.cursor.pages[page_index]
    tag.expand
  end
  
  desc 'Sets the context to the first page'
  tag "gsearch:pages:first" do |tag|
    tag.locals.gpage = gsearch.response_data.cursor.pages.first
    tag.expand
  end
  
  desc 'Sets the context to the last page'
  tag "gsearch:pages:last" do |tag|
    tag.locals.gpage = gsearch.response_data.cursor.pages.last
    tag.expand
  end
  
  desc 'Renders its contents when there is only a single page'
  tag "gsearch:one_page" do |tag|
    tag.expand if gsearch.response_data.cursor.pages.count == 1
  end
  
  desc 'Renders its contents when there is more than a single page'
  tag "gsearch:pages" do |tag|
    tag.expand if gsearch.response_data.cursor.pages.count > 1
  end
  
  desc 'Sets the context for each of the pages in the result set'
  tag "gsearch:pages:each" do |tag|
    output = ""
    gsearch.response_data.cursor.pages.each do |page| 
      tag.locals.gpage = page
      output << tag.expand
    end
    output
  end
  
  desc 'Renders the search page number'
  tag "gsearch:pages:title" do |tag|
    tag.locals.gpage.label
  end
  desc 'Renders the search page path'
  tag "gsearch:pages:url" do |tag|
    "#{url}?q=#{CGI.escapeHTML(query)}&amp;start=#{tag.locals.gpage.start}"
  end

  
  def query
    @request.parameters['q']
  end
  def start
    @request.parameters['start'] || 0
  end
  
  def gsearch
    return unless query
    @gsearch ||= GoogleSearch.new query, start
  end
 
  def cache?
    false
  end

end

