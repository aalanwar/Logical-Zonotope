

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
%other logs are ped02,ped03,ped04
logfolderRA = strcat('logs/',lognameRA,'/');
DRA= DataDrivenRA( logfolderRA );
ZepsFlag =1;
DRA.prepareUWLip(ZepsFlag,moreInputData);


%% Bootstrap the node positions and clock params before filter starts
% use first second of measurements to bootstrap node states

%

fig = figure('Renderer', 'painters', 'Position', [10 10 700 900]); grid on; hold on; %axis equal;
box on;

%% Save as movie
SAVEMOVIE = false;
if SAVEMOVIE
    vidObj = VideoWriter('video/thetaconst_new.avi');
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

xlim([Xdim{1}-2 Xdim{2}+2]);
ylim([Ydim{1}-2 Ydim{2}+2]);
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
t_stop = 37;
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

nm.skipTime(7);%7
% last global time update
meas1 = nm.getNextMeasurement();
t_start = meas1.getTime();
t_last = t_start;
k = 0;


% plotting
plot_delay = 0*0.100; % sec
plot_last  = t_start;

tlast_twr = 0;
period_twr = 5.00;


MOBILEID = 1;

%consider or not the theta constrain
DRA.thetaConstrain =0;

stepsReach = 2;
%for i =1:stepsReach
h_reachLip = plotZono(zonotope([zeros(2,1),0.1*diag(ones(2,1))]),[1,2],'black');
%end
h_reachInter = plotZono(zonotope([zeros(2,1),0.1*diag(ones(2,1))]),[1,2],'red','*');

legend([h_reachLip,h_reachInter],'Original Set','Constrained Set','AutoUpdate','off')
ax = gca;
ax.FontSize = 20;
%set(gcf, 'Position',  [50, 50, 800, 400])

plotZonotime = t_start;
R_history = {};
R_history_index=1;
while t_last  < t_stop
    k = k + 1;
    
    % get next measurement object
    meas = nm.getNextMeasurement();
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
        tstr = sprintf('CAR Reachable Sets (t = %.2fs)', (t_last ));
        set(htitle, 'String', tstr);
        drawnow;
    end
    if walltime >= plotZonotime + DRA.timeStepDataIn*stepsReach
           R_dataLip=DRA.reachDataLip(zonotope([z(1);z(2)]),stepsReach);
           R_dataInter=DRA.reachHlinearCZ(R_dataLip{2},t_last,z(1),z(2),z(4));
           %for ii =1:stepsReach
               
               updatePlotZono(h_reachLip,R_dataLip{2},[1,2],'k*-');
               %plot(R_dataInter,[1,2],'r*-');
               updatePlotZono(h_reachInter,R_dataInter,[1,2],'r*-');
               
               R_history_lip{R_history_index}=R_dataLip{2};
               R_history_Inter{R_history_index}=R_dataInter;
               volume_history_lip{R_history_index}=volume(R_dataLip{2});
               volume_history_Inter{R_history_index}=volume(mptPolytope(R_dataInter));
               R_history_index=R_history_index+1;
          % end
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
figure('Renderer', 'painters', 'Position', [10 10 700 900]); 

box on; hold on
trajHandle=plot(p_history(2:end-1,1),p_history(2:end-1,2),'b-','LineWidth',2);
for i=1:20:length(R_history_lip)
 reachHandle=  plot( R_history_lip{i},[1 2],'r');
end
axis equal
% label plot
xlabel(['x_{',num2str(1),'}']);
ylabel(['x_{',num2str(2),'}']);
axis equal
%axis(axx{plotRun});
% skip warning for extra legend entries
warOrig = warning; warning('off','all');
legend([trajHandle,reachHandle],...
    'Trajectory', 'Set from data $\hat{\mathcal{R}}_k$','Location','northwest','Interpreter','latex');
warning(warOrig);
ax = gca;
ax.FontSize = 21;
%set(gcf, 'Position',  [50, 50, 800, 400])
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3)-0.01;
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

figure('Renderer', 'painters', 'Position', [10 10 700 900]); hold on
box on;
trajHandle=plot(p_history(2:end-1,1),p_history(2:end-1,2),'b-','LineWidth',2);
for i=1:10:length(R_history_Inter)
   reachHandle=plotCZono(R_history_Inter{i});
end
% label plot
xlabel(['x_{',num2str(1),'}']);
ylabel(['x_{',num2str(2),'}']);
axis equal
%axis(axx{plotRun});
% skip warning for extra legend entries
warOrig = warning; warning('off','all');
legend([trajHandle,reachHandle],...
    'Trajectory', 'Set from data $\bar{\mathcal{R}}_k$','Location','northwest','Interpreter','latex');
warning(warOrig);
ax = gca;
ax.FontSize = 21;
%set(gcf, 'Position',  [50, 50, 800, 400])
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3)-0.01;
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];
%saveName ='cache/temp';
%save(saveName,'nm','DRA', 'k', 'p_history', 'R_history');






