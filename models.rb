require 'active_record'
require 'mysql2'
require 'yaml'
require './mailer.rb'

$config = YAML.load_file('config.yml')

ActiveRecord::Base.establish_connection($config['database'])

# use ActiveRecord::QueryCache

class HistoriqueCron < ActiveRecord::Base
  default_scope { order('-date') }
  self.table_name = 'mon_historique_cron'
end

class Message < ActiveRecord::Base
  self.table_name = 'ws_message'
  self.primary_key = 'msCode'
end

class Journal < ActiveRecord::Base
  self.table_name = 'as_journal'
  self.primary_key = 'jrlID'

  # @return [Client]
  def client
    Client.find_by(nom: clt_cltCode)
  end

  def fichier
    "#{client.repertoire}/#{jrlPushFile}"
  end

  def fichier_backup
    "#{client.repertoire_backup}/#{jrlPushFile}.old"
  end

  def self.fichiers_vides(date_time)
    date_last_cron = HistoriqueCron.first.date
    where('jrlDate = DATE(?) AND jrlTime > TIME(?) AND jrlTime <= TIME(?)',
          date_time,
          date_last_cron,
          date_time).delete_if do |journal|
      begin
        f = File.new(journal.fichier)
      rescue Errno::ENOENT => e
        begin
          f = File.new(journal.fichier_backup)
          not f.size.zero?
        rescue Errno::ENOENT => e
          true
        end
      end
    end
  end
end

class Contact < ActiveRecord::Base
  self.table_name = 'mon_contacts'

  belongs_to :client, foreign_key: :client_id
end

class Client < ActiveRecord::Base
  self.table_name = 'mon_clients'

  has_many :contacts, class_name: Contact, foreign_key: :client_id

  def journals
    Journal.where(clt_cltCode: nom)
  end

  def messages
    Message.where(ab_ablogin: nom)
  end

  def emails_contacts
    contacts.map(&:email)
  end

  def fichiers_non_traites
    return [] if self.repertoire.nil?
    begin
      return (Dir.entries(self.repertoire).delete_if{|f| f[-4..-1] != '.txt'}).map do |f|
        (Time.now - File.new("#{self.repertoire}/#{f}").ctime) / 60
      end.delete_if{|e| e < self.nb_minutes_attentes_file}
    rescue Errno::ENOENT => e
      return []
    end
  end

  def trafic_existe?(date_time)
    t = heure_detection_trafic_quotidien
    n = date_time
    heure_detection = Time.new(n.year, n.month, n.day, t.hour, t.min, t.sec)
    date_last_cron = HistoriqueCron.first.date
    return true unless (date_last_cron.today? and date_last_cron < heure_detection and heure_detection <= date_time)
    return true unless journals.where('jrlDate = DATE(?)', date_time).empty?
    not messages.where('msDate = DATE(?)', date_time).empty?
  end
end

class PlageHoraire < ActiveRecord::Base
  self.table_name = 'mon_plage_horaires'

  belongs_to :client, class_name: Client, foreign_key: :client_id

  scope :a_verifier, -> {
    where('jour = ? and heure_debut <= TIME(?) AND heure_fin >= TIME(?)', Time.now.wday, Time.now, Time.now)
  }

  def non_envoye?
    t = Time.now
    h_debut = heure_debut
    h_fin = heure_fin
    client.journals.where('jrlDate = DATE(?) AND jrlTime >= TIME(?) AND jrlTime <= TIME(?)', t, h_debut, h_fin).empty?
  end
end

class BdTask < ActiveRecord::Base
  self.table_name = 'ws_messagestatus'
  self.primary_key = 'msgID'

  scope :untreated, -> { where(msgProcessDate: nil, msgMMGmsgID: [-999 .. -103]) }

  def self.send_mail
    return false if untreated.empty?
    Notification.send_notif($config['mails_notif'],
                            '[2si] systeme notification taches non faites',
                            'Impossible actuellement d\'envoyer des messages!').deliver
  end
end

# class FileTask
#   def self.send_mail
#     return false if untreated.empty?
#     # puts "les fichiers suivants ne sont pas traites :"
#     # puts untreated.map { |e| "- #{e}" }
#     Notification.notif($config['mails_notif']).deliver
#   end
#
#   def self.untreated
#     $config = YAML.load_file('config.yml')
#     fichier_non_traites = $config['directories'].map { |dir| untreated_for_rep(dir) }.reduce(&:+)
#   end
#
#   def self.untreated_for_rep rep
#     begin
#       return (Dir.entries(rep) - %w(. ..)).map do |f|
#         (Time.now - File.new("#{rep}/#{f}").ctime)/60
#       end.delete_if{|e| e < $config['nb_minutes_attente'].to_i}
#     rescue Errno::ENOENT => e
#       return []
#     end
#   end
# end
