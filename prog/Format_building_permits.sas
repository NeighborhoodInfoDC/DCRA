/**************************************************************************
 Program:  Format_building_permits.sas
 Library:  DCRA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  03/25/19
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Read-in permits for 2018.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCRA )

/* Formats for building permits raw data */
proc format;
	value $appstatus
		'APPLICATION ACCEPTED'	= 'APPLICATION ACCEPTED'
		'APPLICATION APPROVED'	= 'APPLICATION APPROVED'
		'APPLICATION CANCELED'	= 'APPLICATION CANCELED'
		'COMPLETED'	= 'COMPLETED'
		'INSPECTION PENDING'	= 'INSPECTION PENDING'
		'INSPECTIONS IN PROCESS'	= 'INSPECTIONS IN PROCESS'
		'PERMIT CANCELED'	= 'PERMIT CANCELED'
		'PERMIT CANCELED REFUND'	= 'PERMIT CANCELED REFUND'
		'PERMIT ISSUED'	= 'PERMIT ISSUED'
		'PERMIT REVOKED'	= 'PERMIT REVOKED'
		'PROJECTDOX ACCEPTED'	= 'PROJECTDOX ACCEPTED'
		'REVIEW IN PROCESS'	= 'REVIEW IN PROCESS' 
; 
	value $permittype
		'CONSTRUCTION'	= 'CONSTRUCTION'
		'HOME OCCUPATION'	= 'HOME OCCUPATION'
		'POST CARD'	= 'POST CARD'
		'SHOP DRAWING'	= 'SHOP DRAWING'
		'SUPPLEMENTAL'	= 'SUPPLEMENTAL' 
;
	value $permitcat
		'AFTER HOURS'	= 'AFTER HOURS'
		'ANTENNA'	= 'ANTENNA'
		'FIREWORKS STAND'	= 'FIREWORKS STAND'
		'FUEL BURNING'	= 'FUEL BURNING'
		'HISTORIC PROPERTY'	= 'HISTORIC PROPERTY'
		'MINIATURE BOILER'	= 'MINIATURE BOILER'
		'NA'	= 'N/A'
		'SCAFFOLDING'	= 'SCAFFOLDING'
		'SOIL BORING'	= 'SOIL BORING'
		'TENT'	= 'TENT'
		'TOWER CRANE'	= 'TOWER CRANE'
		'UNDERGROUND STORAGE TANK'	= 'UNDERGROUND STORAGE TANK'
		'UNFIRED PRESSURE VESSEL'	= 'UNFIRED PRESSURE VESSEL' 
;
	value $permitsub
		'ADDITION'	= 'ADDITION'
		'ADDITION ALTERATION REPAIR'	= 'ADDITION ALTERATION REPAIR'
		'ALTERATION AND REPAIR'	= 'ALTERATION AND REPAIR'
		'AWNING'	= 'AWNING'
		'BOILER'	= 'BOILER'
		'BUILDING'	= 'BUILDING'
		'CAPACITY PLACARD'	= 'CAPACITY PLACARD'
		'CIVIL PLANS'	= 'CIVIL PLANS'
		'DEMOLITION'	= 'DEMOLITION'
		'ELECTRICAL'	= 'ELECTRICAL'
		'ELECTRICAL - GENERAL'	= 'ELECTRICAL - GENERAL'
		'ELECTRICAL - HEAVY UP'	= 'ELECTRICAL - HEAVY UP'
		'ELEVATOR - ALTERATION'	= 'ELEVATOR - ALTERATION'
		'ELEVATOR - NEW'	= 'ELEVATOR - NEW'
		'ELEVATOR - REPAIR'	= 'ELEVATOR - REPAIR'
		'EXCAVATION ONLY'	= 'EXCAVATION ONLY'
		'EXPEDITED'	= 'EXPEDITED'
		'FENCE'	= 'FENCE'
		'FOUNDATION ONLY'	= 'FOUNDATION ONLY'
		'GARAGE'	= 'GARAGE'
		'GAS FITTING'	= 'GAS FITTING'
		'MECHANICAL'	= 'MECHANICAL'
		'MISCELLANEOUS'	= 'MISCELLANEOUS'
		'NA'	= 'N/A'
		'NEW BUILDING'	= 'NEW BUILDING'
		'PLUMBING'	= 'PLUMBING'
		'PLUMBING AND GAS'	= 'PLUMBING AND GAS'
		'RAZE'	= 'RAZE'
		'RETAINING WALL'	= 'RETAINING WALL'
		'SHED'	= 'SHED'
		'SHEETING AND SHORING'	= 'SHEETING AND SHORING'
		'SIGN'	= 'SIGN'
		'SOLAR SYSTEM'	= 'SOLAR SYSTEM'
		'SPECIAL BUILDING'	= 'SPECIAL BUILDING'
		'SPECIAL SIGN'	= 'SPECIAL SIGN'
		'SWIMMING POOL'	= 'SWIMMING POOL'
		'TENANT LAYOUT'	= 'TENANT LAYOUT'
		'VARIANCE'	= 'VARIANCE' 
;
run;


proc catalog catalog=DCRA.formats;
  modify appstatus (desc="Application status") / entrytype=formatc;
  modify permittype (desc="Type of permit") / entrytype=formatc;
  modify permitcat (desc="Category of permit") / entrytype=formatc; ;
  modify permitsub (desc="Subategory of permit") / entrytype=formatc;
  contents;
quit;



/* End of program */
