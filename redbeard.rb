require 'active_support/core_ext'
require 'sinatra'
require 'sinatra/reloader'
require 'tvdbr'
require 'data_mapper'
require 'open-uri'

DataMapper::setup(:default, 'mysql://redbeard:redbeard@localhost/redbeard')
set :bind, '0.0.0.0'

class Show
  include DataMapper::Resource
  property :id, Serial
  property :tvdb_id, Integer, :required => true
  property :title, Text
  property :started, DateTime
  property :added, DateTime
  property :updated, DateTime
  property :episodes, Text
  property :episodes_have, Text
  property :genres, Text
end

DataMapper.finalize.auto_upgrade!

get '/' do
  @shows = Show.all :order => :id.desc
  @title = 'All Shows'
  erb :home
end

post '/' do
  s = Show.new
  tvdb = Tvdbr::Client.new('0BEE2B133E44344D')
  @name = params[:show]
  @series = tvdb.find_series_by_title(@name)
  if @series.nil?
    @error = "A show was not found with the name: \"#{@name}\""
    erb :error
  else
    @show_name = @series.title
    @show_year= @series.first_aired.year
    @show_poster = @series.poster

    s.title = @show_name
    s.started = @series.first_aired
    s.added = DateTime.now
    s.updated = DateTime.now
    s.tvdb_id = @series.id
    s.save

    redirect '/'
    end
end

get '/:show_id/detail' do
  @show = Show.first(:id => params[:show_id])
  erb :detail
end

get '/:id/delete' do
  @show = Show.get params[:id]
  @show_name = @show.title
  @title = "Confirm delete of \"#{@show_name}\""
  erb :delete
end

get '/:show_id/edit' do
  @show = Show.first(:id => params[:show_id])
  @show_name = @show.title
  @title = "Edit - \"#{@show_name}\""
  erb :edit
end

delete '/:id' do
  s = Show.get params[:id]
  s.destroy
  redirect '/'
end

=begin
Episode features:
TODO Get a list of shows for the current season
TODO Get a list of shows names for each show
TODO Get a list/total of episodes for a show
=end


def truncate(string, len)
  if string.length > len
    return string[0..len] << '&hellip;'
  else
    return string
  end
end