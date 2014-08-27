class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  
  before_filter :set_gettext_locale
  before_filter :set_locale
  helper_method :current_user

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def model_translated
    return _("Marchio").to_s if controller_name.classify.downcase == "brand"
    return _("Modello").to_s if controller_name.classify.downcase == "model"
    return _("Moto").to_s if controller_name.classify.downcase == "bike"
  end

  def model_translated_pluralized
    return _("Marchi").to_s if controller_name.classify.downcase == "brand"
    return _("Modelli").to_s if controller_name.classify.downcase == "model"
    return _("Moto").to_s if controller_name.classify.downcase == "bike"
  end

  private 
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def record_not_found
    if controller_name.classify.downcase == "bike"
      @error_msg = model_translated + " non trovata!"
    else
      @error_msg = model_translated + " non trovato!"
    end
   
    redirect_to brands_path, :flash => { :error => _(@error_msg) }
    true
  end

end
