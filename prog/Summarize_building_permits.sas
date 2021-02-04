/**************************************************************************
 Program:  Summarize_building_permits.sas
 Library:  DCRA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  03/19/19
 Version:  SAS 9.4
 Environment:  Windows

 Description:  Summarize building permits by geography.

 Modifications:  Update to include 2019 and 2020 data - Feb 3, 2021, ALH
**************************************************************************/

%include "\\SAS1\DCData\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCRA )

/* Update start and end year */
%let start_yr = 2009;
%let end_yr = 2020;

/* Update base file list with new year of data */
%let base_files = dcra.Permits_base_2009
                                  dcra.Permits_base_2010
                                  dcra.Permits_base_2011
                                  dcra.Permits_base_2012
                                  dcra.Permits_base_2013
                                  dcra.Permits_base_2014
                                  dcra.Permits_base_2015
                                  dcra.Permits_base_2016
                                  dcra.Permits_base_2017
                                  dcra.Permits_base_2018
                                  dcra.Permits_base_2019
                                  dcra.Permits_base_2020 ;


/* No modifications necessary beyond this point */

%macro permits_by_geo (geo);

%let geosuf = %sysfunc( putc( %upcase(&geo), $geosuf. ) );
%let geolbl = %sysfunc( putc( %upcase(&geo), $geolbl. ) );

data permits_&geo._allyears;
        set &base_files.;
        keep &geo. permits_: ;
run;

proc summary data = permits_&geo._allyears;
        class &geo.;
        var permits_:;
        output out= permits_sum&geosuf. sum=;
run;

data permits_sum&geosuf._final;
        set permits_sum&geosuf.;
        drop _type_ _freq_;
        if _type_ = 1;
run;

%Finalize_data_set(
  data=permits_sum&geosuf._final,
  out=permits_sum&geosuf.,
  outlib=DCRA,
  label="DC building permits summary, &start_yr. to &end_yr., &geolbl.",
  sortby=&geo.,
  restrictions=None,
  revisions=;
  );

%mend permits_by_geo;

%permits_by_geo(Anc2002);
%permits_by_geo(Anc2012);
%permits_by_geo(bridgepk);
%permits_by_geo(city);
%permits_by_geo(Cluster_tr2000);
%permits_by_geo(cluster2017);
%permits_by_geo(eor);
%permits_by_geo(Psa2004);
%permits_by_geo(Psa2012);
%permits_by_geo(stantoncommons);
%permits_by_geo(Geo2000);
%permits_by_geo(Geo2010);
%permits_by_geo(VoterPre2012);
%permits_by_geo(Ward2002);
%permits_by_geo(Ward2012);
%permits_by_geo(Zip);
