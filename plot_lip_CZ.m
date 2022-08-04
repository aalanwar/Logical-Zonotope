clear all
close all

parking =0;

if parking
load('cache\theta30CZ.mat')
%load('cache\parkingconst_CZ_v2.mat') 
plotStep =20;
else    
load('cache\roundCZ')
plotStep =10;
end
%%%%%%%%%%%%%%%%%%
average_volume_orig = mean(cell2mat(volume_history_lip))
average_volume_Inter = mean(cell2mat(volume_history_Inter))


% save data
figure('Renderer', 'painters', 'Position', [10 10 700 900]); hold on
%axis equal
box on;
if parking
    xlim([-4 6])
    ylim([-4 4])
else
    xlim([-3 3])
    ylim([-3 5])
end
trajHandle=plot(p_history(2:end,1),p_history(2:end,2),'b-','LineWidth',2);
for i=1:plotStep:length(R_history_lip)
  reachHandle= plot( R_history_lip{i},[1 2],'r');
end

% label plot
xlabel(['x_{',num2str(1),'}']);
ylabel(['x_{',num2str(2),'}']);
%axis equal
%axis(axx{plotRun});
% skip warning for extra legend entries
warOrig = warning; warning('off','all');
legend([trajHandle,reachHandle],...
    'Trajectory', 'Set from data $\hat{\mathcal{Z}}_k$','Location','northwest','Interpreter','latex');
warning(warOrig);
ax = gca;
ax.FontSize = 23;
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
%axis equal
box on;
%axis equal
if parking
    xlim([-4 6])
    ylim([-4 4])
else
    xlim([-3 3])
    ylim([-3 5])
end
trajHandle=plot(p_history(2:end,1),p_history(2:end,2),'b-','LineWidth',2);
for i=1:plotStep:length(R_history_Inter)
   reachHandle=plotCZono(R_history_Inter{i});
end
% label plot
xlabel(['x_{',num2str(1),'}']);
ylabel(['x_{',num2str(2),'}']);
%
%axis(axx{plotRun});
% skip warning for extra legend entries
warOrig = warning; warning('off','all');
legend([trajHandle,reachHandle],...
    'Trajectory', 'Set from data $\bar{\mathcal{C}}_k$','Location','northwest','Interpreter','latex');
warning(warOrig);
ax = gca;
ax.FontSize = 23;
%set(gcf, 'Position',  [50, 50, 800, 400])
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3)-0.01;
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];



