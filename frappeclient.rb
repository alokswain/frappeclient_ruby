require 'httparty'
include HTTParty

class FrappeClient

	attr_accessor :url, :session_cookie

	def initialize(url, username, password)
		self.url = url
		login(username, password)
	end

	def login(username, password)
		method = "api/method/login"
		login_url = File.join(self.url, method)
		response = HTTParty.post(login_url, :body => {usr: username, pwd: password})
		self.session_cookie = "sid=#{parse_set_cookie(response.headers["set-cookie"])["sid"]}"
	end

	def get_all_doc_types
		# method = 
	end

	def get_authenticated_user
		method = "api/method/frappe.auth.get_logged_user"
		login_url = File.join(self.url, method)
		response = HTTParty.get(login_url, :headers => {"Cookie" => self.session_cookie, "Content-Type" => "application/json"})
		return response.parsed_response
	end

	def parse_set_cookie(all_cookies_string)
		cookies = Hash.new

		if all_cookies_string.length > 0
			all_cookies_string.split(',').each {|single_cookie_string|
				cookie_part_string  = single_cookie_string.strip.split(';')[0]
				cookie_part         = cookie_part_string.strip.split('=')
				key                 = cookie_part[0]
				value               = cookie_part[1]

				cookies[key] = value
			}
		end

		cookies
	end
end