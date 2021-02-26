%uloha3
%isid92654
space_down = zeros(1,5);
space_up = ones(1,5) * 2500000;
space = [space_down; space_up];
pop_size = 200;
cycles = 10000;

population = genrpop(pop_size, space);
vec_of_best_ones = [25, 15, 10];

%test
%test_individual = [1, 2500000, 2500002, 2500000, 2500000];
%cond_matrix = conditions(test_individual);
%fit = fitness(test_individual);
%fee = infringement_rate(cond_matrix);
%F = fit - fee;

%best = [0, 2500000, 2500000, 2500000, 2500000];
%for i=1:pop_size
%    population(i,:) = best;
%end

for i=1:cycles
    profit(i,:) = fitness_fee(population, pop_size);
    best_individuals(i) = max(profit(i));
    
    temp_best = selbest(population, profit(i), vec_of_best_ones);
    %population = mutx(
end

plot(best_individuals);

function F = fitness_fee(population, pop_size)
%returns row of function values
    for i=1:pop_size
        fit = fitness(population(i, :));
        cond_matrix = conditions(population(i, :));
        fee = infringement_rate(cond_matrix);
        F(i) = fit - fee;
    end
end

function fee = infringement_rate(cond_matrix)
    if sum(cond_matrix) == 0
        fee = 0;
    else
        alpha = 100;
        fee = alpha^(sum(cond_matrix));
    end
end

function fit = fitness(i)
    temp1 = 0.04 * i(1);
    temp2 = 0.07 * i(2);
    temp3 = 0.11 * i(3);
    temp4 = 0.06 * i(4);
    temp5 = 0.05 * i(5);
    
    fit = temp1 + temp2 + temp3 + temp4 + temp5;
end

function cond_matrix = conditions(individual)
    cond_matrix = zeros(1,4);
    
    cond_matrix(1) = first_cond(individual);
    cond_matrix(2) = second_cond(individual);
    cond_matrix(3) = third_cond(individual);
    cond_matrix(4) = fourth_cond(individual);
end

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