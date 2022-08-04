clear all
close all

%initial set
R0 = zonotope([[2;2],diag([0.5;0.5]),[2 3 ; -2 1]]);
% has no effect if the h does not have u
options.U = zonotope([1 1;4 2]);

options.p.u = center(options.U) ;%+ options.uTrans;
%linearization point p.x and p.y
options.p.x = center(R0);

% dimension of x
options.dim_x=2;
options.dim_f=1;
options.method='svd';%'svd';%'radius';%'normGen';
options.reductionTechnique = 'girard';

% Reachability Settings 
options.zonotopeOrder = 100;
options.tensorOrder = 1;
 options.errorOrder =100;
%options.lagrangeRem.method='interval';
%options.lagrangeRem.simplify = 2;
%options.lagrangeRem=8;
%options.lagrangeRem.method='interval';

% System Dynamics  
dt = 0.05; %not used
options.fun = @(x,u) hNonLinear(x,u);




% define system 
hDisc = nonlinearDT('stirredTankReactor',options.fun,dt,2,2,1);
a =1;
[Rout]= intersectNonLinearH(hDisc,a,R0,options);

%intR0 = interval(R0);
%positX = conZonotope(interval([0;intR0.inf(2)],intR0.sup));
fimplicit(@(x1,x2) abs(hNonLinear([x1,x2],0))-a,'-.*c')
%fplot(@(x1,x2) abs(hNonLinear([x1,x2],0))-a,'-.*c');
%fimplicit(@(x1,x2) x1.^2 + x2.^2 - 3,'-.*c')
hold on
plot(R0,[1 2],'r');
plot(Rout,[1 2],'k');
%plot(positX&conZonotope(Rout),[1 2],'b-+');