module MediaHelper
  def js_months
    "['#{I18n.t('date.month_names')[1..12].join("','")}']"
  end
  
  def js_days
    "['#{I18n.t('date.day_names').join("','")}']"
  end
end

