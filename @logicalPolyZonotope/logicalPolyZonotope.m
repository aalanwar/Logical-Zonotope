%classdef (InferiorClasses = {?intervalMatrix, ?matZonotope}) logicalZonotope
classdef logicalPolyZonotope
% zonotope - Object and Copy Constructor 
%
% Syntax:  
%    obj = zonotope(c,G)
%    obj = zonotope(Z)
%
% Inputs:
%    c - center vector
%    G - generator matrix
%    Z - center vector and generator matrix Z = [c,G]
%
% Outputs:
%    obj - generated zonotope object
%
% Example: 
%    c = [1;1];
%    G = [1 1 1; 1 -1 0];
%    zono = zonotope(c,G);
%    plot(zono,[1,2],'r');
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: interval, polytope

% Author:       Amr Alanwar
% Written:      16-October-2022 
% Last update:  16-October-2022 
%               
% Last revision: ---

%------------- BEGIN CODE --------------

properties (SetAccess = protected, GetAccess = public)
    c = [];
    GI =  {};
    G   = {};
    E = [];

end

methods

    function Obj = logicalPolyZonotope(varargin)
        
                Obj.c = varargin{1};
                Obj.GI = varargin{2}; 
                Obj.G = varargin{3};
                Obj.E = varargin{4};

        end
        
    end


methods (Static = true)
    %Z = generateRandom(varargin) % generate random zonotope
    Z = enclosePoints(points,varargin) % enclose point cloud with zonotope
    Z = encloseMany(Zcell)
end


end
%------------- END OF CODE --------------