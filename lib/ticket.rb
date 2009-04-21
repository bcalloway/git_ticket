module Ticket # :nodoc:
  module TicketMixin
    def git_ticket_code(request = nil)
      return unless GitTicket.enabled?
      GitTicket.ticket_pane(request)
    end
    
    # An after_filter to automatically add the code.
    def add_git_ticket_code
      code = git_ticket_code(request)
      return if code.blank?
      response.body.gsub! '</body>', code + '</body>' if response.body.respond_to?(:gsub!)
    end
    
  end

  class GitTicket
      
    @@project = nil
    cattr_accessor :project
    
    @@account = nil
    cattr_accessor :account
    
    @@token = nil
    cattr_accessor :token
    
    @@site_name = nil
    cattr_accessor :site_name
    
    @@with_style = true
    cattr_accessor :with_style

    # The environments in which to enable. Defaults to 'production' only.
    @@environments = ['production']
    cattr_accessor :environments

    # Return true if the system is enabled and configured correctly.
    def self.enabled?
      (environments.include?(RAILS_ENV) and
        not project.blank? and
        not account.blank? and
        not token.blank?)
    end
    
    def self.ticket_pane(request = nil)
      
      javascript = <<-HTML
  		<script src="/javascripts/gitticket.js" type="text/javascript"></script>
      HTML

      style = <<-HTML  
      <link href="/stylesheets/gitticket.css" media="screen" rel="stylesheet" type="text/css" />
      HTML

      code = <<-HTML
    <div id="bug_button">
			<a href="javascript:void(0);" onclick="GitTicket.toggle('show')"><span>Report Issue</span></a>
		</div>
    <div id="create_ticket_form" style="display:none">
    	<div style="float:right">
    		<a href="javascript:void(0);" onclick="GitTicket.toggle('hide')">close</a>
    	</div>

    	<form action="/create_ticket" method="GET" onsubmit="return GitTicket.submit(this);">
    	  <input type="hidden" name="url" value="#{request.request_uri}"/>
    		<h2>Create a ticket#{ " for "+site_name unless site_name.blank?}</h2>
    		<div id="ticket_title" class="field">
    			<label>Issue Title</label>
    			<input type="text" id="ticket_title_field" maxsize="140" name="title" />
    		</div>
    		<div id="ticket_body" class="field">
    			<label>Tell Us What Happened</label>
    			<textarea name="body" id="ticket_body_field"></textarea>
    		</div>
    		<div id="submitting_ticket" style="display:none">
    			Submitting ticket...
    		</div>
    		<div id="submit_ticket">
    		<input type="submit" class="submit_button" value="Submit Ticket"/> or 
    			<a href="javascript:void(0);" onclick="GitTicket.toggle('hide')">Cancel</a>
    		</div>
    	</form>
    </div>
      HTML
      
      str = javascript
      str += style if @@with_style
      str += code
      str
    end
  end
  
end