function Z = enclosePoints(points,varargin)
% enclosePoints - enclose a point cloud with a zonotope
%
% Syntax:  
%    Z = enclosePoints(points)
%
% Inputs:
%    points - matrix storing point cloud (dimension: [n,p] for p points)
%
% Outputs:
%    Z - logical zonotope object
%
% Example: 
%
% References:
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author:        Amr Alanwar
% Written:       11-Aug-2020
% Last update:   ---
% Last revision: ---

%------------- BEGIN CODE --------------

points=unique(points','rows')';
[dim,numOfPoints] = size(points);
cen = points(:,1);
if numOfPoints > 1
    containsZeroFlag=0;
    newPoints = [];
    for i =1:numOfPoints
        if points(:,i) == zeros(dim,1)
            containsZeroFlag =1;
        else
            newPoints =[newPoints points(:,i)];
        end
    end
    
    if containsZeroFlag ==1
        cen = zeros(dim,1);
        for i =1:numOfPoints-1
            gen{i} =newPoints(:,i);
        end
    else
        index =1;
        for i =2:numOfPoints
            gen{index} = xor(cen,points(:,i));
            index = index +1;
        end
   end
    Z =logicalZonotope(cen,gen);
else
    Z =logicalZonotope(cen,{});
end
Z=unique(Z);

end

%------------- END OF CODE --------------