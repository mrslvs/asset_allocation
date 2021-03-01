%uloha3
%isid92654
space_down = zeros(1,5);
space_up = ones(1,5) * 2500000;
space = [space_down; space_up];
pop_size = 200;
cycles = 1000;

population = genrpop(pop_size, space);
vec_of_best_ones = [20, 15, 10];

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
    profit(i,:) = fitness_three_fee(population, pop_size);    
    best_individuals(i) = min(profit(i));
    
    temp_best = selbest(population, profit(i, :), vec_of_best_ones);
    
    work = selsus(population, profit(i, :), 155);
    
    work = crossov(work, 1, 0);
    work = mutx(work, 0.8, space);
    
    population = [temp_best; work];
end

hold on
plot(best_individuals);

function F = fitness_fee(population, pop_size)
%returns row of function values
    for i=1:pop_size
        fit = fitness(population(i, :));
        cond_matrix = conditions(population(i, :));
        fee = infringement_rate(cond_matrix);
        F(i) = (fit + fee) * -1; %F(max) = -F(min)
    end
end

function [F] = fitness_three_fee(population, pop_size)
%returns row of function values
    for i=1:pop_size
        fit = fitness(population(i, :));
        cond_matrix = conditions(population(i, :));
        
        %penalties
        fee = 0;
        if cond_matrix(1) == 1
            fee = fee + death_penalty();
        elseif cond_matrix(4) == 1
            fee = fee + infringement_rate(cond_matrix);
        else
            fee = fee + proportionate(population(i,:), cond_matrix);
        end
        
        F(i) = (fit * -1) + fee; %F(max) = -F(min)
    end
end

function fee = proportionate(individual, cond_matrix)
%umerna
    fee = 0;
    if cond_matrix(2) == 1
        x = individual(1) + individual(2) - 2500000;
        fee = fee + x;
    end
    
    if cond_matrix(3) == 1
        x = individual(5) - individual(4); %x4 must be bigger
        fee = fee + x;
    end
    
    if cond_matrix(4) == 1
        x = 0.5 * (i(3) + i(4) - i(1) - i(2) - i(5));
        fee = fee + x
    end
end

function fee = death_penalty()
    fee = 1000000000;
end

function fee = infringement_rate(cond_matrix)
%stupnova
    alpha = 1000;
    fee = alpha^(sum(cond_matrix));
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