function lab_2()
    clc
    
    % Было в защите
    % Объяснить, почему график S^2(Xn) сначала резко растет, а потом падает
    % X = 10 * csvread('X.csv');
    % X = [X zeros(1, 300) - 110];

    X = csvread('X.csv');
    n = length(X);

    % Вычисление выборочного среднего
    mu = sum(X) / n;
    fprintf("Выборочное среднее = %.4f\n", mu);
    
    % Вычисление исправленной выборочной дисперсии
    if (n > 1)
        s2 = sum((X - mu) .^2) / (n - 1);
    else
        s2 = 0;
    endif

    fprintf("Исправленная выборочная дисперсия = %.4f\n", s2);
    

    gamma = 0.9;
    alpha = (1 - gamma) / 2;
    
    % Вычисление доверительных интервалов

    % m - неизвестно, 
    % sigma - неизвестно,
    % Оценить m

    quant_st = tinv((1 - alpha), (n - 1));
    
    lower_m = mu - (quant_st * sqrt(s2) / sqrt(n));
    upper_m = mu + (quant_st * sqrt(s2) / sqrt(n));

    fprintf("\nНижняя граница gamma-доверительного интервала для mu = %.4f\n", lower_m);
    fprintf("Верхняя граница gamma-доверительного интервала для mu = %.4f\n", upper_m);

    fprintf("\ngamma-доверительный интервал для mu: (%.4f, %.4f)\n", lower_m, upper_m);
    
    % sigma - неизвестно
    % Оценить sigma^2

    quant_xi2_lower = chi2inv((1 - alpha), (n - 1));
    quant_xi2_upper = chi2inv(alpha, (n - 1));
    
    lower_sigma = s2 * (n - 1) / quant_xi2_lower;
    upper_sigma = s2 * (n - 1) / quant_xi2_upper;

    fprintf("\nНижняя граница gamma-доверительного интервала для sigma = %.4f\n", lower_sigma);
    fprintf("Верхняя граница gamma-доверительного интервала для sigma = %.4f\n", upper_sigma);

    fprintf("\ngamma-доверительный интервал для sigma: (%.4f, %.4f)\n", lower_sigma, upper_sigma);
    
    % Построение графиков для задания 3 а)
    
    mu_arr = zeros(n, 1);
    s2_arr = zeros(n, 1);
    
    for i = 1 : n
        X_part = X(1 : i);

        mu_arr(i) = sum(X_part) / i;

        if (i > 1)
            s2_arr(i) = sum((X_part - mu_arr(i)) .^2) / (i - 1);
        else
            s2_arr(i) = 0;
        endif
    endfor
    
    mu_line = zeros(n, 1);
    mu_line(1 : n) = mu_arr(n);
    
    mu_lower = zeros(n, 1);
    mu_upper = zeros(n, 1);
    
    for i = 1 : n
        quant_st = tinv((1 - alpha), (i - 1));

        mu_lower(i) = mu_arr(i) - (quant_st * sqrt(s2_arr(i)) / sqrt(i));
        mu_upper(i) = mu_arr(i) + (quant_st * sqrt(s2_arr(i)) / sqrt(i)); 
    endfor
    
    % Графики
    plot((10 : n), mu_line(10 : n), 'r', 'LineWidth', 1);
    hold on;
    plot((10 : n), mu_arr(10 : n), 'g', 'LineWidth', 1);
    hold on;
    plot((10 : n), mu_upper(10 : n), 'b', 'LineWidth', 1);
    hold on;
    plot((10 : n), mu_lower(10 : n), 'k', 'LineWidth', 1);
    hold on;
    
    grid on;
    xlabel("n");
    ylabel('\mu');

    legend('\mu\^(x_N)', '\mu\^(x_n)', '\mu^{-}(x_n)', '\mu_{-}(x_n)');

    % Построение графиков для задания 3 b)

    figure()
    
    mu_arr = zeros(n, 1);
    s2_arr = zeros(n, 1);
    
    for i = 1 : n
        X_part = X(1 : i);

        mu_arr(i) = sum(X_part) / i;

        if (i > 1)
            s2_arr(i) = sum((X_part - mu_arr(i)) .^2) / (i - 1);
        else
            s2_arr(i) = 0;
        endif
    endfor
    
    s2_line = zeros(n, 1);
    s2_line(1 : n) = s2_arr(n);
    
    s2_lower = zeros(n, 1);
    s2_upper = zeros(n, 1);
    
    for i = 1 : n
        quant_xi2_lower = chi2inv((1 - alpha), (i - 1));
        quant_xi2_upper = chi2inv(alpha, (i - 1));

        s2_lower(i) = s2_arr(i) * (i - 1) / quant_xi2_lower;
        s2_upper(i) = s2_arr(i) * (i - 1) / quant_xi2_upper; 
    endfor
    
    % Графики
    plot((10 : n), s2_line(10 : n), 'r', 'LineWidth', 1);
    hold on;
    plot((10 : n), s2_arr(10 : n), 'g', 'LineWidth', 1);
    hold on;
    plot((10 : n), s2_upper(10 : n), 'b', 'LineWidth', 1);
    hold on;
    plot((10 : n), s2_lower(10 : n), 'k', 'LineWidth', 1);
    hold on;
    
    grid on;
    xlabel("n");
    ylabel('\sigma');
    
    legend('S^2(x_N)', 'S^2(x_n)', '\sigma^{2 -}(x_n)', '\sigma^2_{-}(x_n)');

endfunction
