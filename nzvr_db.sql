-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 09, 2016 at 11:30 AM
-- Server version: 5.5.53
-- PHP Version: 5.3.10-1ubuntu3.25

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `nzvr_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `brand`
--

CREATE TABLE IF NOT EXISTS `brand` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `tagline` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT 'ie: Pacific Radio Co is ''In a sphere of its own'', Courtenay was ''Known for Tone''',
  `manufacturer_id` int(11) NOT NULL DEFAULT '0' COMMENT 'fk from manufacturer table',
  `distributor_id` int(11) NOT NULL DEFAULT '0' COMMENT 'fk from distributor table',
  `address` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT 'Address, or town / city company was located in',
  `year_started` year(4) NOT NULL COMMENT 'Year started distributing if known',
  `year_ended` year(4) NOT NULL COMMENT 'Year ended distributing if known',
  `notes` longtext CHARACTER SET utf8 NOT NULL COMMENT 'Details about the distributor',
  `logo` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `brand`
--

INSERT INTO `brand` (`id`, `name`, `tagline`, `manufacturer_id`, `distributor_id`, `address`, `year_started`, `year_ended`, `notes`, `logo`) VALUES
(1, 'Courtenay', 'Known For Tone', 3, 1, 'Courtenay Terrace, Wellington', 1931, 1956, 'Coutenay was originally manufactured by W. Marks Ltd, but in 1934 switched to RCNZ.', '');

-- --------------------------------------------------------

--
-- Table structure for table `distributor`
--

CREATE TABLE IF NOT EXISTS `distributor` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `known_as` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT 'This field is for the url, logo img etc - hence unique',
  `address` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT 'Address, or town / city company was located in',
  `notes` longtext CHARACTER SET utf8 NOT NULL COMMENT 'Details about the distributor',
  `logo` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `distributor`
--

INSERT INTO `distributor` (`id`, `name`, `known_as`, `address`, `notes`, `logo`) VALUES
(1, 'Turnbull and Jones Ltd', 'Turnbull and Jones', 'Wellington', 'Turnbull and Jones were tied up with RCNZ, supplying high quality radio manufacturing parts to them.', '');

-- --------------------------------------------------------

--
-- Table structure for table `manufacturer`
--

CREATE TABLE IF NOT EXISTS `manufacturer` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `known_as` varchar(50) CHARACTER SET utf8 NOT NULL COMMENT 'This field is for the url, logo img etc - hence unique',
  `address` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT 'Address, or town / city company was located in',
  `year_started` year(4) NOT NULL COMMENT 'Year started manufactuing if known',
  `year_ended` year(4) NOT NULL COMMENT 'Year ended manufactuing if known',
  `notes` longtext CHARACTER SET utf8 NOT NULL COMMENT 'Details about the manufacturer',
  `logo` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `manufacturer`
--

INSERT INTO `manufacturer` (`id`, `name`, `known_as`, `address`, `year_started`, `year_ended`, `notes`, `logo`) VALUES
(1, 'Akrad Radio Corporation Ltd', 'Akrad', 'Waihi', 1934, 1982, 'Akrad Radio was formed in Waihi, long long ago.', ''),
(2, 'His Master''s Voice (N.Z.) Ltd', 'HMV', 'Wellington', 1940, 1955, 'HMV NZ was a company', ''),
(3, 'Radio Corporation of New Zealand', 'RCNZ', 'Wellington', 1934, 1959, 'One of the biggest radio manufacturers in NZ - they build a lot of their own components in-house.', '');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `user_id` int(10) NOT NULL AUTO_INCREMENT,
  `date_joined` int(11) NOT NULL DEFAULT '0',
  `username` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`,`email`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `date_joined`, `username`, `email`, `password`) VALUES
(1, 1481185199, 'admin', 'nzvr_admin@essentialtech.co.nz', '13601bda4ea78e55a07b98866d2be6be0744e3866f13c00c811cab608a28f322');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
