CREATE OR REPLACE FUNCTION deleteCheck(INTEGER) RETURNS INTEGER AS '
DECLARE
  pCheckid ALIAS FOR $1;

BEGIN
  IF (SELECT (NOT checkhead_void) OR checkhead_posted OR checkhead_replaced OR checkhead_deleted
      FROM checkhead
      WHERE (checkhead_id=pCheckid) ) THEN
    RETURN -1;
  END IF;

  UPDATE checkhead
  SET checkhead_deleted=TRUE
  WHERE (checkhead_id=pCheckid);

  RETURN 1;

END;
' LANGUAGE 'plpgsql';
