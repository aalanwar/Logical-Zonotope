function [neighbor_set, vis_set] = env()

% neighbor sets
neighbor_set = {};
neighbor_set{1} = [1 2 6];
neighbor_set{2} = [1 2 3 7];
neighbor_set{3} = [2 3 4 8];
neighbor_set{4} = [3 4 5];
neighbor_set{5} = [4 5 9];
neighbor_set{6} = [1 6 7 10];
neighbor_set{7} = [2 6 7 8 11];
neighbor_set{8} = [3 7 8];
neighbor_set{9} = [5 9 13];
neighbor_set{10} = [6 10 11 14];
neighbor_set{11} = [7 10 11];
neighbor_set{12} = [12 13];
neighbor_set{13} = [9 12 13 16];
neighbor_set{14} = [10 14 17];
neighbor_set{15} = [15 19];
neighbor_set{16} = [13 16 21];
neighbor_set{17} = [14 17 18];
neighbor_set{18} = [17 18 19];
neighbor_set{19} = [15 18 19 20];
neighbor_set{20} = [19 20 21];
neighbor_set{21} = [16 20 21];

% visibility sets
vis_set = {};
vis_set{1} = [1 2 3 4 5 6 7 8 10 11 14 17];
vis_set{2} = [1 2 3 4 5 6 7 8 10 11];
vis_set{3} = [1 2 3 4 5 6 7 8 10];
vis_set{4} = [1 2 3 4 5];
vis_set{5} = [1 2 3 4 5 9 13 16 21];
vis_set{6} = [1 2 3 6 7 8 10 11 14 17];
vis_set{7} = [1 2 3 6 7 8 10 11];
vis_set{8} = [1 2 3 6 7 8];
vis_set{9} = [5 9 13 16 21];
vis_set{10} = [1 2 3 6 7 10 11 14 17];
vis_set{11} = [1 2 6 7 10 11];
vis_set{12} = [12 13];
vis_set{13} = [5 9 12 13 16 21];
vis_set{14} = [1 6 10 14 17];
vis_set{15} = [15 19];
vis_set{16} = [5 9 13 16 21];
vis_set{17} = [1 6 10 14 17 18 19 20 21];
vis_set{18} = [17 18 19 20 21];
vis_set{19} = [15 17 18 19 20 21];
vis_set{20} = [17 18 19 20 21];
vis_set{21} = [5 9 13 16 17 18 19 20 21];

end

