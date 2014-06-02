ssimon
======

Un outil de monitoring

Installation
------------
Il faut d'abord installer ruby sur la machine, ensuite se déplacer sur le repertoire de l'application puis exécuter la commande suivante :
```bash
bundle install
```

Configuration
-------------
Il faut configurer les 4 blocs du fichier config.yml :
```yaml
database:
  host: localhost
  username: 2si
  password: passer
  database: 2si
smtp_server:
  address: smtp.alwaysdata.com
  port: 25
  user_name: demo@scicasoft.com
  password: scicademopass!!!
  label: 'ssimon'
  subject: '[2si] systeme notification taches non faites'
directories:
  - /chemin/vers/repertoire/1
  - /chemin/vers/repertoire/2
mails_notif:
  - username1@domain.ext
  - username2@domain.ext
  - scicasoft@gmail.com
```
+ database : paramètrage de la base de données
+ smtp_server : configuration du serveur SMTP pour l'envoi des mails
+ directories : liste des répertoires à vérifier
+ mails_notif : liste des adresses email où on doit envoyer les mails de notification

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