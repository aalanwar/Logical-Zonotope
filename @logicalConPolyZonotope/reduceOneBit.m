function Zred = reduceOneBit(Z)
% reduce - Reduces the number of generators of a logical zonotope
%
% Syntax:
%    Zred = reduce(Z)
%
% Inputs:
%    Z - zonotope object
%
% Outputs:
%    Zred - reduced zonotope
%
% Example:
%
%
% See also: none

% Author:        Amr Alanwar
% Written:       16-October-2022
% Last update:   16-October-2022
%                
% Last revision: ---

%------------- BEGIN CODE --------------
Zred = Z;
%2 inputs
if size(Z.c,1) ==1
    Z=rmZeroGens(Z);
    pts=evaluate(Z);
    if isequal(pts,[0 1])
        %Zono=logicalZonotope.enclosePoints([0,1]);
        Zred=logicalPolyZonotope(0,{1},[1],Z.id);
    elseif isequal(pts,1)
        %Zono=logicalZonotope.enclosePoints(1);
        Zred=logicalPolyZonotope(1,{},{},[]);
    elseif isequal(pts,0)
        %Zono=logicalZonotope.enclosePoints(0);
        Zred=logicalPolyZonotope(0,{},{},[]);
    end
end

end
%------------- END OF CODE --------------
