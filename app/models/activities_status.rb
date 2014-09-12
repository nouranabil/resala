class ActivitiesStatus < Status
  @@request_close = 5
  @@request_cancel = 6
  @@cancelled = 7
  
  def self.request_close
    @@request_close
  end
  def self.request_cancel
    @@request_cancel
  end
  def self.cancelled
    @@cancelled
  end
end
