/**************************************************************************
 Program:  Building_permits_2009.sas
 Library:  DCRA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  03/19/19
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Read-in permits for 2009.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCRA )
%DCData_lib( OCTO )


%read_building_permits (year=2009,
						revisions= New file. )


/* End of program */
