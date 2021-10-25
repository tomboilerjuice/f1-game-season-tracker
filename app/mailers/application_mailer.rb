class ApplicationMailer < ActionMailer::Base
  default from: 'admin@manageproject.app'
  layout 'mailer'
# BEGIN Ansible Managed block
def welcome
  @greeting = "Hi"
  mail to: "clive@clivebaker.com"
end
# END Ansible Managed block
end
