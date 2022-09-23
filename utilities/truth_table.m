function T = truth_table(N)
% Truth Table Generator
% Mustafa U. Torun (Jan, 2010)
% ugur.torun@gmail.com
%
% T = truth_table(N);
%
% Inputs:
% N: Number of bits;
%
% Outputs:
% T: Truth Table;
% 
% Example:
% T = truth_table(2)
% T =
%     0     0
%     0     1
%     1     0
%     1     1
L = 2^N;
T = zeros(L,N);
for i=1:N
   temp = [zeros(L/2^i,1); ones(L/2^i,1)];
   T(:,i) = repmat(temp,2^(i-1),1);
end




% g = 2;
% i2 = 2^N;
% T = false(i2,N);
% for m = 1 : 1 : N
%     m2 = 2^m;
%     m3 = (m2/2)-1;
%     i3 = N-m+1;
%     for g = g : m2 : i2
%         for k = 0 : 1 : m3
%             T(g+k,i3) = true;
%         end
%     end
%     g = m2+1;
% end