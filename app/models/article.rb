class Article
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :nullable => false
  property :title, String, :nullable => false
  property :body, Text, :nullable => false
  property :user_id, Integer, :nullable => false
  property :created_at, Datetime, :nullable => false
  property :updated_at, Datetime, :nullable => false
  property :deleted, Boolean, :nullable => false

end
