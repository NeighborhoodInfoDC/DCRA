/**************************************************************************
 Program:  Read_building_permits.sas
 Library:  DCRA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  06/20/17
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Macro to read Building permit data for a given year.

 Modifications:
**************************************************************************/

%macro read_building_permits (year=, revisions=);

/* Read in permits shapefile */
proc mapimport out=permits_&year._in
	datafile="&_dcdata_r_path\DCRA\Raw\Building_Permits_in_&year..shp";
 	select applicatio desc_of_wo fees_paid fee_type full_addre issue_date lastmodifi maraddress owner_name
		   permit_app permit_cat permit_id permit_sub permit_typ ssl xcoord ycoord zoning objectid;
	rename applicatio=AppStatus desc_of_wo=DescOfWork fees_paid=Fees fee_type=FeeType full_addre=Address issue_date=IssueDate_i
		   lastmodifi=LastModified_i maraddress=MARAddress owner_name=OwnerName permit_app=ApplicantName permit_cat=PermitCategory
		   permit_id=PermitID permit_sub=PermitSubcategory permit_typ=PermitType;
run;

proc freq data = permits_&year._in;
	tables PermitType;
run;

/* Read in Census block shapefile */
proc mapimport out=block_shp_in
  datafile="&_dcdata_r_path\OCTO\Maps\Census_Blocks__2010.shp";  
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


/* Add standard geographies to each permit, create dummy vars and label */
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

	label x = "Latitude (decimal degrees)"
		  y = "Longitude (decimal degrees)"
		  geoblk2010 = "Census block (2010)"
		  appstatus = "Permit application status"
		  descofwork = "Description of work"
		  fees = "Amount of permit fees ($)"
		  feetype = "Description and amount of fees required for permit"
		  address = "Address on permit application"
		  issuedate = "Permit issue date"
		  lastmodified = "Last modified date"
		  maraddress = "MAR address ID"
		  objectID = "GIS ObjectID"
		  Ownername = "Name of property owner"
		  applicantname = "Name of permit applicant"
		  permitcategory = "Permit category"
		  permitid = "DCRA permit ID"
		  permitsubcategory = "Permit subcategory"
		  permittype = "Permit type"
		  ssl = "SSL (square, suffix, lot)"
		  zoning = "DC zoning code"
		  xcoord = "Latitude (MD State Plane)"
		  ycoord = "Longitude (MD State Plane)"
	;

	LastModified_c = substr(LastModified_i,1,10);
	IssueDate_c = substr(IssueDate_i,1,10);

	IssueDate = input(IssueDate_c,yymmdd10.);
	LastModified = input(LastModified_c,yymmdd10.);

	format IssueDate date9. LastModified date9.;

	permits_&year.=1;
	permits_construction_&year.= 0;
	permits_homeoccupation_&year.= 0;
	permits_postcard_&year.= 0;
	permits_shopdrawing_&year.= 0;
	permits_supplemental_&year.= 0;

	if PermitType= "CONSTRUCTION" then permits_construction_&year. = 1 ;
	if PermitType= "HOME OCCUPATION" then permits_homeoccupation_&year.= 1 ;
	if PermitType= "POST CARD" then permits_postcard_&year.= 1 ;
	if PermitType= "SHOP DRAWING" then permits_shopdrawing_&year.= 1 ;
	if PermitType= "SUPPLEMENTAL" then permits_supplemental_&year.= 1 ;

	label permits_&year. = "Total building permits in &year."
		  permits_construction_&year. = "Construction permits in &year."
		  permits_homeoccupation_&year. = "Home occupation permits in &year."
		  permits_postcard_&year. = "Postcard permits in &year."
		  permits_shopdrawing_&year. = "Permit drawings in &year."
		  permits_supplemental_&year. = "Supplemental building permits in &year."
	;

	drop geoid10 segment _onborder_ LastModified_i LastModified_c IssueDate_i IssueDate_c;

	format appstatus appstatus. permittype permittype. permitcategory permitcat. permitsubcategory permitsub.;

run;


/* Finalize permit base dataset */
%Finalize_data_set( 
  data=permits_&year._geo,
  out=permits_base_&year.,
  outlib=DCRA,
  label="DC building permits in &year.",
  sortby=issuedate permitid,
  restrictions=None,
  revisions=&revisions.;
  );


%mend read_building_permits;


/* End of macro */
