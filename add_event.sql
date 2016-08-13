create or replace function add_event(i_title text, i_starts timestamp,
  i_ends timestamp, venue text, postal varchar(9), country char(2))
returns boolean as $$

declare
  did_insert boolean := false;
  found_count integer;
  the_venue_id integer;

begin
  select venue_id into the_venue_id
  from venues v
  where v.postal_code = postal and v.country_code = country and v.name ilike venue limit 1;

  if the_venue_id is null then
    insert into venues (name, postal_code, country_code)
    values (venue, postal, country)
    returning venue_id into the_venue_id;

    did_insert := true;
  end if;

  -- Note: no an "error", as in some programming languages
  raise notice 'Venue found %', the_venue_id;

    insert into events (title, starts, ends, venue_id)
    values (i_title, i_starts, i_ends, the_venue_id);

  return did_insert;
end;
$$ language plpgsql;
