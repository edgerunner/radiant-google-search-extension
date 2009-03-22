require File.dirname(__FILE__) + '/../spec_helper'

describe GoogleSearch do
  describe "with the query 'google'" do
    subject do
      GoogleSearch.new('google').response_data
    end
    
    it do 
      should have(8).results
    end
    it do
      subject.results.first.should respond_to(:title, :url)
    end
  end
  
  describe "with the query 'hsdnjklhopewrngbepvdshrb'" do
    subject do
      GoogleSearch.new('hsdnjklhopewrngbepvdshrb').response_data
    end
    
    it do
      should have(0).results
    end
  end
  
  describe "with dummy JSON respopnse" do
    subject do
      dummy_json = %|
        { 
          'TextKey'  : 'text',  
          'ArrayKey' : [
            'text in array',
            { 'TextKey'  : 'text in hash in array' },
            [ 'text in array in array', 'text in array in array' ]
          ],
          'HashKey' : {
            'TextKey' : 'text in hash',
            'ArrayKey': [ 'text in array in hash', 'text in array in hash' ],
            { 'TextKey'  : 'text in hash in hash' }
          }
        }
      |
      
      ActiveResource::HttpMock.respond_to do |mock|
        mock.get '/ajax/services/search/web', {}, dummy_json, 200
      end
      GoogleSearch.new('whatever')
    end
    
    it do
      should respond_to :text_key, :array_key, :hash_key
    end 
  end
end