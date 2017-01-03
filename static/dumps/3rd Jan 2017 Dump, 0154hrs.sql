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

-- Dumping data for table nzvr_db.adverts: ~0 rows (approximately)
DELETE FROM `adverts`;
/*!40000 ALTER TABLE `adverts` DISABLE KEYS */;
/*!40000 ALTER TABLE `adverts` ENABLE KEYS */;

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

-- Dumping data for table nzvr_db.brand: ~5 rows (approximately)
DELETE FROM `brand`;
/*!40000 ALTER TABLE `brand` DISABLE KEYS */;
INSERT INTO `brand` (`id`, `name`, `alias`, `tagline`, `manufacturer_id`, `distributor_id`, `year_started`, `year_started_approx`, `year_ended`, `year_ended_approx`, `notes`) VALUES
	(1, 'Courtenay', 'courtenay', 'Known For Tone', 3, 1, '1930', 0, '1956', 0, '<p>Coutenay was the original brand name of Radio Corp N.Z. (then known as W. Marks Ltd), and was distributed through Stewart Hardware in Courtenay Place (Wellington) - most likely where the name came from.</p><p>After Stewart Hardware shut its doors, Courtenay Radio Ltd was formed in 1933 to distribute the receivers, and then in 1934 Turnbull and Jones Ltd took over distribution, which they held until they pulled out of the radio market in 1956.</p>'),
	(2, 'Columbus', 'columbus', NULL, 3, 2, '1937', 0, '1960', 0, 'Columbus was the house-brand for Radio Corp. of NZ.'),
	(3, 'Pacific', 'pacific', 'In A Sphere Of Its Own', 3, 0, '1933', 0, '1937', 1, '<p>Pacific sets were built initially as special runs for Pacific Radio Co. Ltd by Radio Corp. N.Z., and then as standard RCNZ chassis models from around 1935/36.</p><p>Pacific sets from the early-mid 30\'s were known for their art-deco styling - in particular the 1934/35 \'Elite\' console, which is considered very rare and the envy of most collectors.</p><table><tbody><tr><td> <a class="gallery" title="The Pacific Elite Console" href="/static/images/model/pacific/6 valve dual wave/elite/elite.jpg"><img class="inline_image" src="/static/images/model/pacific/6 valve dual wave/elite/thumbs/elite.jpg" alt="Pacific Elite Console 1934/35" /></a></td></tr><tr><td>The world-famous \'Elite\' console</td></tr></tbody></table><p>There are later (post WWII) sets branded Pacific, however these were built by Akrad who took over the name and branding after the demise of the owner of the original brand.</p>'),
	(4, 'Pacific (post-WWII)', 'pacific_new', 'In A Sphere Of Its Own', 1, 3, '1945', 1, NULL, 1, '<p>Pacific Radio Co. Ltd ceased trading due to the demise of the owner, and the brand and signature line were taken over by Akrad Radio Ltd in Waihi when radio production resumed after WWII.</p><p>Many Pacific models from Akrad were also released under the Regent brand name.</p>'),
	(5, 'Clipper', 'clipper', NULL, 1, 0, '1954', 1, NULL, 0, '<p>Clipper was one of the brands in the Akrad stable, found on both car and home radios, and even radiograms</p>'),
	(6, 'Well-Mayde', 'well_mayde', NULL, 5, 5, '1929', 0, NULL, 0, '<p>The brand name Well-Mayde was established by Johns Ltd in Auckland, and products were manufactured by their factory, Wellmade Ltd.</p>'),
	(7, 'Pathfinder', 'pathfinder', NULL, 1, 0, NULL, 0, NULL, 0, '<p>One of the Akrad brands - possibly also Westonhouse?</p>'),
	(8, 'Stella', 'stella', 'Proudly Made - Proudly Owned', 3, 0, '1933', 1, '1938', 1, '<p>Stella - one of the main private brand sets manufacturerd by RCNZ.  It seems 1937 may have been the last year of RCNZ models, but there were sets in 1938 under the Stella name manufacturered (it seems) by Collier and Beale.  Does anyone know the tie up here?  Was it a new company, just a new brand, or did Stella move to C&B after RCNZ finished up building private brand sets?</p>');
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
	(3, 'A. H. Nathan Ltd', 'a_h_nathan', 'Auckland', '<p>Arthur H Nathan Ltd was an importer and distributor in Auckland.  They appear to have been one of the HMV distributors, but also sold later model Pacific sets from Akrad</p><img class="brand_image" src="/static/images/distributors/ahnathan.jpg" /><p>If you have any more details to share, please contact the admin with them.</p>'),
	(5, 'Johns Ltd', 'johns', 'Auckland', 'Set up in 1920, slogan -Aucklands Oldest Radio Firm-.  Set up by Clive and Victor Johns, returned soldiers from WW1.  Started by importing and selling radio components, then kitsets.  Had distributorship for U.S. made Hammarlund coils and tuning condensers.  They started manufacturing radios - Altona, Ace and Meniwave.  Formed a new manufacturing co called Wellmayde Ltd making radios under the Well Mayde name. In 1930 1ZJ came on the air - Johns Ltds own radio station. More to come...');
