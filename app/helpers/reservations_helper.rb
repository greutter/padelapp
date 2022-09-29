module ReservationsHelper
  def wa_invitation_text reservation
    base_url = "https://wa.me/?text="
    message = ""
    message += "Cancha Reservada! %0A%0A"
    message += "#{l(reservation.starts_at, format: "%A %e %b %k:%M").capitalize}"
    message += " (#{reservation.duration} min)%0A"
    message += "#{reservation.club.name} (Cancha %23#{reservation.court.number})%0A"

    "#{base_url}#{message}"
  end
end
