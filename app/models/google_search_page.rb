class GoogleSearchPage < Page
  description 'A page to display search results obtained through the Google API'
  
  desc 'Renders its contents when there is no search executed yet'
  tag 'google-search:clean' do |tag|
    tag.expand if @query.blank?
  end
  
  desc 'Renders the error message when there is one'
  tag 'google-search:error' do |tag|
    unless @gsearch.response_status == 200
      "#{@gsearch.response_status}: #{@gsearch.response_details}"
    end
  end
  
  desc 'Renders its contents when there are no results'
  tag 'google-search:no-results' do |tag|
    tag.expand if @gsearch.response_data.cursor.estimated_result_count.to_i.zero?
  end
  
  desc 'Renders its contents when there are results'
  tag 'google-search:results' do |tag|
    tag.expand if @gsearch.response_data.cursor.estimated_result_count.to_i > 0
  end
  
  desc 'Sets the context for each result in the set'
  tag 'google-search:results:each' do |tag|
    @gsearch.response_data.results.each do |result|
      tag.locals.result = result
      output << tag.expand
    end
    output
  end
  
  [:title_no_formatting, :content, :visible_url, :url, :title, :gsearch_result_class, :unescaped_url,:cache_url].each do |sym|
    desc "Renders the #{sym.to_s.humanize} of the current result"
    tag "google-search:results:each:#{sym.to_s}" do |tag|
      tag.locals.result.send sym
    end
  end
  
  def process(request,response)
    @query = request.params['q']
    @start = request.params['start'] || '0'
    @gsearch = GoogleSearch.new @query, @start
    super
  end
  
end

