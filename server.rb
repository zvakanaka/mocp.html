require 'rubygems'
require 'sinatra'

$music_dir = '/media/truecrypt1/Fraunhofer Society'

get '/' do
	artists_fullpaths = Dir.glob File.join($music_dir, '*')
	artists = artists_fullpaths.collect{|a| File.basename(a)}.sort
	erb :index, :locals => {:artists => artists}
end

get '/play/:dir' do
	dir_to_play = File.join $music_dir, params[:dir]
	`mocp -s`
	`mocp -c`
	`mocp -a "#{dir_to_play}"`
	`mocp -p`
	redirect to('/')
end