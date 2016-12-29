-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.16-log - MySQL Community Server (GPL)
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

-- Dumping structure for table nzvr_db.brand
DROP TABLE IF EXISTS `brand`;
CREATE TABLE IF NOT EXISTS `brand` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `alias` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT 'for tidy urls',
  `tagline` varchar(50) CHARACTER SET utf8 DEFAULT NULL COMMENT 'ie: Pacific Radio Co is ''In a sphere of its own'', Courtenay was ''Known for Tone''',
  `manufacturer_id` int(11) NOT NULL DEFAULT '0' COMMENT 'fk from manufacturer table',
  `distributor_id` int(11) NOT NULL DEFAULT '0' COMMENT 'fk from distributor table',
  `year_started` year(4) DEFAULT NULL COMMENT 'Year started distributing if known',
  `started_approx` tinyint(1) unsigned DEFAULT '0' COMMENT 'Is this approximate?',
  `year_ended` year(4) DEFAULT NULL COMMENT 'Year ended distributing if known',
  `ended_approx` tinyint(1) unsigned DEFAULT '0' COMMENT 'Is this approximate',
  `notes` longtext CHARACTER SET utf8 NOT NULL COMMENT 'Details about the distributor',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- Dumping data for table nzvr_db.brand: ~5 rows (approximately)
DELETE FROM `brand`;
/*!40000 ALTER TABLE `brand` DISABLE KEYS */;
INSERT INTO `brand` (`id`, `name`, `alias`, `tagline`, `manufacturer_id`, `distributor_id`, `year_started`, `started_approx`, `year_ended`, `ended_approx`, `notes`) VALUES
	(1, 'Courtenay', 'courtenay', 'Known For Tone', 3, 1, '1930', 0, '1956', 0, '<p>Coutenay was the original brand name of Radio Corp N.Z. (then known as W. Marks Ltd), and was distributed through Stewart Hardware in Courtenay Place (Wellington) - most likely where the name came from.</p><p>After Stewart Hardware shut its doors, Courtenay Radio Ltd was formed in 1933 to distribute the receivers, and then in 1934 Turnbull and Jones Ltd took over distribution, which they held until they pulled out of the radio market in 1956.</p>'),
	(2, 'Columbus', 'columbus', NULL, 3, 2, '1937', 0, '1960', 0, 'The in-house brand of Radio Corp. N.Z.'),
	(3, 'Pacific', 'pacific', 'In A Sphere Of Its Own', 3, 3, '1933', 0, '1937', 1, '<p>Pacific sets were built initially as special runs for Pacific Radio Co. Ltd by Radio Corp. N.Z. and then as standard RCNZ chassis models from around 1935/36.</p><p>Pacific sets from the early-mid 30\'s were known for their art-deco styling - in particular the 1934/35 \'Elite\' console, which is considered very rare and the envy of most collectors.</p><table><tbody><tr><td> <a class="gallery" title="The Pacific Elite Console - envy of all NZ collectors" href="/static/images/models/pacific/elite1.jpg"><img class="inline_image" src="/static/images/models/pacific/elite1.thumb.jpg" alt="Pacific Elite Console 1934/35" /></a></td></tr><tr><td>The world-famous \'Elite\' console</td></tr></tbody></table><p>There are later (post WWII) sets branded Pacific, however these were built by Akrad who took over the name and branding after the demise of the owner of the original brand.</p>'),
	(4, 'Pacific (post-WWII)', 'pacific_new', 'In A Sphere Of Its Own', 1, 3, '1945', 1, NULL, 1, '<p>Pacific Radio Co. Ltd ceased trading due to the demise of the owner, and the brand and signature line were taken over by Akrad Radio Ltd in Waihi when radio production resumed after WWII.</p><p>Many Pacific models from Akrad were also released under the Regent brand name.</p>'),
	(5, 'Clipper', 'clipper', NULL, 1, 0, '1954', 1, NULL, 0, 'Clipper was introduced some time in the 50\'s as another brand in the Akrad stable'),
	(6, 'Well-Mayde', 'well_mayde', NULL, 5, 5, '1929', 0, NULL, 0, '<p>The brand name Well-Mayde was established by Johns Ltd in Auckland, and products were manufactured by their factory, Wellmade Ltd.</p>');
/*!40000 ALTER TABLE `brand` ENABLE KEYS */;

-- Dumping structure for table nzvr_db.distributor
DROP TABLE IF EXISTS `distributor`;
CREATE TABLE IF NOT EXISTS `distributor` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `alias` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT 'This field is for the url, logo img etc - hence unique',
  `address` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT 'Address, or town / city company was located in',
  `notes` longtext CHARACTER SET utf8 NOT NULL COMMENT 'Details about the distributor',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Dumping data for table nzvr_db.distributor: ~4 rows (approximately)
DELETE FROM `distributor`;
/*!40000 ALTER TABLE `distributor` DISABLE KEYS */;
INSERT INTO `distributor` (`id`, `name`, `alias`, `address`, `notes`) VALUES
	(1, 'Turnbull and Jones Ltd', 'turnbull_and_jones', 'Wellington', 'Turnbull and Jones were tied up with RCNZ, supplying high quality radio manufacturing parts to them.'),
	(2, 'Radio Centre Ltd', 'radio_centre', 'Nationwide', 'Set up by RCNZ to distribute their house brand, Columbus'),
	(3, 'A. H. Nathan Ltd', 'a_h_nathan', 'Auckland', 'If you remember A. H. Nathan, contact me with some details for this page'),
	(5, 'Johns Ltd', 'johns', 'Auckland', 'Set up in 1920, slogan -Aucklands Oldest Radio Firm-.  Set up by Clive and Victor Johns, returned soldiers from WW1.  Started by importing and selling radio components, then kitsets.  Had distributorship for U.S. made Hammarlund coils and tuning condensers.  They started manufacturing radios - Altona, Ace and Meniwave.  Formed a new manufacturing co called Wellmayde Ltd making radios under the Well Mayde name. In 1930 1ZJ came on the air - Johns Ltds own radio station. More to come...');
