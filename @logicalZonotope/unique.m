function Z = unique(Z1)
% unique - remove redundant generators
%
% Syntax:  
%    Z = unique(Z1)
%
% Inputs:
%    Z1 - logical zonotope
% Outputs:
%    Z - logical zonotope with removed redundant generators
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
% Last update:   16-October-2022 (optimize)
%                
%                
% Last revision: ---

%------------- BEGIN CODE --------------


gMat = cell2mat(Z1.G);
gMat = unique(gMat','rows')';

newGen = mat2cell( gMat ,size(gMat,1),ones(1,size(gMat,2)) );

Z = logicalZonotope(Z1.c,newGen);
end

%------------- END OF CODE --------------