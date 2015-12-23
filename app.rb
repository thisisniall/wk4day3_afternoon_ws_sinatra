require "sinatra"
require "sinatra/activerecord"

require "./models.rb"
set :database, "sqlite3:myblogdb.sqlite3"

enable :sessions

get '/' do 
	if session[:user_id]
		# since we're going to eventually add more pages, it's better to add a helper method
		# @user = User.find(session[:user_id])
		@user = current_user
		erb :index
	else
		redirect 'sign_in'
	end
end

get '/sign_in' do
	erb :sign_in
end

post '/sign_in' do
	#checking inputs
	puts params
	puts params[:password] 
	# getting the user for the next check
	@user = User.where(username: params[:username]).first
	# ensures user.password matches the user
	if @user && @user.password == params[:password] 
		#starts a session, redirects to homepage
		session[:user_id] = @user.id
		redirect '/'
	else 
		redirect '/doesnotexist'
	end
end

post '/logout' do
	session.clear
	redirect 'sign_in'
end

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end

get '/sign_up' do
	erb :sign_up
end

post '/sign_up' do
	# psuedo:
	#if username in use, deny
	# if password != confirm password, deny
	
	# if password.length < 4, deny
	# else if, create!
	User.create(username: params[:username], password: params[:password], fname: params[:fname], lname: params[:lname], email: params[:email])
	redirect 'sign_in'
end