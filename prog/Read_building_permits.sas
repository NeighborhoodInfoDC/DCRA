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
	%Block10_to_ward02
	%Block10_to_ward12;
	%Block10_to_zip;


run;


