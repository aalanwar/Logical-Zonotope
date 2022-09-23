clear all
close all

%A = ones(12) - diag([1 1 1 1]);

rng(900);
nbits = 5;
A = randi([0 1],nbits,nbits);
B = randi([0 1],nbits,nbits);
%G = graph(A~=0);

X0 = randi([0 1],nbits,1000);
U = randi([0 1],nbits,1000);
X1 = A * X0 + B * U;

XU = [X0;U];
% isinv = isInvBol(mod(X0*X0',2))
bb=invBol([mod(XU*XU',2),eye(size(mod(XU*XU',2)))]);
[rows,cols] = size(bb);
invXUXU = bb(:,cols/2+1:end);

invXU = mod(XU'* invXUXU,2);
iseye= mod(XU*invXU,2)
compAB =  mod(X1*invXU,2);

differ = [A,B] - compAB;

X1comp = compA * X0;

