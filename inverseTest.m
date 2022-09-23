clear all
L =[zeros(1,4) 1 0 0 0;...
       zeros(1,8);...
       1 zeros(1,7);...
       zeros(1,8);...
       zeros(1,5) 1 1 0;...
       zeros(1,7) 1;...
       0 1 1 zeros(1,5);...
       zeros(1,8)];


II = eye(8);
X0 = [II(:,[5 7 1 2 4 3 8 6])];
U0 = [II(:,[4 1 3 2 5 7 8 6])];
for i =1:length(X0)
%X1(:,i) = semiKron(L,semiKron(U0(:,i),X0(:,i)));
X1(:,i) = semiKron(L,U0(:,i));
end

for i =1:length(X0)
%X1(:,i) = semiKron(L,semiKron(U0(:,i),X0(:,i)));
X11(:,i)=semiKron(X1,X0(:,i));
end

XU = [X0];
bb=invBol([mod(XU*XU',2),eye(size(mod(XU*XU',2)))]);
[rows,cols] = size(bb);
invX0X0 = bb(:,cols/2+1:end);
invX0 = mod(XU'* invX0X0,2);
iseye= mod(XU*invX0,2)

XU = [U0];
bb=invBol([mod(XU*XU',2),eye(size(mod(XU*XU',2)))]);
[rows,cols] = size(bb);
invX0X0 = bb(:,cols/2+1:end);
invU0 = mod(XU'* invX0X0,2);
iseye= mod(XU*invU0,2)

compL =  mod(X11*invX0*invU0,2);

differ = L - compL