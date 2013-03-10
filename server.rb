require 'rubygems'
require 'sinatra'
require 'uri'

$music_dir = '/media/truecrypt1/Fraunhofer Society'

get '/' do
	dirs = Dir.glob File.join($music_dir, '*')
	dirs = dirs.collect{|a| File.basename(a)}.sort
	erb :index, :locals => {:dirs => dirs}
end

get '/play/:dir' do
	dir = params[:dir]
	dir_to_play = File.join $music_dir, dir
	`mocp -s`
	`mocp -c`
	`mocp -a "#{dir_to_play}"`
	`mocp -p`
	safe_dir = URI.escape dir
	redirect to("/\##{safe_dir}")
end

get '/volume_plus' do
	`mocp -v +5`
	redirect to('/')
end

get '/volume_minus' do
	`mocp -v -5`
	redirect to('/')
end