/**************************************************************************************
*
*	PROGRAM TO ANALYSE FORWARD PROJECTIONS FOR SOCIAL CARE - MASTER
*
*	Last version:  Justin van de Ven, 11 Mar 2025
*	First version: Justin van de Ven, 11 Mar 2025
*
*************************************************************************************/

clear all
global run_name = "sc_analysis1"
do "C:\Justin\dev\WELLCARE\analysis\care analysis6.do"
do "C:\Justin\dev\WELLCARE\analysis\care analysis7.do"

clear all
global run_name = "sc_analysis1b"
do "C:\Justin\dev\WELLCARE\analysis\care analysis6.do"
do "C:\Justin\dev\WELLCARE\analysis\care analysis7.do"

clear all
global run_name = "sc_analysis1c"
do "C:\Justin\dev\WELLCARE\analysis\care analysis6.do"
do "C:\Justin\dev\WELLCARE\analysis\care analysis7.do"

clear all
global run_name = "sc_analysis1d"
do "C:\Justin\dev\WELLCARE\analysis\care analysis6.do"
do "C:\Justin\dev\WELLCARE\analysis\care analysis7.do"

clear all
global run_name = "care_gap"
do "C:\Justin\dev\WELLCARE\analysis\care analysis6.do"
do "C:\Justin\dev\WELLCARE\analysis\care analysis7.do"

clear all
global run_name = "carer_support"
do "C:\Justin\dev\WELLCARE\analysis\care analysis6.do"
do "C:\Justin\dev\WELLCARE\analysis\care analysis7.do"