/*!40000 ALTER TABLE `distributor` ENABLE KEYS */;

-- Dumping structure for table nzvr_db.images
DROP TABLE IF EXISTS `images`;
CREATE TABLE IF NOT EXISTS `images` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT 'Title of the file shown in the browser',
  `path` varchar(100) NOT NULL COMMENT 'path to the file',
  `type` tinyint(3) unsigned NOT NULL COMMENT '1=radio, 2=brand, 3=manufacturer, 4=distributor',
  `type_id` int(10) unsigned NOT NULL COMMENT 'which item it belongs to',
  `is_schematic` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Is this image a schematic',
  `rank` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='locations and descriptions of images used on the site\r\n';

-- Dumping data for table nzvr_db.images: ~20 rows (approximately)
DELETE FROM `images`;
/*!40000 ALTER TABLE `images` DISABLE KEYS */;
INSERT INTO `images` (`id`, `name`, `path`, `type`, `type_id`, `is_schematic`, `rank`) VALUES
	(1, 'Clipper 5M4 Front', '/images/model/clipper/5m4/clipper_5m4_front.jpg', 1, 1, b'0', 1),
	(2, 'Clipper 5M4 Side', '/images/model/clipper/5m4/clipper_5m4_lside.jpg', 1, 1, b'0', 2),
	(3, 'Clipper 5M4 Dial', '/images/model/clipper/5m4/clipper_5m4_dial.jpg', 1, 1, b'0', 3),
	(4, 'Clipper 5M4 Rear', '/images/model/clipper/5m4/clipper_5m4_rear.jpg', 1, 1, b'0', 4),
	(5, 'Clipper 5M4 Rear 2', '/images/model/clipper/5m4/clipper_5m4_rear_label.jpg', 1, 1, b'0', 5),
	(7, 'Clipper 5M4 Schematic (early)', '/images/model/clipper/5m4/clipper_5m4_schematic.png', 1, 1, b'1', 30),
	(8, 'Clipper 5M4 Label', '/images/model/clipper/5m4/clipper_5m4_label.png', 1, 1, b'0', 29),
	(9, 'Clipper 5M4 Red', '/images/model/clipper/5m4/clipper_5m4_red.jpg', 1, 1, b'0', 9),
	(10, 'Clipper 5M4 Blue', '/images/model/clipper/5m4/clipper_5m4_blue.jpg', 1, 1, b'0', 8),
	(11, 'Clipper 5M4 Green', '/images/model/clipper/5m4/clipper_5m4_green.jpg', 1, 1, b'0', 7),
	(12, 'Clipper 5M4 Brown', '/images/model/clipper/5m4/clipper_5m4_brown.jpg', 1, 1, b'0', 10),
	(13, 'Clipper 5M4 Ivory', '/images/model/clipper/5m4/clipper_5m4_ivory.jpg', 1, 1, b'0', 6),
	(14, 'Clipper 5M4 Black (RARE)', '/images/model/clipper/5m4/clipper_5m4_black.jpg', 1, 1, b'0', 11),
	(15, 'Pacific Raleigh Dual Wave', '/images/model/pacific/6 valve dual wave/raleigh/20160320_144502.jpg', 1, 2, b'0', 2),
	(16, 'Pacific Raleigh Dual Wave Dial', '/images/model/pacific/6 valve dual wave/raleigh/20160322_104320.jpg', 1, 2, b'0', 3),
	(17, 'Pacific Raleigh Dual Wave Valve Card', '/images/model/pacific/6 valve dual wave/raleigh/20160322_104136.jpg', 1, 2, b'0', 4),
	(18, 'Pacific Raleigh Dual Wave Front', '/images/model/pacific/6 valve dual wave/raleigh/20160322_104306.jpg', 1, 2, b'0', 1),
	(19, 'Pacific Raleigh Dual Wave Advert', '/images/model/pacific/6 valve dual wave/raleigh/Pacific Raleigh 6-valve advert.png', 1, 2, b'0', 5),
	(20, 'Pacific 6 Valve Dual Wave Schematic', '/images/model/pacific/6 valve dual wave/raleigh/Pacific 6-Valve Dual-Wave Schematic.png', 1, 2, b'1', 30),
	(21, 'Pacific Elite', '/images/model/pacific/6 valve dual wave/elite/elite.jpg', 1, 3, b'0', 1);
