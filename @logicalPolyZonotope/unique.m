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
%independent generators
gMatI = cell2mat(Z1.GI);
gMatI = unique(gMatI','rows')';
newGenI = mat2cell( gMatI ,size(gMatI,1),ones(1,size(gMatI,2)) );


% %dep generators
% gMat = cell2mat(Z1.G);
% [gMat,indexgMat,~] = unique(gMat','rows');
% [newE,indexE,~] = unique(Z1.E','rows');
% gMat = gMat';
% newE = newE';
% newGen = mat2cell( gMat ,size(gMat,1),ones(1,size(gMat,2)) );



%if isequal(indexgMat,indexE)
%    Z = logicalPolyZonotope(Z1.c,newGenI,newGen,newE);
%else
    Z = logicalPolyZonotope(Z1.c,newGenI,Z1.G,Z1.E);    
%end

if size(Z1.c,1) ==1
    Z=rmZeroGens(Z);
    pts=evaluate(Z);
    if isequal(pts,[0 1])
        %Zono=logicalZonotope.enclosePoints([0,1]);
        Z=logicalPolyZonotope(0,{1},{},[]);
    elseif isequal(pts,1)
        %Zono=logicalZonotope.enclosePoints(1);
        Z=logicalPolyZonotope(1,{},{},[]);
    elseif isequal(pts,0)
        %Zono=logicalZonotope.enclosePoints(0);
        Z=logicalPolyZonotope(0,{},{},[]);
    end
end

end

%------------- END OF CODE --------------