ssimon
======

Un outil de monitoring

Installation
------------
Il faut d'abord installer ruby sur la machine, ensuite se déplacer sur le repertoire de l'application puis exécuter la commande suivante :
```bash
bundle install
```
Ensuite ajouter les tables qui se trouve dans le fichier `base.sql` sur votre base de données

Configuration
-------------
Il faut configurer les 4 blocs du fichier config.yml :
```yaml
frequence_cron: 60
database:
  adapter: mysql2
  host: localhost
  username: 2si
  password: passer
  database: 2si
smtp_server:
  address: smtpgp1-med.orange.sn
  port: 25
  user_name: demo@test.com
mails_notif:
  - username1@domain.ext
  - username2@domain.ext
  - scicasoft@gmail.com
```
+ frequence_cron : la fréquence d'execution du cron (ici 60 minutes)
+ database : paramètrage de la base de données
+ smtp_server : configuration du serveur SMTP pour l'envoi des mails
+ mails_notif : liste des adresses emails des admins de 2smobile où on doit envoyer les mails de notification

Execution
---------
Se déplacer sur le repertoire de l'application et exécuter la commande suivante :
```bash
./main.rb
```
ou
```bash
ruby main.rb
```
