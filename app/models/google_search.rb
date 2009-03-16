class GoogleSearch < ActiveResource::Base
  self.site = "http://ajax.googleapis.com/ajax/services/search/web"
  self.format = ActiveResource::Formats[:json]
  
  
  def initialize(q,start='0')
    start ||= '0'
    query_string_hash = {
      :v => "1.0",
      :q => q,
      :key => Radiant::Config['google_search.api_key'],
      :cx => Radiant::Config['google_search.custom_search_id'],
      :rsz => 'large',
      :start => start.to_s
    }
    
    query_string_hash.delete(:cx) if query_string_hash[:cx].empty?
    
    u = query_string_hash.map{|k,v| "#{k}=#{v}" }.join('&')
    u = 'http://ajax.googleapis.com/ajax/services/search/web?' + u
    u = URI.escape u
    
    objectify connection.get(u, {'Accept-Charset'=>'UTF-8'})
  end
  
  private
  
  def objectify(h, base=self)
    h.each do |k,v|
      k = k.underscore.to_sym
      base.instance_variable_set "@#{k}", objectify_element(v)  
      base.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
    end
    base
  end
  
  def objectify_element(v)
    if v.is_a? Hash
      objectify(v, Object.new)
    elsif v.is_a? Array
      v.map { |a| objectify_element(a) }
    else
      v  
    end
  end
end
