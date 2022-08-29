function [C] = semiKron(A,B)
%SEMIKRON Summary of this function goes here
%   Detailed explanation goes here
[m ,n]=size(A);
[p ,q]=size(B);
alpha = lcm(n,p);
C = kron(A,eye(alpha/n)) * kron(B,eye(alpha/p));
end

