/**************************************************************************
 Program:  Summarize_building_permits.sas
 Library:  DCRA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  03/19/19
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Summarize building permits by geography.

 Modifications:
**************************************************************************/

proc freq data=permits_&year._geo;
tables PERMIT_TYP;
run;

%let summaryvars = permit_&year. permit_construction_&year. permits_homeoccupation_&year. permits_postcard_&year. permits_shopdrawing_&year. permits_supplemental_&year.;

%macro summarizebygeo(geo);
proc summary data= permits_&year._geo;
	class &geo.;
	var &summaryvars.;
	output out= permits_sum_&geo._1 sum=;
run;

data permits_sum_&geo._&year. ;
	set permits_sum_&geo._1;
	if _type_=1 ;
	drop _type_ _freq_;


run;

%Finalize_data_set( 
  data=permits_sum_&geo._&year.,
  out=permits_sum_&geo._&year.,
  outlib=DCRA,
  label="Building permit by type statistics for DC, MD, VA and WV",
  sortby=&geo.,
  restrictions=None,
  revisions=;
  );

%mend summarizebygeo;

%summarizebygeo(Anc2002);
%summarizebygeo(Anc2012);
%summarizebygeo(bridgepk);
%summarizebygeo(CITY);
%summarizebygeo(Cluster2000);
%summarizebygeo(Cluster_tr2000);
%summarizebygeo(eor);
%summarizebygeo(cluster2017);
%summarizebygeo(Psa2004);
%summarizebygeo(Psa2012);
%summarizebygeo(stantoncommons);
%summarizebygeo(Geo2000);
%summarizebygeo(Geo2010);
%summarizebygeo(VoterPre2012);
%summarizebygeo(Ward2002);
%summarizebygeo(Ward2012);
%summarizebygeo(Zip);


