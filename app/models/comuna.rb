# == Schema Information
#
# Table name: comunas
#
#  id                             :bigint           not null, primary key
#  grouping                       :string
#  name                           :string
#  region                         :string
#  region_north_to_south_ordering :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
class Comuna < ApplicationRecord
    validates :name, presence: true, uniqueness: true

    [{"0"=>"Región de Arica y Parinacota"},
        {"1"=>"Región de Tarapacá"},
        {"2"=>"Región de Antofagasta"},
        {"3"=>"Región de Atacama"},
        {"4"=>"Región de Coquimbo"},
        {"5"=>"Región de Valparaíso"},
        {"6"=>"Región Metropolitana de Santiago"},
        {"7"=>"Región del Libertador General Bernardo O’Higgins"},
        {"8"=>"Región del Maule"},
        {"9"=>"Región del Ñuble"},
        {"10"=>"Región del Biobío"},
        {"11"=>"Región de La Araucanía"},
        {"12"=>"Región de Los Ríos"},
        {"13"=>"Región de Los Lagos"}]
end
