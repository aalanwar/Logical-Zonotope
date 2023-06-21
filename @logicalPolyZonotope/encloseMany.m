function [Zenclose] = encloseMany(Z)
% encloseMany - function for the enclosure of many zonotopes
%
% Syntax:  
%    [Zenclose,rotMatrixInv] = encloseMany(Z,direction)
%
% Inputs:
%    Z - cell array of zonotopes to be enclosed
%
% Outputs:
%    Zenclose - enclosing zonotope 
%   
%
% Example: 
%
% Other m-files required: 
% Subfunctions: none
% MAT-files required: none
%
% See also: dirPolytope

% Author:       Amr Alanwar
% Written:      21-August-2022
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------
resp= [];
for i=1:length(Z)
resp= [resp, evaluate(Z{i})];
end
Zenclose = logicalZonotope.enclosePoints(resp);



    
%------------- END OF CODE --------------