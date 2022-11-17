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

  def self.sectors
    s = Comuna.all.map { |c| c.sector }.uniq.reject(&:blank?)
    s.map { |sector| [sector, Comuna.where(sector: sector).map(&:name)] }.to_h
  end
end
