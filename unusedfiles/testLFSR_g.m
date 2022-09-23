
clear all
close all
%rng(500)

Aleng = 19;
for i =1:Aleng
    A{i} = randi([0 1]);
end

numOfmessages =121;
[z,~]  =LFSR1(A,numOfmessages);
for i =1:numOfmessages
    m{i} = randi([0 1]);
    c{i}= xor(z{i},m{i});
end




% for i =1:63
%     testK{i} = logicalZonotope.enclosePoints([0 1]);
% end
% testK{64} = logicalZonotope.enclosePoints([0]);
% 
% [testz,A,B,C]  =AStreamCipher(testK,10);
% 
% for i =1:10
%     m{i} = randi([0 1]);
%     testc{i}= xor(testz{i},logicalZonotope.enclosePoints(m{i}))
% end
% 
% for i =1:10
%     if ~testc{i}.containsPoint(c{i})
%         flag =1;
%     end
% end

index=1;
flag{index}=0;
index=index+1;
for kk=1:Aleng

    for i =1:kk-1
        if flag{i}==1
            testA{i} = logicalZonotope.enclosePoints([1]);
            
        else
            testA{i} = logicalZonotope.enclosePoints([0]);
            
        end
    end
    testA{kk} = logicalZonotope.enclosePoints([0]);
    for i=kk+1:Aleng
        testA{i} = logicalZonotope.enclosePoints([0 1]);
    end
    [testz,~]  =LFSR1(testA,numOfmessages);

    for i =1:numOfmessages
        testc{i}= xor(testz{i},logicalZonotope.enclosePoints(m{i}));
    end
    


    flag{kk} =0;
    tempA{kk}=0;
    for i =1:numOfmessages
        if ~testc{i}.containsPoint(c{i})
            flag{kk} =1;
            tempA{kk}=1;
            break;
        end
    end

end

sum=0;
for i =1:Aleng
    sum = sum + (tempA{i}-A{i}) ;
end

sum
