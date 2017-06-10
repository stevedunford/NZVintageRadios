-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.17-log - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for nzvr_db
DROP DATABASE IF EXISTS `nzvr_db`;
CREATE DATABASE IF NOT EXISTS `nzvr_db` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `nzvr_db`;

-- Dumping structure for table nzvr_db.adverts
DROP TABLE IF EXISTS `adverts`;
CREATE TABLE IF NOT EXISTS `adverts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `category` int(11) unsigned NOT NULL COMMENT '0 valves, 1 components, 2 test equipment, 3 radio kitsets, 4 radios, 5 publications, 6 courses',
  `type_id` int(11) unsigned DEFAULT NULL COMMENT 'if appropriate - same as images',
  `type` int(11) unsigned DEFAULT NULL COMMENT 'if appropriate - same as images',
  `publication` varchar(50) DEFAULT NULL,
  `pub_date` date DEFAULT NULL,
  `page` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='collection of advertisements from various sources';

-- Data exporting was unselected.
-- Dumping structure for table nzvr_db.brand
DROP TABLE IF EXISTS `brand`;
CREATE TABLE IF NOT EXISTS `brand` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `alias` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT 'for tidy urls',
  `tagline` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT 'ie: Pacific Radio Co is ''In a sphere of its own'', Courtenay was ''Known for Tone''',
  `manufacturer_id` int(11) NOT NULL DEFAULT '0' COMMENT 'fk from manufacturer table',
  `distributor_id` int(11) NOT NULL DEFAULT '0' COMMENT 'fk from distributor table.  0 means various, -1 means unknown',
  `year_started` year(4) DEFAULT NULL COMMENT 'Year started distributing if known',
  `year_started_approx` tinyint(1) unsigned DEFAULT '0' COMMENT 'Is this approximate?',
  `year_ended` year(4) DEFAULT NULL COMMENT 'Year ended distributing if known',
  `year_ended_approx` tinyint(1) unsigned DEFAULT '0' COMMENT 'Is this approximate',
  `notes` longtext CHARACTER SET utf8 NOT NULL COMMENT 'Details about the distributor',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `alias` (`alias`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
-- Dumping structure for table nzvr_db.cabinet
DROP TABLE IF EXISTS `cabinet`;
CREATE TABLE IF NOT EXISTS `cabinet` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text COMMENT 'nickname for the cabinet',
  `cabinetmaker_id` int(11) NOT NULL,
  `style` text COMMENT 'tombstone, cathedral, chest, mantle, etc',
  `material` text COMMENT 'plastic, bakelite, veneer-over-ply, solid timber, etc',
  `coating` text COMMENT 'lacquer, shellac, paint, etc',
  `width` smallint(6) DEFAULT NULL COMMENT 'mm',
  `height` smallint(6) DEFAULT NULL COMMENT 'mm',
  `depth` smallint(6) DEFAULT NULL COMMENT 'mm',
  PRIMARY KEY (`id`),
  KEY `FK_cabinet_cabinetmaker` (`cabinetmaker_id`),
  CONSTRAINT `FK_cabinet_cabinetmaker` FOREIGN KEY (`cabinetmaker_id`) REFERENCES `cabinetmaker` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='One of the main components of a radio, these were often produced by cabinetmakers specifically dealing in the radio manufacturing industry';

-- Data exporting was unselected.
-- Dumping structure for table nzvr_db.cabinetmaker
DROP TABLE IF EXISTS `cabinetmaker`;
CREATE TABLE IF NOT EXISTS `cabinetmaker` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` tinytext,
  `alias` tinytext,
  `address` text,
  `notes` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='The manufacturers of the cabinets used in radios';

-- Data exporting was unselected.
-- Dumping structure for table nzvr_db.chassis
DROP TABLE IF EXISTS `chassis`;
CREATE TABLE IF NOT EXISTS `chassis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` tinytext NOT NULL,
  `manufacturer_id` int(10) NOT NULL DEFAULT '1',
  `start_year` smallint(4) unsigned DEFAULT NULL,
  `start_year_approx` tinyint(3) unsigned DEFAULT NULL,
  `bands` tinyint(3) unsigned DEFAULT NULL,
  `num_valves` smallint(5) unsigned DEFAULT NULL,
  `valve_lineup` text,
  `if_peak` text,
  `notes` longtext,
  PRIMARY KEY (`id`),
  KEY `manufacturer_id` (`manufacturer_id`),
  CONSTRAINT `manufacturer_id` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8 COMMENT='Radio chassis information - used because many radios share the same chassis and schematic info';