/*!40000 ALTER TABLE `distributor` ENABLE KEYS */;

-- Dumping structure for table nzvr_db.manufacturer
DROP TABLE IF EXISTS `manufacturer`;
CREATE TABLE IF NOT EXISTS `manufacturer` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `alias` varchar(50) NOT NULL COMMENT 'This field is for the url, logo img etc - hence unique',
  `address` varchar(255) NOT NULL COMMENT 'Address, or town / city company was located in',
  `year_started` year(4) NOT NULL COMMENT 'Year started manufactuing if known',
  `year_started_approx` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Start year approximate',
  `year_ended` year(4) NOT NULL COMMENT 'Year ended manufactuing if known',
  `year_ended_approx` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'End year approximate',
  `notes` longtext NOT NULL COMMENT 'Details about the manufacturer',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- Dumping data for table nzvr_db.manufacturer: ~5 rows (approximately)
DELETE FROM `manufacturer`;
/*!40000 ALTER TABLE `manufacturer` DISABLE KEYS */;
INSERT INTO `manufacturer` (`id`, `name`, `alias`, `address`, `year_started`, `year_started_approx`, `year_ended`, `year_ended_approx`, `notes`) VALUES
	(1, 'Akrad Radio Corporation Ltd', 'akrad', 'Waihi', '1934', 0, '1982', 0, '<p>Akrad Radio was formed in Waihi by Keith M. Wrigley when he was just 18.</p><p>Notable brand names produced by Akrad include Pacific (the brand name was taken over in approximately 1940 after the demise of the original Pacific Radio Co.), Regent and Clipper.</p>'),
	(2, 'His Master\'s Voice (N.Z.) Ltd', 'hmv', 'Wellington', '1940', 0, '1955', 0, '<p>Pre-war HMV sets were almost all imported.  After the war most sets were made in their Wellington factory with a few exceptions being made by various other manufacturers (mainly Collier and Beale)</p>'),
	(3, 'Radio Corporation of New Zealand', 'rcnz', 'Wellington', '1934', 0, '1959', 0, '<p>One of the biggest radio manufacturers in NZ - they build a lot of their own components in-house.</p><p>Brands manufactured include Columbus, Courtenay, Stella, Pacific, CQ, Acme, Troubador and more...</p>'),
	(4, 'Dominion Radio & Electrical Corp. Ltd', 'dreco', 'Dominion Rd, Auckland', '1939', 0, '1980', 0, 'DRECO brands included Philco (who the company was originally set up to manufacture), La Gloria, Majestic...'),
	(5, 'Wellmade Ltd', 'wellmade', 'Auckland', '1928', 0, '1956', 1, '<p>Wellmade Ltd was set up by Johns Ltd as a manufacturing factory for the various brands that Johns produced such as Ace, Altona and Well-Mayde</p>');
/*!40000 ALTER TABLE `manufacturer` ENABLE KEYS */;

-- Dumping structure for table nzvr_db.radio
DROP TABLE IF EXISTS `radio`;
CREATE TABLE IF NOT EXISTS `radio` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL COMMENT 'May not exist (ie: Pacific 516) - often the names can be found in old print adverts',
  `number` varchar(50) DEFAULT NULL COMMENT 'May not exist (ie: Philco Alabama)',
  `start_year` year(4) DEFAULT NULL,
  `start_year_approx` tinyint(3) unsigned DEFAULT '0',
  `end_year` year(4) DEFAULT NULL,
  `end_year_approx` tinyint(3) unsigned DEFAULT '0',
  `valve_lineup` varchar(100) DEFAULT NULL,
  `brand_id` int(11) unsigned NOT NULL COMMENT 'All sets must have a brand, this ties them back to a manufacturer',
  `notes` longtext COMMENT 'Information about this set',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table nzvr_db.radio: ~3 rows (approximately)
DELETE FROM `radio`;
/*!40000 ALTER TABLE `radio` DISABLE KEYS */;
INSERT INTO `radio` (`id`, `name`, `number`, `start_year`, `start_year_approx`, `end_year`, `end_year_approx`, `valve_lineup`, `brand_id`, `notes`) VALUES
	(1, NULL, '5M4', '1954', 0, '1956', 1, 'ECH42 EF41 EBC41 EL41 EZ40', 5, '<p>The first plastic-cased radio to be fully designed and built in New Zealand.</p><p>There are two known variants - the earlier one is distinguishable by its round IF cans and no resistors soldered on the speaker.</p><p>Colours include ivory, blue, green, red, and the very rare black.</p>'),
	(2, 'Raleigh', '6 Valve Dual Wave', '1934', 0, '1935', 0, '6D6 6A7 6D6 6B7 42 80', 3, '<p>Art deco tabletop radio from 1934</p>'),
	(3, 'Elite', '6 Valve Dual Wave', '1934', 0, '1935', 0, '6D6 6A7 6D6 6B7 42 80', 3, '<p>Stunning art deco console from 1934</p>');
/*!40000 ALTER TABLE `radio` ENABLE KEYS */;

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

-- Dumping data for table nzvr_db.user: ~0 rows (approximately)
DELETE FROM `user`;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`user_id`, `date_joined`, `username`, `email`, `password`) VALUES
	(1, 1481185199, 'admin', 'nzvr_admin@essentialtech.co.nz', '13601bda4ea78e55a07b98866d2be6be0744e3866f13c00c811cab608a28f322');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;