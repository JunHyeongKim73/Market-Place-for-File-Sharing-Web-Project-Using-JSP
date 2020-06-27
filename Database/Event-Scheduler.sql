DELIMITER //
CREATE EVENT DROPEVENT
ON SCHEDULE EVERY 1 MONTH
DO BEGIN
INSERT INTO DROPPED_ITEM(item_ID, dropped_date, dropped_reason) SELECT item_ID, CURTIME(), “thresholdPurged”	 from item where download_no < 2;
DELETE FROM ITEM WHERE download_no < 2;
END //
DELIMITER ;

#Event scheduler that drops item where download number is less than 2 every month and adds the items into the dropped item table.
