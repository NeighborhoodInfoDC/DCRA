/**************************************************************************
 Program:  Building_permits_YYYY template.sas
 Library:  DCRA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  03/19/19
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Read-in permits for YYYY.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCRA )
%DCData_lib( OCTO )


%read_building_permits (year=/*Enter year in YYYY format*/,
						revisions= /*Enter revisions or New file if it's a new year of data */)


/* End of program */
