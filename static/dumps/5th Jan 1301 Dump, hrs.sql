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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

-- Dumping data for table nzvr_db.brand: ~11 rows (approximately)
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
	(8, 'Stella', 'stella', 'Proudly Made - Proudly Owned', 3, 0, '1933', 1, '1938', 1, '<p>Stella - one of the main private brand sets manufacturerd by RCNZ.  It seems 1937 may have been the last year of RCNZ models, but there were sets in 1938 under the Stella name manufacturered (it seems) by Collier and Beale.  Does anyone know the tie up here?  Was it a new company, just a new brand, or did Stella move to C&B after RCNZ finished up building private brand sets?</p>'),
	(9, 'Philco', 'philco', 'A Musical Instrument of Quality', 4, 0, '1930', 0, '1962', 1, '<p>Philco as a brand in New Zealand started in 1930 when Chas Begg & Co. Ltd imported radios direct from America - Philco being one of the few US manufacturers to produce export sets with 230V transformers.</p>\r\n<p>By 1938, import restrictions meant that only chassis\' were being imported, and the cabinets were made locally.  This didn\'t last very long before Dominion Radio and Electrical was set up as a New Zealand franchise and Philco sets were being produced here lock, stock and barrel.</p>'),
	(10, 'Bell', 'bell', NULL, 8, 0, '1952', 0, '1980', 0, '<p>Bell was the mainstay brand name of Bell Radio-Television Corp., found on portables, bookshelf radios, table radios, radiograms, televisions and more from the early 50\'s until the 80\'s when Bell ceased production</p>'),
	(11, 'General', 'general', NULL, 8, 0, '1962', 0, NULL, 0, '<p>General radios were a Bell Radio-Television Corp. brand, made in Japan by Yaou Radio Mfg. Co.  They never fully caught on in NZ despite being pushed heavily by Bell, and according to John Stokes the 7-pin Japanese valves used were unreliable by comparison to the modern noval valves being used in the <a href="/colt">colt</a> at the time.</p>'),
	(12, 'Fountain', 'fountain', NULL, 9, 0, '1963', 1, '1983', 1, '<p>Fountain radios and radiograms were reasonably common in the transistor era, but they also produced radios prior to this, including at least one model based on the Bell Colt - the <a href="/o.a.">Fountain O.A. Marine Band</a> radio</p>');
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
  `title` varchar(50) NOT NULL COMMENT 'Title of the file shown in the browser',
  `filename` varchar(100) NOT NULL COMMENT 'path to the file',
  `type` tinyint(3) unsigned NOT NULL COMMENT '1=radio, 2=brand, 3=manufacturer, 4=distributor',
  `type_id` int(10) unsigned NOT NULL COMMENT 'which item it belongs to',
  `is_schematic` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Is this image a schematic',
  `rank` int(11) DEFAULT '99' COMMENT '1=highest priority',
  `attribution` varchar(100) DEFAULT NULL COMMENT 'If (c) then add details here',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8 COMMENT='locations and descriptions of images used on the site\r\n';

