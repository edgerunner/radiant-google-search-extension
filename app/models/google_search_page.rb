class GoogleSearchPage < Page
  attr_reader :query, :start, :gsearch
  
  description 'A page to display search results obtained through the Google API'
  
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
  
  desc 'Sets the context for each result in the set'
  tag 'gsearch:results:each' do |tag|
    output = ""
    gsearch.response_data.results.each do |result|
      tag.locals.result = result
      output << result.title + ' - '
    end
    output
  end
  
  [:title_no_formatting, :content, :visible_url, :url, :title, :gsearch_result_class, :unescaped_url,:cache_url].each do |sym|
    desc "Renders the #{sym.to_s.humanize} of the current result"
    tag "gsearch:results:each:#{sym.to_s}" do |tag|
      tag.locals.result.send sym
    end
  end
  
  def process(request,response)
    if @query = request.parameters['q']
      @start = request.parameters['start'] || '0'
      @gsearch = GoogleSearch.new @query, @start
      puts "Found #{@gsearch.response_data.results.count} results for #{@query}"
    end
    super
    puts 'Processing complete'
  end
  
  def cache?
    false
  end
  
end

