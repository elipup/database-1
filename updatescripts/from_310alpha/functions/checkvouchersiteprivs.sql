CREATE OR REPLACE FUNCTION checkVoucherSitePrivs(INTEGER) RETURNS BOOLEAN AS '
DECLARE
  pVoheadid ALIAS FOR $1;
  _check    BOOLEAN;
  _result   INTEGER;

BEGIN

  SELECT COALESCE(usrpref_value::BOOLEAN, false) INTO _check
    FROM usrpref
   WHERE ( (usrpref_username=current_user)
     AND   (usrpref_name=''selectedSites'') );
  IF (NOT _check) THEN
    RETURN true;
  END IF;

  SELECT COALESCE(COUNT(*), 0) INTO _result
    FROM ( SELECT voitem_id
             FROM voitem, poitem, itemsite
            WHERE ( (voitem_vohead_id=pVoheadid)
              AND   (poitem_id=voitem_poitem_id)
              AND   (poitem_itemsite_id=itemsite_id)
              AND   (itemsite_warehous_id NOT IN (SELECT usrsite_warehous_id
                                                    FROM usrsite
                                                   WHERE (usrsite_username=current_user))) )
           UNION
           SELECT pohead_warehous_id
             FROM vohead, pohead
            WHERE ( (vohead_id=pVoheadid)
              AND   (pohead_id=vohead_pohead_id)
              AND   (pohead_warehous_id NOT IN (SELECT usrsite_warehous_id
                                                  FROM usrsite
                                                 WHERE (usrsite_username=current_user))) )
         ) AS data;
  IF (_result > 0) THEN
    RETURN false;
  END IF;

  RETURN true;
END;
' LANGUAGE 'plpgsql';