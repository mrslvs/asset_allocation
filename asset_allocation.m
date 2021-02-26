%uloha3
%isid92654
space_down = zeros(1,5);
space_up = ones(1,5) * 2500000;
space = [space_down; space_up];
pop_size = 200;

population = genrpop(pop_size, space);