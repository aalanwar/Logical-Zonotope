% author Busy code
% date of submission 22 April 2010
% the below program is for the random binary number generation 
% the program asks for the length of the sequence to be generated
% then the generated sequence is stored in the file sequence.txt
% the algorithm of the code can be obtained form the wikipedia

clc;
clear all;
close all;

RA = zeros(19,1,'uint8');
RB = ones(22,1,'uint8');
RC = zeros(23,1,'uint8');
RA(19,1) = 0;
RA(11,1) = 1;
RB(5,1) = 1;
RB(15,1) = 1;
RC(1,1) = 1;
RC(10,1) = 1;

count = input('Enter the length of the sequence to be generated = ');
index = 0;
while(index ~= count )
    index = index + 1   ;
RA19 = RA(19,1);
RA18 = RA(18,1);
RA17 = RA(17,1);
RA14 = RA(14,1);
RB22 = RB(22,1);
RB21 = RB(21,1);
RC23 = RC(23,1);
RC22 = RC(22,1);
RC21 = RC(21,1);
RC8  = RC(8,1);

RA9 = RA(9,1);
RB11 = RB(11,1);
RC11 = RC(11,1);
Max0 = 0;
Max1 = 0;
if(RA9 == 1)
    Max1 = Max1 + 1;
else
    MAx0 = Max0 + 1;
end
if(RB11 == 1)
    Max1 = Max1 + 1;
else
    Max0 = Max0 + 1;
end
if(RC11 == 1)
    Max1 = Max1 + 1;
else
    Max0 = Max0 + 1;
end

if(Max1 > Max0)
    CK = 1;
else
    CK = 0;
end

tempA = bitxor(RA19, RA18);
tempA = bitxor(RA17, tempA);
tempA = bitxor(RA14, tempA);
tempB = bitxor(RB22, RB21);
tempC = bitxor(RC23, RC22);
tempC = bitxor(RC21, tempC);
tempC = bitxor(RC8,  tempC);

if(RA9 == CK)
    for ind = 19 :-1: 2
        RA(ind,1) = RA(ind-1,1);
    end
    RA(1,1) = tempA;
end

if(RB11 == CK)
    for ind = 22 :-1: 2
        RB(ind,1) = RB(ind-1,1);
    end
    RB(1,1) = tempB;
end

if(RC11 == CK)
    for ind = 23 :-1: 2
        RC(ind,1) = RC(ind-1,1);
    end
    RC(1,1) = tempC;
end

outA = bitxor(RA19,RB22);
outA = bitxor(RC23,outA);
seq(index) = outA;
end

%    fid = fopen('sequence.txt','w');
%    fprintf(fid,'%d',seq);
%    fclose(fid);
    



