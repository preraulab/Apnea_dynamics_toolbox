%old version
%Hypnoplot
%
%hypnoplot(time,stage)
function hypnoplot_old(varargin)
if nargin==1
    s=varargin{1};
    time=s.time(:)';
    stage=s.stage(:)';
elseif nargin>=2
    time=varargin{1}(:)';
    stage=varargin{2}(:)';
end

time =[time, time(end)+30];
stage=[stage, stage(end)];

if nargin==3
    groupNREM=varargin{3};
else
    groupNREM=true;
end

hyplabs={'N3','N2','N1','REM','Wake'};

%stage_colors the hypnogram
stage_colors(time,stage, groupNREM);

%Plot the hypnogram
stairs(time,stage,'k','linewidth',2);
set(gca,'ytick',1:5,'yticklabel',hyplabs,'xticklabel','','fontsize',25);
axis([0 max(time) .7 5.3]);
title('Hypnogram','fontsize',35);

function stage_colors(time,stage,groupNREM)
hold on

%Define the colors by stages
NS=[1 1 1]; %No stage
W=[1 .7 .7];
N3=[.6 .6 1];
N2=[.8 .8 1];
N1=[.8 1  1];
REM=[.7 1 .7];
NREM=N2;


colors=[NS; ...
    N3; ...
    N2; ...
    N1; ...
    REM; ...
    W;...
    NS];

% groupNREM=false;

if groupNREM %If you want to group NREM with background colors
    %Fill the whole hypnogram background with NREM color
    a=time(1);
    b=time(end);
    c=ones(1,length(a))*-.3;
    d=ones(1,length(a))*5.3;
    
    fill([a;b;b;a],[c;c;d;d], N2,'edgecolor','none')
    
    %Overlay the no-stage, REM, and Wake on top
    for i=[0 4 5]
        inds = find(stage(1:end-1)==i);
        
        %Get epoch times
        a=time(inds);
        b=time(inds+1);
        c=ones(1,length(a))*-.3;
        d=ones(1,length(a))*5.3;
        
        %Plot shaded rectangle
        fill([a;b;b;a],[c;c;d;d],colors(i+1,:),'edgecolor','none')
    end
else %To plot all stages different colors
    for i=0:5 %Loop through all stages
        inds = find(stage(1:end-1)==i);
        
        %Get epoch times
        a=time(inds);
        b=time(inds+1);
        c=ones(1,length(a))*-.3;
        d=ones(1,length(a))*5.3;
        
        %Plot shaded rectangle
        fill([a;b;b;a],[c;c;d;d],colors(i+1,:),'edgecolor','none')
    end
end

%Set the proper limits
xlim(time([1 end-1]));
ylim([.7 5.3]);
