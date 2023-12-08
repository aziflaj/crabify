require "sinatra"
require "sinatra/json"
require "cassandra"

set :bind, "0.0.0.0"
set :public_folder, 'assets'
set :views, 'templates'

get "/" do
  erb :index, layout: :layout
end

get "/playtime" do
  json calculate_playtime.to_a.group_by { |row| row["username"] }
end

not_found do
  erb :not_found, layout: :layout
end

def calculate_playtime
  query = <<~CQL
    SELECT username, artist_name, sum(duration) AS total_time
    FROM playtime
    GROUP BY artist_id, username;
  CQL

  cassandra_client.execute(query)
end

def cassandra_client
  @cassandra_client ||=
    Cassandra.
    cluster(hosts: ["cassandra"]).
    connect("crabify_analytics")
end
