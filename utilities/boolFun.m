function [A] = boolFun(A,U)
% Summary of this function goes here
%   Detailed explanation goes here
temp{1} = or(U{1},xnor(A{2},A{1}));
temp{2} = xnor(A{2},and(A{1},U{2}));
xn = xnor(U{2},U{3});
temp{3} = nand(A{3},xn);

%temp{4}= or(U{4},and(A{1},xor(A{2},A{3})));
A = temp;
end

