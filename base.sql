-- --------------------------------------------------------

--
-- Structure de la table `mon_clients`
--

CREATE TABLE IF NOT EXISTS `mon_clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(30) NOT NULL,
  `repertoire` varchar(255) DEFAULT NULL,
  `repertoire_backup` varchar(255) DEFAULT NULL,
  `nb_minutes_attentes_file` int(11) NOT NULL DEFAULT '30',
  `heure_detection_trafic_quotidien` time NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Structure de la table `mon_contacts`
--

CREATE TABLE IF NOT EXISTS `mon_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `mon_historique_cron`
--

CREATE TABLE IF NOT EXISTS `mon_historique_cron` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Structure de la table `mon_plage_horaires`
--

CREATE TABLE IF NOT EXISTS `mon_plage_horaires` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL,
  `jour` int(11) NOT NULL COMMENT '0=>dimanche, 1=>lundi, 2=>mardi, 3=>mercredi, 4=>jeudi, 5=>vendredi, 6=>samedi',
  `heure_debut` time NOT NULL,
  `heure_fin` time NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
