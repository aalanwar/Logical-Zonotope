clear all
c1 = [0;1];
c2 = [0;1];
g1 = {[1;1]};
g2 = {[1;0]};

Z1 = logicalZonotope(c1,g1);
Z2 = logicalZonotope(c2,g2);

% manually 
p1=evaluate(Z1)
p2=evaluate(Z2)
[~,p1Col]=size(p1);
[~,p2Col]=size(p2);
andPoints=[];
orPoints =[];
norPoints =[];
nandPoints =[];
for i =1:p1Col
    for j=1:p2Col
        andPoints = [andPoints, p1(:,i)&p2(:,j)];
        orPoints = [orPoints, p1(:,i)|p2(:,j)];
        norPoints = [norPoints, norLogic(p1(:,i),p2(:,j))];
        nandPoints = [nandPoints, nandLogic(p1(:,i),p2(:,j))];
    end
end

andPoints = unique(andPoints','rows')'
orPoints = unique(orPoints','rows')'
norPoints = unique(norPoints','rows')'
nandPoints = unique(nandPoints','rows')'
% using CORA
Z1NorZ2 = nor(Z1 , Z2)
Z1AndZ2 = and(Z1, Z2)
Z1OrZ2 = or(Z1, Z2)
Z1NandZ2 = nand(Z1, Z2)
Z1AndZ2Points= evaluate(Z1AndZ2)
Z1OrZ2Points= evaluate(Z1OrZ2)
Z1NorZ2Points= evaluate(Z1NorZ2)
Z1NandZ2Points= evaluate(Z1NandZ2)



cNor = ~norLogic(~c1,~c2);
g1Nor = g1{1};
g2Nor = g2{1};
ANorB=[   norLogic(~cNor,norLogic(0*g1Nor,0*g2Nor)) norLogic(~cNor,norLogic(0*g1Nor,1*g2Nor)) norLogic(~cNor,norLogic(1*g1Nor,0*g2Nor)) norLogic(~cNor,norLogic(1*g1Nor,1*g2Nor))]

