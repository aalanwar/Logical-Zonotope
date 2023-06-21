clear all

load('cache\L.mat')

steps = 1000;


VPl{1}{1} = logical(1);
VPl{1}{2} = logicalZonotope.enclosePoints(logical([0,1]));
VPl{1}{3} = logical(0);
VPl{1}{4} = logicalZonotope.enclosePoints(logical([0,1]));

VplOrig = VPl;

CFl{1}{1} = logical(1);
CFl{1}{2} = logicalZonotope.enclosePoints(logical([0,1]));
CFl{1}{3} = logical(0);
CFl{1}{4} = logicalZonotope.enclosePoints(logical([0,1]));

CFlOrig = CFl;

Ul{1} = logicalZonotope.enclosePoints(logical([0,1]));
Ul{2} = logical(0);
Ul{3} = logicalZonotope.enclosePoints(logical([0,1]));
Ul{4} = logicalZonotope.enclosePoints(logical([0,1]));
Ul{5} = logicalZonotope.enclosePoints(logical([0,1]));
Ul{6} = logical(0);
Ul{7} = logicalZonotope.enclosePoints(logical([0,1]));
Ul{8} = logicalZonotope.enclosePoints(logical([0,1]));

UlOrig = Ul;
tic
for i=1:steps
    [VPl{i+1},CFl{i+1}] = vehLogicZono4(Ul,VPl{i},CFl{i});
end
execlogicZono = toc



VP1data=evaluate(VPl{steps+1}{1});
VP2data=evaluate(VPl{steps+1}{2});
VP3data=evaluate(VPl{steps+1}{3});
VP4data=evaluate(VPl{steps+1}{4});

CF1data=evaluate(CFl{steps+1}{1});
CF2data=evaluate(CFl{steps+1}{2});
CF3data=evaluate(CFl{steps+1}{3});
CF4data=evaluate(CFl{steps+1}{4});

VP1NPoints=length(VP1data);
VP2NPoints=length(VP2data);
VP3NPoints=length(VP3data);
VP4NPoints=length(VP4data);
CF1NPoints=length(CF1data);
CF2NPoints=length(CF2data);
CF3NPoints=length(CF3data);
CF4NPoints=length(CF4data);

totalPointsZono = VP1NPoints + VP2NPoints +VP3NPoints + VP4NPoints ...
    + CF1NPoints + CF2NPoints + CF3NPoints + CF4NPoints


%%----------- Poly Zonotope ---------%%
%VPl ={};
%CFl ={};

for i =1:4
    if isa(VplOrig{1}{i},'logicalZonotope')
        VPl{1}{i}= logicalPolyZonotope(VPl{1}{i}.c,VPl{1}{i}.G,{},[]); 
    end
end

for i =1:4
    if isa(CFlOrig{1}{i},'logicalZonotope')
        CFl{1}{i}= logicalPolyZonotope(CFl{1}{i}.c,CFl{1}{i}.G,{},[]); 
    end
end

for i =1:8
    if isa(UlOrig{i},'logicalZonotope')
        Ul{i}= logicalPolyZonotope(Ul{i}.c,Ul{i}.G,{},[]); 
    end
end


tic
for i=1:steps
    [VPl{i+1},CFl{i+1}] = vehLogicZono4(Ul,VPl{i},CFl{i});
    %     CFl{i+1}{1}=rmZeroGens(CFl{i+1}{1});
    %     CFl{i+1}{2}=rmZeroGens(CFl{i+1}{2});
    %     VPl{i+1}{1}=rmZeroGens(VPl{i+1}{1});
    %     VPl{i+1}{2}=rmZeroGens(VPl{i+1}{2});
end
execlogicPolyZono = toc


VP1PZdata=evaluate(VPl{steps+1}{1});
VP2PZdata=evaluate(VPl{steps+1}{2});
VP3PZdata=evaluate(VPl{steps+1}{3});
VP4PZdata=evaluate(VPl{steps+1}{4});
CF1PZdata=evaluate(CFl{steps+1}{1});
CF2PZdata=evaluate(CFl{steps+1}{2});
CF3PZdata=evaluate(CFl{steps+1}{3});
CF4PZdata=evaluate(CFl{steps+1}{4});

VP1PZNPoints=length(VP1PZdata);
VP2PZNPoints=length(VP2PZdata);
VP3PZNPoints=length(VP3PZdata);
VP4PZNPoints=length(VP4PZdata);
CF1PZNPoints=length(CF1PZdata);
CF2PZNPoints=length(CF2PZdata);
CF3PZNPoints=length(CF3PZdata);
CF4PZNPoints=length(CF4PZdata);

totalPointsPZ = VP1PZNPoints + VP2PZNPoints + CF1PZNPoints + CF2PZNPoints ...
               +VP3PZNPoints + VP4PZNPoints + CF3PZNPoints + CF4PZNPoints

%%----------- BCN ---------%%

