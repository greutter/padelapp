begin
  Club.find_by(third_party_id: 336).update(members_only: true)
rescue Exception => e
  p e
end

#Comunas
comunas = Club.all.map { |c| { name: c.comuna, region: c.region } }
Comuna.create(comunas)

sectors = [
  { name: "Padre Hurtado", sector: "Santiago Poniente" },
  { name: "Huechuraba", sector: "Santiago Norte" },
  { name: "Las Condes", sector: "Santiago Oriente" },
  { name: "La Florida", sector: "Santiago Sur" },
  { name: "Melipilla", sector: "Santiago Poniente" },
  { name: "Colina", sector: "Santiago Norte" },
  { name: "Lampa ", sector: "Santiago Norte" },
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
  { name: "Vitacura", sector: "Santiago Oriente" }
]
sectors.each { |s| Comuna.find_by(name: s[:name])&.update(sector: s[:sector]) }
