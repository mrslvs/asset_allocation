%task3
%isid92###
space_down = zeros(1,5); %lowest value
space_up = ones(1,5) * 2500000; %highest value
space = [space_down; space_up];
global pop_size;
pop_size = 200;
cycles = 2000;

population = genrpop(pop_size, space);
vec_of_best_ones = [20, 15, 10];


for i=1:cycles
    %choose the penalty method
    
    %profit(i,:) = fitness_proportionate(population, pop_size);
    profit(i,:) = fitness_infringement(population);
    %profit(i,:) = fitness_penalty_mashup(population, pop_size);
    
    best_individuals(i) = max(profit(i, :));
    temp_best = selbest(population, -profit(i, :), vec_of_best_ones);
    diff = pop_size - sum(vec_of_best_ones);
    work = seltourn(population, -profit(i, :), diff);
    
    %mutate and cross
    work = crossov(work, 1, 0);
    work = mutx(work, 0.2, space); 
    amp = ones(1,5) * 30000;
    work = muta(work, 0.9, amp, space);
    
    population = [temp_best; work];
end

hold on
plot(best_individuals);

function F = fitness_penalty_mashup(pop)
%using every penalty method
    global pop_size;
    
    for i=1:pop_size
        fit = fitness(pop(i, :));
        cond_matrix = conditions(pop(i, :));
        
        %penalties
        fee = 0;
        
        if sum(cond_matrix) == 4
            fee = fee + death_penalty();
        elseif cond_matrix(2) == 1
            fee = fee + ((pop(i,1) + pop(i,2)) - 2500000);
        elseif cond_matrix(3) == 1
            fee = fee + (pop(i,5) - pop(i,4));
        elseif cond_matrix(4) == 1
            fee = fee + (0.5 * (pop(i,3) + pop(i,4) - pop(i,1) - pop(i,2) - pop(i,5)));
        end
           
        fee = fee + (10000 ^ sum(cond_matrix));
        
        F(i) = fit - fee; %F(max) = -F(min)
    end
end

function F = fitness_proportionate(population)
    global pop_size;
    for i=1:pop_size
        fit = fitness(population(i, :));
        cond_matrix = conditions(population(i, :));
        
        fee = proportionate(population(i, :), cond_matrix); %penalty
        F(i) = fit - fee;
    end
end

function F = fitness_infringement(population)
    global pop_size;
    for i=1:pop_size
        fit = fitness(population(i, :));
        cond_matrix = conditions(population(i, :));
        
        fee = infringement_rate(cond_matrix); %penalty
        F(i) = fit - fee;
    end
end

function fee = proportionate(i, cond_matrix)
    fee = 0;
    
    if cond_matrix(1) == 1
        x = sum(i) - 10000000;
        fee = fee + x;
    end
    
    if cond_matrix(2) == 1
        x = (i(1) + i(2)) - 2500000;
        fee = fee + x;
    end
    
    if cond_matrix(3) == 1
        x = i(5) - i(4); %x4 must be bigger
        fee = fee + x;
    end
    
    if cond_matrix(4) == 1
        x = 0.5 * (i(3) + i(4) - i(1) - i(2) - i(5));
        fee = fee + x;
    end
end

function fee = death_penalty()
    fee = 100000000;
end

function fee = infringement_rate(cond_matrix)
    alpha = 1000;
    fee = alpha^(sum(cond_matrix));
end

function fit = fitness(i)
%argument is individual = money to be invested
%returns possible earnings for investments in 5 different assets
    temp1 = 0.04 * i(1);
    temp2 = 0.07 * i(2);
    temp3 = 0.11 * i(3);
    temp4 = 0.06 * i(4);
    temp5 = 0.05 * i(5);
    
    fit = temp1 + temp2 + temp3 + temp4 + temp5;
end

function cond_matrix = conditions(individual)
%check conditions for the individual
%0 = condition met
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
    if (individual(1) + individual(2)) > 2500000
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