% x1=[0,0,1,1,1;...
%     1,1,0,0,0;...
%     0,1,0,1,1;...
%     1,0,1,0,0];
% 
% P= [1;0];
% Q= [0;1];
% s=[semiKron([Q;Q],[Q;Q]),semiKron([Q;P],[Q;P]),semiKron([P;Q],[P;Q]),semiKron([P;P],[Q;Q]),semiKron([P;P],[P;P])];
% 
% 
% 
% tt = x1*pinv(s)

Md = [ 1 1 1 0; 0 0 0 1 ];
Mc = [ 1 0 0 0; 0 1 1 1];
Mi = [ 1 0 1 1; 0 1 0 0];
Me=  [ 1 0 0 1;0 1 1 0];
Mn = [0 1 ; 1 0];
A1=  [0;1];
B1 = [1;0];
C1 = [0;1];
x1=semiKron(A1,semiKron(B1,C1));

A2=  [1;0];
B2 = [0;1];
C2 = [0;1];
x2=semiKron(A2,semiKron(B2,C2));

An = semiKron(Mc,semiKron(B1,C1));
Bn = semiKron(Mn,A1);
Cn = semiKron(Md,semiKron(B1,C1));

x1=semiKron(A1,semiKron(B1,C1));

xn1_v1 = semiKron(Mc,semiKron(semiKron(B1,C1),semiKron(Mn,semiKron(A1,semiKron(Md,semiKron(B1,C1))))))


xn1_v2=semiKron(An,semiKron(Bn,Cn));

%A Linear Representation of Dynamics of Boolean Networks
L =[zeros(1,4) 1 0 0 0;...
       zeros(1,8);...
       1 zeros(1,7);...
       zeros(1,8);...
       zeros(1,5) 1 1 0;...
       zeros(1,7) 1;...
       0 1 1 zeros(1,5);...
       zeros(1,8)];



logzono = logicalZonotope.enclosePoints([x1,x2]);
xn1 = semiKron(L,x1);
xn2 = semiKron(L,x2);

x3= mod(x1+x2,2);
xn3 = semiKron(L,x3)

[xn1,xn2]

evaluate(semiKron(L,logzono))

%%%%%%%%%%%%%%%%%%%%%%%%%

AlogZono = logicalZonotope.enclosePoints([[0;1],[1;0]]);
BlogZono = [0;1];%logicalZonotope.enclosePoints([[0;1],[1;0]]);
C = [0,1];

xlogZono=semiKron(AlogZono,semiKron(BlogZono,C));

evaluate(semiKron(L,xlogZono))


A1=  [0;1];
B1 = [0;1];
C1 = [0;1];
x11=semiKron(A1,semiKron(B1,C1));

A2=  [1;0];
B2 = [0;1];
C2 = [0;1];
x22=semiKron(A2,semiKron(B2,C2));

xn11 = semiKron(L,x11);
xn22 = semiKron(L,x22);
[xn11,xn22]
xlogZono2=logicalZonotope.enclosePoints([x11,x22]);

evaluate(semiKron(L,xlogZono2))


% W24 = [1 zeros(1,7);...
%        zeros(1,4) 1 zeros(1,3);...
%        0 1 zeros(1,6); ...
%        zeros(1,5) 1 zeros(1,2);...
%        0 0 1 zeros(1,5);...
%        zeros(1,6) 1 0;...
%        0 0 0 1 zeros(1,4);...
%        zeros(1,7) 1];
% 
% W2 = [ 1 0 0 0;
%        0 0 1 0;
%        0 1 0 0;
%        0 0 0 1];
% 
% Mr = [1 0;0 0 ; 0 0;0 1];


