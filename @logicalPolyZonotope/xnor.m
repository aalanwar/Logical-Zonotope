function Z = xnor(Z1,Z2)
% xnor - computes the xnor of two zonotopes
%
% Syntax:  
%    Z = xnor(Z1,Z2)
%
% Inputs:
%    Z1 - zonotope
%    Z2 - zonotope, 
%
% Outputs:
%    Z - zonotope object enclosing the xnor zonotope 
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:        Amr Alanwar
% Written:       16-October-2022
% Last update:   16-October-2022
%                
%                
% Last revision: ---

%------------- BEGIN CODE --------------
if ~isa(Z1,'logicalPolyZonotope') 
Z1=logicalPolyZonotope.enclosePoints(Z1);
end

if ~isa(Z2,'logicalPolyZonotope') 
Z2=logicalPolyZonotope.enclosePoints(Z2);
end

Z = not(xor(Z1,Z2));
%Z =unique(Z);
end

%------------- END OF CODE --------------