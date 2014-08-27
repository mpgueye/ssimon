#!/usr/bin/env ruby
require './models.rb'
require 'yaml'
require './mailer.rb'

$config = YAML.load_file('config.yml')

t = Time.new
HistoriqueCron.create(date: Time.new(t.year, t.month, t.day)) if HistoriqueCron.count.zero?

cron_new = HistoriqueCron.new(date: Time.now)

# FileTask.send_mail

# 1. délai de renvoi des messages
puts '[1/5] délai de renvoi des messages'
BdTask.send_mail

# 2. délai traitement fichier
puts '[2/5] délai traitement fichier'
Client.all.each do |client|
  unless client.fichiers_non_traites.empty?
    puts "Il y a des fichiers non traite pour le client #{client.nom}"
    Notification.notif($config['mails_notif'],
                       "[2si] systeme notification taches non faites'",
                       "Il y a des fichiers non traite pour le client #{client.nom}").deliver
  end
end

# 3. Fichiers Vides
puts '[3/5] Fichiers Vides'
Journal.fichiers_vides(cron_new.date).each do |journal|
  client = journal.client
  
  puts "Nous avons détecté un fichier vide pour le client #{client.nom}"
  
  Notification.notif($config['mails_notif'],
                     "[2si] fichier vide detecte'",
                     "Nous avons détecté un fichier vide pour le client #{client.nom}").deliver

  Notification.notif(client.emails_contacts,
                     "[2si] fichier vide detecte'",
                     "Un de vos fichiers que vous avez envoyé est vide").deliver
end

# 4. Trafic par plage horaire
puts '[4/5] Trafic par plage horaire'
clients = []
PlageHoraire.a_verifier.each do |plage_horaire|
  clients << plage_horaire.client if plage_horaire.non_envoye?
end
clients.uniq.each do |client|
  puts "Il n y a pas de trafic pour le client #{client.nom}"
  Notification.notif($config['mails_notif'],
                     "[2si] pas de trafic'",
                     "Il n y a pas de trafic pour le client #{client.nom}").deliver

  Notification.notif(client.emails_contacts,
                     "[2si] pas de trafic'",
                     "Nous n'avons pas détecté de trafic").deliver
end

# 5. Trafic quotidien
puts '[5/5] Trafic quotidien'
Client.all.each do |client|
  unless client.trafic_existe?(cron_new.date)
    puts "Il n y a pas eu de trafic aujourd'hui pour le client #{client.nom}"
    Notification.notif($config['mails_notif'],
                       "[2si] pas de trafic quotidien'",
                       "Il n y a pas eu de trafic aujourd'hui pour le client #{client.nom}").deliver

    Notification.notif(client.emails_contacts,
                       "[2si] pas de trafic quotidien'",
                       "Nous n'avons pas détecté de trafic aujourd'hui").deliver
  end
end

# enregistrement historique cron
cron_new.save
