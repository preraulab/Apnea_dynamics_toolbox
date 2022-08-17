function [] = plot_DesignMx_Resp(pos,sta,y)
%% Fxn to visualize design matrix and response
% - Input:
%   * pos: [, x 1] double - binary (0 or 1), 1 means Supine position at that time interval
%   * sta: [, x 5] double - [N1 N2 N3 REM Wake], binary (0 or 1), 
%                value 1 in each sta column indicates the corresponding stage the participant is in at that time interval
%   * y: [, x 1] double - response, binary (0 or 1) event train, 1 means the apnea event happened at that time interval 
%
% - Output:
%   A figure shows respiratory event train, body position, sleep stages (From top to bottom).
%
% ________________________________________________________________________________________________________________________
% Created by, Shuqiang Chen, 08/16/22
% The fxn is companion to the paper by Shuqiang Chen, Susan Redline, Uri T. Eden, and Michael J. Prerau. 
% "Dynamic Models of Obstructive Sleep Apnea Provide Robust Prediction of Respiratory Event Timing
%  and a Statistical Framework for Phenotype Exploration, Sleep, 2022"
%*************************************************************************************************************************

%%
figure
ax = figdesign(5,1, 'margins',[.1 .1 .1 .1 .1],'merge',{[3 4 5]});     % Design figure layout
set(gcf, 'units','inches','Position',  [0, 0, 20,10])                  % Set figure size
linkaxes(ax([1 2 3]),'x');                                             % Link x-axes

% Specify a time session
event_idx = find(y>=1);
startt = event_idx(1) - 200;
endt = event_idx(end) + 200;

% Event train
axes(ax(1)); 
stem(event_idx, ones(length(event_idx)),'k','marker','none');
set(gca,'xtick',[],'ytick',[],'box','off','YColor','none','Linewidth',2)
xlim([startt endt]);
title('Respiratory Event Train','fontsize',35);

% Position
axes(ax(2)); 
stairs(1:length(y),pos,'k','linewidth',2);hold on
fill([1:length(y) fliplr(1:length(y))],[zeros(length(y),1);flipud(pos)],[0.75,0.75,0.75],'FaceAlpha',.5,'edgecolor','none')
set(gca, 'YTick', [0.1 0.9],'box','off','TickLength',[0 0],'XColor','none');
set(gca,'YTickLabel',{'NonSupine', 'Supine'},'fontsize',25,'XTick',[],'box','off');
xlim([startt endt]);
ylim([-0.1 1.1]);
title('Body Position','fontsize',35);

% Stage
axes(ax(3)); 
stagetrain = ones(length(y),1).*sta(:,1) + 2*ones(length(y),1).*sta(:,2) + 3*ones(length(y),1).*sta(:,3) + 4*ones(length(y),1).*sta(:,4) + 5*ones(length(y),1).*sta(:,5);
hypnoplot_old(1:length(y),stagetrain);
xlim([startt endt]);
set(gca,'XTick',[])
xlabel('Time','Fontsize',30);
[~,h2] = scaleline(gca,3600,'1 Hour');
h2.FontSize = 20;
title('Sleep Stage','fontsize',35);



end
