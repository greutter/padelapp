# == Schema Information
#
# Table name: comunas
#
#  id                             :bigint           not null, primary key
#  name                           :string
#  region                         :string
#  region_north_to_south_ordering :integer
#  sector                         :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
class Comuna < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  REGIONES = [
    { name: "Región de Arica y Parinacota", ns_order: 0 },
    { name: "Región de Tarapacá", ns_order: 1 },
    { name: "Región de Antofagasta", ns_order: 2 },
    { name: "Región de Atacama", ns_order: 3 },
    { name: "Región de Coquimbo", ns_order: 4 },
    { name: "Región de Valparaíso", ns_order: 5 },
    { name: "Región Metropolitana de Santiago", ns_order: 6 },
    { name: "Región del Libertador General Bernardo O’Higgins", ns_order: 7 },
    { name: "Región del Maule", ns_order: 8 },
    { name: "Región del Ñuble", ns_order: 9 },
    { name: "Región del Biobío", ns_order: 10 },
    { name: "Región de La Araucanía", ns_order: 11 },
    { name: "Región de Los Ríos", ns_order: 12 },
    { name: "Región de Los Lagos", ns_order: 13 }
  ]

  def self.create_comunas_from_clubs  
    comunas = Club.all.map { |c| { name: c.comuna, region: c.region } }
    Comuna.create(comunas)
    Sector.update_sectors
  end

end

class Sector

  attr_accessor :name, :comunas, :clubs

  SECTORS = [
    { name: "Padre Hurtado", sector: "Santiago Poniente" },
    { name: "Huechuraba", sector: "Santiago Norte" },
    { name: "Las Condes", sector: "Santiago Oriente" },
    { name: "La Florida", sector: "Santiago Sur" },
    { name: "Melipilla", sector: "Santiago Poniente" },
    { name: "Colina", sector: "Santiago Norte" },
    { name: "Lampa", sector: "Santiago Norte" },
    { name: "Talagante", sector: "Santiago Poniente" },
    { name: "Maipú", sector: "Santiago Poniente" },
    { name: "San Bernardo", sector: "Santiago Sur" },
    { name: "Calera de Tango", sector: "Santiago Poniente" },
    { name: "Estación Central", sector: "Santiago Poniente" },
    { name: "Paine", sector: "Santiago Poniente" },
    { name: "Puente Alto", sector: "Santiago Sur" },
    { name: "Providencia", sector: "Santiago Oriente" },
    { name: "La Reina", sector: "Santiago Oriente" },
    { name: "Buin", sector: "Santiago Poniente" },
    { name: "Peñalolén", sector: "Santiago Sur" },
    { name: "Vitacura", sector: "Santiago Oriente" },
    { name: "Lo Barnechea", sector: "Santiago Oriente" }
  ]

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

  def self.update_sectors
    SECTORS.each { |s| Comuna.find_by(name: s[:name])&.update(sector: s[:sector]) }
  end
end