-- Data exporting was unselected.
-- Dumping structure for table nzvr_db.distributor
DROP TABLE IF EXISTS `distributor`;
CREATE TABLE IF NOT EXISTS `distributor` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `alias` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT 'This field is for the url, logo img etc - hence unique',
  `address` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT 'Address, or town / city company was located in',
  `notes` longtext CHARACTER SET utf8 NOT NULL COMMENT 'Details about the distributor',
  PRIMARY KEY (`id`),
  UNIQUE KEY `alias` (`alias`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
-- Dumping structure for table nzvr_db.images
DROP TABLE IF EXISTS `images`;
CREATE TABLE IF NOT EXISTS `images` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(80) NOT NULL COMMENT 'Title of the file shown in the browser',
  `filename` varchar(100) NOT NULL COMMENT 'path to the file',
  `type` tinyint(3) unsigned NOT NULL COMMENT '1=radio, 2=brand, 3=manufacturer, 4=distributor',
  `type_id` int(10) unsigned NOT NULL COMMENT 'which item it belongs to',
  `is_schematic` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Is this image a schematic',
  `rank` int(11) DEFAULT '99' COMMENT '1=highest priority',
  `attribution` varchar(100) DEFAULT NULL COMMENT 'If (c) then add details here',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=367 DEFAULT CHARSET=utf8 COMMENT='locations and descriptions of images used on the site\r\n';

-- Data exporting was unselected.
-- Dumping structure for table nzvr_db.manufacturer
DROP TABLE IF EXISTS `manufacturer`;
CREATE TABLE IF NOT EXISTS `manufacturer` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `alias` varchar(50) NOT NULL COMMENT 'This field is for the url, logo img etc - hence unique',
  `address` varchar(255) DEFAULT NULL COMMENT 'Address, or town / city company was located in',
  `year_started` year(4) DEFAULT NULL COMMENT 'Year started manufactuing if known',
  `year_started_approx` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Start year approximate',
  `year_ended` year(4) DEFAULT NULL COMMENT 'Year ended manufactuing if known',
  `year_ended_approx` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'End year approximate',
  `became` int(10) unsigned DEFAULT NULL COMMENT 'If this company merged into or renamed itself, add the id of the new company here',
  `became_how` tinytext COMMENT 'merged, taken over, sold to, or rebranded',
  `notes` longtext NOT NULL COMMENT 'Details about the manufacturer',
  PRIMARY KEY (`id`),
  UNIQUE KEY `alias` (`alias`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table nzvr_db.model
DROP TABLE IF EXISTS `model`;
CREATE TABLE IF NOT EXISTS `model` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL COMMENT 'May not be known (ie later model NZ Philco sets had no model number on them) - but needs something',
  `nickname` tinytext COMMENT 'If the model has a nickname beside the model code/name',
  `chassis_id` int(11) NOT NULL COMMENT '0 if its a chassis model, or the id of the chassis model if you''re refering to it for a radio variant',
  `brand_id` int(10) NOT NULL COMMENT 'All sets must have a brand, this ties them back to a manufacturer',
  `cabinet_id` int(11) NOT NULL DEFAULT '1',
  `start_year` year(4) DEFAULT NULL,
  `start_year_approx` tinyint(3) unsigned DEFAULT '0',
  `end_year` year(4) DEFAULT NULL,
  `end_year_approx` tinyint(3) unsigned DEFAULT '0',
  `notes` longtext COMMENT 'Information about this set',
  PRIMARY KEY (`id`),
  KEY `FK_model_brand` (`brand_id`),
  KEY `FK_model_chassis` (`chassis_id`),
  KEY `FK_model_cabinet` (`cabinet_id`),
  CONSTRAINT `FK_model_brand` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`),
  CONSTRAINT `FK_model_cabinet` FOREIGN KEY (`cabinet_id`) REFERENCES `cabinet` (`id`),
  CONSTRAINT `FK_model_chassis` FOREIGN KEY (`chassis_id`) REFERENCES `chassis` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table nzvr_db.user
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `user_id` int(10) NOT NULL AUTO_INCREMENT,
  `date_joined` int(11) NOT NULL DEFAULT '0',
  `username` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`,`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
-- Dumping structure for table nzvr_db.valve
DROP TABLE IF EXISTS `valve`;
CREATE TABLE IF NOT EXISTS `valve` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `filename` tinytext NOT NULL,
  `type` tinytext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
