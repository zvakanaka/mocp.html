require 'rubygems'
require 'sinatra'
require 'uri'

set :bind, '0.0.0.0'

$music_dir = '/home/pi/Music/'

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

get '/pause' do
	`mocp -G`
	redirect to('/')
end

post '/upload' do
  
  @filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open($music_dir+"#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
  redirect to('/')
end
