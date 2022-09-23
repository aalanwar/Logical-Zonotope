clear all 

close all
%rng(10);
nbits =3;
key=randi([0 1],nbits,1);
m = randi([0 1],nbits,1);
c = xor(key,m);

allpoints = truth_table(nbits);



chosenPoints = allpoints';
tic
for i=1:length(chosenPoints(1,:))
    keytest = xor(c,chosenPoints(:,i)) ;
    if keytest == key
       disp('found') 
    end
end
searchTime = toc


tic
for i=nbits:-1:1
    leftpoints = chosenPoints(:,[1:2^(i-1)]);
    rightpoints = chosenPoints(:,[2^(i-1)+1:end]);

    leftZono = logicalZonotope.enclosePoints(leftpoints);
    %leftZono = reduce(leftZono);
    leftZonoXOR = xor(logicalZonotope(m,{}),leftZono);
    resleft = containsPoint(leftZonoXOR,c);
    if resleft
        %chosenZono = leftZonoXOR;
        chosenPoints = leftpoints;
       % left =1;
    else
        %chosenZono = rightZonoXOR;
        chosenPoints = rightpoints;
       % right =1;
    end

%     rightZono = logicalZonotope.enclosePoints(rightpoints);
%     %rightZono = reduce(rightZono);
%     rightZonoXOR = xor(logicalZonotope(m,{}),rightZono);
%     resright = containsPoint(rightZonoXOR,c);
end
zonoTime = toc

if chosenPoints == key
    disp('success')
else
    disp('fail')
end


