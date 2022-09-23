function res = containsPoint(Z,p,varargin)
% containsPoint - determines if the point p is inside the zonotope Z1
%
% Syntax:
%    res = containsPoint(Z,p)
%    res = containsPoint(Z,p,tolerance)
%
% Inputs:
%    Z - zonotope object
%    p - point specified as a vector
%    tolerance - numerical tolerance up to which the point is allowed to
%                outside the zonotope
%
% Outputs:
%    res - boolean whether the point is inside the zonotope or not
%
% Example:
%    Z = zonotope([1;0],[1 0; 0 1]);
%    p = [1;0];
%    res = containsPoint(Z,p);
%
%    plot(Z); hold on;
%    scatter(p(1),p(2),16,'r');
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: ---

% Author:       Niklas Kochdumper
% Written:      30-January-2018
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

% parse input arguments
points = [];
if ~isempty(Z.G)
    numOfgen = length( Z.G );
    L=2^numOfgen;
    %T = zeros(L,N);
    for i=1:L

        table = de2bi(i-1,numOfgen,'left-msb');

        onePoint=[ table(1,1)&Z.G{1}];
        
        for j=2:numOfgen
            onePoint =xor( onePoint, (table(1,j)&Z.G{j}) );
        end
            if ~isempty(Z.c)
                points = [ points xor(Z.c,onePoint)];
            else
                points = [ points onePoint];
            end


            if ismember(p',points','rows')
                res = true;
                return;
            end

        


    end

else
    points = Z.c;
end


points=unique(points','rows')';

if ismember(p',points','rows')
    res = true;
else
    res = false;
end

%------------- END OF CODE --------------
