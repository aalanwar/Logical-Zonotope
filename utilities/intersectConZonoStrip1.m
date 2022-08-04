function [zResult]=intersectConZonoStrip1(z,hl,rl,yl,varargin)
% intersectZonoStrip : computes the intersection between one constrained zonotope and list of strips 
% one strip is defined as | hx-y | <= r
%
% Syntax:  
%    res_conzonotope=intersectConZonoStrip(z1,hl,rl,yl)
%
% Inputs:
%    z  - intial constrained zonotope
%    hl - list of measurement functions
%    rl - list of r values
%    yl - list of y values
%
% Outputs:
%    zResult - constrained zonotope object
%
%
%% example with three strips and one constrained zonotope:
%    hl{1} = [1 0];
%    Rl{1} = 5;
%    yl{1} = -2;
% 
%    hl{2} = [0 1];
%    Rl{2} = 3;
%    yl{2} = 2;
% 
%    hl{3} = [1 1];
%    Rl{3} = 3;
%    yl{3} = 2;
% 
%    Z = [0 3 0 1;0 0 2 1];
%    A = [1 0 1];
%    b = 1;
%    z = conZonotope(Z,A,b);
%    zResult = intersectConZonoStrip(z,hl,Rl,yl);
%
%%just for plotting strips
%    poly = mptPolytope([1 0;-1 0; 0 1;0 -1; 1 1;-1 -1],[3;7;5;1;5;1]);
%    figure; hold on 
%    plot(z,[1 2],'r-+');
%    plot(poly,[1 2],'r-*');
%    plot(zResult,[1 2],'b-*');
%
%    legend('zonotope','strips','czonoStrips');
%
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none
%
% Author: Amr Alanwar
% Written: 9-Mar-2020
% Last update: ---
%              
% Last revision: ---

%------------- BEGIN CODE --------------

if nargin==4
    %free parameter as multiple zonotopes Z can contain the constrained
    %zonotope
    lambda = zeros(length(z.center),length(rl));
end

%prepare center
c_new=z.Z(:,1);
for i=1:length( rl)
    c_new = c_new + lambda(:,i)*( yl{i} - hl{i}*z.Z(:,1) );
end

%prepare generators
part1 = eye(length(z.Z(:,1)));
if isempty(z.A)
    A_new =[];
    b_new =[];
else
    A_new = [ z.A zeros(size(z.A,1),length( rl))];
    b_new = z.b;
end

for ii=1:length(rl)
    part1 = part1 - lambda(:,ii)*hl{ii};
    part2(:,ii) = rl{ii}*lambda(:,ii);
    A_new = [A_new ; hl{ii}*z.Z(:,2:end) , zeros(1,ii-1),-rl{ii},zeros(1,length(rl)-ii)];
    b_new = [b_new; yl{ii}-(hl{ii}*z.Z(:,1))];
end
part1 = part1 * z.Z(:,2:end);
H_new = [part1 part2];

zResult = conZonotope([c_new H_new],A_new,b_new);





end
