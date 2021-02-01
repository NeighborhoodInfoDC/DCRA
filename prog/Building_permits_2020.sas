/**************************************************************************
 Program:  Building_permits_2020.sas
 Library:  DCRA
 Project:  NeighborhoodInfo DC
 Author:   Ananya Hariharan
 Created:  2/1/21
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Read-in permits for 2020.

 Modifications:
**************************************************************************/

%include "\\SAS1\DCData\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( DCRA )
%DCData_lib( OCTO )


%read_building_permits (year=2020/*Enter year in YYYY format*/,
						revisions= New File. /*Enter revisions or New file if it's a new year of data */)


/* End of program */
