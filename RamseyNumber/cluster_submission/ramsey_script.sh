#!/bin/sh
#ramsey_script.sh
#Torque script to run Matlab program

#Torque directives
#PBS -N ramsey_script
#PBS -W group_list=yetifree
#PBS -l nodes=1,walltime=00:10:00,mem=1000mb
#PBS -M alb2281@columbia.edu
#PBS -m abe
#PBS -V

#set output and error directories (SSCC example here)
#PBS -o localhost:/vega/free/users/alb2281/
#PBS -e localhost:/vega/free/users/alb2281/

#define parameter lambda

#Command to execute Matlab code
matlab -nosplash -nodisplay -nodesktop -r "overall_function(4)" > matoutfile_4

#Command below is to execute Matlab code for Job Array (Example 4) so that each part writes own output
#matlab -nosplash -nodisplay -nodesktop -r "simPoissGLM($LAMBDA)" > matoutfile.$PBS_ARRAYID

#End of script