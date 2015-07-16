class PagesController < ApplicationController
	#skip_before_filter  :verify_authenticity_token, only: :result
	
	def index
	end

	def result
		require 'fileutils'
		require "net/https"
		require "uri"
		require "json"
		require "rest-client"

		location = params[:location]

		unless File.directory?(location)
			FileUtils.mkdir_p(location)
		end

		unless params[:organizations].blank? 
			@orgs = "&organizations=#{params[:organizations]}"
		else 
			@orgs = ""
		end

		unless params[:projects].blank? 
			@projects = "&projects=#{params[:projects]}"
		else
			@projects = ""
		end

		unless params[:users].blank? 
			@users = "&users=#{params[:users]}"
		else
			@users = ""
		end

		unless params[:offset].blank?
			@offset = "&offset=#{params[:offset]}"
		else
			@offset = ""
		end

		uri = URI.parse("https://api.hubstaff.com/v1/screenshots?start_time=#{params[:starttime]}&stop_time=#{params[:stoptime]}#{@orgs}#{@projects}#{@users}#{@offset}") 

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		request = Net::HTTP::Get.new(uri.request_uri)
		request.initialize_http_header({"App-Token" => params[:apptoken], "Auth-Token" => params[:authtoken]})

		response = http.request(request)
		@screens = JSON.parse(response.body)['screenshots']

		unless @screens == nil
			@screens.each do |screen|
			  File.open("#{location}/#{screen["id"]}.jpg", "wb") do |file|
			    file.write RestClient.get(screen['url'])
			  end
			end
		end
	end
end