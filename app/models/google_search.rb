class GoogleSearch < ActiveResource::Base
  self.site = "http://ajax.googleapis.com/ajax/services/search/web"
  self.format = ActiveResource::Formats[:json]
  attr_reader :query, :start, :response_data, :response_status, :response_details
  
  def initialize(q,s=0)
    @query, @start = q, s
    query_string_hash = {
      :v => "1.0",
      :q => query,
      :key => Radiant::Config['google_search.api_key'],
      :cx => Radiant::Config['google_search.custom_search_id'],
      :rsz => 'large',
      :start => start.to_s
    }
    
    query_string_hash.delete(:cx) if query_string_hash[:cx].blank?
    query_string_hash.delete(:key) if query_string_hash[:key].blank?
    
    u = query_string_hash.map{|k,v| "#{k}=#{v}" }.join('&')
    u = 'http://ajax.googleapis.com/ajax/services/search/web?' + u
    u = URI.escape u
    
    objectify connection.get(u, {'Accept-Charset'=>'UTF-8'}), self
  end
  
  private
  
  def objectify(h, base)

    h.each do |k,v|
      k = k.underscore.to_sym
      base.instance_variable_set "@#{k}", objectify_element(v)  
      base.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
    end
    base
  end
  
  def objectify_element(v)
    if v.is_a? Hash
      objectify(v, Class.new.new)
    elsif v.is_a? Array
      v.map { |a| objectify_element(a) }
    elsif v.is_a? String
      v.gsub(/\\u..../){|u| [u[-4..-1].to_i(16)].pack('U') }
    else
      v  
    end
  end
end
