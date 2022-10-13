function [x,xn,xu,xnu,u] = vehLogic(U,VP,CF)


VPn{1} = or(U{1} & U{3} & not(CF{2}), U{1});	
VPn{2} =or(U{2} &U{4}&not(CF{1})& VP{1},VP{2});	
% VPn{3} =or(U{3},U{1} &U{2} &not(VP{2})&not(VP{3})&CF{3});	
% VPn{4} =or(U{4},U{1} &U{2} &not(VP{1})&not(VP{4})&CF{4});	

CFn{1} =or(U{3},and(U{1},not(VPn{1})));	
CFn{2} =or(U{4},and(U{2},not(VPn{2})));	
% CFn{3} =or(U{1}, and(or(and(not(VP{3}),VPn{3}),U{1}),not(VPn{3})));	
% CFn{4} =or(U{2}, and(or(and(not(VP{4}),VPn{4}),U{2}),not(VPn{4})));


% VPn{1} = not(VP{2}) & not(VP{4}) & not(VP{1}) & CF{1} & not(CF{2}) & not(CF{4});	
% VPn{2} = not(VP{1})&  not(VP{3})&  not(VP{2})&CF{2}&not(CF{1})&not(CF{3});
% VPn{3} =not(VP{2})&not(VP{3})&CF{3};	
% VPn{4} =not(VP{1})&not(VP{4})&CF{4};	
% 
% CFn{1} =and(or(and( not(VP{1}),VPn{1}) ,U{1}),not(VPn{1}));	
% CFn{2} =and(or(and(not(VP{2}),VPn{2}),U{2}),not(VPn{2}));	
% CFn{3} = and(or(and(not(VP{3}),VPn{3}),CF{3}),not(VPn{3}));	
% CFn{4} = and(or(and(not(VP{4}),VPn{4}),CF{4}),not(VPn{4}));


for i=1:4
    if U{i}==0
        U{i} = [0;1];
    else
        U{i} = [1;0];        
    end
end    
for i=1:2
%     if U{i}==0
%         U{i} = [0;1];
%     else
%         U{i} = [1;0];        
%     end
    if VP{i}==0
        VP{i} = [0;1];
    else
        VP{i} = [1;0];        
    end
    if VPn{i}==0
        VPn{i} = [0;1];
    else
        VPn{i} = [1;0];        
    end
    if CF{i}==0
        CF{i} = [0;1];
    else
        CF{i} = [1;0];        
    end
    if CFn{i}==0
        CFn{i} = [0;1];
    else
        CFn{i} = [1;0];        
    end
end

u= semiKron(U{1},semiKron(U{2},semiKron(U{3},U{4})));
%u= semiKron(U{1},U{2});
xVP = semiKron(VP{1},VP{2});
xCF = semiKron(CF{1},CF{2});
%xVP = semiKron(VP{1},semiKron(VP{2},semiKron(VP{3},VP{4})));
%xCF = semiKron(CF{1},semiKron(CF{2},semiKron(CF{3},CF{4})));

xu = semiKron(u,semiKron(xVP,xCF));
x = semiKron(xVP,xCF);

%xVPn = semiKron(VPn{1},semiKron(VPn{2},semiKron(VPn{3},VPn{4})));
%xCFn = semiKron(CFn{1},semiKron(CFn{2},semiKron(CFn{3},CFn{4})));
xVPn = semiKron(VPn{1},VPn{2});
xCFn = semiKron(CFn{1},CFn{2});
xnu = semiKron(u,semiKron(xVPn,xCFn));
xn = semiKron(xVPn,xCFn);

end