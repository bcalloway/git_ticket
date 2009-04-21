require 'fileutils'

# Install JS file
js_path   = '/public/javascripts/gitticket.js'
js_target = File.dirname(__FILE__) + "/../../..#{js_path}"
FileUtils.cp File.dirname(__FILE__) + js_path, js_target unless File.exist?(js_target)

# Install CSS file
css_path   = '/public/stylesheets/gitticket.css'
css_target = File.dirname(__FILE__) + "/../../..#{css_path}"
FileUtils.cp File.dirname(__FILE__) + css_path, css_target unless File.exist?(css_target)

# Install image file
image_path   = '/public/images/feedback.png'
image_target = File.dirname(__FILE__) + "/../../..#{image_path}"
FileUtils.cp File.dirname(__FILE__) + image_path, image_target unless File.exist?(image_target)

#dump sample values into environment.rb

default_values = <<-VALUES

###################################################
#
# GitTicket Configuration
#

#replace with your account name (account login for GitHub)
Ticket::GitTicket.account = "mylogin"		

#replace with your valid Git Token (from the "account" section in GitHub)
Ticket::GitTicket.token   = "8adfbd9f9360350125226ac46c27c6fd"

# replace with the name of your repo
Ticket::GitTicket.project= "myproject"					

# The name of your application to make it feel localized, leave blank if you do not care.
Ticket::GitTicket.site_name = "My Project"	

# If set to false, the gitticket.css file (located in RAILS_ROOT/public/stylesheets) will not be dynamically included.
Ticket::GitTicket.with_style = true

# The environments you want your GitTicket to show up in, list as many or as few as you want.
Ticket::GitTicket.environments = ['production']	

VALUES

File.open(File.dirname(__FILE__) + "/../../../config/environment.rb", File::WRONLY | File::APPEND) do |environment_rb|
  environment_rb << default_values
end

puts IO.read(File.join(File.dirname(__FILE__), 'README.textile'))