/*!40000 ALTER TABLE `images` ENABLE KEYS */;

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
  `became` int(10) unsigned DEFAULT NULL COMMENT 'If this company merged into or renamed itself, add the id of the new company here',
  `notes` longtext NOT NULL COMMENT 'Details about the manufacturer',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- Dumping data for table nzvr_db.manufacturer: ~6 rows (approximately)
DELETE FROM `manufacturer`;
/*!40000 ALTER TABLE `manufacturer` DISABLE KEYS */;
INSERT INTO `manufacturer` (`id`, `name`, `alias`, `address`, `year_started`, `year_started_approx`, `year_ended`, `year_ended_approx`, `became`, `notes`) VALUES
	(1, 'Akrad Radio Corporation Ltd', 'akrad', 'Waihi', '1934', 0, '1982', 0, NULL, '<p>Akrad Radio was formed in Waihi by Keith M. Wrigley when he was just 18.</p><p>Notable brand names produced by Akrad include Pacific (the brand name was taken over in approximately 1940 after the demise of the original Pacific Radio Co.), Regent and Clipper.</p>'),
	(2, 'His Master\'s Voice (N.Z.) Ltd', 'hmv', 'Wellington', '1940', 0, '1955', 0, NULL, '<p>Pre-war HMV sets were almost all imported.  After the war most sets were made in their Wellington factory with a few exceptions being made by various other manufacturers (mainly Collier and Beale)</p>'),
	(3, 'Radio Corporation of New Zealand', 'rcnz', 'Wellington', '1932', 0, '1959', 0, 7, '<p>Originally known as <a href="/manufacturer/w_marks">W. Marks Ltd</a>, RCNZ became one of the largest radio manufacturers in NZ.  In around 1937, with the introduction of the house brand Columbus, RCNZ started moving away from producing \'private brand\' sets and within a couple of years was only manufacturing receivers under the names <a href="\r\n/brand/columbus">Columbus</a> and <a href="\r\n/brand/courtenay">Courtenay</a>.</p><p>RCNZ built a lot of their own components in-house, including capacitors and speakers.</p><p>Brands manufactured include <a href="\r\n/brand/columbus">Columbus</a>, <a href="\r\n/brand/courtenay">Courtenay</a>, <a href="\r\n/brand/stella">Stella</a>, <a href="\r\n/brand/pacific">Pacific</a>, <a href="\r\n/brand/cq">CQ</a>, <a href="\r\n/brand/acme">Acme</a>, <a href="\r\n/brand/troubador">Troubador</a> and more...</p>'),
	(4, 'Dominion Radio & Electrical Corp. Ltd', 'dreco', 'Dominion Rd, Auckland', '1939', 0, '1980', 0, NULL, 'DRECO brands included Philco (who the company was originally set up to manufacture), La Gloria, Majestic...'),
	(5, 'Wellmade Ltd', 'wellmade', 'Auckland', '1928', 0, '1956', 1, NULL, '<p>Wellmade Ltd was set up by Johns Ltd as a manufacturing factory for the various brands that Johns produced such as Ace, Altona and Well-Mayde</p>'),
	(6, 'W. Marks Ltd', 'w_marks', 'Wellington', '1931', 0, '1932', 0, 3, '<p>The business was started in 1930 by Russian immigrant William Markoff (later changed to Willam Marks) to wind / rewind transformers and make amplifiers.  By 1931 he had formed the company that would go on to be one of the largest and most successful  New Zealand radio manufacturers of its day, and it seems this was his plan all along when in 1932 he changed the company name to <a href="/manufacturer/rcnz">Radio Corporation (N. Z.) Ltd</a></p>'),
	(7, 'Pye (N.Z.) Ltd', 'pye', 'Waihi', '1962', 0, '1982', 0, NULL, '<p>The New Zealand branch of Pye Ltd from Cambridge, England</p>');
