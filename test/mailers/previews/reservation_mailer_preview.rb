# Preview all emails at http://localhost:3000/rails/mailers/reservation_mailer

class ReservationMailerPreview < ActionMailer::Preview
    def new_reservation_email
        @reservation = Payment.where(status: 'approved').last.payable
        ReservationMailer.with(reservation: @reservation).new_reservation_email
    end
end
