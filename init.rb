require 'ticket'

ActionController::Base.send :include, Ticket::TicketMixin
ActionController::Base.send :after_filter, :add_git_ticket_code