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

if ~isempty(Z1.G)
numOfgen = length( Z1.G );



points = [];
%for o=1:numOfgen
%for k=1:numOfgen
    

table=truth_table(numOfgen);
[rowsTable,colsTable]=size(table);
for i =1:rowsTable

    % [rowsGen,colsGen]=size(gen1);
    onePoint=[ table(i,1)&Z1.G{1}];
    for j=2:numOfgen
        onePoint =xor( onePoint, (table(i,j)&Z1.G{j}) );
    end
    if ~isempty(Z1.c)
        points = [ points xor(Z1.c,onePoint)];
    else
        points = [ points onePoint];
    end
end
else
points = Z1.c;
end



% %for o=1:numOfgen
%     for k=1:numOfgen
%         gen1=Z1.G{k};
%         [rowsGen,colsGen]=size(gen1);
%         table=truth_table(colsGen);
%         [rowsTable,colsTable]=size(table);
%         for i =1:rowsTable
%             onePoint=[ table(i,1)&gen1(:,1)];
%             for j=2:colsGen
%                 onePoint =[ onePoint, (table(i,j)&gen1(:,j)) ];
%             end
%             points = [ points onePoint];
%         end
%         if k ==1
%             oldPoints = points;
%         elseif k ==numOfgen
%             points = xor(Z1.c,points);
%             oldPoints = points;
%         else
%             points = xor(oldPoints,points);
%             oldPoints = points;
%         end
%     end

%end

% cen = ;
% 
% operand = [ ];
% 
% 
% for i =1:numOfgen
%     points = [ points , norLogic(operand,0&gen1{i} )  , norLogic(operand , 1& gen1{i} )];
% end
points=unique(points','rows')';
end

%------------- END OF CODE --------------