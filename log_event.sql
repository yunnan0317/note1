create or replace function log_event() returns trigger as $$
declare
begin
  insert into logs (event_id, old_title, old_starts, old_ends)
  values (OLD.event_id, OLD.title, OLD.starts, OLD.ends);

  raise notice 'Someon just change event #%', OLD.event_id;

  return new;
end;
$$ language plpgsql;

create trigger log_events
  after update on events
  for each row execute procedure log_event();
