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
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `alias` (`alias`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;

-- Dumping data for table nzvr_db.brand: ~21 rows (approximately)
DELETE FROM `brand`;
/*!40000 ALTER TABLE `brand` DISABLE KEYS */;
INSERT INTO `brand` (`id`, `name`, `alias`, `tagline`, `manufacturer_id`, `distributor_id`, `year_started`, `year_started_approx`, `year_ended`, `year_ended_approx`, `notes`) VALUES
	(1, 'Courtenay', 'courtenay', 'Known For Tone', 3, 1, '1930', 0, '1956', 0, '<p>Coutenay was the original brand name of Radio Corp N.Z. (then known as W. Marks Ltd), and was distributed through Stewart Hardware in Courtenay Place (Wellington) - most likely where the name came from.</p><p>After Stewart Hardware shut its doors, Courtenay Radio Ltd was formed in 1933 to distribute the receivers, and then in 1934 Turnbull and Jones Ltd took over distribution, which they held until they pulled out of the radio market in 1956.</p>'),
	(2, 'Columbus', 'columbus', NULL, 3, 2, '1937', 0, '1960', 0, 'Columbus was the house-brand for Radio Corp. of NZ.'),
	(3, 'Pacific', 'pacific', 'In A Sphere Of Its Own', 3, 6, '1933', 0, '1937', 1, '<p>Pacific sets were built initially as special runs for Pacific Radio Co. Ltd by Radio Corp. N.Z., and then as standard RCNZ chassis models from around 1935/36.</p><p><a class="gallery img_right" title="The Pacific Elite Console" href="/static/images/models/pacific/elite/elite.jpg"><img class="inline_image" src="/static/images/models/pacific/elite/thumbs/elite.jpg" alt="Pacific Elite Console 1934/35" /></a>Pacific sets from the early-mid 30\'s were known for their art-deco styling - in particular the 1934/35 \'Elite\' console, which is considered very rare and the envy of most collectors.</p>\r\n<p>There are later (post WWII) sets branded \'Pacific\', however these were built by Akrad who took over the name and branding after Pacific Radio Ltd closed.</p>'),
	(4, 'Pacific (post-WWII)', 'pacific_new', 'In A Sphere Of Its Own', 1, 3, '1947', 1, NULL, 1, '<p>Pacific Radio Co. Ltd ceased trading due to the demise of the owner, and the brand and signature line were taken over by Akrad Radio Ltd in Waihi when radio production resumed after WWII.</p><p>Many Pacific models from Akrad were also released under the Regent brand name.</p><p><img class="img_left" src="/static/images/brands/pacific_new/pacific_old_ad.jpg">Interestingly, as this advert for the original Pacific brand shows, Keith Wrigley (Founder of Akrad Radio) was listed as the local Pacific dealer for Waihi in the early-mid 30\'s so he would have been well aware of the brand.</p>'),
	(5, 'Clipper', 'clipper', NULL, 1, 0, '1954', 1, NULL, 0, '<p>Clipper was one of the brands in the Akrad stable, found on both car and home radios, and even radiograms</p>'),
	(6, 'Well-Mayde', 'well_mayde', NULL, 5, 5, '1929', 0, NULL, 0, '<p>The brand name Well-Mayde was established by Johns Ltd in Auckland, and products were manufactured by their factory, Wellmade Ltd.</p>'),
	(7, 'Pathfinder', 'pathfinder', NULL, 1, 0, NULL, 0, NULL, 0, '<p>One of the Akrad brands - possibly also Westonhouse?</p>'),
	(8, 'Stella', 'stella', 'Proudly Made - Proudly Owned', 3, 0, '1933', 1, '1938', 1, '<p>Stella - one of the main private brand sets manufacturerd by RCNZ.  It seems 1937 may have been the last year of RCNZ models, but there were sets in 1938 under the Stella name manufacturered (it seems) by Collier and Beale.  Does anyone know the tie up here?  Was it a new company, just a new brand, or did Stella move to C&B after RCNZ finished up building private brand sets?</p>'),
	(9, 'Philco', 'philco', 'A Musical Instrument of Quality', 4, 0, '1930', 0, '1962', 1, '<p>Philco as a brand in New Zealand started in 1930 when Chas Begg & Co. Ltd imported radios direct from America - Philco being one of the few US manufacturers to produce export sets with 230V transformers.</p>\r\n<p>By 1938, import restrictions meant that only chassis\' were being imported, and the cabinets were made locally.  This didn\'t last very long before Dominion Radio and Electrical was set up as a New Zealand franchise and Philco sets were being produced here lock, stock and barrel.</p>'),
	(10, 'Bell', 'bell', NULL, 8, 0, '1952', 0, '1980', 0, '<p>Bell was the mainstay brand name of Bell Radio-Television Corp., found on portables, bookshelf radios, table radios, radiograms, televisions and more from the early 50\'s until the 80\'s when Bell ceased production</p>'),
	(11, 'General', 'general', NULL, 8, 0, '1962', 0, NULL, 0, '<p>General radios were a Bell Radio-Television Corp. brand, made in Japan by Yaou Radio Mfg. Co.  They never fully caught on in NZ despite being pushed heavily by Bell, and according to John Stokes the 7-pin Japanese valves used were unreliable by comparison to the modern noval valves being used in the <a href="/colt">colt</a> at the time.</p>'),
	(12, 'Fountain', 'fountain', NULL, 9, 0, '1963', 1, '1983', 1, '<p>Fountain radios and radiograms were reasonably common in the transistor era, but they also produced radios prior to this, including at least one model based on the Bell Colt - the <a href="/o.a.">Fountain O.A. Marine Band</a> radio</p>'),
	(13, 'Regent', 'regent', NULL, 1, 0, '1947', 1, NULL, 0, '<p>Regent was one of 3 brands introduced by Akrad in the post-war years, the other two being Pacific (taken over after the original Pacific Radio Co. ceased trading) and Five Star.</p>'),
	(14, 'Five Star', 'five_star', NULL, 1, 0, '1947', 1, NULL, 0, '<p>Five Star was one of 3 brands introduced by Akrad in the post-war years, the other two being Pacific (taken over after the original Pacific Radio Co. ceased trading) and Regent.</p>\r\n<p>source: https://leanpub.com/pyeradiowaihi/read</p>'),
	(15, 'Haywin', 'haywin', NULL, 10, 0, '1936', 1, NULL, 0, '<p>Haywin was the radio brand made for, and sold by, Hay\'s Dept Store in Christchurch which opened in 1929, changed its name to HayWrights in 1968, and was aquired in 1982 by Farmers.</p>'),
	(16, 'Gulbransen', 'gulbransen', NULL, 11, 0, '1929', 0, '1958', 0, '<p>Originally imported by H. W. Clarke who had the Gulbransen Piano importation business - but as the demand for pianos declined with the onset of radio, Gulbransen in the US started into the radio business - a short-lived venture there. However, after import restrictions came into force in 1936, H. W. Clarke  had Collier & Beale begin manufacturing sets under licence from Gulbransen in the US.</p>\r\n<p>Model numbering in the 40\'s appears to have been three digit, with the first indicating the number of valves, the second the number of bands and the third the year.  For example, the model <span style="color:red">6</span>2<b>8</b> was a <span style="color:red">6</span>-valve dual wave set manufactured in 194<b>8</b>.  This continued into the 50\'s with a 4-digit scheme that was essentially the same but with 2 digits for the year.  The model <span style="color:red">5</span>1<b>51</b> was a <span style="color:red">5</span>-valve, broadcast-band only set manufactured in 19<b>51</b>.</p>\r\n<p>The name dropped out of use after 1958 along with another long-running brand manufactured by Collier & Beale: Cromwell.</p>'),
	(17, 'HMV', 'hmv', 'His Masters Voice', 2, 0, '1926', 0, '1972', 0, '<p>HMV was an international brand that reaches back into the earliest days of radio.  In New Zealand it was a franchise owned from 1910 by E J Hyams, with the primary Australasian agency being held in Sydney.</p><p>In 1926 His Masters Voice (New Zealand) Ltd was formed and gramaphones, radios and radiograms were imported, produced and even manufactured for HMV (the principal manufacturer outside HMV themselves was Collier & Beale).\r\n</p>\r\n<p>Model numbering seems to follow a 3-digit scheme where the first 2 digits are the year of the model and the third digit is the number of valves.  Letters after indicate features: BC = Bbroadcast, DW = Dual Wave, P = Portable, RG = Radiogram, TRG = Table Radiogram.  After 1957 this moved to 4-digits, with the first 2 being the year, and the second two indicating the model for that year (01, 02, 03 etc depending how many models were released that year).</p>\r\n<p><span style="bold">Sources:</span><br>http://www.audioculture.co.nz/scenes/emi-new-zealand-the-first-50-years</p>'),
	(18, 'Companion', 'companion', NULL, 5, 5, '1933', 0, '1951', 0, '<p>The Companion brand name was introduced to coincide with the introduction of superhet radios to the Johns family, and it immediately superceeded all other brand names except for Well Mayde which remained in use for all other products except radios.</p>'),
	(19, 'Ultimate', 'ultimate', NULL, 15, 0, '1923', 0, NULL, 0, '<p>Ultimate was the first brand name of Radio Ltd.</p>'),
	(20, 'Courier', 'courier', NULL, 15, 0, '1931', 0, '1955', 0, '<p>Courier was the \'other\' brand name of Radio Ltd. (Ultimate being the main brand)</p>'),
	(21, 'Courier (original)', 'courier_original', 'Brings Tidings From Afar', 0, 0, '1927', 0, '1930', 1, '<P>The original Courier brand name belonged to J. Wiseman & Sons, a saddle maker.  They had a sideline making radios between 1927 and around 1930 when production ceased for unknown reasons - the Courier name was picked up the following year by Radio Ltd.</p>'),
	(22, 'Skymaster', 'skymaster', NULL, 8, 8, NULL, 0, NULL, 0, 'Manufactured for Bond & Bond by Bell, the main model was a rebranded Bell Colt with different knobs and a different dial glass.'),
	(23, 'Skyscraper', 'skyscraper', NULL, 15, 8, NULL, 0, NULL, 0, '<p>House brand for Bond & Bond, a major appliance retailer throughout New Zealand</p>');
/*!40000 ALTER TABLE `brand` ENABLE KEYS */;

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

-- Dumping data for table nzvr_db.distributor: ~4 rows (approximately)
DELETE FROM `distributor`;
/*!40000 ALTER TABLE `distributor` DISABLE KEYS */;
INSERT INTO `distributor` (`id`, `name`, `alias`, `address`, `notes`) VALUES
	(1, 'Turnbull and Jones Ltd', 'turnbull_and_jones', 'Wellington', 'Turnbull and Jones were tied up with RCNZ, supplying high quality radio manufacturing parts to them.'),
	(2, 'Columbus Radio Centre Ltd', 'radio_centre', 'Nationwide', 'Set up by RCNZ to distribute their house brand, Columbus'),
	(3, 'A. H. Nathan Ltd', 'a_h_nathan', 'Auckland', '<p>Arthur H Nathan Ltd were importers / merchants in Auckland City.  They sold HMV and later model Pacific sets (from Akrad)<img class="brand_image" src="/static/images/distributors/ahnathan.jpg" /></p><p>If you have any more details to share, please contact the admin with them.</p>'),
	(5, 'Johns Ltd', 'johns', 'Auckland', 'Set up in 1920, slogan -Aucklands Oldest Radio Firm-.  Set up by Clive and Victor Johns, returned soldiers from WW1.  Started by importing and selling radio components, then kitsets.  Had distributorship for U.S. made Hammarlund coils and tuning condensers.  They started manufacturing radios - Altona, Ace and Meniwave.  Formed a new manufacturing co called Wellmayde Ltd making radios under the Well Mayde name. In 1930 1ZJ came on the air - Johns Ltds own radio station. More to come...'),
	(6, 'Pacific Radio Co. Ltd', 'pacific', 'Wellington', 'The parent company for Pacific radios, based in Wellington but distributed nationwide through various retailers.  Interestingly started on the same day with the same capital and the same number of shares as Courtenay Radio Ltd.  Different shareholders, but the wording in the adverts is basically identical.'),
	(7, 'His Masters Voice (New Zealand) Ltd', 'hmv', 'Auckland', '<p>HMV was an international brand that reaches back into the earliest days of radio.  In New Zealand it was a franchise owned from 1910 by Messrs E J Hyams, with the primary Australasian agency being held in Sydney.</p><p>In 1926 His Masters Voice (New Zealand) Ltd was formed and gramaphones, radios and radiograms were imported, produced and even manufactured for HMV (the principal manufacturer outside HMV themselves was Collier & Beale).'),
	(8, 'Bond & Bond', 'bond_and_bond', 'Nationwide', 'A major NZ appliance retailer, Skymaster, Skyscraper and Crusader were their house brands.');
/*!40000 ALTER TABLE `distributor` ENABLE KEYS */;

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
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=utf8 COMMENT='locations and descriptions of images used on the site\r\n';

-- Dumping data for table nzvr_db.images: ~259 rows (approximately)
DELETE FROM `images`;
/*!40000 ALTER TABLE `images` DISABLE KEYS */;
INSERT INTO `images` (`id`, `title`, `filename`, `type`, `type_id`, `is_schematic`, `rank`, `attribution`) VALUES
	(1, 'Clipper 5M4 Front', 'clipper_5m4_front.jpg', 1, 28, 0, 12, NULL),
	(2, 'Clipper 5M4 Side', 'clipper_5m4_lside.jpg', 1, 28, 0, 13, NULL),
	(3, 'Clipper 5M4 Dial', 'clipper_5m4_dial.jpg', 1, 28, 0, 14, NULL),
	(4, 'Clipper 5M4 Rear', 'clipper_5m4_rear.jpg', 1, 28, 0, 15, NULL),
	(5, 'Clipper 5M4 Rear 2', 'clipper_5m4_rear_label.jpg', 1, 28, 0, 20, NULL),
	(7, 'Clipper 5M4 Schematic (early)', 'clipper_5m4_schematic.png', 1, 28, 1, 30, NULL),
	(8, 'Clipper 5M4 Label', 'clipper_5m4_label.png', 1, 28, 0, 29, NULL),
	(9, 'Clipper 5M4 Red', 'clipper_5m4_red.jpg', 1, 28, 0, 4, NULL),
	(10, 'Clipper 5M4 Blue', 'clipper_5m4_blue.jpg', 1, 28, 0, 3, NULL),
	(11, 'Clipper 5M4 Green', 'clipper_5m4_green.jpg', 1, 28, 0, 2, NULL),
	(12, 'Clipper 5M4 Brown', 'clipper_5m4_brown.jpg', 1, 28, 0, 5, NULL),
	(13, 'Clipper 5M4 Ivory', 'clipper_5m4_ivory.jpg', 1, 28, 0, 1, NULL),
	(14, 'Clipper 5M4 Black (RARE)', 'clipper_5m4_black.jpg', 1, 28, 0, 6, NULL),
	(15, 'Pacific Raleigh ', '20160320_144502.jpg', 1, 2, 0, 2, NULL),
	(16, 'Pacific Raleigh Dial', '20160322_104320.jpg', 1, 2, 0, 3, NULL),
	(17, 'Pacific Raleigh Valve Card', '20160322_104136.jpg', 1, 2, 0, 4, NULL),
	(18, 'Pacific RaleighFront', '20160322_104306.jpg', 1, 2, 0, 1, NULL),
	(19, 'Pacific Raleigh Advert', 'Pacific Raleigh 6-valve advert.png', 1, 2, 0, 5, NULL),
	(20, 'Pacific 6 Valve Dual Wave Schematic', 'Pacific 6-Valve Dual-Wave Schematic.png', 1, 2, 1, 30, NULL),
	(21, 'Pacific Elite', 'elite.jpg', 1, 3, 0, 1, NULL),
	(46, 'Pacific Elite', '20161005_102450.jpg', 1, 3, 0, 7, NULL),
	(47, 'Pacific Elite', '20161005_150428.jpg', 1, 3, 0, 6, NULL),
	(48, 'Pacific Elite', '20161005_161012.jpg', 1, 3, 0, 8, NULL),
	(49, 'Pacific Elite', 'chassis badge.jpg', 1, 3, 0, 9, NULL),
	(50, 'Pacific Elite', 'DSC00024.jpg', 1, 3, 0, 4, NULL),
	(51, 'Pacific Elite', 'DSC00025.jpg', 1, 3, 0, 5, NULL),
	(52, 'Pacific Elite', 'IMG_20161005_164726.jpg', 1, 3, 0, 2, NULL),
	(53, 'Pacific Elite', 'IMG_20161005_171653.jpg', 1, 3, 0, 3, NULL),
	(54, 'Philco Alabama', '20160718_105116.jpg', 1, 4, 0, 99, NULL),
	(55, 'Philco Alabama', '20160718_105400.jpg', 1, 4, 0, 99, NULL),
	(56, 'Under Chassis 1', '20160718_105542.jpg', 1, 4, 0, 99, NULL),
	(57, 'Under Chassis 2', '20160718_105549.jpg', 1, 4, 0, 99, NULL),
	(58, 'Grey Cabinet', '20160719_143549.jpg', 1, 4, 0, 99, NULL),
	(59, 'Philco Alabama', 'Dads philco 401 alabama front after restoration.jpg', 1, 4, 0, 1, NULL),
	(60, 'Chassis Under Original', 'Dads philco 401 alabama Full_chassis_before.jpg', 1, 4, 0, 99, NULL),
	(61, 'Philco Alabama', 'Dads philco 401 alabama rear after restoration.jpg', 1, 4, 0, 99, NULL),
	(62, 'Philco Alabama', 'LaGloria_PhilcoSiesta.jpg', 1, 4, 1, 100, NULL),
	(63, 'Philco 401', '463396333.jpg', 1, 5, 0, 180, NULL),
	(64, 'Philco 401', '463396384.jpg', 1, 5, 0, 1, NULL),
	(65, 'Philco 401', '463396440.jpg', 1, 5, 0, 99, NULL),
	(66, 'Philco 401', '463396563.jpg', 1, 5, 0, 99, NULL),
	(67, 'Philco 401', '463396643.jpg', 1, 5, 0, 99, NULL),
	(68, 'Philco 401', '463396663.jpg', 1, 5, 0, 99, NULL),
	(69, 'Philco 401', '463396748.jpg', 1, 5, 0, 182, NULL),
	(70, 'Philco Nevada', '523928129.jpg', 1, 5, 0, 200, NULL),
	(71, 'Courtenay 5M', '20141225_164116.jpg', 1, 6, 0, 99, NULL),
	(72, 'Courtenay 5M', '20141225_164141.jpg', 1, 6, 0, 99, NULL),
	(75, 'Courtenay model 5M', 'courtenay_5m_front.jpg', 1, 6, 0, 1, NULL),
	(77, 'Courtenay 5M', 'courtenay talisman.png', 1, 6, 0, 99, NULL),
	(79, 'Philco Alabama', 'philco-alabama-401-1-281212.jpg', 1, 4, 0, 99, NULL),
	(80, 'Bell Colt Ivory', '1.jpg', 1, 7, 0, 1, NULL),
	(81, 'Bell Colt Grey', '2.jpg', 1, 7, 0, 2, NULL),
	(82, 'Bell Colt early 5V chassis', '20160530_173204.jpg', 1, 7, 0, 110, NULL),
	(83, 'Bell Colt Green', '3.jpg', 1, 7, 0, 4, NULL),
	(84, 'Bell Colt Blue', '4.jpg', 1, 7, 0, 3, NULL),
	(85, 'Bell Colt', '463398315.jpg', 1, 7, 0, 26, NULL),
	(86, 'Bell Colt', '474769580.jpg', 1, 7, 0, 36, NULL),
	(87, 'Bell Colt', '475877334.jpg', 1, 7, 0, 40, NULL),
	(88, 'Bell Colt', '477166182.jpg', 1, 7, 0, 30, NULL),
	(89, 'Bell Colt', '481688135.jpg', 1, 7, 0, 33, NULL),
	(90, 'Bell Colt', '496270634.jpg', 1, 7, 0, 20, NULL),
	(91, 'Bell Colt Red', '5.jpg', 1, 7, 0, 5, NULL),
	(92, 'Bell Colt', '507080079 (1).jpg', 1, 7, 0, 46, NULL),
	(93, 'Bell Colt', '507227168.jpg', 1, 7, 0, 53, NULL),
	(94, 'Bell Colt', '507978318.jpg', 1, 7, 0, 50, NULL),
	(95, 'Bell Colt', '514050907.jpg', 1, 7, 0, 23, NULL),
	(96, 'Bell Colt', '540490991.jpg', 1, 7, 0, 43, NULL),
	(97, 'Bell Colt Brown', '6.jpg', 1, 7, 0, 6, NULL),
	(100, 'Bell Colt BC / SW', 'dual-wave.jpg', 1, 7, 0, 65, NULL),
	(101, 'Bell Colt', '5B4j.jpg', 1, 7, 1, 122, NULL),
	(102, 'Bell Colt', '5B60.jpg', 1, 7, 1, 123, NULL),
	(103, 'Bell Colt', '5B61.jpg', 1, 7, 1, 124, NULL),
	(104, 'Bell Colt', '5B67.jpg', 1, 7, 1, 125, NULL),
	(105, 'Bell Colt 3V Champ', 'three valve chassis.jpg', 1, 7, 0, 109, NULL),
	(106, 'Bell Explorer', '1.jpg', 1, 8, 0, 99, NULL),
	(107, 'Bell Explorer', '2.jpg', 1, 8, 0, 99, NULL),
	(108, 'Bell Explorer', '3.jpg', 1, 8, 0, 99, NULL),
	(109, 'Bell Explorer', 'dual-wave.jpg', 1, 8, 0, 99, NULL),
	(110, 'Bell Champ', '1.jpg', 1, 9, 0, 99, NULL),
	(111, 'Bell Champ', '2.jpg', 1, 9, 0, 99, NULL),
	(112, 'Bell Champ', '3.jpg', 1, 9, 0, 99, NULL),
	(113, 'Bell Planet', '1.jpg', 1, 10, 0, 99, NULL),
	(114, 'Bell Planet', '2.jpg', 1, 10, 0, 99, NULL),
	(115, 'Fountain O.A. Marine Band', '1.jpg', 1, 11, 0, 2, 'Paul Burt - NZVRS Magazine V21#1 Pg29'),
	(116, 'Fountain O.A. Dial', '2.jpg', 1, 11, 0, 2, NULL),
	(117, 'Fountain O.A. Back', '3.jpg', 1, 11, 0, 3, NULL),
	(118, 'Fountain O.A. Inside', '4.jpg', 1, 11, 0, 4, NULL),
	(119, 'Fountain O.A. Partial Schematic', '5.jpg', 1, 11, 0, 5, NULL),
	(120, 'Fountain O.A. Marine Band', '01.jpg', 1, 11, 0, 1, ''),
	(121, 'Fountain O.A. Top', '6.jpg', 1, 11, 0, 3, NULL),
	(122, 'Fountain O.A. Side', '7.jpg', 1, 11, 0, 3, NULL),
	(123, 'Columbus 12', '544511058.jpg', 1, 13, 0, 1, NULL),
	(124, 'Columbus 12', '544511097.jpg', 1, 13, 0, 4, NULL),
	(125, 'Columbus 12', '544511120.jpg', 1, 13, 0, 2, NULL),
	(126, 'Columbus 12', '544511152.jpg', 1, 13, 0, 3, NULL),
	(127, 'Columbus 12', 'columbus 12 ACDC p1.png', 1, 13, 0, 96, NULL),
	(128, 'Columbus 12', 'columbus 12 ACDC p2.png', 1, 13, 0, 97, NULL),
	(129, 'Columbus 12', 'columbus 12 ACDC p3.png', 1, 13, 0, 98, NULL),
	(130, 'Columbus 12', 'columbus 12 ACDC p4.png', 1, 13, 0, 99, NULL),
	(131, 'Columbus 12', 'columbus 12 p1.png', 1, 13, 1, 81, NULL),
	(132, 'Columbus 12', 'columbus 12 p2.png', 1, 13, 1, 82, NULL),
	(133, 'Columbus 12', 'columbus 12 p3.png', 1, 13, 1, 83, NULL),
	(134, 'Haywin Broadcaster', '1941 Haywin 5-valve.jpg', 1, 15, 0, 99, NULL),
	(135, 'Courtenay 12', '543735855.jpg', 1, 14, 0, 99, NULL),
	(136, 'Courtenay 12', '543735873.jpg', 1, 14, 0, 99, NULL),
	(137, 'Courtenay 12', '543735899.jpg', 1, 14, 0, 99, NULL),
	(138, 'Courtenay 12', '543735919.jpg', 1, 14, 0, 99, NULL),
	(139, 'Courtenay 12', 'columbus 12 ACDC p1.png', 1, 14, 0, 99, NULL),
	(140, 'Courtenay 12', 'columbus 12 ACDC p2.png', 1, 14, 0, 99, NULL),
	(141, 'Courtenay 12', 'columbus 12 ACDC p3.png', 1, 14, 0, 99, NULL),
	(142, 'Courtenay 12', 'columbus 12 ACDC p4.png', 1, 14, 0, 99, NULL),
	(143, 'Courtenay 12', 'columbus 12 p1.png', 1, 14, 0, 99, NULL),
	(144, 'Courtenay 12', 'columbus 12 p2.png', 1, 14, 0, 99, NULL),
	(145, 'Courtenay 12', 'columbus 12 p3.png', 1, 14, 0, 99, NULL),
	(146, 'Columbus 84 in a sorry state', 'IMG_20170110_231813595.jpg', 1, 17, 0, 1, NULL),
	(147, 'Columbus 84 rear', 'IMG_20170110_231832925.jpg', 1, 17, 0, 2, NULL),
	(148, 'Columbus 84 label', 'IMG_20170110_231842648.jpg', 1, 17, 0, 3, NULL),
	(149, 'Columbus 84', 'rcnz model 84 schematic.png', 1, 17, 1, 99, NULL),
	(150, 'Columbus 65', 'IMG_20170109_182454914_HDR.jpg', 1, 19, 0, 1, NULL),
	(151, 'Columbus 65 Chassis', 'IMG_20170110_231710965.jpg', 1, 19, 0, 10, NULL),
	(152, 'Columbus 65 Label', 'IMG_20170110_231731176.jpg', 1, 19, 0, 15, NULL),
	(153, 'p14 New Zealand Herald 14 Feb 1940', 'Page 14 Advertisements Column 3,New Zealand Herald, Volume LXXVII, Issue 23580, 14 February 1940.png', 1, 19, 0, 99, NULL),
	(154, 'Gulbransen 5151', '470003630.jpg', 1, 20, 0, 99, NULL),
	(155, 'Gulbransen 5151', '470003681.jpg', 1, 20, 0, 99, NULL),
	(156, 'Gulbransen 5151', '470003693.jpg', 1, 20, 0, 99, NULL),
	(157, 'Gulbransen 617', '530346093.jpg', 1, 22, 0, 99, NULL),
	(158, 'Gulbransen 617', '530346797.jpg', 1, 22, 0, 99, NULL),
	(159, 'Gulbransen 617', '530346996.jpg', 1, 22, 0, 99, NULL),
	(160, 'Gulbransen 617', '530347299.jpg', 1, 22, 0, 99, NULL),
	(161, 'Gulbransen 756', '528528340.jpg', 1, 21, 0, 99, NULL),
	(162, 'Gulbransen 756', '528528423.jpg', 1, 21, 0, 99, NULL),
	(163, 'Columbus 65', 'rcnz_65_schematic.jpg', 1, 19, 1, 99, NULL),
	(164, 'Columbus 65', 'Copy_of_Columbus_65_before.jpg', 1, 19, 0, 5, NULL),
	(165, 'Columbus 75', '506972638.jpg', 1, 23, 0, 5, NULL),
	(166, 'Columbus 75', '506972652.jpg', 1, 23, 0, 10, NULL),
	(167, 'Columbus 75', 'victory.jpg', 1, 23, 0, 15, NULL),
	(168, 'Bell Colt 5V chassis', '5-valve chassis.jpg', 1, 7, 0, 111, NULL),
	(169, 'Philco \'Majestic\' Alabama', '547438533.jpg', 1, 4, 0, 199, NULL),
	(170, 'Bell Colt', '9.jpg', 1, 7, 0, 9, NULL),
	(171, 'Bell Colt', 'dial.jpg', 1, 7, 0, 27, NULL),
	(172, 'Bell Colt', '7.jpg', 1, 7, 0, 7, NULL),
	(173, 'Bell Colt', '8.jpg', 1, 7, 0, 8, NULL),
	(174, 'Courtenay 24', '467259000 (1).jpg', 1, 24, 0, 99, NULL),
	(175, 'Courtenay 24', '467259310a.jpg', 1, 24, 0, 99, NULL),
	(176, 'Courtenay 24', '467259374a.jpg', 1, 24, 0, 99, NULL),
	(177, 'Bell 6P7', '457300467.jpg', 1, 26, 0, 1, NULL),
	(179, 'Bell 1', '541663709.jpg', 1, 25, 0, 100, NULL),
	(180, 'Bell 1', '541663810.jpg', 1, 25, 0, 1, NULL),
	(181, 'Bell 1', '541663859.jpg', 1, 25, 0, 5, NULL),
	(182, 'Bell 1', '541663924.jpg', 1, 25, 0, 8, NULL),
	(183, 'Bell 1', '541663931.jpg', 1, 25, 0, 12, NULL),
	(184, 'Bell 1', 'P1090916-001.JPG', 1, 25, 0, 2, NULL),
	(185, 'Bell 1', 'P1090917-001.JPG', 1, 25, 0, 16, NULL),
	(186, 'Bell 6P7', '457300468.jpg', 1, 26, 0, 99, NULL),
	(187, 'Clipper 5M4', '5m4oldnewbottom.jpg', 1, 28, 0, 99, NULL),
	(188, 'Clipper 5M4', '5m4oldnewtop.jpg', 1, 28, 0, 99, NULL),
	(189, 'Courtenay 84', '509152342.jpg', 1, 18, 0, 99, NULL),
	(190, 'Courtenay 84', '509227171.jpg', 1, 18, 0, 99, NULL),
	(191, 'Courtenay 84', 'rcnz model 84 schematic.png', 1, 18, 1, 99, NULL),
	(192, 'Pacific Nottingham', 'New Zealand Herald, Volume LXXII, Issue 22130, 8 June 1935, Page 16.jpg', 1, 29, 0, 99, 'PapersPast & NZ Herald 8th June 1935'),
	(193, 'Pacific Nottingham', 'nottingham.jpg', 1, 29, 0, 1, NULL),
	(194, 'Bell Colt - Rimlock Valves', 'P1040013.JPG', 1, 7, 0, 99, NULL),
	(195, 'Bell Colt 4-Valve 5B67 Probably', '5b67 maybe - 4 valve.jpg', 1, 7, 0, 80, NULL),
	(196, 'Hmv 495BC', '522535227.jpg', 1, 31, 0, 99, NULL),
	(197, 'Hmv 495BC', '522535263.jpg', 1, 31, 0, 99, NULL),
	(198, 'Hmv 495BC', '522535288.jpg', 1, 31, 0, 99, NULL),
	(199, 'Hmv 495BC', '522535351.jpg', 1, 31, 0, 99, NULL),
	(200, 'Hmv 495BC', '522535391.jpg', 1, 31, 0, 99, NULL),
	(201, 'Hmv 495BC', '522535439.jpg', 1, 31, 0, 99, NULL),
	(202, 'Hmv 495BC', '550558592.jpg', 1, 31, 0, 99, NULL),
	(203, 'Hmv 495BC', '550558671.jpg', 1, 31, 0, 99, NULL),
	(204, 'Hmv 495BC', '550559378.jpg', 1, 31, 0, 99, NULL),
	(205, 'Hmv 495BC', '550559494.jpg', 1, 31, 0, 99, NULL),
	(206, 'Hmv 495BC', '550566054.jpg', 1, 31, 0, 99, NULL),
	(207, 'Columbus 75', 'schematic 1.jpg', 1, 23, 1, 98, NULL),
	(208, 'Columbus 75', 'schematic 2 - supplement.jpg', 1, 23, 1, 99, NULL),
	(209, 'Ultimate BCU', '1.jpg', 1, 32, 0, 99, NULL),
	(210, 'Ultimate BCU', '2.jpg', 1, 32, 0, 99, NULL),
	(211, 'Ultimate BCU', '3.jpg', 1, 32, 0, 99, NULL),
	(212, 'Ultimate BCU', '4.jpg', 1, 32, 0, 99, NULL),
	(214, 'Ultimate AAU', 'IMG_20170127_180413798.jpg', 1, 33, 0, 99, NULL),
	(215, 'Ultimate AAU', 'IMG_20170127_180431688.jpg', 1, 33, 0, 99, NULL),
	(216, 'Ultimate AAU', 'IMG_20170127_180442985.jpg', 1, 33, 0, 99, NULL),
	(217, 'Ultimate AAU', 'IMG_20170127_180451614.jpg', 1, 33, 0, 99, NULL),
	(218, 'Ultimate AAU', 'IMG_20170127_180500951.jpg', 1, 33, 0, 99, NULL),
	(219, 'Ultimate AAU', 'IMG_20170127_180515148.jpg', 1, 33, 0, 99, NULL),
	(220, 'Ultimate AAU', 'IMG_20170127_180535631.jpg', 1, 33, 0, 99, NULL),
	(221, 'Ultimate AAU', 'IMG_20170127_180555739.jpg', 1, 33, 0, 99, NULL),
	(222, 'Ultimate AAU', 'Ultimate AAU.jpg', 1, 33, 0, 1, NULL),
	(223, 'Courtenay 108 revised schematic', '108 Revised Version.jpg', 1, 34, 1, 99, NULL),
	(224, 'Courtenay 108', 'Courtenay 108 BFB collection.jpg', 1, 34, 0, 1, 'Brian F Baker Collection - Art & Object'),
	(225, 'Courtenay 108 original schematic', '108 Early Version.png', 1, 34, 1, 98, NULL),
	(226, 'Skyscraper XS', '1.jpg', 1, 37, 0, 99, NULL),
	(227, 'Skyscraper XS', '2.jpg', 1, 37, 0, 99, NULL),
	(228, 'Skyscraper XS', '3.jpg', 1, 37, 0, 99, NULL),
	(229, 'Skyscraper XS', '4.jpg', 1, 37, 0, 99, NULL),
	(230, 'Courtenay  Model 38 \'Opera\'', 'courtnayspiral.jpg', 1, 39, 0, 1, NULL),
	(232, 'Courtenay 38', 'Courtenay 38 Ballad.png', 1, 39, 0, 53, NULL),
	(233, 'Courtenay 38', 'Courtenay 38 Opera.png', 1, 39, 0, 50, NULL),
	(234, 'Courtenay 38', 'Courtenay Spiral Dial Evening Post, Volume CXXIII, Issue 136, 10 June 1937, Page 6.png', 1, 39, 0, 70, NULL),
	(235, 'Columbus 38', 'columbus 38.jpg', 1, 40, 0, 99, NULL),
	(236, 'RCNZ Model 38 Schematic', 'RCNZ model 38 004_.jpg', 1, 38, 1, 100, NULL),
	(239, 'Pacific 38', '20150914_212253 (1).jpg', 1, 41, 0, 99, NULL),
	(240, 'Pacific 38', '20150914_212304.jpg', 1, 41, 0, 99, NULL),
	(241, 'Pacific 38', '20150914_212313.jpg', 1, 41, 0, 99, NULL),
	(242, 'Pacific 38', '20150914_212350 (1).jpg', 1, 41, 0, 99, NULL),
	(243, 'Pacific 38', '20150914_212436.jpg', 1, 41, 0, 99, NULL),
	(244, 'Pacific 38', '20150914_212445.jpg', 1, 41, 0, 99, NULL),
	(246, 'Pacific 38', 'PRESS, VOLUME LXXIII, ISSUE 22166, 9 AUGUST 1937.png', 1, 41, 0, 99, NULL),
	(247, 'Stella 38', '20151217_081346.jpg', 1, 42, 0, 99, NULL),
	(248, 'Stella 38', '20151217_081432.jpg', 1, 42, 0, 99, NULL),
	(249, 'Stella 38', '20151217_081514.jpg', 1, 42, 0, 99, NULL),
	(250, 'Stella 38', '20151217_082059.jpg', 1, 42, 0, 99, NULL),
	(251, 'Stella 38', '20151217_082118.jpg', 1, 42, 0, 99, NULL),
	(252, 'Stella 38', '20151217_082141.jpg', 1, 42, 0, 99, NULL),
	(253, 'Stella 38', '_Stella 38 Front.jpg', 1, 42, 0, 1, NULL),
	(254, 'Stella 38', '_Stella 38 Rear.jpg', 1, 42, 0, 2, NULL),
	(256, 'Philco 401', 'green 401.jpg', 1, 5, 0, 3, NULL),
	(257, 'Philco 401', '544699035.jpg', 1, 5, 0, 4, NULL),
	(258, 'Philco 401', '544699292.jpg', 1, 5, 0, 2, NULL),
	(259, 'Ultimate Bcu', '10.jpg', 1, 32, 0, 99, NULL),
	(260, 'Ultimate Bcu', '13.jpg', 1, 32, 0, 99, NULL),
	(261, 'Ultimate Bcu', '7.jpg', 1, 32, 0, 99, NULL),
	(262, 'Ultimate Bcu', '8.jpg', 1, 32, 0, 99, NULL),
	(263, 'Ultimate Bcu', '9.jpg', 1, 32, 0, 99, NULL),
	(264, 'Ultimate Bcu', 'unnamed.jpg', 1, 32, 1, 100, NULL),
	(265, 'Stella 38', 'Stella Aquila 38 spiral dial - Hutt News, Volume 11, Issue 3, 16 June 1937, Page 1 (Medium).png', 1, 42, 0, 99, NULL),
	(266, 'Columbus 38', 'Columbus Model 38 Tombstone Cabinet 2.jpg', 1, 40, 0, 99, NULL),
	(267, 'Columbus 38', 'Papers Past - Hutt News - 15 December 1937 - Page 4 - Page 4 Advertisements Column 2.jpg', 1, 40, 0, 99, NULL),
	(268, 'RCNZ Model 38 Dial Front', '38_dial_1.jpg', 1, 38, 0, 10, NULL),
	(269, 'RCNZ Model 38 Dial Rear closed', '38_dial_2.jpg', 1, 38, 0, 15, NULL),
	(270, 'RCNZ Model 38 Dial Rear open', '38_dial_3.jpg', 1, 38, 0, 20, NULL),
	(271, 'RCNZ Model 38 Behind Dial', '38_dial_4.jpg', 1, 38, 0, 25, NULL),
	(272, 'RCNZ Model 38 Underside', '38_01.jpg', 1, 38, 0, 5, NULL),
	(273, 'RCNZ Model 18 Chassis', '0.jpg', 1, 43, 0, 60, NULL),
	(274, 'RCNZ Model 18 Chassis Under', '1.jpg', 1, 43, 0, 60, NULL),
	(275, 'RCNZ Model 18 dual volume pot arrangement', '2.jpg', 1, 43, 0, 60, NULL),
	(276, 'RCNZ Model 18 Chassis Underside 2', '3.jpg', 1, 43, 0, 60, NULL),
	(277, 'RCNZ Model 18 Chassis Underside 3', '4.jpg', 1, 43, 0, 60, NULL),
	(278, 'RCNZ Model 18 schematic', 's.jpg', 1, 43, 1, 99, NULL),
	(279, 'Courtenay 18', '18-2.jpg', 1, 44, 0, 5, NULL),
	(280, 'Courtenay 18', '18.jpg', 1, 44, 0, 1, NULL),
	(281, 'Courtenay 18', '18vib1.jpg', 1, 44, 0, 10, NULL),
	(282, 'Courtenay 18', '18vib2.jpg', 1, 44, 0, 15, NULL),
	(283, 'Courtenay 18', '18vib3.jpg', 1, 44, 0, 20, NULL),
	(284, 'Courtenay 18', 'Model 18 New Zealand Herald, Volume LXXIV, Issue 22735, 22 May 1937, Page 21.png', 1, 44, 0, 25, 'New Zealand Herald, Volume LXXIV, Issue 22735, 22 May 1937, Page 21 - Papers Past'),
	(285, 'Columbus 18', '0.jpg', 1, 45, 0, 99, NULL),
	(286, 'Columbus 18', '1.jpg', 1, 45, 0, 99, NULL),
	(287, 'Columbus 18', '2.jpg', 1, 45, 0, 99, NULL),
	(288, 'Columbus 18', '3.jpg', 1, 45, 0, 99, NULL),
	(289, 'Columbus 18', '4.jpg', 1, 45, 0, 99, NULL),
	(290, 'Columbus 18 - possibly a vibrator chassis fitted to a Pacific 18 cab', '492089490.jpg', 1, 45, 0, 99, NULL),
	(291, 'Columbus 18', '492089495.jpg', 1, 45, 0, 99, NULL),
	(295, 'Rcnz 5M', '20141120_150419.jpg', 1, 46, 0, 99, NULL),
	(296, 'Rcnz 5M', 'Back_nearly_finished.jpg', 1, 46, 0, 99, NULL),
	(297, 'Rcnz 5M', 'Chassis-underside-before.jpg', 1, 46, 0, 99, NULL),
	(298, 'Courtenay 5M', 'courtenay talisman.jpg', 1, 6, 0, 99, NULL),
	(299, 'Columbus 6', 'columbus6.jpg', 1, 47, 0, 99, NULL),
	(300, 'Columbus 6', 'mod6rear.jpg', 1, 47, 0, 99, NULL);
/*!40000 ALTER TABLE `images` ENABLE KEYS */;

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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

-- Dumping data for table nzvr_db.manufacturer: ~19 rows (approximately)
DELETE FROM `manufacturer`;
/*!40000 ALTER TABLE `manufacturer` DISABLE KEYS */;
INSERT INTO `manufacturer` (`id`, `name`, `alias`, `address`, `year_started`, `year_started_approx`, `year_ended`, `year_ended_approx`, `became`, `became_how`, `notes`) VALUES
	(1, 'Akrad Radio Corporation Ltd', 'akrad', 'Waihi', '1934', 0, '1982', 0, NULL, NULL, '<p>Akrad Radio (an abbreviation of Auckland Radio) was formed in Waihi by Keith M. Wrigley when he was just 18.</p><p>Brand names used in the early years were Futura, Luxor and Everest.</p><p>Notable brand names from the post-war era produced by Akrad include Pacific (the brand name was taken over in approximately 1940 after the demise of the original Pacific Radio Co.), Regent and Clipper.</p>\r\n<p><span class=\'bold\'>More History of Akrad Radio here:</span><br>\r\nhttps://leanpub.com/pyeradiowaihi/read<br>\r\nhttp://www.waihi.org.nz/about-us/history-and-heritage/the-pye-story<br>\r\n'),
	(2, 'His Master\'s Voice (N.Z.) Ltd', 'hmv', 'Wellington', '1940', 0, '1955', 0, NULL, NULL, '<p>Pre-war HMV sets were almost all imported.  After the war most sets were made in their Wellington factory with a few exceptions being made by various other manufacturers (mainly Collier and Beale)</p>'),
	(3, 'Radio Corporation of New Zealand', 'rcnz', 'Wellington', '1932', 0, '1959', 0, 7, 'sold out to', '<p>Originally known as <a href="/manufacturer/w_marks">W. Marks Ltd</a>, RCNZ became one of the largest radio manufacturers in NZ.</p><p>In around 1937, with the introduction of the house brand Columbus, RCNZ started moving away from producing \'private brand\' sets and within a couple of years was only manufacturing receivers under the names <a href="\r\n/brand/columbus">Columbus</a> and <a href="\r\n/brand/courtenay">Courtenay</a>.</p><p>RCNZ built a lot of their own components in-house, including capacitors and speakers.</p>\r\n<p>Date codes used on Columbus and Courtenay sets are based on the first digit of the serial number.  A set with the serial \'07213\' would have been manufactured in either 1940 or 1950.  a holistic approach is required to determine which decade, but in most cases it is reasonably easy to figure out based on valves, cabinet design, technology, etc</p>\r\n<p>Brands manufactured include <a href="\r\n/brand/columbus">Columbus</a>, <a href="\r\n/brand/courtenay">Courtenay</a>, <a href="\r\n/brand/stella">Stella</a>, <a href="\r\n/brand/pacific">Pacific</a>, <a href="\r\n/brand/cq">CQ</a>, <a href="\r\n/brand/acme">Acme</a>, <a href="\r\n/brand/troubador">Troubador</a> and more...</p>'),
	(4, 'Dominion Radio & Electrical Corp. Ltd', 'dreco', 'Dominion Rd, Auckland', '1939', 0, '1975', 1, NULL, NULL, '<p>DRECO was set up in 1939 as a New Zealand franchise of the Philco brand, and immediately began producing NZ versions of many Philco models.  Often these were visually similar but very different inside.</p>\r\n<p>In 1961 Philco USA was taken over by Ford Motor Co. and DRECO replaced the Philco brand with Majestic and LaGloria (which they had been using for a few years on very similar sets to the Philco models).  At one point you could buy a Philco 401 \'Alabama\', a La Gloria \'Imp\' and a Majestic set that were all very similar in both appearance and chassis.</p>\r\n<p>In the mid-70\'s Dominion Radio and Electrical merged with Bell Radio and Television to become Consolidated Electronic Industries Ltd, ending one of New Zealands longest-running radio manufacturing companies.</p>'),
	(5, 'Wellmade Ltd', 'wellmade', 'Auckland', '1928', 0, '1956', 1, NULL, NULL, '<p>Wellmade Ltd was set up by Johns Ltd as a manufacturing factory for the various brands that Johns produced such as Ace, Altona and Well-Mayde</p>'),
	(6, 'W. Marks Ltd', 'w_marks', 'Wellington', '1931', 0, '1932', 0, 3, 'rebranded as', '<p>The business was started in 1930 by Russian immigrant William Markoff (later changed to Willam Marks) to wind / rewind transformers and make amplifiers.  By 1931 he had formed the company that would go on to be one of the largest and most successful  New Zealand radio manufacturers of its day, and it seems this was his plan all along when in 1932 he changed the company name to <a href="/manufacturer/rcnz">Radio Corporation (N. Z.) Ltd</a></p>'),
	(7, 'Pye (N.Z.) Ltd', 'pye', 'Waihi', '1962', 0, '1982', 0, NULL, NULL, '<p>The New Zealand branch of Pye Ltd from Cambridge, England</p>'),
	(8, 'Bell Radio-Television Corp.', 'bell', 'Auckland', '1950', 0, '1980', 1, NULL, NULL, '<p>Bell Radio-Television Corp sprang out of Antone Ltd after the two founding members left the company shortly after Al Bell joined.  The company ran until 1980 when it merged with <a href="/manufacturer/dreco">Dominion Radio and Electrical</a> (DRECO) to form Consolidated Industries Ltd.'),
	(9, 'Fountain Manufacturing Co. Ltd', 'fountain', 'Auckland', '1963', 0, '1983', 0, NULL, NULL, '<p>Roots as SOS Radio, changed to Tee Vee Radio Ltd in 1954, then to Fountain Radio Corporation in 1963, then to Chase Corporation before finally dying out in the early 90\'s</p>\r\n<p><span class=\'bold>Sources:</span><br>\r\n<a href="http://www.aucklandcity.govt.nz/dbtw-wpd/exec/dbtwpub.dll?BU=http%3A%2F%2Fwww.aucklandcity.govt.nz%2Fdbtw-wpd%2Fnzcardindex%2Fsearch.htm&AC=QBE_QUERY&TN=NZcardindex&QF0=unique_record_id&NP=4&RF=Display+card+info&QI0=NZCI000129794">NZCI000129794</a><br>\r\n<a href="http://www.vintage-radio.net/forum/showthread.php?t=94658">User \'Billy-T\'s recollection of Fountain Corp.'),
	(10, 'Unknown', 'unknown', NULL, NULL, 0, NULL, 0, NULL, NULL, '<p>The manufacturers of the radios below are completely unknown - maybe someone can shed some light, but until then gaze upon them and wonder...</p>'),
	(11, 'Collier & Beale Ltd', 'collier_and_beale', 'Wellington', '1926', 0, '1973', 0, 0, 'were taken over by', 'To Come'),
	(12, 'Cash Radio Co.', 'cash_radio', NULL, NULL, 0, NULL, 0, 0, '', 'Cash Radio Co. operated in Chirstchurch from the mid-30\'s'),
	(13, 'Radio Warehouse Co.', 'radio_warehouse', 'Christchurch', NULL, 0, NULL, 0, 0, '', '<p>Produced \'Austin\' brand radios from their shop opposite the Civic Theatre in Christchurch'),
	(14, 'Westonhouse Radio Ltd', 'westonhouse', 'Auckland', '1937', 0, '1947', 0, 0, '', '<p><img class="img_right" src="/static/images/manufacturers/westco/logo.jpg">The company started off as <em>Westonhouse&nbsp; Air Gas Co. Ltd</em>, and appears to have dealt in kerosine / oil / gas burners and lighting systems in the 20\'s. By 1932/33 there were radio repair adverts starting to appear in Auckland newspapers including some for Yale receviers, one of the known Westonhouse brands.&nbsp;</p>\r\n<p>In 1937 there a notice in the Auckland Star (AUCKLAND STAR, VOLUME LXVIII, ISSUE 268, 11 NOVEMBER 1937) advised that <strong>Westonhouse Radio Ltd</strong> had been formed with three shareholders - with one Mr A. Chadwick being the pricipal with 498 of the 500 shares.&nbsp; The company description reads "...suppliers and importers of, and dealers in radio and electrical appliances."</p>\r\n<p>In 1942 there is note of a Military appeal from Westonhouse Radio on behalf of reservist David Leonard Rhodes who presumably had been called up... (one of) their service engineer(s) presumably?&nbsp; (AUCKLAND STAR, VOLUME LXXIII, ISSUE 237, 7 OCTOBER 1942).&nbsp; Also Edward Mark Fort (Radio Designing Engineer) (AUCKLAND STAR, VOLUME LXXIII, ISSUE 186, 8 AUGUST 1942).&nbsp; No notice of what became of either appeal, but it must have been difficult to replace experienced engineers during war time.</p>\r\n<p>By the late 30\'s they were advertising for \'smart\' or \'good\' boys for the workshop, these adverts persisted through the 40\'s as well... what did they do with all these boys?</p>'),
	(15, 'Radio Ltd', 'radio_ltd', 'Auckland', '1922', 0, '1955', 0, 16, 'rebranded as', '<p>1922: Radio Ltd<br>1936: Radio (1936) Ltd.<br>1955: Ultimate-Ekco (N.Z.) Co. Ltd</p>'),
	(16, 'Ultimate-Ekco (N.Z.) Co. Ltd', 'ultimate_ekco', 'Auckland', '1955', 0, '1965', 0, 7, 'were taken over by', '<p>An overseas link to E. K. Cole Ltd (known as Ekco) was formed to provide technical assistance with the prospect of television becoming a new market segment in the near future.  This led to a reorganisation of the company as Ultimate-Ekco (N.Z.) Co. Ltd.  The also had the spin off that some U.K. Ekco models were produced and sold here alongside the long-standing Ultimate name.</p>'),
	(17, 'Inductance Specialists Ltd', 'inductance_specialists', 'Greerton, Tauranga', NULL, 0, NULL, 0, NULL, NULL, '<p>Manufactured RF coils and chokes, IF Transformers, coil packs, etc.  The famous B9 and B10 kitset radio, etc</p>'),
	(18, 'Beacon Radio Ltd', 'beacon', 'Auckland', NULL, 0, NULL, 0, NULL, NULL, '<p>Manufactured mains transformers, speaker transformers, chokes, etc.  Later, about 1970, taken over by Phillips NZ.</p>'),
	(19, 'Auckland Transformer Co. Ltd', 'atc', 'Auckland', NULL, 0, NULL, 0, NULL, NULL, '<p>Manufactured mains transformers, speaker transformers, chokes, etc.</p><p><a class="gallery img_left" title="ATC Audio Output Transformer Specifications" href="/static/images/manufacturers/atc/specs.png"><img class="inline_image" src="/static/images/manufacturers/atc/specs_tn.png" alt="ATC Audio Output Tranformer Specs" /></a>\r\n');
/*!40000 ALTER TABLE `manufacturer` ENABLE KEYS */;

-- Dumping structure for table nzvr_db.model
DROP TABLE IF EXISTS `model`;
CREATE TABLE IF NOT EXISTS `model` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `chassis` mediumint(8) unsigned DEFAULT NULL COMMENT '0 if its a chassis model, or the id of the chassis model if you''re refering to it for a radio variant',
  `code` varchar(50) NOT NULL COMMENT 'May not be known (ie later model NZ Philco sets had no model number on them) - but needs something',
  `brand_id` int(11) unsigned NOT NULL COMMENT 'All sets must have a brand, this ties them back to a manufacturer',
  `start_year` year(4) DEFAULT NULL,
  `start_year_approx` tinyint(3) unsigned DEFAULT '0',
  `end_year` year(4) DEFAULT NULL,
  `end_year_approx` tinyint(3) unsigned DEFAULT '0',
  `num_valves` smallint(5) unsigned DEFAULT NULL COMMENT 'Number of valves if known, otherwise leave blank',
  `valve_lineup` text,
  `bands` tinyint(3) unsigned DEFAULT NULL COMMENT 'Number of bands (ie: DW = 2)',
  `notes` longtext COMMENT 'Information about this set',
  `if` text COMMENT 'IF transformer peak freq.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

-- Dumping data for table nzvr_db.model: ~40 rows (approximately)
DELETE FROM `model`;
/*!40000 ALTER TABLE `model` DISABLE KEYS */;
INSERT INTO `model` (`id`, `chassis`, `code`, `brand_id`, `start_year`, `start_year_approx`, `end_year`, `end_year_approx`, `num_valves`, `valve_lineup`, `bands`, `notes`, `if`) VALUES
	(1, 0, '6 Valve Dual Wave', 3, '1934', 0, NULL, 0, 6, '6D6, 6A7, 6D6, 6B7, 42, 80', 2, '<p>6-valve chassis built by RCNZ, near-standard \'baking pan\' design, with dark metallic gold paint rather than the usual cadmium plating.  Also notable square \'tabs\' on the corners of the chassis rather than the usual rounded corners.  First Pacific model with \'aero\' dial.  Almost identical to Courtenay 108 circuitry (which appears to be identical, except for 2.5V valves).</p>', '256kc/s'),
	(2, 1, 'Raleigh', 3, '1934', 0, NULL, 0, NULL, NULL, 2, '<p>Pacific Radio Ltd art deco tabletop 6-valve dual wave model from 1934</p>', NULL),
	(3, 1, 'Elite', 3, '1934', 0, NULL, 0, NULL, NULL, 2, '<p>Pacific Radio Ltd stunning art deco dual-wave console from 1934</p>', NULL),
	(4, NULL, 'Alabama', 9, '1956', 1, '1962', 1, 5, 'ECH81, EF89, EBC91, EL84, EZ80', 1, '<p>The Philco Alamaba is a 5-valve mantle set available in ivory, grey, green, blue, red and brown</p>\r\n<p>Almost identical to the Majestic set that replaced it after Philco disappeared as a brand in New Zealand, and almost identical to the La Gloria Imp (the main difference being the lack of louvres on the right side of the dial).</p>', '465kc/s'),
	(5, NULL, '401', 9, '1954', 0, NULL, 0, 4, 'ECH42, EAF42, EL41, EZ40', 1, '<p>4-valve predecessor to the well-known (if not by name) <a href="/model/philco/alabama">Philco Alabama</a>.  Known in some literature as the \'Philco Nevada\'</p>', NULL),
	(6, 46, '5M', 1, '1952', 0, NULL, 0, 5, '6BE6, 6BA6, 6AV6, 6AQ5, 6X4', 1, '<p>Also sold as a Columbus model, this was the last small receiver ever sold under the Courtenay label - within two years Turnbull and Jones would have pulled out of the radio receiver market and the Courtenay brand would be consigned to history.  This receiver was known as the \'Talisman\', named after the HMS Talisman, a WW2 Triton class submarine.</p>', NULL),
	(7, NULL, 'Colt', 10, '1951', 0, '1980', 0, NULL, 'Various<br>\r\n5B4:   ECH41 or ECH42 or ECH81, EF41, EBC41, EL41, EZ40<br>\r\n5B60: ECH81, EF89, EBC81, EL84, EZ80<br>\r\n5B61: Same as 5B60, although later variants had a solid state rectifier<br>\r\n5B67: ECH81, EF89, EBC81, EL84, BY179 Silicon Rectifier<br><br>\r\nNote: the chassis numbers hint at the model year:  5B<b>4</b>=195<b>4</b>, 5B<b>60</b>=19<b>60</b> etc - however these chassis codes are not found on the chassis so some detective work is required to find the model you\'re working with.', 1, '<p><b>The Bell Colt</b> was the biggest-selling, longest-running and arguably the best known model of valve radio ever designed and built in New Zealand.  The ubiquitous Colt spanned almost 30 years and saw several different chassis versions with 3, 4 and 5 valves, and two different versions of a transistorised model for the last few years of production.</p>\r\n<p>Along with different circuitry, there were many different dial layouts, at least 7 cabinet colours (with various tones of colours as well) and even some different cabinet styles including a light- and a dark-toned solid oak cabinet being offered.<br><a class=\'non_gallery\' title="Airzone Cub (Aus.)" href="/static/images/models/bell/colt/img/airzone.jpg"><img class="img_right" src="/static/images/models/bell/colt/img/airzone.jpg" title="Airzone Cub (Aus.)"/></a>The plastic cabinet dies came from Australia where they were used for the Airzone Cub, just as the previous Bell mantle, the 5E, had used the fragile Airzone 458 cabinet.<br>\r\nYou can see the mold marks for the Airzone logo mounting area on the early cabinets, but the dies must have been modified at some stage because these marks are not visible on later models</p>\r\n<p><a class=\'non_gallery\' title="Push-On Plastic Knobs" href="/static/images/models/bell/colt/img/pushon.jpg"><img class="img_left" src="/static/images/models/bell/colt/img/pushon.jpg" title="Push-On Plastic Knobs"/></a>There are also two different control versions - one has recessed shafts with push-on plastic knobs, and these can be an absolute nightmare to remove if there is <b>any</b> hint of corrosion on the shaft (sometimes needing to be broken off).  <a class=\'non_gallery\' title="Cracked Bell Colt Knobs" href="/static/images/models/bell/colt/img/molded.jpg"><img class="img_right" src="/static/images/models/bell/colt/img/molded.jpg" title="Cracked Bell Colt Knobs"/></a>The other has shafts that pass through the cabinet and these models generally use a grub-screw mounted molded knob more reminiscent of the early-style bakelite knobs.  Its common for these knobs to crack, most likely due to overtightening as they have no metallic sleeve.<br> These are not the only knobs fitted to Colts, and while many arguments arise as to what knobs a Colt SHOULD have, so many of these were produced over the years (more than 6500 in 1961 alone, that\'s around 20,000 knobs not counting the world-wave models which needed one extra!) that it seems reasonable that the factory would use whatever it had (or could get) if-and-when it ran out of one type.</p>\r\n<p><b>OTHER \'COLT\' MODELS</b><br>\r\n<a href="/explorer">EXPLORER</a>: A dual-wave model with a shortwave band.<br>\r\n<a href="/champ">CHAMP</a>: A three-valve set.<br>\r\n<a href="/planet">PLANET</a>: The oak-cabinet models<br>\r\n<a href="/solid state colt">SOLID STATE COLT</a>: The Solid State (Transistorised) model from 1973 onward</p>\r\n<p><a class=\'non_gallery\' title="B&B Skymaster Colt" href="/static/images/models/bell/colt/img/skymaster.jpg"><img class="img_left" src="/static/images/models/bell/colt/img/skymaster.jpg" title="B&B Skymaster Colt"/></a>The Bell Colt was also produced as a Skymaster model for Bond and Bond, and a \'marine\' version of the dual wave chassis without tone control was seen in a Fountain model.<a class=\'non_gallery\' title="Fountain Marine Band" href="/static/images/models/bell/colt/img/fountain.jpg"><img class="img_right" src="/static/images/models/bell/colt/img/fountain.jpg" title="Fountain Marine Band"/></a>  In 1962 when Bell dropped the Colt in favour of its new \'General Radio\' line, Tee Vee  Radio Ltd took over production as the \'Tee-Rad Colt\' for a couple of years, however they were not successful and production went back to Bell.</p>\r\n', 'Various<br>\r\n5B4:   462kc/s<br>\r\n5B60: 455kc/s<br>\r\n5B61: 455kc/s<br>\r\n5B67: 455kc/s'),
	(8, NULL, 'Explorer', 10, '1960', 1, NULL, 0, 5, 'ECH81, EF89, EBC81, EL84, EZ80', 2, '<p>The Bell Colt \'Explorer\' was a dual-wave model with a shortwave band. To make room for the band switch, the tone control was moved to the back of the chassis, and the band switch was fitted in the middle control position on the front.</p>\r\n<p>See the <a href="/colt">Bell Colt</a> for more information on this model.</p>\r\n', NULL),
	(9, NULL, 'Champ', 10, '1960', 1, NULL, 0, 5, 'Unknown', 1, '<p>The Bell Colt \'Champ\' was the budget model, sporting just 3 valves and having an unusual tuning arrangement that appears to have been sliding slugs inside coils rather than tuning gangs.</p>\r\n<p>See the <a href="/colt">Bell Colt</a> for more information.</p>\r\n', NULL),
	(10, NULL, 'Planet', 10, '1958', 1, '1960', 1, 5, 'ECH81, EF89, EBC81, EL84, EZ80', 1, '<p>The Bell Colt \'Planet\' may have been a dual-wave set although its unclear from the sales literature at hand.  JWS states it was, yet on the opposite page in More Golden Age of Radio he has a brochure that does not refer to it as being \'world-wave\', just \'Australasian reception\', same as the Colt.  Its likely that both were produced, given the lifespan of the model.</p>\r\n<p>See the <a href="/colt">Bell Colt</a> for more information.</p>\r\n', NULL),
	(11, NULL, 'OA', 12, NULL, 0, NULL, 0, 5, 'ECH81, EF89, EBC81, EL84, EZ80', 2, '<p>The Fountain model O.A. is a dual-band set with a formica finish, and appears to be based on the <a href="/colt">Bell Colt</a> World-Wave chassis minus the tone control</p>', 'Most likely 455kc/s'),
	(12, NULL, 'Solid State Colt', 10, '1973', 0, '1980', 0, 0, 'Transistor lineup unknown', 1, '<p>The Solid State Colt was the final version, and the end of an era.</p>', NULL),
	(13, 30, '12', 2, '1940', 1, NULL, 0, NULL, NULL, NULL, '<p>The tiny broadcast-only Columbus Model 12</p>', NULL),
	(14, 30, '12', 1, '1940', 1, NULL, 0, NULL, NULL, NULL, '<p>The tiny broadcast-band only Model 12, also known as the Courtenay \'Tiki\'.</p>', NULL),
	(15, NULL, 'Broadcaster', 15, '1936', 1, NULL, 0, 5, NULL, 1, '<p>The awesome-looking Haywin Broadcaster was built for Hay\'s Dept Store in Christchurch.</p>', NULL),
	(16, NULL, 'Atom', 15, '1949', 0, NULL, 0, 4, NULL, 1, '<p>The Haywin Atom was a tiny white plastic-cased 4-valve bookshelf receiver.</p>', NULL),
	(17, NULL, '84', 2, '1938', 0, NULL, 0, 5, '6A8, 6K7, 6B7, 42, 80 (and 6E5 magic eye on some models)', 1, '<p>5-valve + 6E5 magic eye, Courtenay version as well which was sighted without the magic eye', '456kc/s'),
	(18, NULL, '84', 1, '1938', 0, NULL, 0, 5, '6A8, 6K7, 6B7, 42, 80 (and 6E5 magic eye on some models)', 1, '<p>5-valve + 6E5 magic eye, Columbus version as well', '456kc/s'),
	(19, NULL, '65', 2, '1940', 0, NULL, 0, 6, '6K7G, 6K8G, 6K7G, 6B8G, 6F6G, 5Y3G and 6E5 magic eye', 2, '<p>All-world reception, spin tuning dial, automatic 6-station push button station selector.  Table model photo courtesy of Keith Annabell of radio-restoration.com</p>', '464kc/s, 4kc wide flat-top to improve high frequency response (see RCNZ Service Supplement S39/1 I.F. Channels in Models 60 and 65, 17th March 1939)'),
	(20, NULL, '5151', 16, '1951', 0, NULL, 0, 5, NULL, 1, '<p>Bakelite cabinet, distinctive sweep in from each top corner.  Also produced in 1952 as a 5152.</p>', NULL),
	(21, NULL, '756', 16, '1946', 0, NULL, 0, 7, NULL, 5, '<p>7-valve, bandspread, 1946</p>', NULL),
	(22, NULL, '617', 16, '1947', 0, NULL, 0, 6, NULL, 1, '<p>6-valve, AM only, 1947</p>', NULL),
	(23, NULL, '75', 2, '1940', 0, NULL, 0, 6, 'KTW61, X65, 6K7G, 6B8G, 6F6G, U50 and Y63 Magic Eye', 5, '<p>6-valve + eye, bandspread', '455kc/s'),
	(24, NULL, '24', 1, '1937', 0, NULL, 0, 5, NULL, NULL, '<p>Unusual 5-valve + eye set with NZ stations on the dial and a list of Australian stations / frequencies in the right-hand window</p>', NULL),
	(25, NULL, '1', 10, '1952', 0, NULL, 0, NULL, NULL, 1, '<p>The Model 1 was the first portable under the Bell brand.</p>', NULL),
	(26, NULL, '6P7', 10, '1955', 0, NULL, 0, NULL, NULL, 1, '<p>The 6P7 was a 3-way portable (AC / DC / Battery), and is noted as being one of several \'Hot-Boxes\' available from various manufacturers at the time by John Stokes.  The tranformerless design made them lighter, but less reliable and also meant that the mains was directly connected to the chassis - hopefully neutral, but the plugs at that time were not polarised and so it depended entirely on luck, and the fact that the entire chassis was insulated... however one broken knob could potentially (pun intended) see you and 230V making contact through the metal shaft of the control</p>', NULL),
	(27, NULL, '65-BC', 18, '1936', 0, NULL, 0, 6, NULL, 1, '<p>Data from the 1936-37 Johns catalogue:<br>6-Valve broadcast only receiver, AVC, Celestion speaker, external speaker jacks, Tuning meter, pick-up terminals.  Cabinet hand-polished <a href="https://en.wikipedia.org/wiki/Duco">Duco</a>.</p>', NULL),
	(28, NULL, '5M4', 5, '1954', 0, '1956', 1, 5, 'ECH42, EF41, EBC41, EL41, EZ40', 1, '<p>The Clipper 5M4 was the first plastic radio to be fully designed and manufactured in New Zealand (other models of this size existed - the Bell Colt for example - but they used imported dies for the cabinet).  Akrad designed and manufactured the mold for their cabinet.Several colours were released, however ivory is by far the most common to be found.  The rarest would be black, as it is believed only a handful were made to be presented to the shareholders of the company.  Other known colours are red, blue, brown and green.</p>\r\n<p><a class=\'non_gallery\' title="2 Chassis Variants - Bottom Side" href="/static/images/models/clipper/5m4/5m4oldnewbottom.jpg"><img class="img_left" src="/static/images/models/clipper/5m4/5m4oldnewbottom.jpg" title="2 Chassis Variants - Bottom Side"/></a><a class=\'non_gallery\' title="2 Chassis Variants - Top Side" href="/static/images/models/clipper/5m4/5m4oldnewtop.jpg"><img class="img_left" src="/static/images/models/clipper/5m4/5m4oldnewtop.jpg" title="2 Chassis Variants - Top Side"/></a>\r\nThere are at least two chassis variants, both using almost the same circuit and the same valve lineup, and can be seen here with the older variant at the bottom.  The earlier chassis has the serial number stamped on the back while later models have a serial plate riveted on.</p<p>Earlier models also have round IF cans, where the later models use more modern rectangular units.</p<p>The later models have a Rola 5" speaker providing feedback to the 1st audio section via a resistive divider and also have an internal foil antenna glued to the inside of the cabinet and attached by a small bolt and nut in addition to the external orange aerial wire where the earlier models have no feedback and just the external orange aerial wire (both have a black earth wire as well).</p><p>A few other minor variations have been noted, such as Ducon capacitors in the earlier models with mustard caps in the later and a metal shield over the dial lamp in the later ones to try and cut down on the amount of glow through the cabinet.</p>', NULL),
	(29, 1, 'Nottingham', 3, '1934', 0, NULL, 0, NULL, NULL, 2, '<p>Pacific Radio Ltd art deco tabletop 6-valve dual wave model from 1934</p>', NULL),
	(30, 0, 'RCNZ 12', 0, '1940', 1, NULL, 0, 5, '6K8G, 6K7G, 6B8G, 6K6G, 84', 1, 'A small 5-valve mantle-sized chassis used in Columbus and Courtenay sets - designed for AC or DC (transformerless) operation (with modifications).  Notable for having a very shallow chassis necessitating a riser spot-welded to the back in order to mount the serial plate', '455kc/s'),
	(31, NULL, '495BC', 17, '1949', 0, NULL, 0, 5, '7S7, 7B7, 7C6 (or 6AQ6 ?), 7C5, 7Y4', 1, '<p>5-valve broadcast model.  At least 2 chassis variants - one of which has Philips(?) style IF cans, a miniature valve in the lineup, a different tuning cap (and reversed dial) and other differences like the orientation of the tone switch - possibly different manufacturers?  Or just different runs with changes to suit parts availability (although its odd that the tone switch was rotated and one run was stamped with high / low and the other wasn\'t).  Both sighted models have \'Manufactured by H.M.V. (NZ) Ltd\', however its possible one (or both) were manufactured by other companies, such as Collier & Beale.</p>', '455kc/s'),
	(32, NULL, 'BCU', 19, '1937', 0, NULL, 0, NULL, NULL, NULL, '<p>7-valve all-wave</p>', NULL),
	(33, 36, 'AAU', 19, '1936', 0, NULL, 0, 6, NULL, 2, '<p>6-valve dual-wave set, 2.5V valves, no eye</p>', NULL),
	(34, NULL, '108', 1, '1934', 0, NULL, 0, 6, '58, 2A7, 58, 2B7, 2A5, 80', 2, '<p>Courtenay 108, first aero-dial set from Radio Corp NZ.  Virtually identical to Pacific 6-valve Dual Wave chassis found in the likes of the Pacific Elite, Raleigh, etc. although Pacific used the 6.3V versions of the same valve lineup</p>', '256kc/s'),
	(36, 0, 'AAU', 19, '1936', 0, NULL, 0, 6, '58, 2A7, 58, 2B7, 2A5, 80', 2, '<p>6-valve dual-wave chassis fitted to several models</p>', NULL),
	(37, 36, 'XS', 23, '1936', 0, NULL, 0, 6, NULL, 2, '<p>6-valve dual-wave model, chassis and layout label in cabinet seems nearly identical to the Ultimate AAU (dial is different)</p>', NULL),
	(38, 0, 'RCNZ 38', 0, '1937', 0, NULL, 0, 6, '6D6, 6A7, 6D6, 6B7, 42, 80 and 6E5 Magic Eye', 3, '3-band chassis covering broadcast 550 - 1500kHz, Intermediate SW 2.1 - 6MHz and SW 6 - 18MHz.  The chassis uses a unique spiral dial tuning system with an effective tuning distance of over 2 feet and fast / slow tuning to provide very good control of the frequency.  The spiral tuning system is complex though, and unless its been restored it always seems to be broken on sets found today.  The dial assembly consists of either a red-tinted spiral line of light or a red dot (depending on brand) that indicates the frequency on a novel trio of spirals for the three bands.  The band selector slightly rotates the system so that the dot or the end of the line aligns with the correct band.  Setting this up takes some patience and trial-error (There is some indication that there was to be a service bulletin from RCNZ for the dial assy, but it has never been sighted).', '456kc/s'),
	(39, 38, '38', 1, '1937', 0, NULL, 0, NULL, NULL, NULL, 'The Courtenay model 38 used a diamond-shaped point of light to indicate the frequency, in a system they called "Phantom Ace" tuning.  The 2 known cabinet designs were called the Opera (Tombstone model) and Ballad (Console).</p>\r\n<p>The diamond shaped point of light is generated by two aluminium discs with opposing spiral-shaped slots cut in them.  They rotate independently of each other and in sync with the tuning gang in order to produce a hole where the two spirals meet that indicates the position of the tuning gang.', NULL),
	(40, 38, '38', 2, '1937', 0, NULL, 0, NULL, NULL, NULL, 'The Columbus model 38 used a diamond-shaped point of light to indicate the frequency, in a system they called "Spotlight Spiral Dial" tuning.  The 2 known cabinet designs have no name, although the slatted front model was advertised as being scientifically designed to spread all sound frequencies evenly.</p>\r\n<p>The diamond shaped point of light is generated by two aluminium discs with opposing spiral-shaped slots cut in them.  They rotate independently of each other and in sync with the tuning gang in order to produce a hole where the two spirals meet that indicates the position of the tuning gang.', NULL),
	(41, 38, '38', 3, '1937', 0, NULL, 0, NULL, NULL, NULL, 'The Pacific model 38 used a spiral line of light to indicate the frequency.  Only one cabinet design has been sighted, which is very conventional by the standards of their earlier Art Deco inspired cabinet designs</p>\r\n<p>The spiral line of light is generated by two aluminium discs, one with a spiral-shaped slot cut in it and the other with a large opening with curved sides.  They rotate independently of each other and in sync (but at different speeds) to the tuning gang in order to produce a line from the center out to a point that indicates the position of the tuning gang.', NULL),
	(42, 38, '38', 8, '1937', 0, NULL, 0, NULL, NULL, NULL, 'The Stella model 38 \'Aquila\' used a diamond-shaped point of light to indicate the frequency, in a system probably called "Spotlight Spiral Dial" tuning (based on the wording of an advert from a Stella agent).  Only one known cabinet design, which is a standard looking tombstone.</p>\r\n<p>The diamond shaped point of light is generated by two aluminium discs with opposing spiral-shaped slots cut in them.  They rotate independently of each other and in sync with the tuning gang in order to produce a hole where the two spirals meet that indicates the position of the tuning gang.', NULL),
	(43, 0, 'RCNZ 18', 1, '1936', 0, '1937', 1, 6, '6D6, 6A7, 6D6, 6B7, 42, 80 and 6E5 magic eye on some models', 2, '<p>Model 18 chassis, found in tabletop cabinets, often with a vibrator power supply, or tombstone as mains only.  Dual wave. Radiomuseum has a tombstone without magic eye, and the schematic does not show one.  Production serial numbers have been noted in both 1936 and 1937.', '456kc/s'),
	(44, 43, '18', 1, '1936', 0, NULL, 0, NULL, NULL, NULL, 'Courtenay released several variations of the RCNZ model 18 including table top and tombstone models - some have magic eyes fitted.', NULL),
	(45, 43, '18', 2, '1936', 0, '1937', 0, NULL, NULL, NULL, 'Columbus had several different model 18 variants - these were a 1936 dual wave 6-valve (plus eye on some models) set.', NULL),
	(46, 0, 'RCNZ 5M', 3, '1951', 1, NULL, 0, 5, '6BE6, 6BA6, 6AV6, 6AQ5, 6X4', 1, '<p>5-valve mantle radio chassis, found in Columbus and Courtenay radios that looked very much the same aside from the dial.  Similar in style to the 5, and physically narrower than the 5B.</p>', NULL),
	(47, NULL, '6', 2, '1946', 0, NULL, 0, 5, NULL, 1, '<p>The model 6 was released for Columbus only, and had a metal body with moulded plastic front.  It was a very small cabinet for the time considering the octal GT style valves.</p><p>Images courtesy of kevsradios.100webcustomers.com</p>', NULL);
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

-- Dumping structure for table nzvr_db.valve
DROP TABLE IF EXISTS `valve`;
CREATE TABLE IF NOT EXISTS `valve` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `filename` tinytext NOT NULL,
  `type` tinytext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8;

-- Dumping data for table nzvr_db.valve: ~82 rows (approximately)
DELETE FROM `valve`;
/*!40000 ALTER TABLE `valve` DISABLE KEYS */;
INSERT INTO `valve` (`id`, `name`, `filename`, `type`) VALUES
	(1, '42', '42.jpg', '42 / 2A5 / 6F6 Output Pentode'),
	(2, '2A5', '42.jpg', '42 / 2A5 / 6F6 Output Pentode'),
	(3, '6F6', '42.jpg', '42 / 2A5 / 6F6 Output Pentode'),
	(4, '6F6G', '42.jpg', '42 / 2A5 / 6F6 Output Pentode'),
	(5, '6F6GT', '42.jpg', '42 / 2A5 / 6F6 Output Pentode'),
	(6, '6D6', '6D6.jpg', '6D6 (6.3V version of 58) RF / IF Amp'),
	(7, '6A7', '6A7.jpg', '2A7 / 6A7 Mixer / Osc'),
	(8, '6A8', '6A8.jpg', '6A8 Mixer / Osc'),
	(9, '6A8G', '6A8.jpg', '6A8 Mixer / Osc'),
	(10, '6A8GT', '6A8.jpg', '6A8 Mixer / Osc'),
	(11, '2B7', '6B7.jpg', '2B7 / 6B7 First Audio / Detector'),
	(12, '6B7', '6B7.jpg', '2B7 / 6B7 First Audio / Detector'),
	(13, '6B8G', '6B8.jpg', '6B8 First Audio / Detector'),
	(15, '6B8', '6B8.jpg', '6B8 First Audio / Detector'),
	(17, '6E5', '6E5.jpg', '6E5 Magic Eye'),
	(18, '2A7', '6A7.jpg', '2A7 / 6A7 Mixer / Osc'),
	(19, '6K6', '6K6.jpg', '6K6 Output Pentode AC/DC'),
	(20, '6K7', '6K7.jpg', '6K7 RF / IF Amp'),
	(21, '6K7G', '6K7.jpg', '6K7 RF / IF Amp'),
	(22, '6K8', '6K8.jpg', '6K8 Mixer / Osc'),
	(23, '6K8G', '6K8.jpg', '6K8 Mixer / Osc'),
	(24, '6K8GT', '6K8.jpg', '6K8 Mixer / Osc'),
	(25, '6F6GT/G', '42.jpg', '42 / 2A5 / 6F6 Output Pentode'),
	(26, '80', '80.jpg', 'Type 80 Rectifier - Full Wave AC/DC'),
	(27, '84', '84.jpg', 'Type 84 Rectifier - Full Wave AC'),
	(28, 'ECH42', 'ECH42.jpg', 'ECH42 / 6CU7 Mixer / Osc'),
	(29, 'EF41', 'EF41.jpg', 'EF41 / 6CJ5 RF Pentode'),
	(30, 'ECH41', 'ECH41.jpg', 'ECH41 Mixer / Osc'),
	(32, 'ECH81', 'ECH81.jpg', 'ECH81 / 6AJ8 Mixer / Osc'),
	(33, '6AJ8', 'ECH81.jpg', 'ECH81 / 6AJ8 Mixer / Osc'),
	(34, '6CU7', 'ECH42.jpg', 'ECH42 / 6CU7 Mixer / Osc'),
	(35, '6CJ5', 'EF41.jpg', 'EF41 / 6CJ5 RF Pentode'),
	(36, 'EBC41', 'EBC41.jpg', 'EBC41 / 6CV7 First Audio / Detector'),
	(37, '6CV7', 'EBC41.jpg', 'EBC41 / 6CV7 First Audio / Detector'),
	(38, 'EL41', 'EL41.jpg', 'EL41 / 6CK5 Output Pentode'),
	(39, '6CK5', 'EL41.jpg', 'EL41 / 6CK5 Output Pentode'),
	(40, 'EZ40', 'EZ40.jpg', 'EZ40 Rectifier - Full Wave AC'),
	(41, 'EZ80', 'EZ80.jpg', 'EZ80 / 6V4 Rectifier - Full Wave AC'),
	(42, '6V4', 'EZ80.jpg', 'EZ80 / 6V4 Rectifier - Full Wave AC'),
	(43, 'EL84', 'EL84.jpg', 'EL84 / 6BQ5 Output Pentode'),
	(44, '6BQ5', 'EL84.jpg', 'EL84 / 6BQ5 Output Pentode'),
	(45, 'EBC81', 'EBC81.jpg', 'EBC81 / 6BD7 First Audio / Detector'),
	(46, '6BD7', 'EBC81.jpg', 'EBC81 / 6BD7 First Audio / Detector'),
	(47, 'EF89', 'EF89.jpg', 'EF89 / 6DA6 RF Pentode'),
	(48, '6DA6', 'EF89.jpg', 'EF89 / 6DA6 RF Pentode'),
	(49, '6X4', '6X4.jpg', 'EZ90 / 6X4 Rectifier - Full Wave AC'),
	(50, 'EZ90', '6X4.jpg', 'EZ90 / 6X4 Rectifier - Full Wave AC'),
	(51, '6BE6', '6BE6.jpg', 'EK90 / 6BE6 Mixer / Osc'),
	(52, 'EK90', '6BE6.jpg', 'EK90 / 6BE6 Mixer / Osc'),
	(54, '6BA6', '6BA6.jpg', 'EF93 / 6BA6 RF / IF Pentode'),
	(55, 'EF93', '6BA6.jpg', 'EF93 / 6BA6 RF / IF Pentode'),
	(56, '6AV6', '6AV6.jpg', 'EBC91 / 6AV6 First Audio / Detector'),
	(57, 'EBC91', '6AV6.jpg', 'EBC91 / 6AV6 First Audio / Detector'),
	(58, '6AQ5', '6AQ5.jpg', 'EL90 / 6AQ5 Output Beam Tetrode'),
	(59, 'EL90', '6AQ5.jpg', 'EL90 / 6AQ5 Output Beam Tetrode'),
	(60, 'N78', 'N78.jpg', 'N78 / 6BJ5 Output Pentode'),
	(61, '6BJ5', 'N78.jpg', 'N78 / 6BJ5 Output Pentode'),
	(62, '6X5', '6X5.jpg', '6X5 / EZ35 Rectifier - Full Wave AC/DC'),
	(63, '6X5GT/G', '6X5.jpg', '6X5 / EZ35 Rectifier - Full Wave AC/DC'),
	(65, 'EAF42', 'EAF42.jpg', 'EAF42 / 6CT7 RF / IF Pentode'),
	(66, '6CT7', 'EAF42.jpg', 'EAF42 / 6CT7 RF / IF Pentode'),
	(67, '6K6G', '6K6G.jpg', '6K6 Output Pentode'),
	(68, '6K6GT', '6K6G.jpg', '6K6 Output Pentode'),
	(69, 'EZ35', '6X5.jpg', '6X5 / EZ35 Rectifier - Full Wave AC/DC'),
	(70, '5Y3G', '5Y3.jpg', 'Type 5Y3G / 5Y3GT Rectifier - Full Wave AC/DC'),
	(71, '5Y3GT', '5Y3.jpg', 'Type 5Y3G / 5Y3GT Rectifier - Full Wave AC/DC'),
	(72, '6AQ6', '6AQ6.jpg', '6AQ6 First Audio / Detector'),
	(73, '7Y4', '7Y4.jpg', '7Y4 Rectifier - Full Wave'),
	(74, '7C5', '7C5.jpg', '7C5 Beam Power Output Amplifier'),
	(75, '7C6', '7C6.jpg', '7C6 1st Audio / Dual Detector'),
	(76, '7B7', '7B7.jpg', '7B7 RF Pentode'),
	(77, '7S7', '7S7.jpg', '7S7 Mixer / Osc'),
	(78, '58', '58.jpg', '58 (2.5V version of 6D6) RF / IF Amp'),
	(79, 'U50', 'U50.jpg', 'Bi-Phase Half-Wave Directly Heated Rectifier'),
	(80, 'ECH35', 'ECH35.jpg', 'ECH35 / X65 Mixer / Osc'),
	(81, 'X65', 'ECH35.jpg', 'ECH35 / X65 Mixer / Osc'),
	(82, 'KTW61', 'KTW61.jpg', 'Variable-MU Screened Tetrode (RF / IF)'),
	(83, '6U5', '6U5.jpg', '6U5 / 6G5 Magic Eye'),
	(84, '6G5', '6U5.jpg', '6U5 / 6G5 Magic Eye'),
	(85, '6U5G', '6U5.jpg', '6U5 / 6G5 Magic Eye'),
	(86, '6G5G', '6U5.jpg', '6U5 / 6G5 Magic Eye'),
	(87, 'Y63', '6U5.jpg', '6U5 / 6G5 (and Y63) Magic Eye');
/*!40000 ALTER TABLE `valve` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
