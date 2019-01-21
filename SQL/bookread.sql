-- phpMyAdmin SQL Dump
-- version 4.0.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 06, 2018 at 07:32 AM
-- Server version: 5.6.12-log
-- PHP Version: 5.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `bookread`
--
CREATE DATABASE IF NOT EXISTS `bookread` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `bookread`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_purchase`(IN `c_id` INT, IN `e_id` INT, IN `p_id` INT, IN `pur_qty` INT)
begin
declare totalprice decimal(7,2);
declare ori_price decimal(6,2);
declare rate decimal(3,2);
declare old_qoh int;
declare old_plus_sold int;
select original_price,discnt_rate,qoh into ori_price,rate,old_qoh from products where pid = p_id;

set totalprice = (ori_price-rate)*pur_qty;


insert into purchases(cid,eid,pid,qty,ptime,total_price) values(c_id, e_id, p_id, pur_qty,CURRENT_TIMESTAMP,totalprice);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `del_product`(IN p_id int)
begin
delete from products where pid = p_id;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `find_product`(IN prod_id int)
begin
		select * from products where pid = prod_id;
	end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_product`(IN pname_ varchar(15), qoh_ int(5), qoh_threshold_ int(5), original_price_ decimal(6,2),discnt_rate_ decimal(3,2),sid_ int,imgname_ varchar(50) )
begin
insert into products(pname, qoh, qoh_threshold, original_price,discnt_rate,sid,imgname) values(pname_, qoh_, qoh_threshold_, original_price_,discnt_rate_,sid_,imgname_);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `report_monthly_sale`(IN prod_id int)
begin
		select pname,imgname,left( date_format(ptime,'%M'),3) as month,year(ptime) as year,sum(qty) as total_qty,sum(total_price) as total_dollar,sum(total_price)/sum(qty) as avg_price from purchases,products where purchases.pid = prod_id and purchases.pid = products.pid group by DATE_FORMAT(ptime,'%Y-%m');
	end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_customers`()
begin
select * from customers;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_employees`()
begin
		select * from employees;
	end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_logs`()
begin
		select * from logs;
	end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_products`()
begin
		select * from products;
	end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_purchases`()
begin
		select * from purchases;
	end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_suppliers`()
begin
		select * from suppliers;
	end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE IF NOT EXISTS `cart` (
  `c_name` varchar(100) NOT NULL,
  `p_name` varchar(50) NOT NULL,
  `price` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE IF NOT EXISTS `customers` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `cname` varchar(15) DEFAULT NULL,
  `city` varchar(15) DEFAULT NULL,
  `visits_made` int(5) NOT NULL DEFAULT '0',
  `last_visit_time` datetime DEFAULT NULL,
  `password` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`cid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=16 ;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`cid`, `cname`, `city`, `visits_made`, `last_visit_time`, `password`) VALUES
(1, 'latha', 'Mumbai', 4, '2018-11-24 17:50:31', '123'),
(0, 'Admin', 'Kashmir', 7, '2018-11-24 16:47:41', 'Admin'),
(6, 'roshan', 'Chennai', 13, '2018-11-24 17:43:55', 'micans'),
(8, 'ajayhs', 'Bangalore', 22, '2018-11-23 12:31:39', 'ajay'),
(10, 'abhilash', 'Mahadevapura', 2, '2018-11-14 12:31:30', '123@'),
(12, 'joel', 'Kerala', 41, '2018-11-30 02:28:48', '1234');

--
-- Triggers `customers`
--
DROP TRIGGER IF EXISTS `log_update_visit`;
DELIMITER //
CREATE TRIGGER `log_update_visit` AFTER UPDATE ON `customers`
 FOR EACH ROW begin
  if new.visits_made != old.visits_made then
    insert into logs(who,time,table_name,operation,key_value) values('root',CURRENT_TIMESTAMP,'customers','update',new.cid);
  end if;
  end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE IF NOT EXISTS `employees` (
  `eid` int(11) NOT NULL AUTO_INCREMENT,
  `ename` varchar(15) DEFAULT NULL,
  `city` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`eid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`eid`, `ename`, `city`) VALUES
