BEGIN;

-- Item Site Comment

DROP VIEW api.itemsitecomment;
CREATE VIEW api.itemsitecomment
AS 
   SELECT 
     item_number,
     warehous_code AS warehouse,
     cmnttype_name AS type,
     comment_date AS date,
     comment_user AS username,
     comment_text AS text
   FROM itemsite, item, whsinfo, cmnttype, comment
   WHERE (itemsite_item_id=item_id)
   AND (itemsite_warehous_id=warehous_id
   AND (comment_source='IS')
   AND (comment_source_id=itemsite_id)
   AND (comment_cmnttype_id=cmnttype_id));

GRANT ALL ON TABLE api.salesordercomment TO openmfg;
COMMENT ON VIEW api.salesordercomment IS 'Item Site Comments';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
    ON INSERT TO api.itemsitecomment DO INSTEAD

  INSERT INTO comment (
    comment_date,
    comment_source,
    comment_source_id,
    comment_user,
    comment_cmnttype_id,
    comment_text
    )
  VALUES (
    COALESCE(NEW.date,now()),
    'IS',
    getItemSiteId(NEW.warehouse,NEW.item_number),
    COALESCE(NEW.username,current_user),
    getCmntTypeId(NEW.type),
    NEW.text);

CREATE OR REPLACE RULE "_UPDATE" AS
    ON UPDATE TO api.itemsitecomment DO INSTEAD NOTHING;

CREATE OR REPLACE RULE "_DELETE" AS
    ON DELETE TO api.itemsitecomment DO INSTEAD NOTHING;

COMMIT;
