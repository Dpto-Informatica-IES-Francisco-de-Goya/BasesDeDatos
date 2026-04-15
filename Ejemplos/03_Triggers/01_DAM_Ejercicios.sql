
DELIMITER //
CREATE PROCEDURE ej1_alquier_rapido (
	IN var_customer_id INT,
    IN var_inventory_id INT,
    IN var_staff_id INT)
BEGIN
	INSERT INTO `sakila`.`rental`
		(`rental_date`,
		`inventory_id`,
		`customer_id`,
		`staff_id`)
	VALUES
		(NOW(),
		var_inventory_id,
		var_customer_id,
		var_staff_id);
END //
DELIMITER ;

select * from inventory;
CALL `ej1_alquier_rapido`(
-- customer_id, inventory_id, staff_id
	67,46,1
);
select * from rental where customer_id = 67 and inventory_id = 46 and staff_id = 1;


explain customer;
CALL `ej1_alquier_rapido`(
-- customer_id, inventory_id, staff_id
	(SELECT customer_id from customer where first_name like 'A%' limit 1),
    46,
    1
);

select * from rental where customer_id = (SELECT customer_id from customer where first_name like 'A%' limit 1) and inventory_id = 46 and staff_id = 1;