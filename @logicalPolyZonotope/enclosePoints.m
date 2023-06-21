function Z = enclosePoints(points,varargin)
% enclosePoints - enclose a point cloud with a zonotope
%
% Syntax:  
%    Z = enclosePoints(points)
%
% Inputs:
%    points - matrix storing point cloud (dimension: [n,p] for p points)
%
% Outputs:
%    Z - logical zonotope object
%
% Example: 
%
% References:
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author:        Amr Alanwar
% Written:       11-Aug-2020
% Last update:   ---
% Last revision: ---

%------------- BEGIN CODE --------------

lZ=logicalZonotope.enclosePoints(points);
Z=logicalPolyZonotope(lZ.c,lZ.G,{},[]);


end