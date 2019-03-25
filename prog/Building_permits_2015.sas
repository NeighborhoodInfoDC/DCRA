/**************************************************************************
 Program:  Building_permits_2015.sas
 Library:  DCRA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  03/19/19
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Read-in permits for 2015.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCRA )
%DCData_lib( OCTO )


%read_building_permits (year=2015,
						revisions= New file. )


/* End of program */
