class UserMailer < ApplicationMailer
  default from: 'fiti-support@expertgrid.de'

  def welcome_email(mail)
    @url  = 'http://expertgrid.de'
    mail(to: mail, subject: I18n.t("mailer.subjects.welcome"))
  end

  def onetime_link(mail, url)
    @url = url
    mail(to:mail, subject: I18n.t("mailer.subjects.onetime_link"))
  end
end
