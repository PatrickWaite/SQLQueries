select 
	cit.id,
	it2.title,
	cit.item_id,
	it.barcode,
	lt2."name" as "item_location",
	cast(cit.occurred_date_time as Date),
	cit.service_point_id,
	spt."name" as "checkin_Location",
	cit.item_status_prior_to_check_in 
from 
  circulation.check_in__t cit 
  join inventory.item__t it on it.id = cit.item_id 
  join inventory.holdings_record__t hrt on hrt.id = it.holdings_record_id 
  join inventory.location__t lt2 on lt2.id = hrt.effective_location_id
  join inventory.service_point__t spt on spt.id = cit.service_point_id
  join inventory.instance__t it2 on it2.id = hrt.instance_id 
where
  (cit.item_status_prior_to_check_in = 'Available') 
and
  cit.item_id in (
	select 
		it.id as "itemID"
	from 
		inventory.item__t it 
		join inventory.holdings_record__t hrt on hrt.id = it.holdings_record_id 
		join inventory.instance__t it2 on it2.id = hrt.instance_id 
		join inventory.location__t lt on lt.id = hrt.effective_location_id 
		join inventory.loccampus__t lt2 on lt2.id = lt.campus_id
	where 
		lt2.code = 'XX' -- enter campus code designation
	)
