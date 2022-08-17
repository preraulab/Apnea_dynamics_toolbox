function [ks,ksT] = ks_plot(pos,sta,history,y,b)
%% Function to construct Kolmogorov-Smirnov (KS) plot
% Input:
% * pos: [, x 1] double - binary (0 or 1), 1 means Supine position at that time interval
% * sta: [, x 5] double - [N1 N2 N3 REM Wake], binary (0 or 1), 
%                value 1 in each sta column indicates the corresponding stage the participant is in at that time interval
% * history:[, x 9] double - past event activity in the cardinal spline basis
% * y: [, x 1] double - response, binary (0 or 1) event train, 1 means the apnea event happened at that time interval 
% * b: [15 x 1] double, fitted parameters
%
% Output:
% * ks: double, KS statistics
% * ksT: double, 0: pass the KS test; 1: fail to reject the null 
% * A KS plot will also be drawn to show the goodness-of-fit

%% Figure
event_idx = find(y>=1);
lambda_PSH = exp(pos*b(1)+sta*b(2:6)+history*b(7:end));     % conditional intensity from PSH model 
Z = [];
Z(1) = sum(lambda_PSH(1:event_idx(1)));	
for i = 2:length(event_idx)							
  Z(i) = sum(lambda_PSH(event_idx(i-1)+1:event_idx(i)));    
end
[eCDF, zvals] = ecdf(Z);				
mCDF = 1-exp(-zvals);				
ks = max(abs(mCDF - eCDF));                                 % KS stats
ksT = double(kstest(eCDF, 'CDF', [eCDF mCDF]));             % KS test results

% KS plot
figure;
x = linspace(0.001,1,length(eCDF)); 
upp = x + 1.36/sqrt(length(event_idx)); upp = upp'; 
low = x - 1.36/sqrt(length(event_idx)); low = low'; 
low(low<0) = 0; upp(upp>1) = 1; 
fill([x fliplr(x)],[low; flipud(upp)],[0.9,0.9,0.9],'FaceAlpha',.5)
hold on;  
plot(x, x,'--', 'Color', [0.6 0.6 0.6], 'LineWidth', 1)
plot(mCDF, eCDF, '.k');
plot(mCDF, eCDF, 'k', 'linewidth', 2);
axis square;
ax4 = gca; 
ax4.YTick = [0 1];
ax4.XTick = [0 1];
ylabel('Empirical CDF','Fontsize',17)
xlabel('Theoretical CDF','Fontsize',17)
yyaxis right 
ax4.YColor = 'k'; 
ax4.YTick = 0.5;
ax4.YTickLabel = sprintf('KS Statistics = %.2f', ks);
ax4.YTickLabelRotation = -90; 
ax4.FontSize = 20;
hold off;


end