function Z = not(Z1)
% and - overloads & operator, computes the intersection of two zonotopes
%
% Syntax:  
%    Z = not(Z1,Z2)
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
%    res = zono1 & zono2
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
if (~isempty(Z1.c))
[rows,cols] = size(Z1.c);
else
[rows,cols] = size(Z1.G{1});
end
Zone = logicalZonotope(ones(rows,1),[]);
Z = xor(Zone,Z1);
Z =unique(Z);
end

%------------- END OF CODE --------------