(1, 'Rahul', 'Chennai'),
(2, 'Bob', 'Mailapur'),
(3, 'John', 'Bangalore'),
(4, 'Joel', 'Kerala'),
(5, 'Amy', 'Pondy');

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE IF NOT EXISTS `logs` (
  `logid` int(5) NOT NULL AUTO_INCREMENT,
  `who` varchar(10) NOT NULL,
  `time` datetime NOT NULL,
  `table_name` varchar(20) NOT NULL,
  `operation` varchar(6) NOT NULL,
  `key_value` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`logid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=588 ;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`logid`, `who`, `time`, `table_name`, `operation`, `key_value`) VALUES
(587, 'root', '2018-11-30 02:28:48', 'purchases', 'insert', '196'),
(586, 'root', '2018-11-30 02:28:48', 'customers', 'update', '12'),
(585, 'root', '2018-11-30 02:28:48', 'products', 'update', '2'),
(584, 'root', '2018-11-30 02:28:38', 'purchases', 'insert', '195'),
(583, 'root', '2018-11-30 02:28:38', 'customers', 'update', '12'),
(582, 'root', '2018-11-30 02:28:38', 'products', 'update', '5'),
(581, 'root', '2018-11-28 10:30:20', 'purchases', 'insert', '194'),
(580, 'root', '2018-11-28 10:30:20', 'customers', 'update', '12'),
(579, 'root', '2018-11-28 10:30:20', 'products', 'update', '5'),
(578, 'root', '2018-11-28 10:30:11', 'purchases', 'insert', '193'),
(577, 'root', '2018-11-28 10:30:11', 'customers', 'update', '12'),
(576, 'root', '2018-11-28 10:30:11', 'products', 'update', '3'),
(575, 'root', '2018-11-28 10:27:26', 'purchases', 'insert', '192'),
(574, 'root', '2018-11-28 10:27:26', 'customers', 'update', '12'),
(573, 'root', '2018-11-28 10:27:26', 'products', 'update', '2'),
(572, 'root', '2018-11-28 10:21:45', 'purchases', 'insert', '191'),
(571, 'root', '2018-11-28 10:21:45', 'customers', 'update', '12'),
(570, 'root', '2018-11-28 10:21:45', 'products', 'update', '2'),
(569, 'root', '2018-11-28 10:03:45', 'purchases', 'insert', '190'),
(568, 'root', '2018-11-28 10:03:45', 'customers', 'update', '12'),
(567, 'root', '2018-11-28 10:03:45', 'products', 'update', '2'),
(566, 'root', '2018-11-24 18:25:58', 'purchases', 'insert', '189'),
(565, 'root', '2018-11-24 18:25:58', 'customers', 'update', '12'),
(564, 'root', '2018-11-24 18:25:58', 'products', 'update', '3'),
(563, 'root', '2018-11-24 18:23:11', 'purchases', 'insert', '188'),
(562, 'root', '2018-11-24 18:23:11', 'customers', 'update', '12'),
(561, 'root', '2018-11-24 18:23:11', 'products', 'update', '3'),
(560, 'root', '2018-11-24 18:23:05', 'purchases', 'insert', '187'),
(559, 'root', '2018-11-24 18:23:05', 'customers', 'update', '12'),
(558, 'root', '2018-11-24 18:23:05', 'products', 'update', '1'),
(557, 'root', '2018-11-24 18:11:05', 'purchases', 'insert', '186'),
(556, 'root', '2018-11-24 18:11:05', 'customers', 'update', '12'),
(555, 'root', '2018-11-24 18:11:05', 'products', 'update', '1'),
(554, 'root', '2018-11-24 18:10:58', 'purchases', 'insert', '185'),
(553, 'root', '2018-11-24 18:10:58', 'customers', 'update', '12'),
(552, 'root', '2018-11-24 18:10:58', 'products', 'update', '3'),
(551, 'root', '2018-11-24 17:50:31', 'purchases', 'insert', '184'),
(550, 'root', '2018-11-24 17:50:31', 'customers', 'update', '1'),
(549, 'root', '2018-11-24 17:50:31', 'products', 'update', '3'),
(548, 'root', '2018-11-24 17:50:24', 'purchases', 'insert', '183'),
(547, 'root', '2018-11-24 17:50:24', 'customers', 'update', '1'),
(546, 'root', '2018-11-24 17:50:24', 'products', 'update', '1'),
(545, 'root', '2018-11-24 17:43:55', 'purchases', 'insert', '182'),
(544, 'root', '2018-11-24 17:43:55', 'customers', 'update', '6'),
(543, 'root', '2018-11-24 17:43:55', 'products', 'update', '3'),
(542, 'root', '2018-11-24 17:43:46', 'purchases', 'insert', '181'),
(541, 'root', '2018-11-24 17:43:46', 'customers', 'update', '6'),
(540, 'root', '2018-11-24 17:43:46', 'products', 'update', '5'),
(539, 'root', '2018-11-24 17:43:37', 'purchases', 'insert', '180'),
(538, 'root', '2018-11-24 17:43:37', 'customers', 'update', '6'),
(537, 'root', '2018-11-24 17:43:37', 'products', 'update', '1'),
(536, 'root', '2018-11-24 17:41:58', 'purchases', 'insert', '179'),
(535, 'root', '2018-11-24 17:41:58', 'customers', 'update', '6'),
(534, 'root', '2018-11-24 17:41:58', 'products', 'update', '5'),
(533, 'root', '2018-11-24 17:41:24', 'purchases', 'insert', '178'),
(532, 'root', '2018-11-24 17:41:24', 'customers', 'update', '12'),
(531, 'root', '2018-11-24 17:41:24', 'products', 'update', '7'),
(530, 'root', '2018-11-24 17:40:28', 'purchases', 'insert', '177'),
(529, 'root', '2018-11-24 17:40:28', 'customers', 'update', '12'),
(528, 'root', '2018-11-24 17:40:28', 'products', 'update', '7'),
(527, 'root', '2018-11-24 17:32:45', 'purchases', 'insert', '176'),
(526, 'root', '2018-11-24 17:32:45', 'customers', 'update', '12'),
(525, 'root', '2018-11-24 17:32:45', 'products', 'update', '7'),
(524, 'root', '2018-11-24 17:32:38', 'purchases', 'insert', '175'),
(523, 'root', '2018-11-24 17:32:38', 'customers', 'update', '12'),
(522, 'root', '2018-11-24 17:32:38', 'products', 'update', '1'),
(521, 'root', '2018-11-24 17:11:44', 'purchases', 'insert', '174'),
(520, 'root', '2018-11-24 17:11:44', 'customers', 'update', '6'),
(519, 'root', '2018-11-24 17:11:44', 'products', 'update', '3'),
(518, 'root', '2018-11-24 17:03:56', 'purchases', 'insert', '173'),
(517, 'root', '2018-11-24 17:03:56', 'customers', 'update', '6'),
(516, 'root', '2018-11-24 17:03:56', 'products', 'update', '3'),
(515, 'root', '2018-11-24 17:03:36', 'purchases', 'insert', '172'),
(514, 'root', '2018-11-24 17:03:36', 'customers', 'update', '6'),
(513, 'root', '2018-11-24 17:03:36', 'products', 'update', '6'),
(512, 'root', '2018-11-24 17:03:20', 'purchases', 'insert', '171'),
(511, 'root', '2018-11-24 17:03:20', 'customers', 'update', '6'),
(510, 'root', '2018-11-24 17:03:20', 'products', 'update', '5'),
(509, 'root', '2018-11-24 17:01:00', 'purchases', 'insert', '170'),
(508, 'root', '2018-11-24 17:01:00', 'customers', 'update', '6'),
(507, 'root', '2018-11-24 17:01:00', 'products', 'update', '7'),
(506, 'root', '2018-11-24 17:00:53', 'purchases', 'insert', '169'),
(505, 'root', '2018-11-24 17:00:53', 'customers', 'update', '6'),
(504, 'root', '2018-11-24 17:00:53', 'products', 'update', '1'),
(503, 'root', '2018-11-24 16:47:41', 'purchases', 'insert', '168'),
(502, 'root', '2018-11-24 16:47:41', 'customers', 'update', '0'),
(501, 'root', '2018-11-24 16:47:41', 'products', 'update', '1'),
(500, 'root', '2018-11-24 16:43:51', 'purchases', 'insert', '167'),
(499, 'root', '2018-11-24 16:43:51', 'customers', 'update', '0'),
(498, 'root', '2018-11-24 16:43:51', 'products', 'update', '1'),
(497, 'root', '2018-11-24 16:43:20', 'purchases', 'insert', '166'),
(496, 'root', '2018-11-24 16:43:20', 'customers', 'update', '0'),
(495, 'root', '2018-11-24 16:43:20', 'products', 'update', '1'),
(494, 'root', '2018-11-24 16:39:44', 'purchases', 'insert', '165'),
(493, 'root', '2018-11-24 16:39:44', 'customers', 'update', '0'),
(492, 'root', '2018-11-24 16:39:44', 'products', 'update', '1'),
(491, 'root', '2018-11-24 16:37:00', 'purchases', 'insert', '164'),
(490, 'root', '2018-11-24 16:37:00', 'customers', 'update', '0'),
(489, 'root', '2018-11-24 16:37:00', 'products', 'update', '1'),
(488, 'root', '2018-11-24 16:12:19', 'purchases', 'insert', '163'),
(487, 'root', '2018-11-24 16:12:19', 'customers', 'update', '12'),
(486, 'root', '2018-11-24 16:12:19', 'products', 'update', '5'),
(485, 'root', '2018-11-24 15:44:07', 'purchases', 'insert', '162'),
(484, 'root', '2018-11-24 15:44:07', 'customers', 'update', '6'),
(483, 'root', '2018-11-24 15:44:07', 'products', 'update', '1'),
(482, 'root', '2018-11-24 15:43:34', 'purchases', 'insert', '161'),
(481, 'root', '2018-11-24 15:43:34', 'customers', 'update', '6'),
(480, 'root', '2018-11-24 15:43:34', 'products', 'update', '3'),
(479, 'root', '2018-11-24 15:42:39', 'purchases', 'insert', '160'),
(478, 'root', '2018-11-24 15:42:39', 'customers', 'update', '6'),
(477, 'root', '2018-11-24 15:42:39', 'products', 'update', '2'),
(476, 'root', '2018-11-23 13:06:53', 'purchases', 'insert', '159'),
(475, 'root', '2018-11-23 13:06:53', 'customers', 'update', '0'),
(474, 'root', '2018-11-23 13:06:53', 'products', 'update', '1'),
(473, 'root', '2018-11-23 13:05:02', 'purchases', 'insert', '158'),
(472, 'root', '2018-11-23 13:05:02', 'customers', 'update', '12'),
(471, 'root', '2018-11-23 13:05:02', 'products', 'update', '2'),
(470, 'root', '2018-11-23 13:04:51', 'purchases', 'insert', '157'),
(469, 'root', '2018-11-23 13:04:51', 'customers', 'update', '12'),
(468, 'root', '2018-11-23 13:04:51', 'products', 'update', '1'),
(467, 'root', '2018-11-23 12:46:46', 'purchases', 'insert', '156'),
(466, 'root', '2018-11-23 12:46:46', 'customers', 'update', '12'),
(465, 'root', '2018-11-23 12:46:46', 'products', 'update', '7'),
(464, 'root', '2018-11-23 12:46:37', 'purchases', 'insert', '155'),
(463, 'root', '2018-11-23 12:46:37', 'customers', 'update', '12'),
(462, 'root', '2018-11-23 12:46:37', 'products', 'update', '1'),
(461, 'root', '2018-11-23 12:44:04', 'purchases', 'insert', '154'),
(460, 'root', '2018-11-23 12:44:04', 'customers', 'update', '12'),
(459, 'root', '2018-11-23 12:44:04', 'products', 'update', '3'),
(458, 'root', '2018-11-23 12:43:55', 'purchases', 'insert', '153'),
(457, 'root', '2018-11-23 12:43:55', 'customers', 'update', '12'),
(456, 'root', '2018-11-23 12:43:55', 'products', 'update', '2'),
(455, 'root', '2018-11-23 12:38:43', 'purchases', 'insert', '152'),
(454, 'root', '2018-11-23 12:38:43', 'customers', 'update', '12'),
(453, 'root', '2018-11-23 12:38:43', 'products', 'update', '5'),
(452, 'root', '2018-11-23 12:38:33', 'purchases', 'insert', '151'),
(451, 'root', '2018-11-23 12:38:33', 'customers', 'update', '12'),
(450, 'root', '2018-11-23 12:38:33', 'products', 'update', '3'),
(449, 'root', '2018-11-23 12:38:25', 'purchases', 'insert', '150'),
(448, 'root', '2018-11-23 12:38:25', 'customers', 'update', '12'),
(447, 'root', '2018-11-23 12:38:25', 'products', 'update', '2'),
(446, 'root', '2018-11-23 12:31:39', 'purchases', 'insert', '149'),
(445, 'root', '2018-11-23 12:31:39', 'customers', 'update', '8'),
(444, 'root', '2018-11-23 12:31:39', 'products', 'update', '3'),
(443, 'root', '2018-11-23 12:31:23', 'purchases', 'insert', '148'),
(442, 'root', '2018-11-23 12:31:23', 'customers', 'update', '8'),
(441, 'root', '2018-11-23 12:31:23', 'products', 'update', '2'),
(440, 'root', '2018-11-23 12:23:13', 'purchases', 'insert', '147'),
(439, 'root', '2018-11-23 12:23:13', 'customers', 'update', '12'),
(438, 'root', '2018-11-23 12:23:13', 'products', 'update', '2'),
(437, 'root', '2018-11-23 12:21:54', 'purchases', 'insert', '146'),
(436, 'root', '2018-11-23 12:21:54', 'customers', 'update', '12'),
(435, 'root', '2018-11-23 12:21:54', 'products', 'update', '2'),
(434, 'root', '2018-11-23 12:16:59', 'purchases', 'insert', '145'),
(433, 'root', '2018-11-23 12:16:59', 'customers', 'update', '12'),
(432, 'root', '2018-11-23 12:16:59', 'products', 'update', '3'),
(431, 'root', '2018-11-23 12:16:49', 'purchases', 'insert', '144'),
(430, 'root', '2018-11-23 12:16:49', 'customers', 'update', '12'),
(429, 'root', '2018-11-23 12:16:49', 'products', 'update', '2'),
(428, 'root', '2018-11-23 12:07:29', 'purchases', 'insert', '143'),
(427, 'root', '2018-11-23 12:07:29', 'customers', 'update', '12'),
(426, 'root', '2018-11-23 12:07:29', 'products', 'update', '5'),
(425, 'root', '2018-11-23 12:01:53', 'purchases', 'insert', '142'),
(424, 'root', '2018-11-23 12:01:53', 'customers', 'update', '12'),
(423, 'root', '2018-11-23 12:01:53', 'products', 'update', '3'),
(422, 'root', '2018-11-23 11:58:14', 'purchases', 'insert', '141'),
(421, 'root', '2018-11-23 11:58:14', 'customers', 'update', '12'),
(420, 'root', '2018-11-23 11:58:14', 'products', 'update', '2'),
(419, 'root', '2018-11-23 11:58:06', 'purchases', 'insert', '140'),
(418, 'root', '2018-11-23 11:58:06', 'customers', 'update', '12'),
(417, 'root', '2018-11-23 11:58:06', 'products', 'update', '3'),
(416, 'root', '2018-11-23 11:56:32', 'purchases', 'insert', '139'),
(415, 'root', '2018-11-23 11:56:32', 'customers', 'update', '8'),
(414, 'root', '2018-11-23 11:56:32', 'products', 'update', '1'),
(413, 'root', '2018-11-23 11:53:24', 'purchases', 'insert', '138'),
(412, 'root', '2018-11-23 11:53:24', 'customers', 'update', '0'),
(411, 'root', '2018-11-23 11:53:24', 'products', 'update', '3'),
(410, 'root', '2018-11-23 11:51:58', 'purchases', 'insert', '137'),
(409, 'root', '2018-11-23 11:51:58', 'customers', 'update', '12'),
(408, 'root', '2018-11-23 11:51:58', 'products', 'update', '1'),
(407, 'root', '2018-11-23 11:51:43', 'purchases', 'insert', '136'),
(406, 'root', '2018-11-23 11:51:43', 'customers', 'update', '12'),
(405, 'root', '2018-11-23 11:51:43', 'products', 'update', '2'),
(404, 'root', '2018-11-23 11:36:07', 'purchases', 'insert', '135'),
(403, 'root', '2018-11-23 11:36:07', 'customers', 'update', '8'),
(402, 'root', '2018-11-23 11:36:07', 'products', 'update', '6'),
(401, 'root', '2018-11-23 11:32:17', 'purchases', 'insert', '134'),
(400, 'root', '2018-11-23 11:32:17', 'customers', 'update', '8'),
(399, 'root', '2018-11-23 11:32:17', 'products', 'update', '1'),
(398, 'root', '2018-11-23 11:30:21', 'purchases', 'insert', '133'),
(397, 'root', '2018-11-23 11:30:21', 'customers', 'update', '8'),
(396, 'root', '2018-11-23 11:30:21', 'products', 'update', '1'),
(395, 'root', '2018-11-23 11:28:41', 'purchases', 'insert', '132'),
(394, 'root', '2018-11-23 11:28:41', 'customers', 'update', '8'),
(393, 'root', '2018-11-23 11:28:41', 'products', 'update', '7'),
(392, 'root', '2018-11-23 11:27:00', 'purchases', 'insert', '131'),
(391, 'root', '2018-11-23 11:27:00', 'customers', 'update', '8'),
(390, 'root', '2018-11-23 11:27:00', 'products', 'update', '5'),
(389, 'root', '2018-11-23 11:25:58', 'purchases', 'insert', '130'),
(388, 'root', '2018-11-23 11:25:58', 'customers', 'update', '8'),
(387, 'root', '2018-11-23 11:25:58', 'products', 'update', '2'),
(386, 'root', '2018-11-23 11:22:21', 'purchases', 'insert', '129'),
(385, 'root', '2018-11-23 11:22:21', 'customers', 'update', '8'),
(384, 'root', '2018-11-23 11:22:21', 'products', 'update', '2'),
(383, 'root', '2018-11-23 11:12:16', 'purchases', 'insert', '128'),
(382, 'root', '2018-11-23 11:12:16', 'customers', 'update', '8'),
(381, 'root', '2018-11-23 11:12:16', 'products', 'update', '3'),
(380, 'root', '2018-11-23 11:11:40', 'purchases', 'insert', '127'),
(379, 'root', '2018-11-23 11:11:40', 'customers', 'update', '8'),
(378, 'root', '2018-11-23 11:11:40', 'products', 'update', '2'),
(377, 'root', '2018-11-23 11:03:16', 'purchases', 'insert', '126'),
(376, 'root', '2018-11-23 11:03:16', 'customers', 'update', '8'),
(375, 'root', '2018-11-23 11:03:16', 'products', 'update', '3'),
(374, 'root', '2018-11-23 11:01:42', 'purchases', 'insert', '125'),
(373, 'root', '2018-11-23 11:01:42', 'customers', 'update', '8'),
(372, 'root', '2018-11-23 11:01:42', 'products', 'update', '1'),
(371, 'root', '2018-11-23 10:52:51', 'purchases', 'insert', '124'),
(370, 'root', '2018-11-23 10:52:51', 'customers', 'update', '8'),
(369, 'root', '2018-11-23 10:52:51', 'products', 'update', '7'),
(368, 'root', '2018-11-23 10:18:41', 'purchases', 'insert', '123'),
(367, 'root', '2018-11-23 10:18:41', 'customers', 'update', '8'),
(366, 'root', '2018-11-23 10:18:41', 'products', 'update', '6'),
(365, 'root', '2018-11-23 10:16:45', 'purchases', 'insert', '122'),
(364, 'root', '2018-11-23 10:16:45', 'customers', 'update', '8'),
(363, 'root', '2018-11-23 10:16:45', 'products', 'update', '1'),
(362, 'root', '2018-11-23 10:12:40', 'purchases', 'insert', '121'),
(361, 'root', '2018-11-23 10:12:40', 'customers', 'update', '8'),
(360, 'root', '2018-11-23 10:12:40', 'products', 'update', '1'),
(359, 'root', '2018-11-23 10:10:07', 'purchases', 'insert', '120'),
(358, 'root', '2018-11-23 10:10:07', 'customers', 'update', '8'),
(357, 'root', '2018-11-23 10:10:07', 'products', 'update', '3'),
(356, 'root', '2018-11-23 10:08:33', 'purchases', 'insert', '119'),
(355, 'root', '2018-11-23 10:08:33', 'customers', 'update', '8'),
(354, 'root', '2018-11-23 10:08:33', 'products', 'update', '3'),
(353, 'root', '2018-11-23 09:48:43', 'purchases', 'insert', '118'),
(352, 'root', '2018-11-23 09:48:43', 'customers', 'update', '8'),
(351, 'root', '2018-11-23 09:48:43', 'products', 'update', '2'),
(350, 'root', '2018-11-23 09:31:58', 'purchases', 'insert', '117'),
(349, 'root', '2018-11-23 09:31:58', 'customers', 'update', '8'),
(348, 'root', '2018-11-23 09:31:58', 'products', 'update', '2'),
(347, 'root', '2018-11-15 02:58:04', 'purchases', 'insert', '116'),
(346, 'root', '2018-11-15 02:58:04', 'customers', 'update', '1'),
(345, 'root', '2018-11-15 02:58:04', 'products', 'update', '5'),
(344, 'root', '2018-11-14 14:28:48', 'purchases', 'insert', '115'),
(343, 'root', '2018-11-14 14:28:48', 'customers', 'update', '1'),
(342, 'root', '2018-11-14 14:28:48', 'products', 'update', '7');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE IF NOT EXISTS `products` (
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  `pname` varchar(20) NOT NULL,
  `qoh` int(5) NOT NULL,
  `qoh_threshold` int(5) DEFAULT NULL,
  `original_price` decimal(6,2) DEFAULT NULL,
  `discnt_rate` decimal(3,2) DEFAULT NULL,
  `sid` int(11) DEFAULT NULL,
  `imgname` varchar(50) DEFAULT '',
  `pdfname` varchar(50) NOT NULL,
  PRIMARY KEY (`pid`),
  KEY `sid` (`sid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`pid`, `pname`, `qoh`, `qoh_threshold`, `original_price`, `discnt_rate`, `sid`, `imgname`, `pdfname`) VALUES
