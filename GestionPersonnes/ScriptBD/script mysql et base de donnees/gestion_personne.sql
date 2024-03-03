-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : sam. 02 mars 2024 à 14:54
-- Version du serveur : 10.4.22-MariaDB
-- Version de PHP : 7.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `gestion_personne`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_etudiant` (`in_id` INT)  BEGIN
    IF EXISTS (SELECT * FROM etudiant WHERE id = in_id) THEN
        DELETE FROM etudiant WHERE id = in_id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_telephone` (`in_id` INT)  BEGIN
    IF EXISTS (SELECT * FROM telephone WHERE id = in_id) THEN
        DELETE FROM telephone WHERE id = in_id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_etudiant` (`in_id` INT, `in_nom` VARCHAR(50), `in_postnom` VARCHAR(50), `in_prenom` VARCHAR(50), `in_sexe` VARCHAR(1), `in_matricule` VARCHAR(20))  BEGIN
    DECLARE id_count INT;
    SELECT COUNT(*) INTO id_count FROM etudiant WHERE id = in_id;
    
    IF id_count = 0 THEN
        INSERT INTO etudiant(id, nom, postnom, prenom, sexe, matricule) 
        VALUES (in_id, in_nom, in_postnom, in_prenom, in_sexe, in_matricule);
    ELSE
        UPDATE etudiant 
        SET nom = in_nom, postnom = in_postnom, prenom = in_prenom, sexe = in_sexe, matricule = in_matricule 
        WHERE id = in_id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_telephone` (`in_id` INT, `in_id_proprietaire` INT, `in_initial` VARCHAR(4), `in_numero` VARCHAR(9))  BEGIN
    DECLARE id_count INT;
    SELECT COUNT(*) INTO id_count FROM telephone WHERE id = in_id;
    
    IF id_count = 0 THEN
        INSERT INTO telephone(id, id_proprietaire, initial, numero) 
        VALUES (in_id, in_id_proprietaire, in_initial, in_numero);
    ELSE
        UPDATE telephone 
        SET id_proprietaire = in_id_proprietaire, initial = in_initial, numero = in_numero 
        WHERE id = in_id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_liste_etudiants` ()  BEGIN
    SELECT etudiant.id, CONCAT(etudiant.nom, ' ', COALESCE(etudiant.postnom, ''), ' ', COALESCE(etudiant.prenom, '')) AS nom,
    etudiant.sexe, telephone.id AS idtel, CONCAT(telephone.initial, telephone.numero) AS numero
    FROM etudiant
    LEFT OUTER JOIN telephone 
    ON etudiant.id = telephone.id_proprietaire;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_select_etudiant` ()  BEGIN
    SELECT id, nom, postnom, prenom, sexe, matricule FROM etudiant ORDER BY nom ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_select_etudiants` (`in_id` INT)  BEGIN
    SELECT id, nom, postnom, prenom, sexe, matricule FROM etudiant WHERE id = in_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_select_telephone` (`in_id` INT)  BEGIN
    SELECT id, id_proprietaire, initial, numero FROM telephone WHERE id = in_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_select_telephones` ()  BEGIN
    SELECT id, id_proprietaire, initial, numero FROM telephone ORDER BY numero ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_select_telephones_personne` (`in_id_personne` INT)  BEGIN
    SELECT id, id_proprietaire, initial, numero 
    FROM telephone 
    WHERE id_proprietaire = in_id_personne 
    ORDER BY numero ASC;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `adresse`
--

CREATE TABLE `adresse` (
  `id` int(11) NOT NULL,
  `quartier` varchar(50) DEFAULT NULL,
  `commune` varchar(50) DEFAULT NULL,
  `ville` varchar(50) DEFAULT NULL,
  `pays` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `domicile`
--

CREATE TABLE `domicile` (
  `id` int(11) NOT NULL,
  `id_personne` int(11) NOT NULL,
  `id_adresse` int(11) NOT NULL,
  `avenue` varchar(50) DEFAULT NULL,
  `numero_avenue` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `etudiant`
--

CREATE TABLE `etudiant` (
  `id` int(11) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `postnom` varchar(50) DEFAULT NULL,
  `prenom` varchar(50) DEFAULT NULL,
  `sexe` varchar(1) NOT NULL DEFAULT 'M',
  `matricule` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `etudiant`
--

INSERT INTO `etudiant` (`id`, `nom`, `postnom`, `prenom`, `sexe`, `matricule`) VALUES
(1, 'Isamuna', 'Nkembo', 'Josue', 'M', '22LIAGELJ253'),
(2, 'Kibambe', 'Kabululu', 'Nathan', 'M', '22LIAGELJ620114'),
(3, 'Kyakimwa', 'Ndivito', 'Milka', 'F', '22LIAGELJ620354');

-- --------------------------------------------------------

--
-- Structure de la table `telephone`
--

CREATE TABLE `telephone` (
  `id` int(11) NOT NULL,
  `id_proprietaire` int(11) NOT NULL,
  `initial` varchar(4) NOT NULL,
  `numero` varchar(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `telephone`
--

INSERT INTO `telephone` (`id`, `id_proprietaire`, `initial`, `numero`) VALUES
(1, 1, '+250', '785623146'),
(2, 1, '+243', '081270036'),
(3, 2, '+243', '985645235'),
(4, 3, '+243', '815790584'),
(5, 3, '+242', '808256231');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `adresse`
--
ALTER TABLE `adresse`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `domicile`
--
ALTER TABLE `domicile`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_personne_domicile` (`id_personne`),
  ADD KEY `fk_addresse_domicile` (`id_adresse`);

--
-- Index pour la table `etudiant`
--
ALTER TABLE `etudiant`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_personne` (`nom`,`postnom`,`prenom`);

--
-- Index pour la table `telephone`
--
ALTER TABLE `telephone`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_personne_telephone` (`id_proprietaire`);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `domicile`
--
ALTER TABLE `domicile`
  ADD CONSTRAINT `fk_addresse_domicile` FOREIGN KEY (`id_adresse`) REFERENCES `adresse` (`id`),
  ADD CONSTRAINT `fk_personne_domicile` FOREIGN KEY (`id_personne`) REFERENCES `etudiant` (`id`);

--
-- Contraintes pour la table `telephone`
--
ALTER TABLE `telephone`
  ADD CONSTRAINT `fk_personne_telephone` FOREIGN KEY (`id_proprietaire`) REFERENCES `etudiant` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
