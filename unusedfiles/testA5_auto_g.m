
clear all
close all
rng(254)

Aleng = 19;
Bleng = 22;
Cleng = 23;
for i =1:Aleng
    A{i} = randi([0 1]);
end
for i =1:Bleng
    B{i} = randi([0 1]);
end
for i =1:Cleng
    C{i} = randi([0 1]);
end

numOfmessages =1211;
[z,~,~,~]  =AStreamCipherABC(A,B,C,numOfmessages);
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
disp('start')
index=index+1;
setIndex =4;
compA=truth_table(setIndex*3);
% compB = compA;
% compC = compA;
for j =1:length(compA(:,1))
    for i=1:setIndex
        testA{i} = logicalZonotope.enclosePoints(compA(j,i));
        tempA{i} = compA(j,i);
        testB{i} = logicalZonotope.enclosePoints(compA(j,i+1));
        tempB{i} = compA(j,i+1);
        testC{i} = logicalZonotope.enclosePoints(compA(j,i+2));
        tempC{i} = compA(j,i+2);
    end

    % try first the chosen bits and other are logical zonotope
    for i=setIndex+1:Aleng
        testA{i} = logicalZonotope.enclosePoints([0 1]);
    end
    for i=setIndex+1:Bleng
        testB{i} = logicalZonotope.enclosePoints([0 1]);
    end
    for i=setIndex+1:Cleng
        testC{i} = logicalZonotope.enclosePoints([0 1]);
    end    

    
    [testz,~,~,~]  =AStreamCipherABC(testA,testB,testC,numOfmessages);

    for i =1:numOfmessages
        testc{i}= xor(testz{i},logicalZonotope.enclosePoints(m{i}));
    end



    flagChosenBits =0;
    for i =1:numOfmessages
        if ~testc{i}.containsPoint(c{i})
            flagChosenBits =1;
            break;
        end
    end

    if flagChosenBits ==1
        % do not continue with chosen bits
        continue;
    end

    % the chosen bits are correct, let's continue 
    for kk=setIndex+1:Aleng
        testA{kk} = logicalZonotope.enclosePoints([0]);
        for i=kk+1:Aleng
            testA{i} = logicalZonotope.enclosePoints([0 1]);
        end
        [testz,~,~,~]  =AStreamCipherABC(testA,testB,testC,numOfmessages);

        for i =1:numOfmessages
            testc{i}= xor(testz{i},logicalZonotope.enclosePoints(m{i}));
        end



        flag{kk} =0;
        for i =1:numOfmessages
            if ~testc{i}.containsPoint(c{i})
                flag{kk} =1;                
                break;
            end
        end

        for i=setIndex+1:kk
            if flag{i}==1
                testA{i} = logicalZonotope.enclosePoints([1]);
                tempA{kk}=1;
            else
                testA{i} = logicalZonotope.enclosePoints([0]);
                tempA{kk}=0;
            end
        end

    end
    sum=0;
    for i =1:Aleng
        sum = sum + abs(tempA{i}-A{i}) ;
    end
    %if sum == 0 
        sprintf("sum =%d , j =%d ",sum,j)
    %end


end

