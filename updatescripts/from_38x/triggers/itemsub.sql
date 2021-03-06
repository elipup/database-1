CREATE OR REPLACE FUNCTION _itemsubTrigger () RETURNS TRIGGER AS '
-- Copyright (c) 1999-2012 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
BEGIN

-- Privilege Checks
   IF (NOT checkPrivilege(''MaintainItemMasters'') OR NOT checkPrivilege(''MaintainItemSubstitutes'')) THEN
     RAISE EXCEPTION ''You do not have privileges to maintain Item Substitutes.'';
   END IF;
  
  RETURN NEW;
END;
' LANGUAGE 'plpgsql';

DROP TRIGGER itemsubTrigger ON itemsub;
CREATE TRIGGER itemsubTrigger AFTER INSERT OR UPDATE ON itemsub FOR EACH ROW EXECUTE PROCEDURE _itemsubTrigger();
