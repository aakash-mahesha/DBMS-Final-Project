CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPetsForAgencies`(IN agency_name VARCHAR(50))
BEGIN
	-- Fetch pets for the current agency
	SELECT *
	FROM pet
	WHERE provided_by_agency = agency_name;

END