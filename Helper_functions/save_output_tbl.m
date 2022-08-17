function [tbl] = save_output_tbl(bin,b,stats)
%% Function to save model output as a table
% Input:
% * bin: double, bin size, bin = 1 (sec) 
% * b: double, [15 x 1], fitted parameters
% * stats: a struct that contains all the information about the model fitting result
%
% Output:
% * tbl: a cell table that lists rates, multiplier and correspinding 95% confidence intervals 
% * A csv file named "example_sub_output.csv" will also be saved in your current folder
% 
%__________________________________________________________________________________________________________
% Created by, Shuqiang Chen, 08/16/22
% The script is companion to the paper by Shuqiang Chen, Susan Redline, Uri T. Eden, and Michael J. Prerau. 
% "Dynamic Models of Obstructive Sleep Apnea Provide Robust Prediction of Respiratory Event Timing
%  and a Statistical Framework for Phenotype Exploration, Sleep, 2022"
%*************************************************************************************************************

%%
% Compute rates and mutiplier
Supine_multip = exp(b(1));
N1_rate = exp(b(2))*3600/bin;
N2_rate = exp(b(3))*3600/bin;
N3_rate = exp(b(4))*3600/bin;
REM_rate = exp(b(5))*3600/bin;
Rate_col = [N1_rate N2_rate N3_rate REM_rate Supine_multip]'; % Rates for N1,N2,N3,REM, and Supine multiplier

% Compute confidence intervals
se = stats.se;
linear_ci = [b(1:5)-1.96.*se(1:5) b(1:5)+1.96.*se(1:5)];
CI_col = 3600*[exp(linear_ci(2:5,:)); exp(linear_ci(1,:))/3600]; % CI for N1,N2,N3,REM, Supine

% Output Table t
tbl{1,1}='Sleep Stage';    tbl{1,2}='Rate(events/hour)';           tbl{1,3}= '95% Confidence Interval ';   
tbl{2,1}='N1';             tbl{2,2}= sprintf('%0.2f',Rate_col(1)); tbl{2,3}= ['[' sprintf('%0.2f',CI_col(1,1)) ', ' sprintf('%0.2f',CI_col(1,2)) ']'];
tbl{3,1}='N2';             tbl{3,2}= sprintf('%0.2f',Rate_col(2)); tbl{3,3}= ['[' sprintf('%0.2f',CI_col(2,1)) ', ' sprintf('%0.2f',CI_col(2,2)) ']'];
tbl{4,1}='N3';             tbl{4,2}= sprintf('%0.2f',Rate_col(3)); tbl{4,3}= ['[' sprintf('%0.2f',CI_col(3,1)) ', ' sprintf('%0.2f',CI_col(3,2)) ']'];
tbl{5,1}='REM';            tbl{5,2}= sprintf('%0.2f',Rate_col(4)); tbl{5,3}= ['[' sprintf('%0.2f',CI_col(4,1)) ', ' sprintf('%0.2f',CI_col(4,2)) ']'];
tbl{6,1}='Body Position';  tbl{6,2}='Multiplier';                  tbl{6,3}= '95% Confidence Interval ';  
tbl{7,1}='Supine';         tbl{7,2}= sprintf('%0.2f',Rate_col(5)); tbl{7,3}= ['[' sprintf('%0.2f',CI_col(5,1)) ', ' sprintf('%0.2f',CI_col(5,2)) ']'];

writecell(tbl,'example_sub_output.csv');    % Save as a csv file 


end