for i =1:4
    if isa(VplOrig{1}{i},'logicalZonotope')
        VPl{1}{i}= [[0;1],[1;0]]; 
    elseif VplOrig{1}{i}== logical(0)
        VPl{1}{i}= [0;1];
    else
        VPl{1}{i}= [1;0];
    end
end

for i =1:4
    if isa(CFlOrig{1}{i},'logicalZonotope')
        CFl{1}{i}= [[0;1],[1;0]]; 
    elseif CFlOrig{1}{i}== logical(0)
        CFl{1}{i}= [0;1];
    else
        CFl{1}{i}= [1;0];
    end
end

for i =1:8
    if isa(UlOrig{i},'logicalZonotope')
        Ul{i}= [[0;1],[1;0]]; 
    elseif UlOrig{i}== logical(0)
        Ul{i}= [0;1];
    else
        Ul{i}= [1;0];
    end
end

tic
xpoints{1}= [];
for i1=1:length(VPl{1}{1}(1,:))
    for i2=1:length(VPl{1}{2}(1,:))
        for i3=1:length(VPl{1}{3}(1,:))
            for i4=1:length(VPl{1}{4}(1,:))
                for j1 = 1:length(CFl{1}{1}(1,:))
                    for j2 = 1:length(CFl{1}{2}(1,:))
                        for j3 = 1:length(CFl{1}{3}(1,:))
                            for j4 = 1:length(CFl{1}{4}(1,:))

                                xVP =semiKron(VPl{1}{1}(:,i1),semiKron(VPl{1}{2}(:,i2), semiKron(VPl{1}{3}(:,i3),VPl{1}{4}(:,i4))));
                                xCF =semiKron(CFl{1}{1}(:,j1),semiKron(CFl{1}{2}(:,j2), semiKron(CFl{1}{3}(:,j3),CFl{1}{4}(:,j4))));
                                xpoints{1} = [ xpoints{1} semiKron(xVP,xCF)];
                            end
                        end
                    end
                end
            end
        end
    end
