class Sector
    attr_accessor :name, :comunas, :clubs
  
    def initialize(name = nil)
      self.name = name
    end
  
    def comunas
      Comuna.where(sector: self.name) unless self.name.blank?
    end
  
    def clubs
      unless self.name.blank?
        Club.where("comuna IN (?)", self.comunas.map(&:name))
      end
    end
  
    def self.all
      sectors_names = Comuna.all.map(&:sector).uniq.reject(&:blank?)
      sectors = sectors_names.map { |sector_name| self.new(sector_name) }
    end
end