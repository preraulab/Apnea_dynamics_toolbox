%% Example script 1
% Walk through a single subject, MESA ID 2127, same subject as in Figure 1b (Chen et al, Sleep 2022)
% 
% - Step 1: Convert saved data to design matrix and response
%   -- Step 1+ : Visualize the position, stage and event train
% - Step 2: Model fitting 
%   -- Step 2+ : Visualize model output as a table 
% - Step 3: Plot history modulation curve
% - Step 4: Evaluating model goodness-of-fit using KS plot
%
% ____________________________________________________________________________________________________________
% Created by, Shuqiang Chen, 08/16/22
% The script is companion to the paper by Shuqiang Chen, Susan Redline, Uri T. Eden, and Michael J. Prerau. 
% "Dynamic Models of Obstructive Sleep Apnea Provide Robust Prediction of Respiratory Event Timing
%  and a Statistical Framework for Phenotype Exploration, Sleep, 2022"
%*************************************************************************************************************
%
%% Clear all
clear; close all;

%% Load data for a single subject
load('Example_data/example1sub.mat');

%% Pre settings
bin = 1;                                     % set bin size (seconds)
Fs_pos = 32;                                 % sampling freq for position in MESA dataset
ord = 150;                                   % total number of orders we consider in history
AHI = sub2127.AHI;                           % AHI in events/hr
N = sub2127.N;                               % Number of respiratory events
TST = sub2127.TST;                           % Total Sleep Time in hours

%% - Step 1: Convert saved data to design matrix and response

[pos,sta,history,y,Sp,isis] = build_design_mx(bin,Fs_pos,ord,sub2127.event_info,sub2127.hypnogram,sub2127.rawposition);
 
%% -- Step 1+ : Visualize the position, stage and event train

plot_DesignMx_Resp(pos,sta,y);

%% - Step 2: Model fitting 

[b, dev, stats] = glmfit([pos sta history],y,'poisson','constant','off');

%% -- Step 2+: Visualize model output as a table 

[tbl] = save_output_tbl(bin,b,stats)

%% - Step 3: Plot history modulation curve
[yhat,ylo,yhi] = glmval(b,[zeros(ord,6) Sp],'log',stats,'constant','off');

% 95% Confidence bounds for history curve
hi_bound = yhat + yhi;
lo_bound = yhat - ylo;

% Figure
plot_hist_mod_curve(bin,ord,yhat,lo_bound,hi_bound,isis);

%% - Step 4: Evaluating model goodness-of-fit using KS plot

[ks,ksT] = ks_plot(pos,sta,history,y,b);




