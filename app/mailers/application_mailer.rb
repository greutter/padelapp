class ApplicationMailer < ActionMailer::Base
  layout 'bootstrap-mailer'
  default from: "hello@padelapp.cl"

  helper :reservations
  helper :application  

end
