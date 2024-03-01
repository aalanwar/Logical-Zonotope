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
    %Z=rmZeroGens(Z);
    pts=evaluate(Z);
    if isequal(pts,[0 1])
        Zred =Z;
        % %Zono=logicalZonotope.enclosePoints([0,1]);
        % if length(Z.id)==1
        % %Zred=logicalPolyZonotope(0,{1},[1],Z.id);
        %  Zred= logicalPolyZonotope(Z.c,Z.G,Z.E,Z.id) ;
        % elseif length(Z.id)==2
        % %Zred=logicalPolyZonotope(0,{1,0},eye(2),Z.id);
        %  Zred= logicalPolyZonotope(Z.c,Z.G,Z.E,Z.id) ;
        % elseif length(Z.id)==3
        % %Zred=logicalPolyZonotope(0,{1,1,1},eye(3),Z.id);
        %  Zred= logicalPolyZonotope(Z.c,Z.G,Z.E,Z.id) ;
        % elseif length(Z.id)==4
        % %Zred=logicalPolyZonotope(0,{1,1,1.0},eye(4),Z.id);
        %  Zred= logicalPolyZonotope(Z.c,Z.G,Z.E,Z.id) ;
        % elseif length(Z.id)==5
        %  %Zred= logicalPolyZonotope(0,{1,1,1,0,0},eye(5),Z.id) ;
        %  Zred= logicalPolyZonotope(Z.c,Z.G,Z.E,Z.id) ;
        % elseif length(Z.id)==8
        %  Zred= logicalPolyZonotope(Z.c,Z.G,Z.E,Z.id) ;
        % else
        % Zred=logicalPolyZonotope(0,{1},[1],Z.id);
        % end
    elseif isequal(pts,1)
        %Zono=logicalZonotope.enclosePoints(1);
        Zred=logicalPolyZonotope(1,{},[],Z.id);
    elseif isequal(pts,0)
        %Zono=logicalZonotope.enclosePoints(0);
        Zred=logicalPolyZonotope(0,{},[],Z.id);
    end
end

end
%------------- END OF CODE --------------
