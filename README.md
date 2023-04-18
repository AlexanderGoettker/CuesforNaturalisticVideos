# CuesforNaturalisticVideos
The MATLAB-code belongs to the paper "Cues for predictive eye movements in naturalistic scenes". You can find the paper here: 

The raw data you need to run the analysis are available at osf: https://osf.io/kqup8/

Run 'Main_Exp1' or 'Main_Exp2' for the analysis of Experiment 1 or Experiment 2 respectively (see paper for more details).
The main scripts will loop through conditions and subjects and calls all functions that perform the analysis. You can find the individual functions in the 'functions'-folder and all contain comments and documentation.

After running the analysis succesfully, the code will reproduce the figures of the paper and save the respective variables in seperate files (you can also directly download them at osf under aggregated data). 

Things to do/modify before running the analysis: 
(1) Download all files and put them in a folder. Adjust line 17 to match the folder name (initially 'Analysis_clean'), so that all things will be added to your analysis path.

(2) Line 41ff: Define the datapath (the folder were you put the downloaded  raw data from osf), as well as the stimulus path (the folder were you put the target information from osf). 

(3) In Line 143 you can also chose the path you want the result files saves. 


