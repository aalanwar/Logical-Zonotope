function res = isempty(obj)
% is_empty - returns 1 if a zonotope is empty and 0 otherwise
%
% Syntax:  
%    res = is_empty(obj)
%
% Inputs:
%    obj - zonotope object
%
% Outputs:
%    res - result in {0,1}
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: ---

% Author:       Amr Alanwar
% Written:      12-August-2022
% Last update:  
% Last revision:---

%------------- BEGIN CODE --------------

res = isempty(obj.c) && isempty(obj.G);

%------------- END OF CODE --------------