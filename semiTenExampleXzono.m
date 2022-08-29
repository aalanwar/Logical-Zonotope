
clear all;
F = zeros(5,20); 
F(2,1)=1;
F(3,7) =1;
F(3,13) =1;
F(4,3) =1;
F(4,12) =1;
F(5,18)=1;
F(5,19) =1;

Fu4 = zeros(5);
Fu4(5,3)=1;
Fu4(5,4)=1;


xx = zeros(5,1);
xx(4) =1;
xx2 = zeros(5,1);
xx2(3) =1;
logZ= logicalZonotope.enclosePoints([xx,xx2]);



uu = zeros(4,1);
uu(4) =1;
nextx= semiKron(semiKron(F,uu),logZ);






semiKron(F,uu)


evaluate(nextx)