

clc; close all ;
keepvars = {'ii'};
clearvars('-except', keepvars{:});

addpath('classes');
addpath('utilities');

%% Supress warnings
warning('off', 'MATLAB:nearlySingularMatrix');

%% Raw Data Log Folder
logname='ped0';
%other logs are ped02,ped03,ped04
logfolder = strcat('logs/',logname,'/');


%% Node/Network configuration
configfile = 'config/car';


%% Create Network Manager 
nm = Manager(configfile, logfolder);
node_ids = nm.getNodeIds();
node_names = nm.getNodeNames();
moreInputData=nm.dataparser.inputlogs(:,[2,5]);
%% Rigid body IDs
nm.setRigidBodyId('car-mobile', 1);


%% Data Driven reachability Raw Data Log Folder
lognameRA='ped1';
%other logs are ped2,ped3,ped4
logfolderRA = strcat('logs/',lognameRA,'/');
DRA= DataDrivenRA( logfolderRA );
ZepsFlag =1;
DRA.prepareUWLip(ZepsFlag,moreInputData);


%% Bootstrap the node positions and clock params before filter starts
% use first second of measurements to bootstrap node states

%

fig = cfigure(25,25); grid on; hold on; axis equal;


%% Save as movie
SAVEMOVIE = false;
if SAVEMOVIE
    vidObj = VideoWriter('video/car.avi');
    vidObj.FrameRate=20;
    open(vidObj);
end


% rigid bodies in mocap
rigid_bodies = nm.dataparser.getRigidBodyIds();
[Xdim, Ydim] = nm.dataparser.getMaxDimension();
hrigidbodies = zeros( length(rigid_bodies),1 );
for i=1:length(rigid_bodies)
    hrigidbodies(i) = plot(0, 0, 'sb', 'MarkerSize', 5, 'MarkerFaceColor', 'k', 'LineWidth', 2);
end

xlim([Xdim{1}-0.5 Xdim{2}+0.5]);
ylim([Ydim{1}-0.5 Ydim{2}+0.5]);
%zlim([Ydim{1}-0.5 Ydim{2}+0.5]);
xlabel('X Position (m)', 'FontSize',14);
ylabel('Y Position (m)', 'FontSize',14);
%zlabel('Y Position (m)', 'FontSize',14);
htitle = title('KTH Car (t = 0.00s)','FontSize',12);
%view(180,0);
%legend(herr, nm.getNodeNames());
drawnow;

%% Replay data and run EKF
% analysis stop time
%t_stop = 200;
t_stop = 35;
% state, time, and transformed position history
%s_history = [];
p_history = [];
%cov_history = [];
% pDKAL_history =[];
% P_big_history = [];
t_history = [];
timeUpdateFlag_history = [];
% DiffFlag_history = [];
% MeasFlag_history = [];

nm.skipTime(7);
% last global time update
meas1 = nm.getNextMeasurement();
t_start = meas1.getTime();
t_last = t_start;
k = 0;


% plotting
plot_delay = 0*0.100; % sec
plot_last = t_start;

tlast_twr = 0;
period_twr = 5.00;


MOBILEID = 1;



stepsReach = 2;
for i =1:stepsReach
  h_reach(i) = plotZono(zonotope([zeros(2,1),0.1*diag(ones(2,1))]),[1,2],'r');
end

h_logic = plotZono(zonotope([zeros(2,1),0.1*diag(ones(2,1))]),[1,2],'k');

plotZonotime = t_start;
R_history = {};
R_history_index=1;
while (t_last - t_start) < t_stop
    k = k + 1;
    
    % get next measurement object
    for i=1:DRA.dataStep
    meas = nm.getNextMeasurement();
    end
    if isempty(meas)
        break;
    end
    walltime = meas.getTime();
    z = meas.vectorize(); 
    

       
    % delta-time uses wallclock (desktop timestamp) for now
    dt_ref = meas.getTime() - t_last;
    t_last = walltime;
    t_history = [t_history; walltime];



    
    if walltime - plot_last >= plot_delay
        plot_last = walltime;
        % update rigid bodies
        %for i=1:length(rigid_bodies)
%             rb = rigid_bodies(i);
%             [xy, latency] = nm.dataparser.getMocapPos(rb, walltime);
           % if latency < 0.250
                set(hrigidbodies(1), 'XData', z(1), 'YData',  z(2));
           % end
       % end


        % update plot title
        tstr = sprintf('CAR Reachable sets (t = %.2fs)', (t_last - t_start));
        set(htitle, 'String', tstr);
        drawnow;
    end
    if walltime >= plotZonotime + DRA.timeStepDataIn*stepsReach
           loc = [z(1) z(1)+0.05 z(1)     z(1)+0.05 z(1)-0.05 z(1)      z(1)-0.05     ; ...
                  z(2) z(2)     z(2)+0.05 z(2)+0.05 z(2)      z(2)-0.05 z(2)-0.05];
    
           R_logic=DRA.reachLogic(loc,stepsReach);
           locations=DRA.getPoints(R_logic);
           ZLoc = zonotope.enclosePoints([locations]);
           updatePlotZono(h_logic,ZLoc);
            
           R_data=DRA.reachDataLip(zonotope([z(1);z(2)]),stepsReach);
           for ii =1:stepsReach
               updatePlotZono(h_reach(ii),R_data{ii},[1,2],'r');
               
               R_history{R_history_index}=R_data{ii};
               R_history_index=R_history_index+1;
           end
           plotZonotime = walltime;
           
    end
    % append state estimate & measurement to history
   % s_history = [s_history; s'];
    p_history = [p_history; z(1) z(2)];

    %fprintf('t = %.2f / %.2f \n', meas.getTime()-meas1.getTime(), t_stop);
    
    if SAVEMOVIE
        f = getframe(fig);
        writeVideo(vidObj,f);
    end

    %pause();
end

if SAVEMOVIE
    close(vidObj);
end

% save data
figure; hold on
plot(p_history(:,1),p_history(:,2))
for i=1:7:length(R_history)
   plot( R_history{i},[1 2],'r');
end

%saveName ='cache/temp';
%save(saveName,'nm','DRA', 'k', 'p_history', 'R_history');






