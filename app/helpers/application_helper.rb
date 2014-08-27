module ApplicationHelper

  def command_label icon, label
    "<i class='#{icon} icon-white'></i> <span class='command-label'>&nbsp;#{label}</span>".html_safe
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

  def getUrl url
    (URI(request.url) + url).to_s
  end
  
end
