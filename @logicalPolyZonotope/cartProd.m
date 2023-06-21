function Z = cartProd(Z1,Z2)
% cartProd - Returns the cartesian product of two zonotopes
%
% Syntax:  
%    Z = cartProd(Z1,Z2)
%
% Inputs:
%    Z1 - zonotope object
%    Z2 - zonotope object
%
% Outputs:
%    Z - zonotope object
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Amr Alanwar
% Written:      16-October-2022
% Last update:  
%               
% Last revision:---

%------------- BEGIN CODE --------------


    
if(~isempty(Z1.c) & ~isempty(Z2.c))
    newCen = [ Z1.c;Z2.c ];
elseif (isempty(Z1.c) & isempty(Z2.c))
    newCen =[];
elseif isempty(Z1.c)
    newCen = Z2.c ;
elseif isempty(Z2.c)
    newCen = Z1.c ;
end

if(isempty(Z1.GI))
    newGenI = Z2.GI;
elseif(isempty(Z2.GI))
    newGenI = Z1.GI;
elseif(isempty(Z1.GI) && isempty(Z2.GI))
    newGenI ={};
elseif(~isempty(Z1.GI) && ~isempty(Z2.GI))
    g1Len = length(Z1.GI);
    g2Len = length(Z2.GI);
    sizeOfGen1 = length(Z1.GI{1});
    sizeOfGen2 = length(Z2.GI{1});
    
    for i =1:g1Len
        newGenI{i} = [Z1.GI{i};zeros(sizeOfGen2,1)];
    end


    index =1;
    for i=g1Len+1:g1Len+g2Len
        newGenI{i} =  [zeros(sizeOfGen1,1);Z2.GI{index}];
        index = index +1;
    end
end

if(isempty(Z1.G))
    newGen = Z2.G;
    newE = Z2.E;
elseif(isempty(Z2.G))
    newGen = Z1.G;
    newE = Z1.E;
elseif(isempty(Z1.G) && isempty(Z2.G))
    newGen ={};
    newE=[];
elseif(~isempty(Z1.G) && ~isempty(Z2.G))
    g1Len = length(Z1.G);
    g2Len = length(Z2.G);
    sizeOfGen1 = length(Z1.G{1});
    sizeOfGen2 = length(Z2.G{1});
    
    for i =1:g1Len
        newGen{i} = [Z1.G{i};zeros(sizeOfGen2,1)];
    end

    index =1;
    for i=g1Len+1:g1Len+g2Len
        newGen{i} =  [zeros(sizeOfGen1,1);Z2.G{index}];
        index = index +1;
    end

    newE = blkdiag(Z1.E,Z2.E);
end

Z=logicalPolyZonotope(newCen,newGenI,newGen,newE);
Z =unique(Z);

end
    


%------------- END OF CODE --------------