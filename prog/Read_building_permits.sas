/**************************************************************************
 Program:  Read_building_permits.sas
 Library:  DCRA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  06/20/17
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Read Building permit data.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCRA )
%DCData_lib( OCTO )

%let rawfolder = &_dcdata_r_path\DCRA\Raw;
%let filename = Building_Permits_in_2016_tab.txt;

%let year = 2018; ** <- For testing. Eventually convert into a full macro **;


/* Read in permits shapefile */
proc mapimport out=permits_&year._in
  datafile="&rawfolder.\Building_Permits_in_&year..shp";  
run;


/* Read in Census block shapefile */
proc mapimport out=block_shp_in
  datafile="L:\Libraries\OCTO\Maps\Census_Blocks__2010.shp";  
run;

proc sort data=block_shp_in out=block_shp (keep = x y geoid10); 
	by geoid10;
run;


/* Spatial join permits to Census blocks */
proc ginside includeborder
  data=permits_&year._in
  map=block_shp
  out=permits_&year._join;
  id geoid10;
run;

/* Add standard geographies to each permit */
data permits_&year._geo;
	set permits_&year._join;

	geoblk2010 = geoid10;

	%Block10_to_anc02;
	%Block10_to_anc12;
	%Block10_to_bpk;
	%Block10_to_city;
	%Block10_to_cluster00;
	%Block10_to_cluster_tr00;
	%Block10_to_cluster17;
	%Block10_to_eor;
	%Block10_to_psa04;
	%Block10_to_psa12;
	%Block10_to_stantoncommons;
	%Block10_to_tr00;
	%Block10_to_tr10;
	%Block10_to_vp12;
	%Block10_to_ward02;
	%Block10_to_ward12;
	%Block10_to_zip;


permit_&year.=1;

if PERMIT_TYP= "CONSTRUCTION" then permit_construction_&year. = 1 ;
if PERMIT_TYP= "HOME OCCUPATION" then permits_homeoccupation_&year.= 1 ;
if PERMIT_TYP= "POST CARD" then permits_postcard_&year.= 1 ;
if PERMIT_TYP= "SHOP DRAWING" then permits_shopdrawing_&year.= 1 ;
if PERMIT_TYP= "SUPPLEMENTAL" then permits_supplemental_&year.= 1 ;

run;

proc freq data=permits_&year._geo;
tables PERMIT_TYP;
run;

%macro summarizebygeo(geo);
proc summary data= permits_&year._geo;
	class &geo.;
	ways 0 1; 
	var permit_&year. permit_construction_&year. permits_homeoccupation_&year. permits_postcard_&year. permits_shopdrawing_&year. permits_supplemental_&year.;
	output out= permits_sum_&geo._1(drop= _FREQ_) sum=;
run;

data permits_sum_&geo._&year. ;
	set permits_sum_&geo._1;
	if _TYPE_=0 then &geo.="All";
run;

data permits_sum_&geo._&year. ;
	set permits_sum_&geo._&year.;
	drop _TYPE_;
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


