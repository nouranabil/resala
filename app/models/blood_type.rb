class BloodType
  @@blood_type = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
  
  def self.all
    return @@blood_type
  end
end