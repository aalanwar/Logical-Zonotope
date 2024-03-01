clear all
close all

rng(151);

for kk=1:1
dim=4;
c1= [randi([0 1],dim,1) ];
for i=1:2
    g1{i} = randi([0 1],dim,1);
end
E1=[1 1; 0 1];
id1 = [ 1;2];


c2= [randi([0 1],dim,1) ];
%gI2 = {randi([0 1],dim,1)};
for i=1:1
    g2{i} = randi([0 1],dim,1);
end
%g2 = {};
E2 =  [1 0;0 1];
id2 = [ 3;4];




Z1 = logicalZonotope(c1,g1);
Z2 = logicalZonotope(c2,g2);
pZ1 = logicalPolyZonotope(c1,g1,E1,id1);
pZ2 = logicalPolyZonotope(c2,g2,E2,id2);

%plot(Z1,[1 2 3],'r*');
% manually
p1=evaluate(pZ1);
p2=evaluate(pZ2);
[~,p1Col]=size(p1);
[~,p2Col]=size(p2);
andPoints=[];
orPoints =[];
norPoints =[];
nandPoints =[];
xorPoints = [];
xnorPoints = [];
semiKronPoints =[];
notPointsZ1 = [];
notPointsZ2 = [];
tic
for i =1:p1Col
    notPointsZ1 = [notPointsZ1, ~p1(:,i)];
    for j=1:p2Col
        andPoints = [andPoints, p1(:,i)&p2(:,j)];
        orPoints = [orPoints, p1(:,i)|p2(:,j)];
        norPoints = [norPoints, norLogic(p1(:,i),p2(:,j))];
        nandPoints = [nandPoints, nandLogic(p1(:,i),p2(:,j))];
        xorPoints = [xorPoints, xor(p1(:,i),p2(:,j))];
        xnorPoints = [xnorPoints, xnor(p1(:,i),p2(:,j))];
        %   semiKronPoints =[semiKronPoints, semiKron(p1(:,i),p2(:,j))];
    end
end
exeTime=toc;
for j=1:p2Col
    notPointsZ2 = [notPointsZ2, ~p2(:,j)];
end
andPoints = unique(andPoints','rows')';
orPoints = unique(orPoints','rows')';
norPoints = unique(norPoints','rows')';
nandPoints = unique(nandPoints','rows')';
xorPoints = unique(xorPoints','rows')';
xnorPoints = unique(xnorPoints','rows')';
%semiKronPoints = unique(semiKronPoints','rows')'
notPointsZ2 = unique(notPointsZ2','rows')';
notPointsZ1 = unique(notPointsZ1','rows')';


notpZ1 = not(pZ1);
notpZ2 = not(pZ2);
pZ1NorpZ2 = nor(pZ1 , pZ2);
%ExactpZ1AndpZ2 = exactAnd(pZ1, pZ2);
pZ1AndpZ2 = exactAnd(pZ1, pZ2);
pZ1OrpZ2 = or(pZ1, pZ2);
pZ1NandpZ2 = nand(pZ1, pZ2);
pZ1XorpZ2 = xor(pZ1,pZ2);
pZ1XnorpZ2 = xnor(pZ1,pZ2);
%Z1SemiKronZ2 =semiKron(Z1,Z2);

notpZ1Points= evaluate(notpZ1);
notpZ2Points= evaluate(notpZ2);
pZ1AndpZ2Points= evaluate(pZ1AndpZ2);
pZ1OrpZ2Points= evaluate(pZ1OrpZ2);
pZ1NorpZ2Points= evaluate(pZ1NorpZ2);
pZ1NandpZ2Points= evaluate(pZ1NandpZ2);
pZ1XorpZ2Points= evaluate(pZ1XorpZ2);
pZ1XnorpZ2Points= evaluate(pZ1XnorpZ2);
%% checks
if isequal(notPointsZ1,notpZ1Points) && isequal(notPointsZ2,notpZ2Points) && isequal(pZ1AndpZ2Points,andPoints) ...
        && isequal(pZ1OrpZ2Points,orPoints) && isequal(pZ1NorpZ2Points,norPoints) && isequal(pZ1NandpZ2Points,nandPoints) ...
        && isequal(pZ1XorpZ2Points,xorPoints) && isequal(pZ1XnorpZ2Points,xnorPoints)
    disp('All tests passed')
else
    disp('Test problem(s)')
end

if ~isequal(notPointsZ1,notpZ1Points)
    disp('Not Z1 problem')
end

if ~isequal(notPointsZ2,notpZ2Points)
    disp('Not Z2 problem')    
end

if ~isequal(pZ1AndpZ2Points,andPoints)
    disp('And problem')
end

if ~isequal(pZ1OrpZ2Points,orPoints)
    disp('OR problem')
end

if ~isequal(pZ1NorpZ2Points,norPoints)
    disp('Nor problem')
end

if ~isequal(pZ1NandpZ2Points,nandPoints)
    disp('Nand problem')
end

if ~isequal(pZ1XorpZ2Points,xorPoints)
    disp('Xor problem')
end

if ~isequal(pZ1XnorpZ2Points,xnorPoints)
    disp('Xor problem')
end

end
%Z1SemiKronZ2Points = evaluate(Z1SemiKronZ2)

%%%
% points = [1 0 0; 0 0 1];
% pointsZono = logicalZonotope.enclosePoints(points)
% pointsBack=evaluate(pointsZono)


