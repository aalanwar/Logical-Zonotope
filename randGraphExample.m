clear all

close all


n_x = 800;
n_u = 100;
G = [];
for i =1:n_u
    G = [G round(rand(n_x))];
end

indexu=1;

numbOfInputs = [10 30 50];
numbOfstates =[10 100:100:600];
for ptu = numbOfInputs
    index=1;
    for pt =numbOfstates

        % number of points in x
        n_x_points = pt;
        pointx =[];
        for i =1 :n_x_points
            xx = zeros(n_x,1);
            xx(randi(n_x,1)) =1;
            pointx = [pointx xx];
        end
        logX= logicalZonotope.enclosePoints(pointx);

        % number of points in u
        n_u_points = ptu;
        pointu =[];
        for i =1 :n_u_points
            uu = zeros(n_u,1);
            uu(randi(n_u,1)) =1;
            pointu = [pointu uu];
        end
        logU= logicalZonotope.enclosePoints(pointu);       
        
        tic
        stateIter = [];
        for ii =1:length(pointx(1,:))
            for jj =1:length(pointu(1,:))
                stateIter = [ stateIter semiKron(semiKron(G,pointu(:,jj)),pointx(:,ii))];
            end    
        end
        execTimIter(indexu,index) = toc
        
        tic
        nextx2= semiKron(semiKron(G,logU),logX);
        execTim(indexu,index) = toc
        index = index +1;
    end
    indexu = indexu +1;
end


% plot reachable sets from data
figure('Renderer', 'painters', 'Position', [10 10 800 900])
hold on
box on
handleplot{1}=   plot(numbOfstates,execTim(1,:),'rx-');
handleplot{2}=   plot(numbOfstates,execTim(2,:),'b*-');
handleplot{3}=   plot(numbOfstates,execTim(3,:),'k+-');

% label plot
xlabel('Number of starting states $p_x$','Interpreter','latex');
ylabel('Execution time (sec)','Interpreter','latex');
%axis(axx{plotRun});
% skip warning for extra legend entries
warOrig = warning; warning('off','all');
legend([handleplot{1},handleplot{2},handleplot{3}],...
    '$p_u=10$','$p_u=30$','$p_u=50$','Location','northwest','Interpreter','latex');
warning(warOrig);
ax = gca;
ax.FontSize = 22;
%set(gcf, 'Position',  [50, 50, 800, 400])
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3)-0.01;
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];
