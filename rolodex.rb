require "sinatra"
require "sinatra/content_for"
require "sinatra/reloader"
require "tilt/erubis"

require_relative "database_persistence"

configure do
  also_reload "database_persistence.rb"
  set :erb, escape_html: true
end

configure :development do
  set :static_cache_control, [:no_cache, :no_store, :must_revalidate]
end

before do
  @storage = DatabasePersistence.new(logger)
end

after do
end

helpers do
  
end

get "/" do
  @contact_table = @storage.contact_table

  erb :home
end

get "/create" do

end

post "/create/:id" do

end

get "/edit/:id" do
  @id = params[:id].to_i
  @contact_details = @storage.contact_details(@id).first
  @categories = @storage.categories

  erb :edit
end

post "/edit/:id" do
  name = params[:name]
  phone_number = params[:phone_number]
  email = params[:email]
  category_id = params[:category_id]
  id = params[:id]

  update_contact(name, phone_number, email, category_id, id)

  redirect '/'
end

post "delete/:id" do

end