(1, 'Web Technology', 234, 10, '100.00', '5.00', 1, 'web.jpg', 'web.pdf'),
(2, 'Machine Learning', 120, 10, '110.00', '5.00', 2, 'ml.jpg', 'ml.pdf'),
(3, 'Design Patterns', 144, 10, '120.00', '5.00', 1, 'sadp.jpg', 'sadp.pdf'),
(5, 'Storage Networks', 166, 8, '130.00', '5.00', 2, 'san.jpg', 'san.pdf'),
(6, 'Network Security', 163, 5, '140.00', '5.00', 1, 'ins.jpg', 'ins.pdf'),
(7, 'Exploring Python', 167, 5, '150.00', '5.00', 2, 'python.jpg', 'python.pdf');

--
-- Triggers `products`
--
DROP TRIGGER IF EXISTS `log_update_qoh`;
DELIMITER //
CREATE TRIGGER `log_update_qoh` AFTER UPDATE ON `products`
 FOR EACH ROW begin
  if new.qoh != old.qoh then
    insert into logs(who,time,table_name,operation,key_value) values('root',CURRENT_TIMESTAMP,'products','update',new.pid);
  end if;
  end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

CREATE TABLE IF NOT EXISTS `purchases` (
  `purid` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) NOT NULL,
  `eid` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `qty` int(5) DEFAULT NULL,
  `ptime` datetime DEFAULT NULL,
  `total_price` decimal(7,2) DEFAULT NULL,
  PRIMARY KEY (`purid`),
  KEY `cid` (`cid`),
  KEY `eid` (`eid`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=197 ;

--
-- Dumping data for table `purchases`
--

INSERT INTO `purchases` (`purid`, `cid`, `eid`, `pid`, `qty`, `ptime`, `total_price`) VALUES
(177, 12, 0, 7, 1, '2018-11-24 17:40:28', '145.00'),
(176, 12, 0, 7, 1, '2018-11-24 17:32:45', '145.00'),
(175, 12, 0, 1, 1, '2018-11-24 17:32:38', '95.00'),
(174, 6, 0, 3, 1, '2018-11-24 17:11:44', '115.00'),
(173, 6, 0, 3, 1, '2018-11-24 17:03:56', '115.00'),
(172, 6, 0, 6, 1, '2018-11-24 17:03:36', '135.00'),
(171, 6, 0, 5, 1, '2018-11-24 17:03:20', '125.00'),
(170, 6, 0, 7, 1, '2018-11-24 17:01:00', '145.00'),
(169, 6, 0, 1, 1, '2018-11-24 17:00:53', '95.00'),
(168, 0, 1, 1, 2, '2018-11-24 16:47:41', '190.00'),
(167, 0, 1, 1, 2, '2018-11-24 16:43:51', '190.00'),
(166, 0, 1, 1, 1, '2018-11-24 16:43:20', '95.00'),
(165, 0, 1, 1, 1, '2018-11-24 16:39:44', '95.00'),
(164, 0, 1, 1, 1, '2018-11-24 16:37:00', '95.00'),
(163, 12, 0, 5, 1, '2018-11-24 16:12:19', '125.00'),
(162, 6, 0, 1, 1, '2018-11-24 15:44:07', '95.00'),
(161, 6, 0, 3, 2, '2018-11-24 15:43:34', '230.00'),
(160, 6, 0, 2, 2, '2018-11-24 15:42:39', '210.00'),
(159, 0, 3, 1, 3, '2018-11-23 13:06:53', '285.00'),
(158, 12, 0, 2, 5, '2018-11-23 13:05:02', '525.00'),
(157, 12, 0, 1, 4, '2018-11-23 13:04:51', '380.00'),
(156, 12, 0, 7, 2, '2018-11-23 12:46:46', '290.00'),
(155, 12, 0, 1, 1, '2018-11-23 12:46:37', '95.00'),
(154, 12, 0, 3, 2, '2018-11-23 12:44:04', '230.00'),
(153, 12, 0, 2, 1, '2018-11-23 12:43:55', '105.00'),
(152, 12, 0, 5, 1, '2018-11-23 12:38:43', '125.00'),
(151, 12, 0, 3, 2, '2018-11-23 12:38:33', '230.00'),
(150, 12, 0, 2, 1, '2018-11-23 12:38:25', '105.00'),
(149, 8, 0, 3, 3, '2018-11-23 12:31:39', '345.00'),
(148, 8, 0, 2, 1, '2018-11-23 12:31:23', '105.00'),
(147, 12, 0, 2, 1, '2018-11-23 12:23:13', '105.00'),
(146, 12, 0, 2, 1, '2018-11-23 12:21:54', '105.00'),
(145, 12, 0, 3, 1, '2018-11-23 12:16:59', '115.00'),
(144, 12, 0, 2, 1, '2018-11-23 12:16:49', '105.00'),
(143, 12, 0, 5, 2, '2018-11-23 12:07:29', '250.00'),
(142, 12, 0, 3, 2, '2018-11-23 12:01:53', '230.00'),
(141, 12, 0, 2, 2, '2018-11-23 11:58:14', '210.00'),
(140, 12, 0, 3, 1, '2018-11-23 11:58:06', '115.00'),
(139, 8, 0, 1, 1, '2018-11-23 11:56:32', '95.00'),
(138, 0, 0, 3, 1, '2018-11-23 11:53:24', '115.00'),
(137, 12, 0, 1, 2, '2018-11-23 11:51:58', '190.00'),
(136, 12, 0, 2, 2, '2018-11-23 11:51:43', '210.00'),
(135, 8, 0, 6, 2, '2018-11-23 11:36:07', '270.00'),
(134, 8, 0, 1, 10, '2018-11-23 11:32:17', '950.00'),
(133, 8, 0, 1, 1, '2018-11-23 11:30:21', '95.00'),
(132, 8, 0, 7, 1, '2018-11-23 11:28:41', '145.00'),
(131, 8, 0, 5, 2, '2018-11-23 11:27:00', '250.00'),
(130, 8, 0, 2, 1, '2018-11-23 11:25:58', '105.00'),
(129, 8, 0, 2, 3, '2018-11-23 11:22:21', '315.00'),
(128, 8, 0, 3, 3, '2018-11-23 11:12:16', '345.00'),
(127, 8, 0, 2, 5, '2018-11-23 11:11:40', '525.00'),
(126, 8, 0, 3, 2, '2018-11-23 11:03:16', '230.00'),
(125, 8, 0, 1, 1, '2018-11-23 11:01:42', '95.00'),
(124, 8, 0, 7, 1, '2018-11-23 10:52:51', '145.00'),
(123, 8, 0, 6, 5, '2018-11-23 10:18:41', '675.00'),
(122, 8, 0, 1, 2, '2018-11-23 10:16:45', '190.00'),
(121, 8, 0, 1, 1, '2018-11-23 10:12:40', '95.00'),
(120, 8, 0, 3, 2, '2018-11-23 10:10:07', '230.00'),
(119, 8, 0, 3, 1, '2018-11-23 10:08:33', '115.00'),
(118, 8, 0, 2, 3, '2018-11-23 09:48:43', '315.00'),
(117, 8, 0, 2, 3, '2018-11-23 09:31:58', '315.00'),
(116, 1, 0, 5, 3, '2018-11-15 02:58:04', '375.00'),
(115, 1, 0, 7, 5, '2018-11-14 14:28:48', '725.00'),
(178, 12, 0, 7, 1, '2018-11-24 17:41:24', '145.00'),
(179, 6, 0, 5, 1, '2018-11-24 17:41:58', '125.00'),
(180, 6, 0, 1, 1, '2018-11-24 17:43:37', '95.00'),
(181, 6, 0, 5, 1, '2018-11-24 17:43:46', '125.00'),
(182, 6, 0, 3, 1, '2018-11-24 17:43:55', '115.00'),
(183, 1, 0, 1, 2, '2018-11-24 17:50:24', '190.00'),
(184, 1, 0, 3, 1, '2018-11-24 17:50:31', '115.00'),
(185, 12, 0, 3, 1, '2018-11-24 18:10:58', '115.00'),
(186, 12, 0, 1, 2, '2018-11-24 18:11:05', '190.00'),
(187, 12, 0, 1, 1, '2018-11-24 18:23:05', '95.00'),
(188, 12, 0, 3, 1, '2018-11-24 18:23:11', '115.00'),
(189, 12, 0, 3, 1, '2018-11-24 18:25:58', '115.00'),
(190, 12, 0, 2, 2, '2018-11-28 10:03:45', '210.00'),
(191, 12, 0, 2, 1, '2018-11-28 10:21:45', '105.00'),
(192, 12, 0, 2, 1, '2018-11-28 10:27:26', '105.00'),
(193, 12, 0, 3, 1, '2018-11-28 10:30:11', '115.00'),
(194, 12, 0, 5, 2, '2018-11-28 10:30:20', '250.00'),
(195, 12, 0, 5, 2, '2018-11-30 02:28:38', '250.00'),
(196, 12, 0, 2, 4, '2018-11-30 02:28:48', '420.00');

--
-- Triggers `purchases`
--
DROP TRIGGER IF EXISTS `after_purchase`;
DELIMITER //
CREATE TRIGGER `after_purchase` AFTER INSERT ON `purchases`
 FOR EACH ROW begin
update products set qoh = qoh - new.qty where pid = new.pid;
update customers set visits_made = visits_made + 1,last_visit_time = new.ptime where cid = new.cid;
insert into logs(who,time,table_name,operation,key_value) values('root',CURRENT_TIMESTAMP,'purchases','insert',new.purid);
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE IF NOT EXISTS `suppliers` (
  `sid` int(11) NOT NULL AUTO_INCREMENT,
  `sname` varchar(15) NOT NULL,
  `city` varchar(15) DEFAULT NULL,
  `telephone_no` char(10) DEFAULT NULL,
  PRIMARY KEY (`sid`),
  UNIQUE KEY `sname` (`sname`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`sid`, `sname`, `city`, `telephone_no`) VALUES
(1, 'Supplier 1', 'BLR', '6075555431'),
(2, 'Supplier 2', 'NYC', '6075555432');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
