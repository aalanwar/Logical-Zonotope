function [Rout] = intersectNonLinearH(hDisc,a,Rinit,options)
%INTERSECTNONLINEARH Summary of this function goes here

% compute symbolic derivatives
derivatives(hDisc,options);
%linearization point p.u of the input is the center of the input u
p.u = center(options.U) ;%+ options.uTrans;

%linearization point p.x and p.y
x0 = center(Rinit);
p.x = x0;

%substitute p into the system equation in order to obtain the constant
%input
 f0 = options.fun(p.x, p.u);
% 
% options.jacobians = jacobian(options.fun,[x,u]);
% %get jacobian matrices
[A_lin,B_lin] = hDisc.jacobian(p.x, p.u);
% [A_lin] = options.jacobians(p.x, p.u);



% uTrans = f0; %B*Ucenter from linOptions.U not added as the system is linearized around center(U)
% Udelta = B_lin*(options.U+(-center(options.U)));
% U = Udelta + uTrans;

%save linearization point
%hDisc.linError.p=p;

%translate Rinit by linearization point
Rdelta = Rinit + (-p.x);
options.p = p;

% if options.tensorOrder > 2
%     Verror = linError_thirdOrder_DT(hDisc, options, Rdelta); 
% else
%     Verror = linError_mixed_noInt_DT(hDisc, options, Rdelta);   
% end
%Verror = linearizeOpt(hDisc, options, Rdelta);
Verror = linError_mixed_noInt_DT(hDisc, options, Rdelta);


% initialize lambda
lambda0=zeros(options.dim_x,options.dim_h);
optionsfmin = optimoptions(@fminunc,'Algorithm', 'quasi-newton','Display','off');
%find optimal lambda
lambda = fminunc(@fun,lambda0, optionsfmin);
% resulting zonotope
%Zres = zonotopeFromLambda(Z,R,h,y,lambda);
newCen = Rinit.Z(:,1) - lambda*f0 - lambda*A_lin*Rinit.Z(:,1) + lambda*A_lin*p.x - lambda*Verror.Z(:,1);
newGen = [(eye(options.dim_x)-lambda*A_lin)*Rinit.Z(:,2:end), lambda*a, - lambda*Verror.Z(:,2:end)];
%newCen = Rinit.Z(:,1) - lambda*f0 - lambda*A_lin*Rinit.Z(:,1) + lambda*A_lin*p.x ;
%newGen = [(eye(options.dim_x)-lambda*A_lin)*Rinit.Z(:,2:end),- lambda*a];

%Rout = zonotope(newCen,newGen)  +lambda*Verror ;

Rout = zonotope(newCen,newGen);



% embedded function to be minimized for optimal lambda
function nfro = fun(lambda)
newGen = [(eye(options.dim_x)-lambda*A_lin)*Rinit.Z(:,2:end), lambda*a, -lambda*Verror.Z(:,2:end) ];
%newGen = [(eye(options.dim_x)-lambda*A_lin)*Rinit.Z(:,2:end), -lambda*a];


if strcmp(options.method,'normGen')
    nfro = norm(newGen,'fro');
elseif strcmp(options.method,'svd')
    nfro = sum(svd(newGen));
elseif strcmp(options.method,'radius')
    nfro = radius(zonotope([zeros(options.dim_x,1) newGen]));  
elseif strcmp(options.method,'volume')
    nfro = volume(zonotope([zeros(options.dim_x,1) newGen]));
end

end
end