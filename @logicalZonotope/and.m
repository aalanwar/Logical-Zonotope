function Z = and(Z1,Z2,varargin)
% and - overloads & operator, computes the AND of two logical zonotopes
%
% Syntax:
%    Z = and(Z1,Z2)
%
% Inputs:
%    Z1 - zonotope
%    Z2 - zonotope,
%
% Outputs:
%    Z - zonotope object enclosing the and zonotope
%
% Example:
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:        Amr Alanwar
% Written:       8-Aug-2022
% Last update:
%
%
% Last revision: ---

%------------- BEGIN CODE --------------

if ~isa(Z1,'logicalZonotope') 
Z1=logicalZonotope.enclosePoints(Z1);
end

if ~isa(Z2,'logicalZonotope') 
Z2=logicalZonotope.enclosePoints(Z2);

end

if(~isempty(Z1.c) & ~isempty(Z2.c))
newcen = (Z1.c & Z2.c);
else
newcen =[];
end

if(~isempty(Z1.G) & ~isempty(Z2.G))
    %c2 * G1
    index =1;
    if(~isempty(Z2.c))
        for i=1:length(Z1.G)
            newGen{index} = (Z2.c & Z1.G{i});
            index=index+1;
        end
    end
    if(~isempty(Z1.c))
        for i=1:length(Z2.G)
            newGen{index} = (Z1.c & Z2.G{i});
            index=index+1;
        end
    end
    %G1 * G1
    for i=1:length(Z1.G)
        [rows,cols]=size(Z1.G{i});
        for k=1:length(Z2.G)
            newGen{index} = (Z1.G{i} & Z2.G{k});
            index=index+1;
        end
    end

    Z = logicalZonotope(newcen,newGen);
elseif(isempty(Z1.G) & isempty(Z2.G))
    Z = logicalZonotope(newcen,{});

elseif (isempty(Z2.G))
    %c2 * G1

    index =1;
    newGen ={};
    if(~isempty(Z2.c))
        for i=1:length(Z1.G)
            newGen{index} = (Z2.c & Z1.G{i});
            index=index+1;
        end
    end

    Z = logicalZonotope(newcen,newGen);
elseif (isempty(Z1.G))
    %c2 * G1
    newGen = Z2.G;

    index =length(newGen)+1;
    if(~isempty(Z1.c))
        for i=1:length(Z2.G)
            newGen{index} =  (Z1.c & Z2.G{i});
            index=index+1;
        end
    end

    newGen{index} = (Z2.c) ;


    Z = logicalZonotope(newcen,newGen);

end
Z = unique(Z);
end

%------------- END OF CODE --------------