/*!40000 ALTER TABLE `manufacturer` ENABLE KEYS */;

-- Dumping structure for table nzvr_db.model
DROP TABLE IF EXISTS `model`;
CREATE TABLE IF NOT EXISTS `model` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `variant` varchar(50) DEFAULT NULL COMMENT 'May not exist (ie: Pacific 516) - often the names can be found in old print adverts',
  `code` varchar(50) DEFAULT NULL COMMENT 'May not exist (ie: Philco Alabama)',
  `start_year` year(4) DEFAULT NULL,
  `start_year_approx` tinyint(3) unsigned DEFAULT '0',
  `end_year` year(4) DEFAULT NULL,
  `end_year_approx` tinyint(3) unsigned DEFAULT '0',
  `num_valves` smallint(5) unsigned DEFAULT NULL COMMENT 'Number of valves if known, otherwise leave blank',
  `valve_lineup` varchar(100) DEFAULT NULL,
  `bands` tinyint(3) unsigned DEFAULT NULL COMMENT 'Number of bands (ie: DW = 2)',
  `brand_id` int(11) unsigned NOT NULL COMMENT 'All sets must have a brand, this ties them back to a manufacturer',
  `notes` longtext COMMENT 'Information about this set',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table nzvr_db.model: ~3 rows (approximately)
DELETE FROM `model`;
/*!40000 ALTER TABLE `model` DISABLE KEYS */;
INSERT INTO `model` (`id`, `variant`, `code`, `start_year`, `start_year_approx`, `end_year`, `end_year_approx`, `num_valves`, `valve_lineup`, `bands`, `brand_id`, `notes`) VALUES
	(1, NULL, '5M4', '1954', 0, '1956', 1, 5, 'ECH42, EF41, EBC41, EL41, EZ40', NULL, 5, '<p>The Clipper 5M4 was the first plastic radio to be fully designed and manufactured in New Zealand (other models of this size existed - the Bell Colt for example - but they used imported dies for the cabinet).  Akrad designed and manufactured the mold for their cabinet.Several colours were released, however ivory is by far the most common to be found.  The rarest would be black, as it is believed only a handful were made to be presented to the shareholders of the company.  Other known colours are red, blue, brown and green.</p><p>There are at least two chassis variants, both using almost the same circuit and the same valve lineup.  The earlier chassis has the serial number stamped on the back while later models have a serial plate riveted on.</p<p>Earlier models also have round IF cans, where the later models use more modern rectangular units.</p<p>The later models have a Rola 5" speaker providing feedback to the 1st audio section via a resistive divider and also have an internal foil antenna glued to the inside of the cabinet and attached by a small bolt and nut in addition to the external orange aerial wire where the earlier models have no feedback and just the external orange aerial wire (both have a black earth wire as well).</p><p>A few other minor variations have been noted, such as Ducon capacitors in the earlier models with mustard caps in the later and a metal shield over the dial lamp in the later ones to try and cut down on the amount of glow through the cabinet.</p>'),
	(2, 'Raleigh', '6 Valve Dual Wave', '1934', 0, NULL, 0, 6, '6D6, 6A7, 6D6, 6B7, 42, 80', NULL, 3, '<p>Art deco tabletop radio from 1934</p>'),
	(3, 'Elite', '6 Valve Dual Wave', '1934', 0, NULL, 0, 6, '6D6, 6A7, 6D6, 6B7, 42, 80', NULL, 3, '<p>Stunning art deco console from 1934</p>');
/*!40000 ALTER TABLE `model` ENABLE KEYS */;

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
