clear all

TF = {[1],[0]};

numOfVeh = 2;
Len=2^(numOfVeh*2+4);
for i=1:Len
    table = de2bi(i-1,numOfVeh*2+4,'left-msb');


    for j =1:numOfVeh
        if table(j)==1
            VP{j}= TF{1};
        else
            VP{j}= TF{2};
        end
    end

    index =1;
    for j =numOfVeh+1:numOfVeh*2
        if table(j)==1
            CF{index}= TF{1};
        else
            CF{index}= TF{2};
        end
        index = index +1;
    end

    index =1;
   for j =numOfVeh*2+1:length(table)
        if table(j)==1
            U{index}= TF{1};
        else
            U{index}= TF{2};
        end
        index = index +1;
    end

    [x(:,i),xn(:,i),xu(:,i),xnu(:,i),u(:,i)] = vehLogic(U,VP,CF);

end


[invXu,iseyex] = pseudoInvBol(xu);
isequal( iseyex,eye(Len) ) 
 


Lcomp =  mod(xn*invXu,2);


for i=1:length(x)
    xncomp = semiKron(Lcomp,semiKron(u(:,i),x(:,i)));
    if xncomp ~= xn(:,i)
        disp('wrong')
    end
end

for i=1:length(Lcomp)
    if sum(Lcomp(:,i)) ~= 1
        disp('wrongL')
    end
end


% VPl{1} = logicalZonotope.enclosePoints([[0;1],[1;0]]);
% VPl{2} = VPl{1};
% VPl{3} = [1;0];
% VPl{4} = [1;0];
% 
% CFl{1} = logicalZonotope.enclosePoints([[0;1],[1;0]]);
% CFl{2} = CFl{1};
% CFl{3} = [1;0];
% CFl{4} = [1;0];
% 
% Ul{1} = logicalZonotope.enclosePoints([[0;1],[1;0]]);
% Ul{2} = Ul{1};
% 
% 
% xVP = semiKron(VP{1},semiKron(VP{2},semiKron(VP{3},VP{4})));
% xCF = semiKron(CF{1},semiKron(CF{2},semiKron(CF{3},CF{4})));
% xl{1} = semiKron(xVP,xCF);
% ul{1} = semiKron(Ul{1},Ul{2});
% %x = reduce(x);
% for i=1:10
% xl{i+1} = semiKron(Lcomp,ul{1},xl{i});
% end
