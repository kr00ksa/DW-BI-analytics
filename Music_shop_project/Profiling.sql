select count(*)
	 , count(*) filter(where i."BillingState" is null)
	 , count(i."BillingState")
	 , count(distinct i."BillingState") 
	 , 1. * count(i."BillingState") / count(*)
	 , min(length(i."BillingState"))
	 , max(length(i."BillingState"))
	 , avg(length(i."BillingState"))
from public."Invoice" i 
limit 100;



