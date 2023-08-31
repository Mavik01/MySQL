CREATE TABLE `homework1`.`phones` (
  `id` INT NOT NULL,
  `Manufacturer` VARCHAR(45) NULL,
  `Product_name` VARCHAR(45) NULL,
  `Product_count` VARCHAR(45) NULL,
  `Price` INT NULL,
  PRIMARY KEY (`id`));
INSERT INTO `homework1`.`phones` (`id`, `Manufacturer`, `Product_name`, `Product_count`, `Price`) VALUES ('1', 'Apple', 'iPhone 8', '8', '600');
INSERT INTO `homework1`.`phones` (`id`, `Manufacturer`, `Product_name`, `Product_count`, `Price`) VALUES ('2', 'Apple', 'iPhone 13 Pro Max', '5', '1200');
INSERT INTO `homework1`.`phones` (`id`, `Manufacturer`, `Product_name`, `Product_count`, `Price`) VALUES ('3', 'Samsung', 'Galaxy Fold 3', '1', '1500');
INSERT INTO `homework1`.`phones` (`id`, `Manufacturer`, `Product_name`, `Product_count`, `Price`) VALUES ('4', 'Samsung', 'Galaxy S23', '9', '1000');
INSERT INTO `homework1`.`phones` (`id`, `Manufacturer`, `Product_name`, `Product_count`, `Price`) VALUES ('5', 'Nokia', '8800', '10', '200');

select Product_name, Manufacturer, Price
from homework1.phones
where Product_count > 2

SELECT * from homework1.phones
where Manufacturer like '%Samsung';

SELECT * from homework1.phones
where Product_name like 'iPhone%';

SELECT * from homework1.phones
where Product_name regexp '[0-9]';

SELECT * from homework1.phones
where Product_name like '%8%';
