h{1} = [1 0];
r{1} = 1.7175;
y{1}= 0.2825;
fimplicit(@(x11,x22) abs(h{1}*[x11;x22] - y{1})-r{1},'-.b')
h{2} = [0 1];
r{2} = 2.429;%1.504;
y{2}= 0.839;%0.839;
hparking= fimplicit(@(x11,x22) abs(h{2}*[x11;x22] - y{2})-r{2},'-.b');
% h{1} = [0 1];
% r{1} = 1;
% y{1}= -1.665;
% hstreet= fimplicit(@(x11,x22) abs(h{1}*[x11;x22] - y{1})-r{1},'-b');
% 
% 
% 
% h{3} = [1 0];
% r{3} = 1.3045;
% y{3}= -0.3225;
% fimplicit(@(x11,x22) abs(h{3}*[x11;x22] - y{3})-r{3},'-.b')
% h{4} = [0 1];
% r{4} = 0.453;%1.504;
% y{4} = -1.137;%0.839;
% fimplicit(@(x11,x22) abs(h{4}*[x11;x22] - y{4})-r{4},'-.b')




hLip=plot(R_dataLip{2},[1 2],'k-');
hInter=plot(R_dataInter,[1 2],'*r-','Template',256);
tstr = sprintf('');
set(htitle, 'String', tstr);
xlabel(['x_{',num2str(1),'}']);
ylabel(['x_{',num2str(2),'}']);
%
%axis(axx{plotRun});
% skip warning for extra legend entries
warOrig = warning; warning('off','all');
legend([hrigidbodies(1),hLip,hInter,hparking],...
    'SVEA vehicle','Set from data $\hat{\mathcal{Z}}_k$', 'Set from data $\bar{\mathcal{C}}_k$','Parking constraint','Location','northwest','Interpreter','latex');
  %  'SVEA vehicle','Set from data $\hat{\mathcal{Z}}_k$', 'Set from data $\bar{\mathcal{C}}_k$','Parking constraint','Street constraint','Location','northwest','Interpreter','latex');

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
