clear all


cen = [0;1];

gen = {[1;0]};
Z = logicalZonotope(cen,gen);
Zred = reduce(Z)
evaluate(Z)
evaluate(Zred)

% Z = logicalZonotope(cen,gen);
% evaluate(Z)
% Zred = reduce(Z)
% evaluate(Zred)
