
clear all
close all
rng(120)

for i =1:64
    K{i} = randi([0 1]);
end

numOfmessages =70;
[z,A,B,C]  =AStreamCipher(K,numOfmessages);
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
for kk=1:63

    for i =1:kk-1
        if flag{i}==1
            testK{i} = logicalZonotope.enclosePoints([1]);
            tempK{i}=1;
        else
            testK{i} = logicalZonotope.enclosePoints([0]);
            tempK{i}=0;
        end
    end
    testK{kk} = logicalZonotope.enclosePoints([0]);
    for i=kk+1:64
        testK{i} = logicalZonotope.enclosePoints([0 1]);
    end
    [testz,A,B,C]  =AStreamCipher(testK,numOfmessages);

    for i =1:numOfmessages
        testc{i}= xor(testz{i},logicalZonotope.enclosePoints(m{i}));
    end
    
    longZono = testc{1};
    longC = double(c{1});
    for i =2:numOfmessages
        longZono=cartProd(longZono,testc{i});
        longC = [longC;double(c{i})];
    end

%     flag{kk} =0;
%     for i =1:numOfmessages
%         if ~testc{i}.containsPoint(c{i})
%             flag{kk} =1;
%             break;
%         end
%     end

    flag{kk} =0;
    %longZono = reduce(longZono);
        if ~longZono.containsPoint(longC)
            flag{kk} =1;
        %    break;
        end
    

    index=index+1;


end


