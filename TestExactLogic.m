clear all
 
dim=7;
c1= [logical(randi([0 1],dim,1)) ];
numOfInd1 = 3;
for i=1:numOfInd1
   g1{i} = randi([0 1],dim,1);
end
E1 = [1 0 1;1 1 0];
id1 = [1;2];


c2= [logical(randi([0 1],dim,1)) ];
for i=1:2
    g2{i} = logical(randi([0 1],dim,1));
end
E2 =  [1 0;0 1];
id2 = [3; 4];






pZ1 = logicalPolyZonotope(c1,g1,E1,id1);
pZ2 = logicalPolyZonotope(c2,g2,E2,id2);


% manually
p1=evaluate(pZ1);
p2=evaluate(pZ2);
[~,p1Col]=size(p1);
[~,p2Col]=size(p2);
ExactXorPoints=[];
ExactAndPoints=[];
ExactNandPoints=[];
ExactOrPoints=[];
ExactAndORFormulaPoints =[] ;
tic
for i =1:p1Col
        ExactXorPoints = [ExactXorPoints, xor(p1(:,i),p1(:,i))];
        ExactAndPoints = [ExactAndPoints, and(p1(:,i),p1(:,i))];
        ExactNandPoints =[ExactNandPoints, nand(p1(:,i),p1(:,i))];
        ExactOrPoints =[ExactOrPoints, or(p1(:,i),p1(:,i))];
end

for i =1:p1Col
    for j=1:p2Col
        ExactAndORFormulaPoints = [ExactAndORFormulaPoints, or(p1(:,i),and(not(p1(:,i)),p2(:,j)))];
    end
end
exeTime=toc;


ExactXorPoints = unique(ExactXorPoints','rows')';
ExactAndPoints = unique(ExactAndPoints','rows')';
ExactNandPoints = unique(ExactNandPoints','rows')';
ExactOrPoints = unique(ExactOrPoints','rows')';
ExactAndORFormulaPoints = unique(ExactAndORFormulaPoints','rows')';

pZ1ExactXorpZ1 = exactXor(pZ1,pZ1);
pZ1ExactAndpZ1 = exactAnd(pZ1,pZ1);
pZ1ExactOrpZ1 = exactOr(pZ1,pZ1);
pZ1ExactNandpZ1 = exactNand(pZ1,pZ1);

tempAnd= and(not(pZ1),pZ2);
%tempAnd.id = [1;2;1;2];
pZ1ExactAndORpZ2 = exactOr(pZ1,tempAnd);


pZ1XorpZ1Points= evaluate(pZ1ExactXorpZ1);
pZ1AndpZ1Points= evaluate(pZ1ExactAndpZ1);
pZ1OrpZ1Points= evaluate(pZ1ExactOrpZ1);
pZ1NandpZ1Points= evaluate(pZ1ExactNandpZ1);
pZ1ExactAndORpZ2Points= evaluate(pZ1ExactAndORpZ2);

%% checks
if isequal(ExactXorPoints,pZ1XorpZ1Points) && isequal(ExactNandPoints,pZ1NandpZ1Points) && isequal(ExactAndPoints,pZ1AndpZ1Points) && isequal(ExactAndORFormulaPoints,pZ1ExactAndORpZ2Points)
    disp('All tests passed')
else
    disp('Test problem(s)')
end


if ~isequal(ExactXorPoints,pZ1XorpZ1Points)
    disp('Exact Xor problem')
end

if ~isequal(ExactNandPoints,pZ1NandpZ1Points)
    disp('Exact Nand problem')
end

if ~isequal(ExactAndPoints,pZ1AndpZ1Points)
    disp('Exact And problem')
end

if ~isequal(ExactOrPoints,pZ1OrpZ1Points)
    disp('Exact Or problem')
end

if ~isequal(ExactAndORFormulaPoints,pZ1ExactAndORpZ2Points)
    disp('exactOr(pZ1,and(pZ1,pZ2)) problem')
end

