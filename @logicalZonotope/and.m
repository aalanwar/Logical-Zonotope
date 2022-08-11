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
newcen = Z1.c & Z2.c;

if(~isempty(Z1.G) & ~isempty(Z2.G))
    %c2 * G1
    index =1;
    for i=1:length(Z1.G)
        newGen{index} = Z2.c & Z1.G{i};
        index=index+1;
    end

    for i=1:length(Z2.G)
        newGen{index} = Z1.c & Z2.G{i};
        index=index+1;
    end

    %G1 * G1
    for i=1:length(Z1.G)
        [rows,cols]=size(Z1.G{i});
        for k=1:length(Z2.G)
            Gcon=[];
            for j=1:cols
                gZ1 = Z1.G{i}(:,j);
                Gcon = [Gcon  (gZ1 & Z2.G{k})];
            end
            newGen{index} = Gcon;
            index=index+1;
        end
    end

    Z = logicalZonotope(newcen,newGen);
elseif (~isempty(Z1.G))
    %c2 * G1

    index =1;
    for i=1:length(Z1.G)
        newGen{index} = Z2.c & Z1.G{i};
        index=index+1;
    end


    Z = logicalZonotope(newcen,newGen);
elseif (~isempty(Z2.G))
    %c2 * G1
    newGen = Z2.G;

    index =length(newGen)+1;
    for i=1:length(Z2.G)
        newGen{index} = Z1.c & Z2.G{i};
        index=index+1;
    end


    newGen{index} = Z2.c ;


    Z = logicalZonotope(newcen,newGen);
elseif(isempty(Z1.G) & isempty(Z2.G))
    Z = logicalZonotope(newcen,{});
end

Z = unique(Z);
end

%------------- END OF CODE --------------