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

Description des tables
----------------------
1. mon_clients : liste des clients
  + nom : nom du client
  + repertoire : repertoire ou se trouve les fichiers du clients
  + repertoire_backup : le repertoire de backup du client
  + nb_minutes_attentes_file : le délai de traitement des fichiers du clients
  + heure_detection_trafic_quotidien : l'heure a laquelle on doit verifier s'il y a un trafic dans la journée pour le client
2. mon_contacts : liste des contacts des clients
  + client_id : l'identifiant du client (ca vient de la table mon_clients)
  + email : l'email du contact
3. mon_historique_cron : pour historiser les dates d'execution du crno
  + date : date d'execution du cron
4. mon_plage_horaires : les plages horaires pour vérifier les trafics par plage horaire
  + client_id : l'identifiant du client (ca vient de la table mon_clients)
  + jour : le jour de la semaine (0=>dimanche, 1=>lundi, 2=>mardi, 3=>mercredi, 4=>jeudi, 5=>vendredi, 6=>samedi)
  + heure_debut : l'heure du début de la plage
  + heure_fin : l'heure de la fin de la plage

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
