

clear all

rng(100);
steps = 2;
dim =10;
numOfVar = 3;
numOfVarU = 3;

numOfGens = 1;
numOfGensU =1;




for i=1:numOfVar 
    c= logical(randi([0 1],dim,1));
    g ={};
    for j=1:numOfGens
        g{j} = logical(randi([0 1],dim,1));
    end
    Az{i} = logicalZonotope(c,g);
    Apz{i} = logicalPolyZonotope(c,g,{},[]);
    Apt{i} = evaluate(Az{i});
end

for i=1:numOfVarU 
    c= logical(randi([0 1],dim,1) );
    g ={};
    for j=1:numOfGensU
        g{j} = logical(randi([0 1],dim,1));
    end
    Uz{i} = logicalZonotope(c,g);
    Upz{i} = logicalPolyZonotope(c,g,{},[]);
    pointsU{i} = evaluate(Uz{i});
end


tic
for i =1:steps
    [Az] = boolFun(Az,Uz);
end
execlogicZono = toc

tic
for i =1:steps
    [Apz] = boolFun(Apz,Upz);
end
execplogicPolyZono = toc


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
for i =1:length(Apz)
Apz{i} = rmZeroGens(Apz{i});
Az{i} = rmZeroGens(Az{i});
end

Apz1=evaluate(Apz{1});
Apz2=evaluate(Apz{2});
Apz3=evaluate(Apz{3});


AlpzNPoints=length(Apz1);
A2pzNPoints=length(Apz2);
A3pzNPoints=length(Apz3);


totalPointsPolyZ = AlpzNPoints + A2pzNPoints + A3pzNPoints

% %%----------- BDD ---------%%
% 
A={};
A1points{1}=Apt{1};
A2points{1}=Apt{2};
A3points{1}=Apt{3};


for s = 1:steps
    tic
    A1points{s+1} = [];
    A2points{s+1} = [];
    A3points{s+1} = [];
    for iVP1=1:length(A1points{s}(1,:))
        for iVP2=1:length(A2points{s}(1,:))
            for iCF1=1:length(A3points{s}(1,:))
                for j=1:length(pointsU{1}(1,:))
                    for j2 = 1:length(pointsU{2}(1,:))
                        for j3=1:length(pointsU{3}(1,:))

                            
                            U{1}=pointsU{1}(:,j);
                            U{2}=pointsU{2}(:,j2);
                            U{3}=pointsU{3}(:,j3);

                            A{1}=A1points{s}(:,iVP1);
                            A{2}=A2points{s}(:,iVP2);
                            A{3}=A3points{s}(:,iCF1);


                            [A] = boolFun(A,U);
                            A1points{s+1} = [ A1points{s+1} A{1}];
                            A2points{s+1} = [ A2points{s+1} A{2}];
                            A3points{s+1} = [ A3points{s+1} A{3}];


                        end
                    end
                end
            end
        end
    end
    A1points{s+1} = unique(A1points{s+1}','rows')';
    A2points{s+1} = unique(A2points{s+1}','rows')';
    A3points{s+1} = unique(A3points{s+1}','rows')';
    execBDD(s) = toc
end

execDBB2 = sum(execBDD(1:2))


AlBDDNPoints=length(A1points{steps+1});
A2BDDNPoints=length(A2points{steps+1});
A3BDDNPoints=length(A3points{steps+1});

totalPointsBDD = AlBDDNPoints + A2BDDNPoints + A3BDDNPoints




AlzNPoints=length(evaluate(Az{1}));
A2zNPoints=length(evaluate(Az{2}));
A3zNPoints=length(evaluate(Az{3}));

totalPointsZono = AlzNPoints + A2zNPoints + A3zNPoints
% if ~isequal(Apz1,A1points{steps+1})
%     disp('A1 problem')
% else
%     disp('A1 success')
% end
% 
% if ~isequal(Apz2,A2points{steps+1})
%     disp('A2 problem')
% else
%     disp('A2 success')
% end
% 
% if ~isequal(Apz3,A3points{steps+1})
%     disp('A3 problem')
% else
%     disp('A3 success')
% end
