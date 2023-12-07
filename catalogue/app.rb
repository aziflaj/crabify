require "sinatra"

set :bind, "0.0.0.0"
set :public_folder, 'assets'
set :views, 'templates'

get "/" do
  erb :index, layout: :layout
end

not_found do
  erb :not_found, layout: :layout
end
