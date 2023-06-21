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


newG = Z1.GI;
startIdx = length(Z1.GI);

for i =1:length(Z1.G)
    newG{i+startIdx} = Z1.G{i};
end
if isempty(Z1.E)
    newE = eye(size(Z1.GI,2));
elseif isempty(Z1.GI)
    newE =  Z1.E;
else
    newE = blkdiag(eye(size(Z1.GI,2)),Z1.E);
end

if ~isempty(newG)
    numOfalphas = size(newE,1);%size( newG,2 );
    numOfGens= size( newG,2 );
    L=2^numOfalphas;
    for i=1:L
        table = de2bi(i-1,numOfalphas,'left-msb');

        multAlpha = 1;
        for iErow = 1:size(newE,1)
            multAlpha = multAlpha & (table(1,iErow)^newE(iErow,1) );
        end

        onePoint=[ multAlpha&newG{1}];
        for j=2:numOfGens
            multAlpha = 1;
            for iErow = 1:size(newE,1)
                multAlpha = multAlpha & (table(1,iErow)^newE(iErow,j) );
            end

            onePoint =xor( onePoint, (multAlpha&newG{j}) );
        end
        if ~isempty(Z1.c)
            points = [ points xor(Z1.c,onePoint)];
        else
            points = [ points onePoint];
        end

        if mod(i,1000)==0
            points=unique(points','rows')';
        end
    end

    points=unique(points','rows')';
else
    points=Z1.c;
end


% 
% 
% numOfgenI = length( Z1.GI );
% L=2^numOfgen;
% 
% %T = zeros(L,N);
% for i=1:L
% 
%    table = de2bi(i-1,numOfgen,'left-msb');
% 
%     onePoint=[ table(1,1)&Z1.G{1}];
%     for j=2:numOfgen
%         onePoint =xor( onePoint, (table(1,j)&Z1.G{j}) );
%     end
%     if ~isempty(Z1.c)
%         points = [ points xor(Z1.c,onePoint)];
%     else
%         points = [ points onePoint];
%     end   
% end


% else
% points = Z1.c;
% end



%end

% function genBeta = computeGenBeta ()
% 
% end

%------------- END OF CODE --------------