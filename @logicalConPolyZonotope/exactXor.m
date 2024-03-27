function Z = exactXor(Z1,Z2)
% exactPlus - computes the XOR of two sets while preserving the
%    dependencies between the two sets
%
% Syntax:
%    pZ = exactXOR(pZ1,pZ2)
%
% Inputs:
%    pZ1 - polyZonotope object
%    pZ2 - polyZonotope object
%
% Outputs:
%    pZ - polyZonotope object
%
% Example: 
%    pZ1 = polyZonotope([0;0],[2 1 2;0 2 2],[],[1 0 3;0 1 1]);
%    pZ2 = [1 2;-1 1]*pZ1;
%   
%    pZ = xor(pZ1 + pZ2;
%    pZ_ = exactPlus(pZ1,pZ2);
%
%    figure
%    subplot(1,2,1);
%    plot(pZ,[1,2],'FaceColor','r','Splits',10);
%    title('Minkowski Sum');
%    subplot(1,2,2);
%    plot(pZ_,[1,2],'FaceColor','b');
%    title('Exact Addition');
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: mtimes, zonotope/plus

% Authors:       Niklas Kochdumper
% Written:       26-March-2018 
% Last update:   ---
% Last revision: ---

% ------------------------------ BEGIN CODE -------------------------------

if isempty(Z1.G)
    pZ1.G =[];
end
if isempty(Z2.G)
    pZ2.G =[];
end

for i=1:length(Z1.G)
    pZ1.G(:,i) = Z1.G{i};
end
for i=1:length(Z2.G)
    pZ2.G(:,i) = Z2.G{i};
end



pZ2.E = Z2.E;
pZ1.E = Z1.E;
pZ1.id = Z1.id;
pZ2.id = Z2.id;
pZ1.c = Z1.c;
pZ2.c = Z2.c;
pZ2.EC = Z2.EC;
pZ1.EC = Z1.EC;
pZ1.A = Z1.A;

pZ2.A = Z2.A;
pZ1.b = Z1.b;
pZ2.b = Z2.b;



% bring the exponent matrices to a common representation
[id,E1,E2] = mergeExpMatrix(pZ1.id,pZ2.id,pZ1.E,pZ2.E);
[id,EC1,EC2] = mergeExpMatrix(pZ1.id,pZ2.id,pZ1.EC,pZ2.EC);

% [p1,h1]=size(EC1);
% [m1,q1]=size(pZ1.A);
% [m2,q2]=size(pZ2.A);
% pZ1.A = [pZ1.A,zeros(m1,h1-q1)];
% pZ2.A = [pZ2.A,zeros(m2,h1-q2)];
% newA = [pZ1.A;pZ2.A];

newEC = [EC1,EC2];
[~,newh]=size(newEC);
[m1,q1]=size(Z1.A);
[m2,q2]=size(Z2.A);
Z1.A = [Z1.A,zeros(m1,newh-q1)];
Z2.A = [Z2.A,zeros(m2,newh-q2)];
newA = [Z1.A;Z2.A];
newb = [Z1.b;Z2.b];

% add up all generators that belong to identical exponents
[Enew,Gnew] = removeRedundantExponents([E1,E2],[pZ1.G,pZ2.G]);
%[ECnew,~] = removeRedundantExponents([EC1,EC2],[pZ1.A,pZ2.A]);
ECnew = [EC1,EC2];
% assemble the properties of the resulting polynomial zonotope
%pZ = pZ1;
newGen = Gnew;
newE = Enew;

newCen = xor(pZ1.c, pZ2.c);





for i=1:size(newGen,2)
    newGenCell{i} = newGen(:,i) ;
end

if isempty(newGen)
    newGenCell ={};
end



Z = logicalConPolyZonotope(newCen,newGenCell,newE,newA, newb, newEC,id);
%Z = unique(Z);

% ------------------------------ END OF CODE ------------------------------
