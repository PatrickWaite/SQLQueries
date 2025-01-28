-- Finds continuing resources that aren't micro or directed electronic (cd) in the locations listed. This provides a list to make sure that all have
-- the EAST statement in the bib and holdings records.
SELECT
	--m.srs_id,
	DISTINCT(m.instance_id)
	--hrt.id,
	--m.CONTENT,
	--substring(m.CONTENT, 8,1),
	--m2.CONTENT,
	--substring(m2.CONTENT, 24,1),
	--lt.code
FROM
	folio_source_record.marctab m
	JOIN folio_source_record.marctab m2 ON m2.srs_id = m.srs_id
	LEFT JOIN inventory.instance__t it ON m.instance_id::uuid = it.id::uuid
	LEFT JOIN inventory.holdings_record__t hrt ON it.id = hrt.instance_id
	LEFT JOIN inventory.location__t lt ON hrt.permanent_location_id = lt.id
WHERE
	m.field = '000'
AND
	substring(m.CONTENT, 8,1) IN ('s', 'i')
AND
	m2.field = '008'
AND
	substring(m2.CONTENT, 24,1) NOT IN ('o', 's', 'a', 'b', 'c', 'q')
AND
	it.discovery_suppress IS FALSE
AND
	lt.code IN ('USGEN', 'UMGEN')
	
	
select * 
from 
folio_source_record.marctab m 
JOIN folio_source_record.marctab m2 ON m2.srs_id = m.srs_id
--LEFT JOIN inventory.instance__t it ON m.instance_id::uuid = it.id::uuid
--LEFT JOIN inventory.holdings_record__t hrt ON it.id = hrt.instance_id
--LEFT JOIN inventory.location__t lt ON hrt.permanent_location_id = lt.id
where 
m.field = '000'
and substring(m.CONTENT, 8,1) IN ('s', 'i')
and m2.field = '008'
and substring(m2.CONTENT, 24,1) NOT IN ('o', 's', 'a', 'b', 'c', 'q') 
--and lt.code in ('USGEN','UMGEN')


select 
* 
from 
folio_source_record.marctab m 
where 
m.field = '008'
--and substring(m."content", 8,1) in ('s','i') 


--to provide to JE just the Distinct ID
--2 lists 
---- on serial
---- one everything else sans exceptions


--full datasync script
select 
distinct(it.id)
--mtt."name" as "materialType",
--lt.code,
--lt."name" as "collection",
--lt2."name" as "library",
--it.discovery_suppress 
--string_agg(iti.identifiers__value , ' | ')
--bring in ISSN
from 
inventory.instance__t it 
join inventory.holdings_record__t hrt on hrt.instance_id = it.id 
join inventory.item__t it2 on it2.holdings_record_id = hrt.id
--right outer join inventory.instance__t__identifiers iti on iti.id = it.id
join inventory.material_type__t mtt on mtt.id = it2.material_type_id 
join inventory.location__t lt on lt.id = hrt.permanent_location_id 
join inventory.loclibrary__t lt2 on lt2.id = lt.library_id 
where 
lt.campus_id = '1693a1d9-ef32-429a-86e2-55b483a594d1'
and 
it.id::uuid in(
	--to use for Serials	
	select 
	m.instance_id::uuid 
	from 
	folio_source_record.marctab m 
	join folio_source_record.marctab m2 on m2.instance_id = m.instance_id
	where 
	--(m.field = '000' and substring(m.CONTENT, 8,1) IN ('s', 'i')) 
	--and
	--(m2.field = '008' and substring(m2.CONTENT, 24,1) NOT IN ('o', 's', 'a', 'b', 'c', 'q')) 
	(m.field = '000' and substring(m.CONTENT, 8,1) IN ('m'))
	and 
	(m.field = '000' and substring(m.CONTENT, 7,1) not in ( 'g', 'o', 'k'))
	and
	(m2.field = '008' and substring(m2.CONTENT, 24,1) NOT IN ('o', 's', 'a', 'b', 'c', 'q'))
) 
and it.discovery_suppress IS false 
and lt.code not IN ('UJUV', 'URUD', 'USED', 'UCD', 'UARC', 'UCD', 'UCRIC', 'UDMF', 'UKEY', 'UMAP', 'UMCD', 'UMDIG', 'UMDVD', 'UMED', 'UMFF', 'UMMCD', 'UMMDV', 'UMMED', 'UMMFG', 'UMP', 'UMPA', 'UMPCD', 'UMWWW', 'URFM', 'USBG', 'USEQP', 'USMF', 'USPC', 'USPCX', 'UTHES', 'UMSTOR','USPRF','USEED','USBG','UPTRC','UMREP','UMPRF','UMLC','UMFIL','UMFC','UDGEN','UDMAS','RCHEX','RCMTP','RCOS','RCCDR','RCMT','RCDVD','RCRAR','RCDV','RCKIN','RCDB','RCVHS','RCCD','RCFAC','RCMOR','RCGEN','RCFIN')

--Group by is for if using the instance_t_identifier and String_agg(iti.identitfer_value) above 
group by 
it.id,
mtt."name",
lt.code,
lt."name",
lt2."name"






--to use for Monographs
select 
*
from 
folio_source_record.marctab m 
join folio_source_record.marctab m2 on m2.instance_id = m.instance_id
where 
(m.field = '000' and substring(m.CONTENT, 8,1) IN ('m')) 
and
(m2.field = '008' and substring(m2.CONTENT, 24,1) NOT IN ('e','f','g','i','j','k','m','o','p','r'))


-- pull down holdings by location
-- pull down items by materials type 
-- connect items to holdings using holding id 
-- making a temporary table in the public schema and pull from that.  
-- one of the OCLC API (metadata API) can take oclc numbers and spit back what oclc number it thinks is correct.
-- potentially query collection to see what OCLC thinks we have. 
-- watch out for the natrual joins (this can cut your record pool down beyond what you expect)

	
select *
--m.instance_id::uuid,
--m."content"
from 
folio_source_record.marctab m 
join folio_source_record.marctab m2 on m2.instance_id = m.instance_id
where 
(m.field = '000' and substring(m.CONTENT, 8,1) IN ('s', 'i')) 
and
(m2.field = '008' and substring(m2.CONTENT, 24,1) NOT IN ('o', 's', 'a', 'b', 'c', 'q'))


select count(*)
from 
inventory.instance__t it 
join inventory.holdings_record__t hrt on hrt.instance_id = it.id 
join inventory.location__t lt on lt.id = hrt.permanent_location_id 
where 
lt.code like 'RC%'



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
(cit.item_status_prior_to_check_in = 'Available') and -- or cit.item_status_prior_to_check_in = 'Checked out'
cit.item_id in (
	select 
		it.id as "itemID"
	from 
		inventory.item__t it 
		join inventory.holdings_record__t hrt on hrt.id = it.holdings_record_id 
		join inventory.instance__t it2 on it2.id = hrt.instance_id 
		join inventory.location__t lt on lt.id = hrt.effective_location_id 
		join inventory.loccampus__t lt2 on lt2.id = lt.campus_id
		--join inventory.material_type__t mtt on mtt.id = it.material_type_id
		--join inventory.loan_type__t ltt on ltt.i = it.permanent_loan_type_id  
	where 
		lt2.code = 'UM'
		)