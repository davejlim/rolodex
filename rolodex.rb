require "sinatra"
require "sinatra/content_for"
require "sinatra/reloader"
require "tilt/erubis"

require_relative "database_persistence"

configure do
  also_reload "database_persistence.rb"
  set :erb, escape_html: true
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
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
  def format_phone(phone_number)
    if phone_number.size == 10
      phone_digits = phone_number.to_i.digits.reverse
      "(#{phone_digits[0..2].join('')})#{phone_digits[3..5].join('')}-#{phone_digits[6..10].join('')}"
    end
  end
end

def error_for_contact(phone_number)
  if phone_number.size != 10
    "Phone number must be 10 digits."
  end
end

get "/" do
  @contact_table = @storage.contact_table

  erb :home
end

get "/create" do
  @id = params[:id].to_i
  @categories = @storage.categories

  erb :create
end

post "/create" do
  name = params[:name]
  phone_number = params[:phone_number]
  email = params[:email]
  category_id = params[:category_id]
  @id = params[:id].to_i
  @categories = @storage.categories

  error = error_for_contact(phone_number)
  if error
    session[:message] = error
    erb :create
  else
    @storage.create_contact(name, phone_number, email, category_id)
    session[:message] = "Contact created successfully."
    redirect '/'
  end
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
  @id = params[:id]
  @contact_details = @storage.contact_details(@id).first
  @categories = @storage.categories

  error = error_for_contact(phone_number)
  if error
    session[:message] = error
    erb :edit
  else
    @storage.update_contact(name, phone_number, email, category_id, @id)
    session[:message] = "Contact edited successfully."
    redirect '/'
  end
end

post "/delete/:id" do
  id = params[:id]

  @storage.delete_contact(id)

  session[:message] = "Contact deleted successfully."
  redirect '/'
end
