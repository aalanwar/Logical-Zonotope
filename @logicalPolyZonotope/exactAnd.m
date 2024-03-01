function Z = exactAnd(Z1,Z2,varargin)
% exactAnd - overloads & operator, computes the AND of two logical poly zonotopes
%
% Syntax:
%    Z = exactAnd(Z1,Z2)
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
% Written:       7-Jan-2023
% Last update:
%
%
% Last revision: ---

%------------- BEGIN CODE --------------

if ~isa(Z1,'logicalPolyZonotope')
    Z1=logicalZonotope.enclosePoints(Z1);
    Z1=logicalPolyZonotope(Z1.c,Z1.G,eye(length(Z1.G)));
end

if ~isa(Z2,'logicalPolyZonotope')
    Z2=logicalZonotope.enclosePoints(Z2);
    Z2=logicalPolyZonotope(Z2.c,Z2.G,eye(length(Z2.G)));
end

if(~isempty(Z1.c) && ~isempty(Z2.c))
    newcen = Z1.c & Z2.c;
end



h1=length(Z1.G);
p1=size(Z1.E,1);
h2=length(Z2.G);
p2=size(Z2.E,1);
zeroVec = logical(zeros(size(Z1.c)));
indexI =1;
newE =[];
index =1;
newGen ={};

% bring the exponent matrices to a common representation
[idCom,E1Com,E2Com] = mergeExpMatrix(Z1.id,Z2.id,Z1.E,Z2.E);


[rE1,cE1] = size(E1Com);
[rE2,cE2] = size(E2Com);

if rE1 >rE2
    E2ComZeros = [E2Com;zeros(rE1-rE2,cE2)];
    E1ComZeros = E1Com;
else
    E1ComZeros = [E1Com;zeros(rE2-rE1,cE1)];
    E2ComZeros = E2Com;
end

E1Com = E1ComZeros;
E2Com = E2ComZeros;





%c2 * G1
if(~isempty(Z2.c) && ~isempty(Z1.G))
    for i=1:length(Z1.G)
        vecAnd = Z2.c & Z1.G{i};
        if isequal(vecAnd,zeroVec)
            continue;
        end
        newGen{index} = vecAnd;
        newE = [newE E1Com(:,i)];
        index=index+1;
    end
end

%c1 * G2
if(~isempty(Z1.c) && ~isempty(Z2.G))
    for i=1:length(Z2.G)
        vecAnd = Z1.c & Z2.G{i};
        if isequal(vecAnd,zeroVec)
            continue;
        end
        newGen{index} = vecAnd;
        newE = [newE E2Com(:,i)];        
        index=index+1;
    end
end
%G1 * G2
if(~isempty(Z1.G) && ~isempty(Z2.G))
    for i=1:length(Z1.G)
        for k=1:length(Z2.G)
            vecAnd = (Z1.G{i} & Z2.G{k});
            if isequal(vecAnd,zeroVec)
                continue;
            end
            newGen{index} = vecAnd;
            tempECom=max([E1Com(:,i),E2Com(:,k)] ,[],2);
            newE = [newE tempECom]; 
            index=index+1;
        end
    end
end


% % and up all generators that belong to identical exponents+
if ~isempty(newGen)
    for i=1:length(newGen)
        newGenVec(:,i) = newGen{i};
    end

    [newE,newGenComVec] = removeRedundantExponents(newE,newGenVec);

    for i=1:size(newGenComVec,2)
        newGenComCell{i}= newGenComVec(:,i) ;
    end

    Z = logicalPolyZonotope(newcen,newGenComCell,newE,idCom);
else
    Z = logicalPolyZonotope(newcen,newGen,newE,idCom);
end
%Z = unique(Z);


end

%------------- END OF CODE --------------