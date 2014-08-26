require 'action_mailer'
require 'yaml'

config = YAML.load_file('config.yml')
$config_smtp_server = config['smtp_server']

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  address:        $config_smtp_server['address'],
  port:           $config_smtp_server['port']
}

class Notification < ActionMailer::Base
  default from: "\"ssimon\" <#{$config_smtp_server['user_name']}>"

  def notif(recipient)
    @recipient = recipient
    mail(:bcc => recipient,
      :subject => $config_smtp_server['subject']) do |format|
      format.text { render text: 'Impossible actuellement d\'envoyer des messages!' }
    end
  end

  def send_notif(recipient, sujet, contenu)
    @recipient = recipient
    mail(bcc: recipient, subject: sujet) { |format| format.text { render text: contenu } }
  end
end