-- Dumping data for table nzvr_db.images: ~89 rows (approximately)
DELETE FROM `images`;
/*!40000 ALTER TABLE `images` DISABLE KEYS */;
INSERT INTO `images` (`id`, `title`, `filename`, `type`, `type_id`, `is_schematic`, `rank`, `attribution`) VALUES
	(1, 'Clipper 5M4 Front', 'clipper_5m4_front.jpg', 1, 1, b'0', 1, NULL),
	(2, 'Clipper 5M4 Side', 'clipper_5m4_lside.jpg', 1, 1, b'0', 2, NULL),
	(3, 'Clipper 5M4 Dial', 'clipper_5m4_dial.jpg', 1, 1, b'0', 3, NULL),
	(4, 'Clipper 5M4 Rear', 'clipper_5m4_rear.jpg', 1, 1, b'0', 4, NULL),
	(5, 'Clipper 5M4 Rear 2', 'clipper_5m4_rear_label.jpg', 1, 1, b'0', 5, NULL),
	(7, 'Clipper 5M4 Schematic (early)', 'clipper_5m4_schematic.png', 1, 1, b'1', 30, NULL),
	(8, 'Clipper 5M4 Label', 'clipper_5m4_label.png', 1, 1, b'0', 29, NULL),
	(9, 'Clipper 5M4 Red', 'clipper_5m4_red.jpg', 1, 1, b'0', 9, NULL),
	(10, 'Clipper 5M4 Blue', 'clipper_5m4_blue.jpg', 1, 1, b'0', 8, NULL),
	(11, 'Clipper 5M4 Green', 'clipper_5m4_green.jpg', 1, 1, b'0', 7, NULL),
	(12, 'Clipper 5M4 Brown', 'clipper_5m4_brown.jpg', 1, 1, b'0', 10, NULL),
	(13, 'Clipper 5M4 Ivory', 'clipper_5m4_ivory.jpg', 1, 1, b'0', 6, NULL),
	(14, 'Clipper 5M4 Black (RARE)', 'clipper_5m4_black.jpg', 1, 1, b'0', 11, NULL),
	(15, 'Pacific Raleigh ', '20160320_144502.jpg', 1, 2, b'0', 2, NULL),
	(16, 'Pacific Raleigh Dial', '20160322_104320.jpg', 1, 2, b'0', 3, NULL),
	(17, 'Pacific Raleigh Valve Card', '20160322_104136.jpg', 1, 2, b'0', 4, NULL),
	(18, 'Pacific RaleighFront', '20160322_104306.jpg', 1, 2, b'0', 1, NULL),
	(19, 'Pacific Raleigh Advert', 'Pacific Raleigh 6-valve advert.png', 1, 2, b'0', 5, NULL),
	(20, 'Pacific 6 Valve Dual Wave Schematic', 'Pacific 6-Valve Dual-Wave Schematic.png', 1, 2, b'1', 30, NULL),
	(21, 'Pacific Elite', 'elite.jpg', 1, 3, b'0', 1, NULL),
	(46, 'Pacific Elite', '20161005_102450.jpg', 1, 3, b'0', 7, NULL),
	(47, 'Pacific Elite', '20161005_150428.jpg', 1, 3, b'0', 6, NULL),
	(48, 'Pacific Elite', '20161005_161012.jpg', 1, 3, b'0', 8, NULL),
	(49, 'Pacific Elite', 'chassis badge.jpg', 1, 3, b'0', 9, NULL),
	(50, 'Pacific Elite', 'DSC00024.jpg', 1, 3, b'0', 4, NULL),
	(51, 'Pacific Elite', 'DSC00025.jpg', 1, 3, b'0', 5, NULL),
	(52, 'Pacific Elite', 'IMG_20161005_164726.jpg', 1, 3, b'0', 2, NULL),
	(53, 'Pacific Elite', 'IMG_20161005_171653.jpg', 1, 3, b'0', 3, NULL),
	(54, 'Philco Alabama', '20160718_105116.jpg', 1, 4, b'0', 99, NULL),
	(55, 'Philco Alabama', '20160718_105400.jpg', 1, 4, b'0', 99, NULL),
	(56, 'Under Chassis 1', '20160718_105542.jpg', 1, 4, b'0', 99, NULL),
	(57, 'Under Chassis 2', '20160718_105549.jpg', 1, 4, b'0', 99, NULL),
	(58, 'Grey Cabinet', '20160719_143549.jpg', 1, 4, b'0', 99, NULL),
	(59, 'Philco Alabama', 'Dads philco 401 alabama front after restoration.jpg', 1, 4, b'0', 1, NULL),
	(60, 'Chassis Under Original', 'Dads philco 401 alabama Full_chassis_before.jpg', 1, 4, b'0', 99, NULL),
	(61, 'Philco Alabama', 'Dads philco 401 alabama rear after restoration.jpg', 1, 4, b'0', 99, NULL),
	(62, 'Philco Alabama', 'LaGloria_PhilcoSiesta.jpg', 1, 4, b'1', 100, NULL),
	(63, 'Philco 401', '463396333.jpg', 1, 5, b'0', 180, NULL),
	(64, 'Philco 401', '463396384.jpg', 1, 5, b'0', 1, NULL),
	(65, 'Philco 401', '463396440.jpg', 1, 5, b'0', 99, NULL),
	(66, 'Philco 401', '463396563.jpg', 1, 5, b'0', 99, NULL),
	(67, 'Philco 401', '463396643.jpg', 1, 5, b'0', 99, NULL),
	(68, 'Philco 401', '463396663.jpg', 1, 5, b'0', 99, NULL),
	(69, 'Philco 401', '463396748.jpg', 1, 5, b'0', 182, NULL),
	(70, 'Philco Nevada', '523928129.jpg', 1, 5, b'0', 200, NULL),
	(71, 'Courtenay 5M', '20141225_164116.jpg', 1, 6, b'0', 99, NULL),
	(72, 'Courtenay 5M', '20141225_164141.jpg', 1, 6, b'0', 99, NULL),
	(73, 'Courtenay 5M', 'Back_nearly_finished.jpg', 1, 6, b'0', 99, NULL),
	(74, 'Courtenay 5M', 'Chassis-underside-before.jpg', 1, 6, b'0', 99, NULL),
	(75, 'Courtenay model 5M', 'courtenay_5m_front.jpg', 1, 6, b'0', 1, NULL),
	(76, 'Courtenay 5M', 'Front_nearly_finished.jpg', 1, 6, b'0', 99, NULL),
	(77, 'Courtenay 5M', 'courtenay talisman.png', 1, 6, b'0', 99, NULL),
	(78, 'Courtenay 5M', 'Valve Lineup and Chassis Layout.png', 1, 6, b'0', 99, NULL),
	(79, 'Philco Alabama', 'philco-alabama-401-1-281212.jpg', 1, 4, b'0', 99, NULL),
	(80, 'Bell Colt Ivory', '1.jpg', 1, 7, b'0', 1, NULL),
	(81, 'Bell Colt Grey', '2.jpg', 1, 7, b'0', 2, NULL),
	(82, 'Bell Colt', '20160530_173204.jpg', 1, 7, b'0', 99, NULL),
	(83, 'Bell Colt Green', '3.jpg', 1, 7, b'0', 3, NULL),
	(84, 'Bell Colt Blue', '4.jpg', 1, 7, b'0', 4, NULL),
	(85, 'Bell Colt', '463398315.jpg', 1, 7, b'0', 99, NULL),
	(86, 'Bell Colt', '474769580.jpg', 1, 7, b'0', 99, NULL),
	(87, 'Bell Colt', '475877334.jpg', 1, 7, b'0', 99, NULL),
	(88, 'Bell Colt', '477166182.jpg', 1, 7, b'0', 99, NULL),
	(89, 'Bell Colt', '481688135.jpg', 1, 7, b'0', 99, NULL),
	(90, 'Bell Colt', '496270634.jpg', 1, 7, b'0', 99, NULL),
	(91, 'Bell Colt Red', '5.jpg', 1, 7, b'0', 5, NULL),
	(92, 'Bell Colt', '507080079 (1).jpg', 1, 7, b'0', 99, NULL),
	(93, 'Bell Colt', '507227168.jpg', 1, 7, b'0', 99, NULL),
	(94, 'Bell Colt', '507978318.jpg', 1, 7, b'0', 99, NULL),
	(95, 'Bell Colt', '514050907.jpg', 1, 7, b'0', 99, NULL),
	(96, 'Bell Colt', '540490991.jpg', 1, 7, b'0', 99, NULL),
	(97, 'Bell Colt Brown', '6.jpg', 1, 7, b'0', 6, NULL),
	(98, 'Bell Colt Black', '7.jpg', 1, 7, b'0', 7, NULL),
	(99, 'Bell Colt Oak', '8.jpg', 1, 7, b'0', 8, NULL),
	(100, 'Bell Colt BC / SW', 'dual-wave.jpg', 1, 7, b'0', 101, NULL),
	(101, 'Bell Colt', '5B4j.jpg', 1, 7, b'1', 102, NULL),
	(102, 'Bell Colt', '5B60.jpg', 1, 7, b'1', 103, NULL),
	(103, 'Bell Colt', '5B61.jpg', 1, 7, b'1', 104, NULL),
	(104, 'Bell Colt', '5B67.jpg', 1, 7, b'1', 105, NULL),
	(105, 'Bell Colt 3V Champ', 'three valve chassis.jpg', 1, 7, b'0', 99, NULL),
	(106, 'Bell Explorer', '1.jpg', 1, 8, b'0', 99, NULL),
	(107, 'Bell Explorer', '2.jpg', 1, 8, b'0', 99, NULL),
	(108, 'Bell Explorer', '3.jpg', 1, 8, b'0', 99, NULL),
	(109, 'Bell Explorer', 'dual-wave.jpg', 1, 8, b'0', 99, NULL),
	(110, 'Bell Champ', '1.jpg', 1, 9, b'0', 99, NULL),
	(111, 'Bell Champ', '2.jpg', 1, 9, b'0', 99, NULL),
	(112, 'Bell Champ', '3.jpg', 1, 9, b'0', 99, NULL),
	(113, 'Bell Planet', '1.jpg', 1, 10, b'0', 99, NULL),
	(114, 'Bell Planet', '2.jpg', 1, 10, b'0', 99, NULL),
	(115, 'Fountain O.A. Marine Band', '1.jpg', 1, 11, b'0', 1, 'Paul Burt - NZVRS Magazine V21#1 Pg29');
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- Dumping data for table nzvr_db.manufacturer: ~8 rows (approximately)
DELETE FROM `manufacturer`;
/*!40000 ALTER TABLE `manufacturer` DISABLE KEYS */;
INSERT INTO `manufacturer` (`id`, `name`, `alias`, `address`, `year_started`, `year_started_approx`, `year_ended`, `year_ended_approx`, `became`, `notes`) VALUES
	(1, 'Akrad Radio Corporation Ltd', 'akrad', 'Waihi', '1934', 0, '1982', 0, NULL, '<p>Akrad Radio was formed in Waihi by Keith M. Wrigley when he was just 18.</p><p>Notable brand names produced by Akrad include Pacific (the brand name was taken over in approximately 1940 after the demise of the original Pacific Radio Co.), Regent and Clipper.</p>'),
	(2, 'His Master\'s Voice (N.Z.) Ltd', 'hmv', 'Wellington', '1940', 0, '1955', 0, NULL, '<p>Pre-war HMV sets were almost all imported.  After the war most sets were made in their Wellington factory with a few exceptions being made by various other manufacturers (mainly Collier and Beale)</p>'),
	(3, 'Radio Corporation of New Zealand', 'rcnz', 'Wellington', '1932', 0, '1959', 0, 7, '<p>Originally known as <a href="/manufacturer/w_marks">W. Marks Ltd</a>, RCNZ became one of the largest radio manufacturers in NZ.</p><p>In around 1937, with the introduction of the house brand Columbus, RCNZ started moving away from producing \'private brand\' sets and within a couple of years was only manufacturing receivers under the names <a href="\r\n/brand/columbus">Columbus</a> and <a href="\r\n/brand/courtenay">Courtenay</a>.</p><p>RCNZ built a lot of their own components in-house, including capacitors and speakers.</p><p>Brands manufactured include <a href="\r\n/brand/columbus">Columbus</a>, <a href="\r\n/brand/courtenay">Courtenay</a>, <a href="\r\n/brand/stella">Stella</a>, <a href="\r\n/brand/pacific">Pacific</a>, <a href="\r\n/brand/cq">CQ</a>, <a href="\r\n/brand/acme">Acme</a>, <a href="\r\n/brand/troubador">Troubador</a> and more...</p>'),
	(4, 'Dominion Radio & Electrical Corp. Ltd', 'dreco', 'Dominion Rd, Auckland', '1939', 0, '1975', 1, NULL, '<p>DRECO was set up in 1939 as a New Zealand franchise of the Philco brand, and immediately began producing NZ versions of many Philco models.  Often these were visually similar but very different inside.</p>\r\n<p>In 1961 Philco USA was taken over by Ford Motor Co. and DRECO replaced the Philco brand with Majestic and LaGloria (which they had been using for a few years on very similar sets to the Philco models).  At one point you could buy a Philco 401 \'Alabama\', a La Gloria \'Imp\' and a Majestic set that were all very similar in both appearance and chassis.</p>\r\n<p>In the mid-70\'s Dominion Radio and Electrical merged with Bell Radio and Television to become Consolidated Electronic Industries Ltd, ending one of New Zealands longest-running radio manufacturing companies.</p>'),
	(5, 'Wellmade Ltd', 'wellmade', 'Auckland', '1928', 0, '1956', 1, NULL, '<p>Wellmade Ltd was set up by Johns Ltd as a manufacturing factory for the various brands that Johns produced such as Ace, Altona and Well-Mayde</p>'),
	(6, 'W. Marks Ltd', 'w_marks', 'Wellington', '1931', 0, '1932', 0, 3, '<p>The business was started in 1930 by Russian immigrant William Markoff (later changed to Willam Marks) to wind / rewind transformers and make amplifiers.  By 1931 he had formed the company that would go on to be one of the largest and most successful  New Zealand radio manufacturers of its day, and it seems this was his plan all along when in 1932 he changed the company name to <a href="/manufacturer/rcnz">Radio Corporation (N. Z.) Ltd</a></p>'),
	(7, 'Pye (N.Z.) Ltd', 'pye', 'Waihi', '1962', 0, '1982', 0, NULL, '<p>The New Zealand branch of Pye Ltd from Cambridge, England</p>'),
	(8, 'Bell Radio-Television Corp.', 'bell', 'Auckland', '1950', 0, '1980', 1, NULL, '<p>Bell Radio-Television Corp sprang out of Antone Ltd after the two founding members left the company shortly after Al Bell joined.  The company ran until 1980 when it merged with <a href="/manufacturer/dreco">Dominion Radio and Electrical</a> (DRECO) to form Consolidated Industries Ltd.'),
	(9, 'Fountain Manufacturing Co. Ltd', 'fountain', 'Auckland', '1963', 0, '1983', 0, NULL, '<p>Roots as SOS Radio, changed to Tee Vee Radio Ltd, then to Fountain Radio Corporation, then to Chase Corporation before finally dying out in the early 90\'s');
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- Dumping data for table nzvr_db.model: ~10 rows (approximately)
DELETE FROM `model`;
/*!40000 ALTER TABLE `model` DISABLE KEYS */;
INSERT INTO `model` (`id`, `variant`, `code`, `start_year`, `start_year_approx`, `end_year`, `end_year_approx`, `num_valves`, `valve_lineup`, `bands`, `brand_id`, `notes`) VALUES
	(1, NULL, '5M4', '1954', 0, '1956', 1, 5, 'ECH42, EF41, EBC41, EL41, EZ40', 1, 5, '<p>The Clipper 5M4 was the first plastic radio to be fully designed and manufactured in New Zealand (other models of this size existed - the Bell Colt for example - but they used imported dies for the cabinet).  Akrad designed and manufactured the mold for their cabinet.Several colours were released, however ivory is by far the most common to be found.  The rarest would be black, as it is believed only a handful were made to be presented to the shareholders of the company.  Other known colours are red, blue, brown and green.</p><p>There are at least two chassis variants, both using almost the same circuit and the same valve lineup.  The earlier chassis has the serial number stamped on the back while later models have a serial plate riveted on.</p<p>Earlier models also have round IF cans, where the later models use more modern rectangular units.</p<p>The later models have a Rola 5" speaker providing feedback to the 1st audio section via a resistive divider and also have an internal foil antenna glued to the inside of the cabinet and attached by a small bolt and nut in addition to the external orange aerial wire where the earlier models have no feedback and just the external orange aerial wire (both have a black earth wire as well).</p><p>A few other minor variations have been noted, such as Ducon capacitors in the earlier models with mustard caps in the later and a metal shield over the dial lamp in the later ones to try and cut down on the amount of glow through the cabinet.</p>'),
	(2, 'Raleigh', '6 Valve Dual Wave', '1934', 0, NULL, 0, 6, '6D6, 6A7, 6D6, 6B7, 42, 80', 2, 3, '<p>Art deco tabletop radio from 1934</p>'),
	(3, 'Elite', '6 Valve Dual Wave', '1934', 0, NULL, 0, 6, '6D6, 6A7, 6D6, 6B7, 42, 80', 2, 3, '<p>Stunning art deco console from 1934</p>'),
	(4, NULL, 'Alabama', '1956', 1, '1961', 1, 5, 'ECH81, EF89, EBC91, EL84, EZ80', 1, 9, '<p>The Philco Alamaba is a 5-valve mantle set available in ivory, grey, green, blue, red and brown</p>\r\n<p>Almost identical to the Majestic set that replaced it after Philco disappeared as a brand in New Zealand, and almost identical to the La Gloria Imp (the main difference being the lack of louvres on the right side of the dial).</p>'),
	(5, NULL, '401', '1954', 0, NULL, 0, 4, 'ECH42, EAF42, EL41, EZ40', 1, 9, '<p>4-valve predecessor to the well-known (if not by name) <a href="/model/philco/alabama">Philco Alabama</a>.  Known in some literature as the \'Philco Nevada\'</p>'),
	(6, NULL, '5M', '1952', 0, NULL, 0, 5, '6BE6, 6BA6, 6AV6, 6AQ5, 6X4', 1, 1, '<p>Also sold as a Columbus model, this was the last small receiver ever sold under the Courtenay label - within two years Turnbull and Jones would have pulled out of the radio receiver market and the Courtenay name would be history.  This receiver was known as the \'Talisman\', after the HMS Talisman, a Triton class submarine during WW2.</p>'),
	(7, NULL, 'Colt', '1951', 0, '1980', 0, NULL, 'Various (See text)', 1, 10, '<p>The Bell Colt was the biggest-selling, longest-running and arguably the best known model of valve radio ever designed and built in New Zealand.  The ubiquitous Colt spanned almost 30 years and saw several different chassis versions with 3, 4 and 5 valves, and even included a transistorised model for the last few years of production.</p>\r\n<p>Along with different circuitry, there were many different dial layouts, 7 cabinet colours and even some different cabinet styles including two different-toned solid oak cabinets being offered.</p><p><a class=\'non_gallery\' href="/static/images/model/bell/colt/img/airzone.jpg"><img class="img_right" src="/static/images/model/bell/colt/img/airzone.jpg" title="Airzone Cub (Aus.)"/></a>As a side note, the plastic cabinet dies came from Australia where they were used for the Airzone Cub.  The Cub only has 2 controls, so the centre (tone) control on the Colt was drilled through where the name plate was.</p>\r\n<p><a class=\'non_gallery\' title="Push-On Plastic Knobs" href="/static/images/model/bell/colt/img/pushon.jpg"><img class="img_left" src="/static/images/model/bell/colt/img/pushon.jpg" title="Push-On Plastic Knobs"/></a>There are also two different control versions - one has recessed shafts with push-on plastic knobs, and these can be an absolute nightmare to remove if there is <b>any</b> hint of corrosion on the shaft (sometimes needing to be broken off).  <a class=\'non_gallery\' title="Cracked Bell Colt Knobs" href="/static/images/model/bell/colt/img/molded.jpg"><img class="img_right" src="/static/images/model/bell/colt/img/molded.jpg" title="Cracked Bell Colt Knobs"/></a>The other has shafts that pass through the cabinet and these models generally use a grub-screw mounted moulded knob more reminiscent of the early-style bakelite knobs used on vintage radio.  Its common for these knobs to crack, most likely due to overtightening.  These are not the only knobs fitted to Colts, and while many arguments arise as to what knobs a Colt SHOULD have, so many of these were produced over the years (more than 6500 in 1961 alone, thats around 20,000 knobs not counting the world-wave models which needed one extra!) that it seems reasonable that the factory would use whatever it had (or could get) if-and-when it ran out of one type.</p>\r\n<p><b>OTHER \'COLT\' MODELS</b><br>\r\n<a href="/explorer">EXPLORER</a>: A dual-wave model with a shortwave band.<br>\r\n<a href="/champ">CHAMP</a>: A three-valve set.<br>\r\n<a href="/planet">PLANET</a>: The oak-cabinet models<br>\r\n<a href="/solid state colt">SOLID STATE COLT</a>: The Solid State (Transistorised) model from 1973 onward</p>\r\n<p>The Bell Colt was also produced as a Skymaster model for Bond and Bond, and a \'marine\' version of the dual wave chassis without tone control was seen in a Fountain model.  In 1962 when Bell dropped the Colt in favour of its new \'General Radio\' line, Tee Vee  Radio Ltd took over production as the \'Tee-Rad Colt\' for a couple of years, however they were not successful and production went back to Bell.</p>\r\n<div style="display: inline-block"><a class=\'non_gallery\' title="B&B Skymaster Colt" href="/static/images/model/bell/colt/img/skymaster.jpg"><img class="img_left" src="/static/images/model/bell/colt/img/skymaster.jpg" title="B&B Skymaster Colt"/></a><a class=\'non_gallery\' title="Fountain Marine Band" href="/static/images/model/bell/colt/img/fountain.jpg"><img class="img_left" src="/static/images/model/bell/colt/img/fountain.jpg" title="Fountain Marine Band"/></a></div>\r\n<p><b>Valve Lineups:</b><br>\r\n5B4:   ECH41 or ECH42 or ECH81, EF41, EBC41, EL41, EZ40 - 462kc/s IF<br>\r\n5B60: ECH81, EF89, EBC81, EL84, EZ80 - 455kc/s IF<br>\r\n5B61: Same as 5B60, although later variants had a solid state rectifier<br>\r\n5B67: ECH81, EF89, EBC81, EL84, BY179 Silicon Rectifier - 455kc/s IF</p>\r\n<p>Note: the chassis numbers refer to the years - 5BXX.  5B4=1954, 5B60=1960 etc<p>\r\n'),
	(8, NULL, 'Explorer', '1960', 1, NULL, 0, 5, 'ECH81, EF89, EBC81, EL84, EZ80', 2, 10, '<p>The Bell Colt \'Explorer\' was a dual-wave model with a shortwave band. To make room for the band switch, the tone control was moved to the back of the chassis, and the band switch was fitted in the middle control position on the front.</p>\r\n<p>See the <a href="/colt">Bell Colt</a> for more information on this model.</p>\r\n'),
	(9, NULL, 'Champ', '1960', 1, NULL, 0, 5, 'Unknown', 1, 10, '<p>The Bell Colt \'Champ\' was the budget model, sporting just 3 valves and having an unusual tuning arrangement that appears to have been sliding slugs inside coils rather than tuning gangs.</p>\r\n<p>See the <a href="/colt">Bell Colt</a> for more information.</p>\r\n'),
	(10, NULL, 'Planet', '1958', 1, '1960', 1, 5, 'ECH81, EF89, EBC81, EL84, EZ80', 1, 10, '<p>The Bell Colt \'Planet\' may have been a dual-wave set although its unclear from the sales literature at hand.  JWS states it was, yet on the opposite page in More Golden Age of Radio he has a brochure that does not refer to it as being \'world-wave\', just \'Australasian reception\', same as the Colt.  Its likely that both were produced, given the lifespan of the model.</p>\r\n<p>See the <a href="/colt">Bell Colt</a> for more information.</p>\r\n'),
	(11, NULL, 'O.A.', NULL, 0, NULL, 0, 5, 'ECH81, EF89, EBC81, EL84, EZ80', 2, 12, '<p>Formica finish, appears to be based on the Bell Colt World-Wave chassis minus the tone control</p>'),
	(12, NULL, 'Solid State Colt', '1973', 0, '1980', 0, 0, 'Transistor lineup unknown', 1, 10, '<p>The Solid State Colt was the final version, and the end of an era.</p>');
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

-- Dumping data for table nzvr_db.user: ~1 rows (approximately)
DELETE FROM `user`;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`user_id`, `date_joined`, `username`, `email`, `password`) VALUES
	(1, 1481185199, 'admin', 'nzvr_admin@essentialtech.co.nz', '13601bda4ea78e55a07b98866d2be6be0744e3866f13c00c811cab608a28f322');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