end
for s = 1:steps
    xpoints{s+1} = [];
    for i=1:length(xpoints{s}(1,:))
        for j=1:length(Ul{1}(1,:))
            for j2 = 1:length(Ul{2}(1,:))
                for j3=1:length(Ul{3}(1,:))
                    for j4 = 1:length(Ul{4}(1,:))
                        for j5=1:length(Ul{5}(1,:))
                            for j6 = 1:length(Ul{6}(1,:))
                                for j7=1:length(Ul{7}(1,:))
                                    for j8 = 1:length(Ul{8}(1,:))
                                        usemi = semiKron(Ul{1}(:,j),semiKron(Ul{2}(:,j2),semiKron(Ul{3}(:,j3),Ul{4}(:,j4))));
                                        newx = semiKron(semiKron(Lcomp,usemi),xpoints{s}(:,i));
                                        xpoints{s+1} = [ xpoints{s+1} newx];
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    xpoints{s+1} = unique(xpoints{s+1}','rows')';
end
execBCN = toc



%%----------- BDD ---------%%

for i =1:4
    if isa(VplOrig{1}{i},'logicalZonotope')
        VPl{1}{i}= [[0],[1]]; 
    elseif VplOrig{1}{i}== logical(0)
        VPl{1}{i}= [0];
    else
        VPl{1}{i}= [1];
    end
end

for i =1:4
    if isa(CFlOrig{1}{i},'logicalZonotope')
        CFl{1}{i}= [[0],[1]]; 
    elseif CFlOrig{1}{i}== logical(0)
        CFl{1}{i}= [0];
    else
        CFl{1}{i}= [1];
    end
end

for i =1:8
    if isa(UlOrig{i},'logicalZonotope')
        Ul{i}= [[0],[1]]; 
    elseif UlOrig{i}== logical(0)
        Ul{i}= [0];
    else
        Ul{i}= [1];
    end
end


VP1points{1}=VPl{1}{1};
VP2points{1}=VPl{1}{2};
VP3points{1}=VPl{1}{3};
VP4points{1}=VPl{1}{4};

CF1points{1}=CFl{1}{1};
CF2points{1}=CFl{1}{2};
CF3points{1}=CFl{1}{3};
CF4points{1}=CFl{1}{4};
tic
for s = 1:steps
    VP1points{s+1} = [];
    VP2points{s+1} = [];
    VP3points{s+1} = [];
    VP4points{s+1} = [];
    CF1points{s+1} = [];
    CF2points{s+1} = [];
    CF3points{s+1} = [];
    CF4points{s+1} = [];
    for iVP1=1:length(VP1points{s}(1,:))
        for iVP2=1:length(VP2points{s}(1,:))
            for iVP3=1:length(VP3points{s}(1,:))
                for iVP4=1:length(VP4points{s}(1,:))
                    for iCF1=1:length(CF1points{s}(1,:))
                        for iCF2=1:length(CF2points{s}(1,:))
                            for iCF3=1:length(CF3points{s}(1,:))
                                for iCF4=1:length(CF4points{s}(1,:))
                                    for j=1:length(Ul{1}(1,:))
                                        for j2 = 1:length(Ul{2}(1,:))
                                            for j3=1:length(Ul{3}(1,:))
                                                for j4 = 1:length(Ul{4}(1,:))
                                                    for j5=1:length(Ul{5}(1,:))
                                                        for j6 = 1:length(Ul{6}(1,:))
                                                            for j7=1:length(Ul{7}(1,:))
                                                                for j8 = 1:length(Ul{8}(1,:))
                                                                    Uin{1}=Ul{1}(:,j);
                                                                    Uin{2}=Ul{2}(:,j2);
                                                                    Uin{3}=Ul{3}(:,j3);
                                                                    Uin{4}= Ul{4}(:,j4);
                                                                    Uin{5}=Ul{5}(:,j5);
                                                                    Uin{6}=Ul{6}(:,j6);
                                                                    Uin{7}=Ul{7}(:,j7);
                                                                    Uin{8}= Ul{8}(:,j8);

                                                                    VPin{1}=VP1points{s}(:,iVP1);
                                                                    VPin{2}=VP2points{s}(:,iVP2);
                                                                    VPin{3}=VP3points{s}(:,iVP3);
                                                                    VPin{4}=VP4points{s}(:,iVP4);

                                                                    CFin{1}=CF1points{s}(:,iCF1);
                                                                    CFin{2}=CF2points{s}(:,iCF2);
                                                                    CFin{3}=CF3points{s}(:,iCF3);
                                                                    CFin{4}=CF4points{s}(:,iCF4);

                                                                    [VPin,CFin] = vehLogicZono4(Uin,VPin,CFin);
                                                                    VP1points{s+1} = [ VP1points{s+1} VPin{1}];
                                                                    VP2points{s+1} = [ VP2points{s+1} VPin{2}];
                                                                    VP3points{s+1} = [ VP3points{s+1} VPin{3}];
                                                                    VP4points{s+1} = [ VP4points{s+1} VPin{4}];

                                                                    CF1points{s+1} = [ CF1points{s+1} CFin{1}];
                                                                    CF2points{s+1} = [ CF2points{s+1} CFin{2}];
                                                                    CF3points{s+1} = [ CF3points{s+1} CFin{3}];
                                                                    CF4points{s+1} = [ CF4points{s+1} CFin{4}];

                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    VP1points{s+1} = unique(VP1points{s+1}','rows')';
    VP2points{s+1} = unique(VP2points{s+1}','rows')';
    VP3points{s+1} = unique(VP3points{s+1}','rows')';
    VP4points{s+1} = unique(VP4points{s+1}','rows')';
    CF1points{s+1} = unique(CF1points{s+1}','rows')';
    CF2points{s+1} = unique(CF2points{s+1}','rows')';
    CF3points{s+1} = unique(CF3points{s+1}','rows')';
    CF4points{s+1} = unique(CF4points{s+1}','rows')';
end
execBDD = toc


VP1BDDNPoints=length(VP1points{steps+1});
VP2BDDNPoints=length(VP2points{steps+1});
VP3BDDNPoints=length(VP3points{steps+1});
VP4BDDNPoints=length(VP4points{steps+1});
CF1BDDNPoints=length(CF1points{steps+1});
CF2BDDNPoints=length(CF2points{steps+1});
CF3BDDNPoints=length(CF3points{steps+1});
CF4BDDNPoints=length(CF4points{steps+1});

totalPointsBDD = VP1BDDNPoints + VP2BDDNPoints + CF1BDDNPoints + CF2BDDNPoints ...
               + VP3BDDNPoints + VP4BDDNPoints + CF3BDDNPoints + CF4BDDNPoints


if ~isequal(VP1PZdata,VP1points{steps+1})
    disp('VP1 problem')
else
    disp('VP1 success')
end

if ~isequal(VP2PZdata,VP2points{steps+1})
    disp('VP2 problem')
else
    disp('VP2 success')
end

if ~isequal(VP3PZdata,VP3points{steps+1})
    disp('VP3 problem')
else
    disp('VP3 success')
end

if ~isequal(VP4PZdata,VP4points{steps+1})
    disp('VP4 problem')
else
    disp('VP4 success')
end

if ~isequal(CF1PZdata,CF1points{steps+1})
    disp('CF1 problem')
else
    disp('CF1 success')
end

if ~isequal(CF2PZdata,CF2points{steps+1})
    disp('CF2 problem')
else
    disp('CF2 success')
end

if ~isequal(CF3PZdata,CF3points{steps+1})
    disp('CF3 problem')
else
    disp('CF3 success')
end

if ~isequal(CF4PZdata,CF4points{steps+1})
    disp('CF4 problem')
else
    disp('CF4 success')
end