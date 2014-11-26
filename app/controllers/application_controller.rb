class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_person, :user_logged_in?
  
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :authenticate_account!

  before_filter :set_locale

  private

    def current_person
      @current_person ||= Person.find(session[:person_id]) if session[:person_id]
    end

    def authenticate_account!
      no_access unless user_logged_in?
    end

    def logout!
      session.delete(:person_id)
    end

    def user_logged_in?
      !! current_person
    end

    def no_access
      remember_path
      redirect_to login_path, notice: "Log in to have access to site resources."
    end

    def remember_path
      if request.get?
        session[:return_to] = request.fullpath
      end
    end

    def redirect_to_root_or_back
      redirect_to session[:return_to] || root_path
      session.delete(:return_to)
    end

    def set_locale    
      I18n.locale = params[:locale] || extract_locale_from_accept_language_header
    end

    def default_url_options(options={})
      { locale: I18n.locale }
    end

    def extract_locale_from_accept_language_header
      if request.env['HTTP_ACCEPT_LANGUAGE']
        request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      end
    end

    def record_not_found
      redirect_to cars_path, notice: "Record not found"
    end

end
