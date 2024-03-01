%classdef (InferiorClasses = {?intervalMatrix, ?matZonotope}) logicalZonotope
classdef logicalPolyZonotope
% zonotope - Object and Copy Constructor 
%
% Syntax:  
%    obj = zonotope(c,G)
%
% Inputs:
%    c - center vector
%    G - generator matrix
%    E - Exponent matrix
%    id - identifier for each factor (row vector)
%
% Outputs:
%    obj - generated polynoamil logical zonotope object
%
% Example: 
%   c= logical(0);
%   g{1} = logical(1);
%   id = [1];
%   E =[1];
%   pZ = logicalPolyZonotope(c,g,E,id);
%
% 
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: interval, polytope

% Author:       Amr Alanwar
% Written:      16-October-2022 
% Last update:  12-December-2023 remove indep generator 
%               
% Last revision: ---

%------------- BEGIN CODE --------------

properties (SetAccess = public, GetAccess = public)
    c = [];
    G   = {};
    E = [];
    id;     % identifier vector
end

methods

    function Obj = logicalPolyZonotope(varargin)

        Obj.c = varargin{1};
        Obj.G = varargin{2};
        Obj.E = varargin{3};

        % number of dependent factors
        if length(varargin)<4
            p = size(Obj.E,1);
            Obj.id = (1:p)'; % column vector
        else
            Obj.id = varargin{4};
        end

    end

end


methods (Static = true)
    %Z = generateRandom(varargin) % generate random zonotope
    Z = enclosePoints(points,varargin) % enclose point cloud with zonotope
    Z = encloseMany(Zcell)
end


end
%------------- END OF CODE --------------