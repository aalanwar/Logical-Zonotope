%clear all
close all
% figure
% hold on
%  a = 0.09;%2.684;%h2
%  fimplicit(@(x1,x2) abs(hNonLinear1([x1,x2],0))-a,'-.*k')

a = 0.3225;%2.684;%h2
fimplicit(@(x1,x2) abs(x1-1.6375)-a,'-.*b')
a =0.2175;
fimplicit(@(x1,x2) abs(x2-0.7895)-a,'-.*b')


a = 2.56;% 2.56;%h21
fimplicit(@(x1,x2) abs(hNonLinear21([x1,x2],0))-a,'-.*b')
a = 1.3045 ;%2.684;%h2
fimplicit(@(x1,x2) abs(hNonLinear22([x1,x2],0))-a,'-.*k')
a =  1.453;%2.684;%h2
fimplicit(@(x1,x2) abs(hNonLinear23([x1,x2],0))-a,'-.*r')


a = 0.0171;% 2.56;%h21
fimplicit(@(x1,x2) abs(hangle([x1,x2],0))-a,'-.*b')

figure
hold on
index=1;
for x1=-1.4:0.1:1.9
    for x2=-0.6:0.1:2.3
      pt= hNonLinear2([x1,x2],0);
      plot3(x1,x2,pt,'r*')
      pts(index) = pt; 
      index=index+1;
    end  
end

max(pts)