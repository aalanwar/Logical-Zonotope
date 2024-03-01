function Z = exactNand(Z1,Z2)
% nand - computes the nand of two logical zonotopes
%
% Syntax:  
%    Z = nand(Z1,Z2)
%
% Inputs:
%    Z1 - zonotope
%    Z2 - zonotope, 
%
% Outputs:
%    Z - zonotope object enclosing the nand zonotope 
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


Z=not(exactAnd(Z1,Z2));
%Z =unique(Z);
end

%------------- END OF CODE --------------