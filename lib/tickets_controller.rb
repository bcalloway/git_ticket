class TicketsController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_required
  
  def index
    redirect_back_or_default("/")
  end
  
  def new
    redirect_back_or_default("/")
  end
  
  def create
    redirect_back_or_default("/") and return unless Ticket::GitTicket.enabled?
    
    if not params[:body].blank? and not params[:title].blank?
      body = params[:body]
      if self.respond_to?(:logged_in?) and logged_in?
        body += "\n\nCreated from the web by #{current_user.login} #{current_user.email}\n"
      end
      body += "URL: #{params[:url]}\n"
      body += "Rails Env: #{RAILS_ENV}\n"
      redirect_url = "/"
      redirect_url = params[:url] unless params[:url] == "/create_ticket"
      
      account = Ticket::GitTicket.account
      token = Ticket::GitTicket.token
      project = Ticket::GitTicket.project
      
      ticket = Curl::Easy.http_post("http://github.com/api/v2/xml/issues/open/#{account}/#{project}",
          Curl::PostField.content('login', account),
          Curl::PostField.content('token', token),
          Curl::PostField.content('title', params[:title]),
          Curl::PostField.content('body', body))
      
      if ticket.response_code == 200
        flash[:notice]="Your ticket was successfully posted, we will try to fix it."
      else
        flash[:notice]="There was an error submitting your ticket."
      end
    else
      flash[:notice]="Please provide a Title and Description for the issue."
    end
    respond_to do |format|
      format.html { redirect_to(redirect_url) }
      format.js {
        render :update do |page|
          if not params[:body].blank? and not params[:title].blank?
            page << "GitTicket.toggle('hide');"
          end
          page << "GitTicket.notify('#{flash[:notice]}')"
          flash[:notice] = nil
        end
      }
    end
  end
  
  def edit
    redirect_back_or_default("/")
  end
  
  def update
    redirect_back_or_default("/")
  end
  
  def delete
    redirect_back_or_default("/")
  end
  
end