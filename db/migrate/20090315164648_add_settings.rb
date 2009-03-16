class AddSettings < ActiveRecord::Migration
  def self.up
    Radiant::Config.create :key => 'google_search.api_key', :description => "Required. Your Google search API key"
    Radiant::Config.create :key => 'google_search.custom_search_id', :description => "Optional. The Google Custom Search Engine ID if you want to use one"
  end

  def self.down
    Radiant::Config.find_by_key('google_search.api_key').destroy
    Radiant::Config.find_by_key('google_search.custom_search_id').destroy
  end
end
