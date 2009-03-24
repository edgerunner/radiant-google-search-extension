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
    if gsearch and (gsearch.response_status != 200)
      "#{gsearch.response_status}: #{gsearch.response_details}"
    end
  end
  
  desc 'Renders its contents when there are no results'
  tag 'gsearch:no_results' do |tag|
    tag.expand if (query and results and results.empty?)
  end
  
  desc 'Renders its contents when there are results'
  tag 'gsearch:results' do |tag|
    tag.expand if results and results.length > 0
  end
  
  desc 'Renders the estimated result count. You may set the @one@ and @many@ attributes to specify the output. use a single # where you want the number to appear'
  tag 'gsearch:results:count' do |tag|
    case cursor.estimated_result_count.to_i
    when 1
      output = tag.attr['one']  || '#'
    else
      output = tag.attr['many'] || '#'
    end
    output.sub '#', cursor.estimated_result_count
  end
  
  desc 'Sets the context for each result in the set'
  tag 'gsearch:results:each' do |tag|
    output = ""
    results.each do |result|
      tag.locals.result = result
      output << tag.expand
    end
    output
  end
  
  %w[title_no_formatting content visible_url title cache_url].each do |sym|
    desc "Renders the *#{sym.humanize}* for the current result"
    tag "gsearch:results:each:#{sym}" do |tag|
      tag.locals.result.send sym
    end
  end 
  
  desc "Renders the *escaped url* for the current result"
  tag "gsearch:results:each:escaped_url" do |tag|
    tag.locals.result.url
  end
  
  desc "Renders the *url* for the current result"
  tag "gsearch:results:each:url" do |tag|
    tag.locals.result.unescaped_url
  end
  
  desc 'Sets the context to the current page'
  tag "gsearch:pages:current" do |tag|
    page_index = cursor.current_page_index.to_i
    tag.locals.gpage = pages[page_index]
    tag.expand
  end
  
  desc 'Sets the context to the next page'
  tag "gsearch:pages:next" do |tag|
    page_index = cursor.current_page_index.to_i + 1
    page_index = pages.length if page_index > pages.length
    tag.locals.gpage = pages[page_index]
    tag.expand
  end
  
  desc 'Sets the context to the previous page'
  tag "gsearch:pages:prev" do |tag|
    page_index = cursor.current_page_index.to_i - 1
    page_index = 0 if page_index < 0
    tag.locals.gpage = pages[page_index]
    tag.expand
  end
  
  desc 'Sets the context to the first page'
  tag "gsearch:pages:first" do |tag|
    tag.locals.gpage = pages.first
    tag.expand
  end
  
  desc 'Sets the context to the last page'
  tag "gsearch:pages:last" do |tag|
    tag.locals.gpage = pages.last
    tag.expand
  end
  
  desc 'Renders its contents when there is only a single page'
  tag "gsearch:one_page" do |tag|
    tag.expand if pages and pages.length == 1
  end
  
  desc 'Renders its contents when there is more than a single page'
  tag "gsearch:pages" do |tag|
    tag.expand if pages and pages.length > 1
  end
  
  desc 'Sets the context for each of the pages in the result set'
  tag "gsearch:pages:each" do |tag|
    output = ""
    pages.each do |page| 
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
  def results
    gsearch.response_data.results
  rescue NoMethodError
    nil
  end
  def cursor
    gsearch.response_data.cursor
  rescue NoMethodError
    nil
  end
  def pages
    gsearch.response_data.cursor.pages
  rescue NoMethodError
    nil
  end
  
  def cache?
    false
  end

end

