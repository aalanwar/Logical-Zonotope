clear all
close all

rng(50);
c1 = [0;1];
c2 = [0;1];
g1 = {[1;0]};
%g1 = {[0 1;1 1]};
g2 = {[1;1]};
%g2 = {[1 0;0 1]};
dim =20;
c3= [randi([0 1],dim,1) ];
for i=1:10
g3{i} = randi([0 1],dim,1);
end



Z3 = logicalZonotope(c3,g3);


%plot(Z3,[1:3],'r','Cont',true);
%Z3red = reduce(Z3); 
%hold on
%plot(Z3red,[1:3],'k');


Z1 = logicalZonotope(c1,g1);

res = containsPoint(Z1,c1)
ZB =logicalZonotope([1;0],{[1;0]});
Z1I = semiKron([1 0 0 0; 0 1 1 1],semiKron([0;1],ZB));


Z2 = logicalZonotope(c2,g2);
%plot(Z1,[1 2],'r','Cont',true);
% manually 
p1=evaluate(Z1)
p2=evaluate(Z2)
[~,p1Col]=size(p1);
[~,p2Col]=size(p2);
andPoints=[];
orPoints =[];
norPoints =[];
nandPoints =[];
xorPoints = [];
notPointsZ1 = [];
notPointsZ2 = [];
for i =1:p1Col
    notPointsZ1 = [notPointsZ1, ~p1(:,i)];
    for j=1:p2Col
        andPoints = [andPoints, p1(:,i)&p2(:,j)];
        orPoints = [orPoints, p1(:,i)|p2(:,j)];
        norPoints = [norPoints, norLogic(p1(:,i),p2(:,j))];
        nandPoints = [nandPoints, nandLogic(p1(:,i),p2(:,j))];
        xorPoints = [xorPoints, xor(p1(:,i),p2(:,j))];
    end
end

for j=1:p2Col
    notPointsZ2 = [notPointsZ2, ~p2(:,j)];
end
andPoints = unique(andPoints','rows')'
orPoints = unique(orPoints','rows')'
norPoints = unique(norPoints','rows')'
nandPoints = unique(nandPoints','rows')'
xorPoints = unique(xorPoints','rows')'
notPointsZ2 = unique(notPointsZ2','rows')'
notPointsZ1 = unique(notPointsZ1','rows')'

% using CORA
notZ1 = not(Z1);
notZ2 = not(Z2);
Z1NorZ2 = nor(Z1 , Z2)
Z1AndZ2 = and(Z1, Z2)
Z1OrZ2 = or(Z1, Z2)
Z1NandZ2 = nand(Z1, Z2)
Z1XorZ2 = xor(Z1,Z2);

notZ1Points= evaluate(notZ1)
notZ2Points= evaluate(notZ2)
Z1AndZ2Points= evaluate(Z1AndZ2)
Z1OrZ2Points= evaluate(Z1OrZ2)
Z1NorZ2Points= evaluate(Z1NorZ2)
Z1NandZ2Points= evaluate(Z1NandZ2)
Z1XorZ2Points= evaluate(Z1XorZ2)


cNor = xor(c1,c2);
g1Nor = g1{1};
g2Nor = g2{1};
AXorB=[   xor(cNor,xor(0*g1Nor,0*g2Nor)) xor(cNor,xor(0*g1Nor,1*g2Nor)) xor(cNor,xor(1*g1Nor,0*g2Nor)) xor(cNor,xor(1*g1Nor,1*g2Nor))]

%%%
points = [1 0 0; 0 0 1];
pointsZono = logicalZonotope.enclosePoints(points)
pointsBack=evaluate(pointsZono)


