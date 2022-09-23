function points = evaluate(Z1)
% and - overloads & operator, computes the intersection of two zonotopes
%
% Syntax:  
%    Z = not(Z1,Z2)
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
points = [];
if ~isempty(Z1.G)
numOfgen = length( Z1.G );
L=2^numOfgen;
%T = zeros(L,N);
for i=1:L

   table = de2bi(i-1,numOfgen,'left-msb');

    onePoint=[ table(1,1)&Z1.G{1}];
    for j=2:numOfgen
        onePoint =xor( onePoint, (table(1,j)&Z1.G{j}) );
    end
    if ~isempty(Z1.c)
        points = [ points xor(Z1.c,onePoint)];
    else
        points = [ points onePoint];
    end   
end

%   pointB = dec2bin(i-1,numOfgen);
%    [rows,cols]=size(pointB);
%    row=[];
%    for j =1:cols
%        if j==cols
%            row=[ row, pointB(j)];
%        else
%            row=[ row, pointB(j), ' '];
%        end
%    end
%    table=str2num(row);


% points = [];
% %for o=1:numOfgen
% %for k=1:numOfgen
%     
% 
% table=truth_table(numOfgen);
% [rowsTable,colsTable]=size(table);
% for i =1:rowsTable
% 
%     % [rowsGen,colsGen]=size(gen1);
%     onePoint=[ table(i,1)&Z1.G{1}];
%     for j=2:numOfgen
%         onePoint =xor( onePoint, (table(i,j)&Z1.G{j}) );
%     end
%     if ~isempty(Z1.c)
%         points = [ points xor(Z1.c,onePoint)];
%     else
%         points = [ points onePoint];
%     end
% end
else
points = Z1.c;
end


points=unique(points','rows')';
end

% function genBeta = computeGenBeta ()
% 
% end

%------------- END OF CODE --------------