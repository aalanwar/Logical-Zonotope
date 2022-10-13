function Z = or(Z1,Z2)
% and - overloads & operator, computes the intersection of two zonotopes
%
% Syntax:  
%    Z = or(Z1,Z2)
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

%------------- BEGIN CODE --------------
if ~isa(Z1,'logicalZonotope') 
Z1=logicalZonotope.enclosePoints(Z1);
end

if ~isa(Z2,'logicalZonotope') 
Z2=logicalZonotope.enclosePoints(Z2);
end

[crows1,~] = size(Z1.c);
[crows2,~] = size(Z2.c);
Z1 = reduce(Z1);
Z2 = reduce(Z2);

done=0;
if ~isempty( Z1.G)
    [grows1,gcols1] = size(Z1.G{1});
   if (isequal(Z1.c,zeros(crows1,1)) && isequal(Z1.G{1},zeros(grows1,gcols1) ))
        Z = Z2;
        done =1;
   elseif (isempty(Z1.c) && isequal(Z1.G{1},zeros(grows1,gcols1) ) )
        Z = Z2;
        done =1;
   end
end
if ~isempty( Z2.G)
    [grows2,gcols2] = size(Z2.G{1});
    if (isequal(Z2.c,zeros(crows2,1)) && isequal(Z2.G{1},zeros(grows2,gcols2) ))
        Z = Z1;
        done =1;
    elseif (isempty(Z2.c) && isequal(Z2.G{1},zeros(grows2,gcols2) ) )
        Z = Z1;
        done =1;
    end    
end



if ~done
    Z = nand(nand(Z1,Z1),nand(Z2,Z2));
end
Z =unique(Z);
end

%------------- END OF CODE --------------