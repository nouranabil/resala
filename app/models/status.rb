class Status
  @@requested=1
  @@accepted=2
  @@rejected=3
  @@closed=4
  
  def self.requested
    @@requested
  end
  def self.accepted
    @@accepted
  end
  def self.rejected
    @@rejected
  end
  def self.closed
    @@closed
  end
end