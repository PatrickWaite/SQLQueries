--full datasync script
select 
distinct(it.id)
from 
inventory.instance__t it 
join inventory.holdings_record__t hrt on hrt.instance_id = it.id 
join inventory.item__t it2 on it2.holdings_record_id = hrt.id
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
	--*****for Serial collection uncomment lines 23,24,and 25******
	--(m.field = '000' and substring(m.CONTENT, 8,1) IN ('s', 'i')) 
	--and
	--(m2.field = '008' and substring(m2.CONTENT, 24,1) NOT IN ('o', 's', 'a', 'b', 'c', 'q')) 
	--*****For Monograph collection uncomment lines 27,28,29,30,and 31*****
	(m.field = '000' and substring(m.CONTENT, 8,1) IN ('m'))
	and 
	(m.field = '000' and substring(m.CONTENT, 7,1) not in ( 'g', 'o', 'k'))
	and
	(m2.field = '008' and substring(m2.CONTENT, 24,1) NOT IN ('o', 's', 'a', 'b', 'c', 'q'))
) 
and it.discovery_suppress IS false 
and lt.code not IN ('UJUV', 'URUD', 'USED', 'UCD', 'UARC', 'UCD', 'UCRIC', 'UDMF', 'UKEY', 'UMAP', 'UMCD', 'UMDIG', 'UMDVD', 'UMED', 'UMFF', 'UMMCD', 'UMMDV', 'UMMED', 'UMMFG', 'UMP', 'UMPA', 'UMPCD', 'UMWWW', 'URFM', 'USBG', 'USEQP', 'USMF', 'USPC', 'USPCX', 'UTHES', 'UMSTOR','USPRF','USEED','USBG','UPTRC','UMREP','UMPRF','UMLC','UMFIL','UMFC','UDGEN','UDMAS','RCHEX','RCMTP','RCOS','RCCDR','RCMT','RCDVD','RCRAR','RCDV','RCKIN','RCDB','RCVHS','RCCD','RCFAC','RCMOR','RCGEN','RCFIN')