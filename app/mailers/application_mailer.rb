class ApplicationMailer < ActionMailer::Base
  layout 'bootstrap-mailer'
  default from: "hello@padel64.com"

  helper :reservations
  helper :application  

end
