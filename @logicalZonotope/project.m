function pZ = project(Z,proj)
% project - Returns a logical zonotope which is projected onto the specified
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
% Written:      12-Aug-2022
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

cen = Z.c(proj,:);

newG ={};
for i =1:length(Z.G)
    newG{i}=Z.G{i}(proj,:);
end

pZ =logicalZonotope(cen,newG);
end

%------------- END OF CODE --------------