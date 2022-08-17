function [] = plot_hist_mod_curve(bin,ord,yhat,lo_bound,hi_bound,isis)
%% Function to plot history modulation curve with confidence intervals
% Input:
% * bin: double, bin size, bin = 1 (sec) 
% * ord: double, total time lag: 150
% * yhat: double,[ord x 1], history dependence curve
% * lo_bound: 95% lower confidence bound of yhat
% * hi_bound: 95% upper confidence bound of yhat
% * isis: double,[, x 1] inter-event-intervals in seconds
% 
% Output:
% A history modulation figure that describes how past respiratory event affects current event rate
%
%__________________________________________________________________________________________________________
% Created by, Shuqiang Chen, 08/16/22
% The script is companion to the paper by Shuqiang Chen, Susan Redline, Uri T. Eden, and Michael J. Prerau. 
% "Dynamic Models of Obstructive Sleep Apnea Provide Robust Prediction of Respiratory Event Timing
%  and a Statistical Framework for Phenotype Exploration, Sleep, 2022"
%*************************************************************************************************************

%% Figure
figure;
xtime = (bin:bin:bin*ord)';
plot(xtime,yhat,'b','linewidth',3); hold on;
plot(xtime,hi_bound,'k-',xtime,lo_bound,'k-'); 
stem(isis, -ones(length(isis),1),'Color','k', 'Marker', 'none','linewidth',1);
xlim([0 ord])
ylim([-1 17])
yline(1,'--k','linewidth',2);
ax0 = gca;
ax0.YAxis.FontSize = 18;
ax0.XAxis.FontSize = 18;
xlabel('Time Lag (seconds)','Fontsize',22);
ylabel('Rate Multiplier','Fontsize',22);
title('History Modulation','Fontsize',26);


end