function pZ = project(Z,proj)
% project - Returns a logical PolyZonotope which is projected onto the specified
%    dimensions
%
% Syntax:  
%    Z = project(Z,dim)
%
% Inputs:
%    Z - zonotope object
%    proj - projected dimensions
%
% Outputs:
%    Z - projected zonotope
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Amr Alanwar
% Written:      7-Jan-2023
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

cen = Z.c(proj,:);

newG ={};
for i =1:length(Z.G)
    newG{i}=Z.G{i}(proj,:);
end


pZ =logicalPolyZonotope(cen,newG,Z.E);
end

%------------- END OF CODE --------------