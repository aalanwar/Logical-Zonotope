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
%    Z - zonotope object
%
% Example: 
%
% References:
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: interval, polytope

% Author:        Amr Alanwar
% Written:       11-Aug-2020
% Last update:   ---
% Last revision: ---

%------------- BEGIN CODE --------------
% [dim,numOfPoints] = size(points);
% cen = [];
% newpoints = [];
% for i = 1:numOfPoints
%     if zeros(dim,1) ==points(:,i)
%         cen =zeros(dim,1);
%     else
%         newpoints= [newpoints points(:,i)];
%     end
% end
% newpoints=unique(newpoints','rows')';
% 
% [row,cols] = size(newpoints);
% for i = 1:cols
%     gen{i} = newpoints(:,i);
% end

%points=unique(points','rows')';
% cen =zeros(dim,1);
% gen = {points};
points=unique(points','rows')';
[dim,numOfPoints] = size(points);

cen = points(:,1);
index =1;
for i =2:numOfPoints
    gen{index} = xor(cen,points(:,i));
    index = index +1;
end


Z =logicalZonotope(cen,gen);

end

%------------- END OF CODE --------------