function Z = unique(Z1)
% and - overloads & operator, computes the nor of two logical zonotopes
%
% Syntax:  
%    Z = nor(Z1,Z2)
%
% Inputs:
%    Z1 - zonotope
%    Z2 - zonotope, 
%
% Outputs:
%    Z - zonotope object enclosing the and zonotope 
%
% Example: 
%    zono1 = zonotope([4 2 2;1 2 0]);
%    zono2 = zonotope([3 1 -1 1;3 1 2 0]);
%
%    res = nor(zono1,zono2)
%
%    figure
%    hold on
%    plot(zono1,[1,2],'r');
%    plot(zono2,[1,2],'b');
%    plot(res,[1,2],'g');
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:        Amr Alanwar
% Written:       8-Sept-2022
% Last update:   
%                
%                
% Last revision: ---

%------------- BEGIN CODE --------------

newGen = {};
for i = 1:length(Z1.G)
    newGen{i} = unique(Z1.G{i}','rows')';
end

Z = logicalZonotope(Z1.c,newGen);
end

%------------- END OF CODE --------------