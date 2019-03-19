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

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCRA )
%DCData_lib( OCTO )

%let start_yr = 2009;
%let end_yr = 2018;

%let summaryvars = permit_&year. permit_construction_&year. permits_homeoccupation_&year. permits_postcard_&year. permits_shopdrawing_&year. permits_supplemental_&year.;

%macro permits_by_geo (geo);

proc summary data= permits_&year._geo;
	class &geo.;
	var &summaryvars.;
	output out= permits_sum_&geo._&year._in sum=;
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

%mend permits_by_geo;

%permits_by_geo(Anc2002);
%permits_by_geo(Anc2012);
%permits_by_geo(bridgepk);
%permits_by_geo(CITY);
%permits_by_geo(Cluster2000);
%permits_by_geo(Cluster_tr2000);
%permits_by_geo(eor);
%permits_by_geo(cluster2017);
%permits_by_geo(Psa2004);
%permits_by_geo(Psa2012);
%permits_by_geo(stantoncommons);
%permits_by_geo(Geo2000);
%permits_by_geo(Geo2010);
%permits_by_geo(VoterPre2012);
%permits_by_geo(Ward2002);
%permits_by_geo(Ward2012);
%permits_by_geo(Zip);


