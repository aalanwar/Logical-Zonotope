function [VPn,CFn] = vehLogicZono(U,VP,CF)


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




end