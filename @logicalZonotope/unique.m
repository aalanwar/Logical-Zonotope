function Z = unique(Z1)
% and - overloads & operator, computes the nor of two logical zonotopes
%
% Syntax:  
%    Z = nor(Z1,Z2)
%
% Inputs:
%    Z1 - zonotope
%    Z2 - zonotope, 
%
% Outputs:
%    Z - zonotope object enclosing the and zonotope 
%
% Example: 
%    zono1 = zonotope([4 2 2;1 2 0]);
%    zono2 = zonotope([3 1 -1 1;3 1 2 0]);
%
%    res = nor(zono1,zono2)
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

%------------- BEGIN CODE --------------

newGen = {};
for i = 1:length(Z1.G)
    newGen{i} = unique(Z1.G{i}','rows')';
end

if length(Z1.G) >1
    rednewGen ={};
    index = 1;
    for i = 1:length(Z1.G)
        flagRedun =0;
        for j = 1:length(rednewGen)
            if Z1.G{i} == rednewGen{j}
                flagRedun =1;
            end
        end
        if flagRedun ==0
            rednewGen{index} = Z1.G{i};
            index = index +1;
        end
    end
    newGen = rednewGen;
end

Z = logicalZonotope(Z1.c,newGen);
end

%------------- END OF CODE --------------