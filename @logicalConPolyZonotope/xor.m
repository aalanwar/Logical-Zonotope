function Z = xor(Z1,Z2,varargin)
% and - overloads & operator, computes the intersection of two zonotopes
%
% Syntax:  
%    Z = xor(Z1,Z2)
%
% Inputs:
%    Z1 - logicalPolyzonotope
%    Z2 - logicalPolyzonotope, 
%
% Outputs:
%    Z - zonotope object enclosing the and zonotope 
%
% Example: 
%    zono1 = zonotope([4 2 2;1 2 0]);
%    zono2 = zonotope([3 1 -1 1;3 1 2 0]);
%
%    res = zono1 & zono2
%
%    figure
%    hold on
%    plot(zono1,[1,2],'r');
%    plot(zono2,[1,2],'b');
%    plot(res,[1,2],'g');
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:        Amr Alanwar
% Written:       8-Sept-2022
% Last update:   
%                
%                
% Last revision: ---

%HAFEZ CHECK NIKLAS PAPER CONSTRAINED POL ZONOTOPE XOR IS MINKOWSKI SUM
% FUNCTION EVALUATE FOR LOOP CONSTRAIN in eval.m

%------------- BEGIN CODE --------------
if ~isa(Z1,'logicalConPolyZonotope')
    Z1=logicalZonotope.enclosePoints(Z1);
    Z1=logicalConPolyZonotope(Z1.c,Z1.G,eye(length(Z1.G)));
end

if ~isa(Z2,'logicalConPolyZonotope')
    Z2=logicalZonotope.enclosePoints(Z2);
    Z2=logicalConPolyZonotope(Z2.c,Z2.G,eye(length(Z2.G)));
end


if(~isempty(Z1.c) && ~isempty(Z2.c))
    newCen = xor( Z1.c,Z2.c );
elseif (isempty(Z1.c) && isempty(Z2.c))
    newCen =[];
elseif isempty(Z1.c)
    newCen = Z2.c ;
elseif isempty(Z2.c)
    newCen = Z1.c ;
end

if(isempty(Z1.G))
    newGen = Z2.G;
    newE = Z2.E;
elseif(isempty(Z2.G))
    newGen = Z1.G;
    newE = Z1.E;
elseif(isempty(Z1.G) && isempty(Z2.G))
    newGen ={};
    newE = [];
elseif(~isempty(Z1.G) && ~isempty(Z2.G))
    g1Len = length(Z1.G);
    g2Len = length(Z2.G);
    newGen = Z1.G;
    index =1;
    for i=g1Len+1:g1Len+g2Len
        newGen{i} =  Z2.G{index};
        index = index +1;
    end
    newE = blkdiag(Z1.E,Z2.E);


end

cPZ = updateConstraints(Z1,Z1,Z2);% summation of constrains

if isempty(Z1.id)
    newId =  Z2.id;
else
    newId = [Z1.id;max(Z1.id) + Z2.id];
end

Z = logicalConPolyZonotope(newCen,newGen,newE,cPZ.A,cPZ.b,cPZ.EC,newId);
%Z = unique(Z);

end

%------------- END OF CODE --------------