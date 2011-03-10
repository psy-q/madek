# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  layout "main"

##############################################  
# Authentication


  before_filter :login_required, :except => [:root, :login, :login_successful, :logout, :feedback] # TODO :help

  helper_method :current_user, :logged_in?, :_

  def logged_in?
    !!current_user
  end
    
  def current_user
    @current_user ||= login_from_session
  end

##############################################  

  # I18n
  before_filter :set_gettext_locale

  def set_gettext_locale
#    I18n.locale = 'de-CH'
    I18n.locale = 'en-GB'

  end
  
#   def _(s)
#     s
#   end

##############################################  

  def root
    # madek11
    theme "madek11"
    if logged_in?
      # TODO refactor to UsersController#show and dry with MediaEntriesController#index
      params[:per_page] ||= 30 #PER_PAGE.first
      ids = Permission.accessible_by_user("MediaEntry", current_user)
      options = { :page => params[:page], :per_page => params[:per_page].to_i, :retry_stale => true, :include => [:default_permission, {:media_file => :preview_small}] }
      
      #@my_media_entries = MediaEntry.by_ids(ids).not_public.search(nil, options)
      #@public_media_entries = MediaEntry.by_ids(ids).public.search(nil, options)
      
      @my_media_entries = MediaEntry.by_ids(ids).by_user(current_user).search(nil, options) #tmp# to avoid confusion of users looking for "their" Media entries
      @accessible_media_entries = MediaEntry.by_ids(ids).not_by_user(current_user).search(nil, options)
      @disabled_paginator = true # OPTIMIZE
      
      respond_to do |format|
        format.html { render :template => "/users/show" }
        format.js { render :partial => "/media_entries/index" }
      end
    else
      render :layout => false
    end
  end

  def help
  end

  def feedback
    @title = "Medienarchiv der Künste: Feedback & Support"
    @disable_search = true
  end

  def catalog
  end

##############################################  
  protected

  def not_authorized!
    msg = "Sie haben nicht die notwendige Zugriffsberechtigung." #"You don't have appropriate permission to perform this operation."
    respond_to do |format|
      format.html { flash[:error] = msg
                    redirect_to (request.env["HTTP_REFERER"] ? :back : root_path)
                  } 
      format.js { render :text => msg }
    end
  end

##############################################  
  private
  
  def login_required
    unless logged_in?
      flash[:error] = "Bitte anmelden."
      redirect_to root_path
    end
  end

  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user || false
  end

  def login_from_session
    user = nil
    if session[:user_id]
      # TODO use find without exception: self.current_user = User.find(session[:user_id])
      self.current_user = user = User.where(:id => session[:user_id]).first
      check_usage_terms_accepted
    end
    user
  end

  def check_usage_terms_accepted
    return if request[:action].to_sym != :usage_terms
    redirect_to usage_terms_user_path(current_user) unless current_user.usage_terms_accepted?
  end

end
