%uloha3
%isid92654
space_down = zeros(1,5);
space_up = ones(1,5) * 2500000;
space = [space_down; space_up];
pop_size = 200;

population = genrpop(pop_size, space);

function bool = first_cond(individual)
    bool = 0;
    if sum(individual) > 10000000
        bool = 1;
    end
end

function bool = second_cond(individual)
    bool = 0;
    if individual(1) + individual(2) > 2500000
        bool = 1;
    end
end

function bool = third_cond(individual)
    bool = 0;
    if individual(5) - individual(4) > 0
        bool = 1;
    end
end

function bool = fourth_cond(i)
    bool = 0;
    if (0.5 * (i(3) + i(4) - i(1) - i(2) - i(5))) > 0
        bool = 1;
    end
end