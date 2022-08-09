function [pos,sta,history,y,Sp,isis] = build_design_mx(bin,Fs_pos,ord,event_info,hypnogram,rawposition)
%% Function to convert saved data to design matrix and response
% Input:
% * bin: [double],bin size, bin = 1 (sec) in the paper
% * Fs_pos: [double],sampling frequency of raw position data, Fs_pos = 32 Hz for MESA dataset
% * ord: [double] total order of history length, ord = 150 in the paper
% * event_info: [N x 3] double - [event_start_time(sec), event_duration(sec), event_type], N is total number of events
%               event_type - 1: hypopnea, 2: OSA, 3: Central
%
% * hypnogram: [, x 3] double - [stage_start_time(sec), stage_duration(sec), sleep stage]
%              - sleep stages (5: Wake, 4: REM, 3: N1, 2: N2, 1: N1);
% * rawposition: [,x 1] double, sleep position train in sampling frequency Fs_pos
%              - Raw labels: 0: Right; 1:Supine(Back); 2:Left; 3:Prone; 4:Upright
%________________________________________________________________________________________________
% 
% Output:
% * pos: [, x 1] double - binary (0 or 1), 1 means Supine position at that time interval
% * sta: [, x 5] double - [N1 N2 N3 REM Wake], binary (0 or 1), 
%                value 1 in each sta column indicates the corresponding stage the participant is in at that time interval
% * history:[, x 9] double - past event activity in the cardinal spline basis
% * y: [, x 1] double - response, binary (0 or 1) event train, 1 means the apnea event happened at that time interval 
% * Sp: [ord x 9] double - cardinal spline matrix 
% * isis: [,x 1] double - inter-event-intervals
%
%
% Created by Shuqiang Chen,08/08/2022
% 
%******************************************************************************************************
%
%% Construct respiratory event train
apnea_stime = event_info(:,1);                         % event start time
apnea_time = apnea_stime + event_info(:,2);            % use apnea end time as event timing 
stage_time = hypnogram(:,1);                           % stage time
totaltime = stage_time(end) + hypnogram(end,2);        % total time length
domaindivide = 0:bin:totaltime;                        % timestamps

apneatrain = hist(apnea_time,domaindivide)';           % apnea event train (end time)
apneatrain_s = hist(apnea_stime,domaindivide)';        % event train (start time)
events_idx = find(apneatrain);                         % event idx (end time)
events_idxs = find(apneatrain_s);                      % event idx (start time)

%% Construct sleep stage matrix
stagetrain = hist(stage_time,domaindivide)';           % stage switching train 
sta_switch = find(stagetrain==1);                      % stage switching time idx
for i=1:(size(hypnogram,1)-1)
   stagetrain(sta_switch(i):(sta_switch(i+1)-1)) = hypnogram(i,3);
end
stagetrain(sta_switch(end):end) = hypnogram(size(hypnogram,1),3);  % complete stage train 

% Check "Wake Apnea":
% 1. If event start stage is wake, replace it by its most recent stage
startwake = find(apneatrain_s==1&stagetrain==5);
if ~isempty(startwake)
    for j = 1:length(startwake)
        if find(hist(startwake(j),hypnogram(:,1)))==1
           stagetrain(startwake(j)) = hypnogram((find(hist(startwake(j),hypnogram(:,1)))+1),3);
        else
           stagetrain(startwake(j)) = hypnogram((find(hist(startwake(j),hypnogram(:,1)))-1),3);
        end
    end
end

% 2. In the event duration, replace Wake (if exists) by the event start stage 
for i = 1:length(apnea_time)
    if length(events_idx)==length(events_idxs) % Inequality can happen when exists IEI < binsize
      duration_stage = stagetrain(events_idxs(i):events_idx(i));
      w5 = find(duration_stage==5);
       if  ~isempty(w5)
         duration_stage(w5) = duration_stage(1);
         stagetrain(events_idxs(i):events_idx(i)) = duration_stage;
       end  
    end
end

% Construct stage matrix
stage = zeros(length(apneatrain),5);                       
stage(stagetrain==3,1)=1;                                   % N1
stage(stagetrain==2,2)=1;                                   % N2
stage(stagetrain==1,3)=1;                                   % N3
stage(stagetrain==4,4)=1;                                   % REM
stage(stagetrain==5,5)=1;                                   % WAKE

%% Construct sleep position 
% Raw labels: 0: Right; 1:Supine(Back); 2:Left; 3:Prone; 4:Upright
% Relabeled as: Supine = 1, Nonsupine = 0  

pos_match = rawposition([1 round(domaindivide(2:end)*Fs_pos)]);   % Match timestamps
Supine_pos = zeros(length(apneatrain),1);                              
Supine_pos(pos_match == 1,1) = 1;                                 % Supine position train
			            

%% Adjust position, stage and response to align with history components 
pos = Supine_pos(ord+1:end,:);
sta = stage(ord+1:end,:);
y = apneatrain(ord+1:end);


%% Construct history component

% Build indicator history basis 
xHist = [];					
for i = 1:ord				            % for each step in past
    xHist=[xHist apneatrain(ord+1-i:end-i)];  % shift the spike train to build past event activity
end


% Set cardinal spline knot locations
ISIs = diff(apnea_time);    
isis = unique(ISIs);
c_pt_times_all = round([-10 0 linspace(prctile(ISIs,10), 90, 4) 120 ord ord+10]); 
s = 0.5;                                                      % Tension parameter

% Construct cardinal spline basis history component
[Sp] = CardinalSpline(ord,c_pt_times_all,s);  
history =  xHist*Sp;



end

