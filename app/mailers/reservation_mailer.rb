class ReservationMailer < ApplicationMailer
    default from: "reservas@padelapp.cl"

    def new_reservation_email()
        @reservation = params[:reservation]
        @user = @reservation.user 
        mail(
            to: @user.email,
            subject: "Lista la Cancha! #{@reservation.club.name}"
        )
    end
end
