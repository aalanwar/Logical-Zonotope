
clear all
close all

for i =2:2:80
  K{i} = randi([0 1]);
  IV{i} = randi([0 1]);
end
for i =1:2:79
  K{i} = randi([0 1]);
  IV{i} = randi([0 1]);
end

[s,z] =trivium(K,IV,1000);

m{1} = [1];
c{1}= xor(z{1},m{1})
