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
%    zono1 = zonotope.generateRandom(2);
%    zono2 = zonotope.generateRandom(3);
%
%    zono = cartProd(zono1,zono2);
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      18-May-2011
% Last update:  27-Aug-2019
%               05-May-2020 (MW, standardized error message)
% Last revision:---

%------------- BEGIN CODE --------------

% first or second set is zonotope

    
if(~isempty(Z1.c) & ~isempty(Z2.c))
    newCen = [ Z1.c;Z2.c ];
elseif (isempty(Z1.c) & isempty(Z2.c))
    newCen =[];
elseif isempty(Z1.c)
    newCen = Z2.c ;
elseif isempty(Z2.c)
    newCen = Z1.c ;
end

if(isempty(Z1.G))
    newGen = Z2.G;
elseif(isempty(Z2.G))
    newGen = Z1.G;
elseif(isempty(Z2.G) & isempty(Z2.G))
    newGen ={};
elseif(~isempty(Z2.G) & ~isempty(Z2.G))
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
end

Z=logicalZonotope(newCen,newGen);
Z =unique(Z);

end
    


%------------- END OF CODE --------------