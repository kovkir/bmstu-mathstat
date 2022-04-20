function lab_1()
    % Выборка объема n из генеральной совокупности X
    X = csvread('X.csv');

    X = sort(X);
    n = length(X);
    
    fprintf("a) Вычисление максимального значения Mmax и минимального значения Mmin\n");
    
    Mmax = max(X);
    Mmin = min(X);
    
    fprintf("\nMmax = %.4f\n", Mmax);
    fprintf("\nMmin  = %.4f\n", Mmin);
    
    fprintf("\nb) Вычисление размаха R\n");

    R = Mmax - Mmin;
    fprintf("\nR = %.4f\n", R);
    
    fprintf("\nc) Вычисление оценок Mu и S_quad математического ожидания MX и дисперсии DX\n");
    
    Mu = sum(X) / n; % Выборочное среднее
    S_quad = sum((X - Mu) .^2) / (n - 1); % Исправленная выборочная дисперсия
    
    fprintf("\nMu = %.4f\n", Mu);
    fprintf("\nS_quad = %.4f\n", S_quad);
    
    
    
    fprintf("\nd) Группировка значений выборки в m = [log2 n] + 2 интервала\n\n");
    
    % Поиск количества интервалов
    % floor(X) - возвращает значения, округленные до ближайшего целого <= X
    m = floor(log2(n)) + 2; 
    fprintf("Кол-во интервалов m = %3d\n\n", m);
    
    % Ширина интервала
    delta = (X(n) - X(1)) / m;
    
    % Нахождение границ интервалов
    borders = Mmin : delta : Mmax;
    
    % Массив с кол-вом элементов выборки, попавших в i-ый промежуток
    ni_arr = zeros(m, 1); 
    
    for i = 1 : (m) 
        count = 0; % Кол-во значений в i-том интервале
        
        for x = X
            % Последний интервал включает в себя крайнее правое значение
            if (i == m) && (x >= borders(i)) && (x <= borders(i + 1))
                count = count + 1;
            % Остальные интервалы включают только слева 
            elseif (x >= borders(i)) && (x < borders(i + 1))
                count = count + 1;
            endif
        endfor
        
        if (i == m)
            fprintf(" %d. [%.3f; %.3f], кол-во элементов: %d\n", i, borders(i), borders(i + 1), count);
        else
            fprintf(" %d. [%.3f; %.3f), кол-во элементов: %d\n", i, borders(i), borders(i + 1), count);
        endif
        
        ni_arr(i) = count;
    endfor

    
    
    fprintf("\ne) Построение на одной координатной плоскости гистограммы\
             \n   и графика функции плотности распределния вероятностей\
             \n   нормальной случайной величины с математическим\
             \n   ожиданием Mu и дисперсие S_quad\n\n"); 
    
    % Гистограмма
    
    mid_intervals = zeros(m, 1);
    
    for i = 1 : m
        mid_intervals(i) = (borders(i) + borders(i + 1)) / 2;
    endfor
    
    column_values = zeros(m, 1);
    
    for i = 1 : m
        column_values(i) = ni_arr(i) / (n * delta);
    endfor
    
    % Отрисовка гистограммы
    bar(mid_intervals, column_values, 1, 'b');
    hold on;
    
    % График функции плотности нормального распределения 
    
    % Набор значений
    x_coords = (Mmin - 1) : 1e-3 : (Mmax + 1);
    
    % normpdf - функция плотности нормального распределения
    func_density_norm = normpdf(x_coords, Mu, sqrt(S_quad)); 
    
    % Отрисовка графика плоности нормального распределения 
    plot(x_coords, func_density_norm, 'r', 'LineWidth', 2);
    grid;
    
    
    
    fprintf("\nd) Построение на другой координатной плоскости графика\
             \n   эмпирической функции распределения и функции\
             \n   распределения нормальной случайной величины с\
             \n   математическим ожиданием Mu и S_quad\n\n");   
    
    % Эмпирической функции распределния

    t_arr = zeros(1, n + 2);
    
    t_arr(1)     = X(1) - 1;
    t_arr(n + 2) = X(n) + 1;
    
    for ind = 2 : n + 1
        t_arr(ind) = X(ind - 1);
    endfor
    
    % Значения эмпирической функции распреления
    func_emperic = zeros(length(t_arr), 1);
    
    for i = 1 : length(t_arr)
        count = 0;
        
        for j = 1: n
            if X(j) <= t_arr(i)
                count = count + 1;
            endif
        endfor
        
        func_emperic(i) = count / n;
    endfor
    
    figure();
    
    % Отрисовка эмпирической функции распределения
    stairs(t_arr, func_emperic, 'b', 'LineWidth', 1);
    hold on;
    
    % График функции нормального распределения 
    
    % Набор значений
    x_coords = (Mmin - 1) : 1e-3 : (Mmax + 1);
    
    % normсdf - функция нормального распределения
    func_norm = normcdf(x_coords, Mu, sqrt(S_quad));
    
    % Отрисовка графика нормального распределения 
    plot(x_coords, func_norm, 'r', 'LineWidth', 1);
    grid;
    
endfunction
