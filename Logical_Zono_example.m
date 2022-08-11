clear all
c1 = [0;1];
c2 = [0;1];
g1 = [1;1];
g2 = [1;0];

% manually 
cAnd = (c1+c2)/2;
gAnd = [g1/2 g2/2];
AAndB=[xor(cAnd,[-1 -1]*gAnd),xor(cAnd,[-1 0]*gAnd),xor(cAnd,[0 -1]*gAnd),xor(cAnd,[0 0]*gAnd),xor(cAnd,[0 1]*gAnd),xor(cAnd,[1 0]*gAnd),xor(cAnd,[1 1]*gAnd)]

cXor = xor(c1,c2);
g1Xor = g1;
g2Xor = g2;
AXorB=[xor(cXor,xor(-1*g1Xor,-1*g2Xor)) xor(cXor,xor(-1*g1Xor,0*g2Xor)) xor(cXor,xor(0*g1Xor,-1*g2Xor)) xor(cXor,xor(0*g1Xor,0*g2Xor)) xor(cXor,xor(0*g1Xor,1*g2Xor)) xor(cXor,xor(1*g1Xor,0*g2Xor)) xor(cXor,xor(1*g1Xor,1*g2Xor))]


% using CORA

Z1 = logicalZonotope(c1,g1);
Z2 = logicalZonotope(c2,g2);

Z1norZ2 = nor(Z1 , Z2)

Z1AndZ2 = and(Z1, Z2)