function Z = not(Z1)
% and - overloads ~ operator, computes not of a logical zonotope
%
% Syntax:  
%    Z = not(Z1)
%
% Inputs:
%    Z1 - zonotope
%
% Outputs:
%    Z - zonotope object enclosing the and zonotope 
%
% Example: 
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
    Z = logicalZonotope(xor(ones(rows,1),Z1.c),Z1.G);
else
    [rows,cols] = size(Z1.G{1});
    Z = logicalZonotope(ones(rows,1),Z1.G);
end

%Z =unique(Z);
end

%------------- END OF CODE --------------