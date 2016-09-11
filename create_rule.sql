create rule update_holidays as on update to holidays do instead
  update events
  set title = new.name,
      starts = new.date,
      colors = new.colors
  where title = old.name;

create rule delete_venue as on delete to venue do instead
  update venue
  set active = false
  where name = old.name;
