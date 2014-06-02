require "active_record"
require "mysql2"
require 'yaml'
require './mailer.rb'

$config = YAML.load_file('config.yml')
config_database = $config['database']

ActiveRecord::Base.establish_connection(
  adapter:  "mysql2",
  username: config_database['username'],
  password: config_database['password'],
  database: config_database['database'],
  host:     config_database['host'],
)

# use ActiveRecord::QueryCache

class BdTask < ActiveRecord::Base
  self.table_name = 'ws_messagestatus'
  self.primary_key = 'msgID'

  scope :untreated, -> { where(msgProcessDate: nil, msgMMGmsgID: [-999 .. -103]) }

  def self.send_mail
    return false if untreated.empty?
    # puts "les taches suivantes ne sont pas traitees :"
    # puts untreated.map { |e| "- ##{e.msgID}" }
    Notification.notif($config['mails_notif']).deliver
    return true
  end
end

class FileTask
  def self.send_mail
    return false if untreated.empty?
    # puts "les fichiers suivants ne sont pas traites :"
    # puts untreated.map { |e| "- #{e}" }
    Notification.notif($config['mails_notif']).deliver
    return true
  end

  def self.untreated
    $config = YAML.load_file('config.yml')
    fichier_non_traites = $config['directories'].map { |dir| untreated_for_rep(dir) }.reduce(&:+)
  end

  def self.untreated_for_rep rep
    begin
      return (Dir.entries(rep) - ['.', '..']).map { |f| "#{rep}/#{f}" }
    rescue Errno::ENOENT => e
      return []
    end
  end
end