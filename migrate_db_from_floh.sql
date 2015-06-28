insert into categories select * from demo.categories;
insert into events select
	id,
	created,
	modified,
	name,
	details,
	max_sellers,
	max_items_per_seller,
	date_confirmed,
	concat(`date`, ' ', start_time),
	concat(`date`, ' ', end_time),
	reservation_start,
	reservation_end,
	concat(item_handover_date, ' ', item_handover_start_time),
	concat(item_handover_date, ' ', item_handover_end_time),
	concat(item_pickup_date, ' ', item_pickup_start_time),
	concat(item_pickup_date, ' ', item_pickup_end_time),
	NULL
from demo.events;
insert into sellers select
	s.id,
	s.created,
	s.modified,
	s.first_name,
	s.last_name,
	s.street,
	s.zip_code,
	s.city,
	s.email,
	s.phone,
	s.token,
	IF(s.nomail IS NULL OR s.nomail = 0, 1, 0),
	s.active
from demo.sellers s;
insert into reviews select
	r.id,
	r.event_id,
	r.seller_id,
	r.created,
	r.modified,
	r.registration,
	r.items,
	r.print,
	r.reservation,
	r.mailing,
	r.content,
	r.design,
	r.support,
	r.handover,
	r.payoff,
	r.sale,
	r.organization,
	r.total,
	r.source,
	r.recommend,
	r.to_improve
from demo.reviews r;
insert into messages select
	NULL,
	e.invitation_sent,
	e.invitation_sent,
	'invitation',
	e.id
from demo.`events` e where e.invitation_sent is not null;
insert into messages select
	NULL,
	e.closing_sent,
	e.closing_sent,
	'reservation_closing',
	e.id
from demo.`events` e where e.closing_sent is not null;
insert into messages select
	NULL,
	e.closed_sent,
	e.closed_sent,
	'reservation_closed',
	e.id
from demo.`events` e where e.closed_sent is not null;
insert into messages select
	NULL,
	e.review_sent,
	e.review_sent,
	'finished',
	e.id
from demo.`events` e where e.review_sent is not null;
insert into reservations select
	r.id,
	r.created,
	r.modified,
	r.seller_id,
	r.event_id,
	r.number
from demo.reservations r;
insert into items select
	i.id,
	i.created,
	i.modified,
	i.category_id,
	i.description,
	i.size,
	i.price,
	ri.reservation_id,
	ri.number,
	ri.code,
	ri.sold
from demo.items i
join demo.reserved_items ri on ri.item_id=i.id
