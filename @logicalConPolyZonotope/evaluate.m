function points = evaluate(Z1)
% evaluate - computes the points inside Z1
%
% Syntax:
%    points = evaluate(Z1)
%
% Inputs:
%    Z1 - zonotope
%
% Outputs:
%    points inside the polynomial logical zonotope
%
% Example:
%   c= logical(0);
%   g{1} = logical(1);
%   id = [1];
%   E =[1];
%   pZ = logicalPolyZonotope(c,g,E,id);
%   points = evaluate(pZ);
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
%HAFEZ FOR LOOP on the points if it satisfies the constrain add it.

%------------- BEGIN CODE --------------
points = [];
q = size(Z1.A,2);
if isempty(Z1.A)
  pZ = logicalPolyZonotope(Z1.c,Z1.G,Z1.E,Z1.id);
  points = evaluate(pZ);
  return ;
end

if ~isempty(Z1.G)
    numOfalphas = size(Z1.E,1);%size( Z1.G,2 );
    numOfGens= size( Z1.G,2 );
    L=2^numOfalphas;
    for i=1:L
        table = de2bi(i-1,numOfalphas,'left-msb');
        multAlphaCons = 1;
        for iErow = 1:size(Z1.EC,1)
            multAlphaCons = multAlphaCons & (table(1,iErow)^Z1.E(iErow,1) );
        end
        onePointCons=multAlphaCons & Z1.A(:,1);
        for j=2:q
            multAlphaCons = 1;
            for iErow = 1:size(Z1.EC,1)
                multAlphaCons = multAlphaCons & (table(1,iErow)^Z1.EC(iErow,j) );
            end

            onePointCons =xor( onePointCons, multAlphaCons&Z1.A(:,j) );

        end
        if isequal(onePointCons, Z1.b)
            multAlpha = 1;
            for iErow = 1:size(Z1.E,1)
                multAlpha = multAlpha & (table(1,iErow)^Z1.E(iErow,1) );
            end

            onePoint=[ multAlpha&Z1.G{1}];
            for j=2:numOfGens
                multAlpha = 1;
                for iErow = 1:size(Z1.E,1)
                    multAlpha = multAlpha & (table(1,iErow)^Z1.E(iErow,j) );
                end

                onePoint =xor( onePoint, (multAlpha&Z1.G{j}) );
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