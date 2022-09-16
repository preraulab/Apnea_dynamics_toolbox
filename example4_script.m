%% Example script
% 4 subjects with simiar AHI but different history dependence structures
%
% A: Top left: 0526
% B: Top right: 0537 
% C: Bottom left:2830
% D: Bottom right:5582
%
%____________________________________________________________________________________________________________
% Created by, Shuqiang Chen, 08/08/2022
% Last updated, SC, 08/16/22
% The script is companion to the paper by Shuqiang Chen, Susan Redline, Uri T. Eden, and Michael J. Prerau. 
% "Dynamic Models of Obstructive Sleep Apnea Provide Robust Prediction of Respiratory Event Timing
%  and a Statistical Framework for Phenotype Exploration, Sleep, 2022"
%************************************************************************************************************
%% Clear all
clear; close all;

%% Load data for 4 example subjects
load('Example_data/example4sub.mat');

%% Pre settings
bin = 1;                                     % set bin size (seconds)
Fs_pos = 32;                                 % sampling freq for position in MESA dataset
ord = 150;                                   % total number of orders we consider in history
subj_ID = [0526 0537 2830 5582];             % subject MESA ID
AHI = [sub0526.AHI sub0537.AHI sub2830.AHI sub5582.AHI];         % AHI in events/hr
N = [sub0526.N sub0537.N sub2830.N sub5582.N];                   % Number of respiratory events
TST = [sub0526.TST sub0537.TST sub2830.TST sub5582.TST];         % Total Sleep Time in hours

%% Run models and save results
result_cell = cell(4,4);

for i = 1:4
 datafile = eval(strcat('sub',num2str(subj_ID(i),'%04.f')));        % data file name
 
 %% Convert saved data to design matrix and response
 [pos,sta,history,y,Sp,isis] = build_design_mx(bin,Fs_pos,ord,datafile.event_info,datafile.hypnogram,datafile.rawposition);
 
 %% Model fitting and evaluation
 [b, dev, stats] = glmfit([pos sta history],y,'poisson','constant','off');
 [yhat,ylo,yhi] = glmval(b,[zeros(ord,6) Sp],'log',stats,'constant','off');

 % 95% Confidence bounds for history curve
 hi_bound = yhat + yhi;
 lo_bound = yhat - ylo;
 
 % save results
 result_cell{i,1} = yhat;
 result_cell{i,2} = hi_bound;
 result_cell{i,3} = lo_bound;
 result_cell{i,4} = isis;
 
end
                                         
                                         
%% Plot history curves for 4 subjects  
                                       
figure
ax = figdesign(2,2,'margins',[.1 .1 .1 .1 .15]);
set(gcf, 'units','inches','Position',  [0, 0, 30,20])
linkaxes(ax,'x');
xtime = (bin:bin:bin*ord)';

% A 
axes(ax(1))
plot(xtime,result_cell{1,1},'b','linewidth',3); hold on;
plot(xtime,result_cell{1,2},'k-',xtime,result_cell{1,3},'k-'); 
stem(result_cell{1,4}, -ones(length(result_cell{1,4}),1),'Color','k', 'Marker', 'none','linewidth',1);
xlim([0 150])
ylim([-1 17])
yline(1,'--k','linewidth',2);
ax4 = gca;
ax4.YAxis.FontSize = 18;
ax4.XAxis.FontSize = 18;
xlabel('Time Lag (seconds)','Fontsize',22);
ylabel('Rate Multiplier','Fontsize',22);
title('Participant A: AHI = 29.32 events/hr','Fontsize',26);
%set(gca,'xtick',[])

% B
axes(ax(2))
plot(xtime,result_cell{2,1},'b','linewidth',3); hold on;
plot(xtime,result_cell{2,2},'k-',xtime,result_cell{2,3},'k-'); 
stem(result_cell{2,4}, -ones(length(result_cell{2,4}),1),'Color','k', 'Marker', 'none','linewidth',1);
xlim([0 150])
ylim([-1 17])
yline(1,'--k','linewidth',2);
ax4 = gca;
ax4.YAxis.FontSize = 18;
ax4.XAxis.FontSize = 18;
xlabel('Time Lag (seconds)','Fontsize',22);
ylabel('Rate Multiplier','Fontsize',22);
title('Participant B: AHI = 29.28 events/hr','Fontsize',26);
%set(gca,'xtick',[])     
             

% C
axes(ax(3))
plot(xtime,result_cell{3,1},'b','linewidth',3); hold on;
plot(xtime,result_cell{3,2},'k-',xtime,result_cell{3,3},'k-'); 
stem(result_cell{3,4}, -ones(length(result_cell{3,4}),1),'Color','k', 'Marker', 'none','linewidth',1);
xlim([0 150])
ylim([-1 17])
yline(1,'--k','linewidth',2);
ax4 = gca;
ax4.YAxis.FontSize = 18;
ax4.XAxis.FontSize = 18;
xlabel('Time Lag (seconds)','Fontsize',22);
ylabel('Rate Multiplier','Fontsize',22);
title('Participant C: AHI = 29.49 events/hr','Fontsize',26);
%set(gca,'xtick',[])   


% D
axes(ax(4))
plot(xtime,result_cell{4,1},'b','linewidth',3); hold on;
plot(xtime,result_cell{4,2},'k-',xtime,result_cell{4,3},'k-'); 
stem(result_cell{4,4}, -ones(length(result_cell{4,4}),1),'Color','k', 'Marker', 'none','linewidth',1);
xlim([0 150])
ylim([-1 17])
yline(1,'--k','linewidth',2);
ax4 = gca;
ax4.YAxis.FontSize = 18;
ax4.XAxis.FontSize = 18;
xlabel('Time Lag (seconds)','Fontsize',22);
ylabel('Rate Multiplier','Fontsize',22);
title('Participant D: AHI = 29.71 events/hr','Fontsize',26);
%set(gca,'xtick',[])   

