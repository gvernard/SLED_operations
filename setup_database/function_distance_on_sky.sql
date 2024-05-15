DROP FUNCTION IF EXISTS distance_on_sky;

DELIMITER $$

CREATE FUNCTION strong_lenses_database.distance_on_sky(ra DOUBLE,decl DOUBLE,ra0 DOUBLE,decl0 DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
SQL SECURITY INVOKER
BEGIN

DECLARE a DOUBLE;
DECLARE decl_rad DOUBLE;
DECLARE decl0_rad DOUBLE;
DECLARE Ddecl DOUBLE;
DECLARE Dra DOUBLE;
DECLARE d DOUBLE;
DECLARE d_arcsec DOUBLE;

SET decl_rad = RADIANS(decl);
SET decl0_rad = RADIANS(decl0);
SET Ddecl = ABS(decl_rad - decl0_rad);
SET Dra = ABS(RADIANS(ra) - RADIANS(ra0));
SET a = POW(SIN(Ddecl/2.0),2) + COS(decl_rad)*COS(decl0_rad)*POW(SIN(Dra/2.0),2);
SET d = DEGREES( 2.0*ATAN2(SQRT(a),SQRT(1.0-a)) );
SET d_arcsec = d*3600.0;

RETURN d_arcsec;

END $$

DELIMITER ;

