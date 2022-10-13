function [invX0,iseye] = pseudoInvBol(XU)
bb=invBol([mod(XU*XU',2),eye(size(mod(XU*XU',2)))]);
[rows,cols] = size(bb);
invX0X0 = bb(:,cols/2+1:end);
invX0 = mod(XU'* invX0X0,2);
iseye= mod(XU*invX0,2);
end

