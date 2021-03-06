
CREATE OR REPLACE FUNCTION toggleBankrecCleared(INTEGER, TEXT, INTEGER, NUMERIC, NUMERIC) RETURNS BOOLEAN AS $$
-- Copyright (c) 1999-2012 by OpenMFG LLC, d/b/a xTuple. 
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pBankrecid ALIAS FOR $1;
  pSource    ALIAS FOR $2;
  pSourceid  ALIAS FOR $3;
  pCurrrate  ALIAS FOR $4;
  pAmount    ALIAS FOR $5;
  _cleared BOOLEAN;
  _r RECORD;

BEGIN

  SELECT bankrecitem_id, bankrecitem_cleared INTO _r
    FROM bankrecitem
   WHERE ( (bankrecitem_bankrec_id=pBankrecid)
     AND   (bankrecitem_source=pSource)
     AND   (bankrecitem_source_id=pSourceid) );
  IF ( NOT FOUND ) THEN
    _cleared := TRUE;
    INSERT INTO bankrecitem
    (bankrecitem_bankrec_id, bankrecitem_source,
     bankrecitem_source_id, bankrecitem_cleared,
     bankrecitem_curr_rate, bankrecitem_amount)
    VALUES
    (pBankrecid, pSource,
     pSourceid, _cleared,
     pCurrrate, pAmount);
  ELSE
    _cleared := FALSE;
    DELETE FROM bankrecitem 
    WHERE bankrecitem_id = _r.bankrecitem_id;
  END IF;

  RETURN _cleared;
END;
$$ LANGUAGE 'plpgsql';

