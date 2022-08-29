function Zres = tensorMultiplication(Z,M)
% tensorMultiplication - computes \{M_{ijk...l}*x_j*x_k*...*x_l|x \in Z\}
% when the center of Z is the origin
%
% Syntax:  
%    Zres = tensorMultiplication(Z,M)
%
% Inputs:
%    Z - zonotope object
%    M - tensor
%
% Outputs:
%    Zres - zonotope object
%
% Example: 
%    ---
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Amr Alanwar
% Written:      19-Aug-2022
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------
% points = evaluate(Z);
% pM= kron(points,M);
% Zres = logicalZonotope.enclosePoints(pM);
% Zres = unique(Zres);


%points = evaluate(Z);
newc= kron(Z.c,M);
gen=[];
for i =1:length(Z.G)
    gen = [gen, Z.G{i}];
end
newGMat= kron(gen,M);
for i =1:length(newGMat(1,:))
    newGenCell{i} = newGMat(:,i);
end
Zres = logicalZonotope(newc,newGenCell);
Zres = unique(Zres);

%------------- END OF CODE --------------