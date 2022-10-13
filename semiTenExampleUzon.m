
clear all;
F = zeros(5,20); 
F(2,1)=1;
F(3,7) =1;
F(3,13) =1;
F(4,3) =1;
F(4,12) =1;
F(5,18)=1;
F(5,19) =1;

xx = zeros(5,1);
xx(4) =1;
xx2 = zeros(5,1);
xx2(3) =1;
logZ= logicalZonotope.enclosePoints([xx,xx2]);

uu = zeros(4,1);
uu(2) =1;
uu2 = zeros(4,1);
uu2(4) =1;
%uu3 = zeros(4,1);
%uu3(2) =1;
logU= logicalZonotope.enclosePoints([uu,uu2]);


xd = zeros(5,1);
xd(1)=1;
xd(4)=1;
xd(3)=1;

ud = zeros(4,1);
ud(1) =1;
ud(4) =1;
semiKron(semiKron(F,ud),xd)
% res{1} =semiKron(semiKron(F,logU.c),logZ);
% index=2;
% for i =1:length(logU.G)
%     res{index} = semiKron(semiKron(F,logU.G{i}),logZ)  ;
%     index=index+1;
% end
% nextx= logicalZonotope.encloseMany(res);


plogU = evaluate(logU);

res =[];
for i =1:length(plogU(1,:))
    res = [res , evaluate(semiKron(semiKron(F,plogU(:,i)),logZ))  ];
end
nextx= logicalZonotope.enclosePoints(res);
nextxP=evaluate(nextx)

nextx2= semiKron(semiKron(F,logU),logZ);
%nextx2= semiKron(F,semiKron(logU,logZ));

nextxP=evaluate(nextx2)
%nextxLogUP =evaluate(nextxLogU)