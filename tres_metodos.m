clear all;
clc;
close all;

% =========================================================================
% PARÁMETROS DE EVALUACIÓN
% =========================================================================
K_prueba = 20; % Cantidad de épocas reducidas para poner a prueba los algoritmos
v = 1;         % Parámetro de sensibilidad del PWS

for c = 1:6
    % Cargamos la base de datos (dimensión nativa: 1025 muestras x 600 épocas)
    archivo = ['epocas_P300_C' int2str(c) '.dat'];
    x_completo = load(archivo); 

    [num_muestras, K_total] = size(x_completo); 

    % =====================================================================
    % 1. CONTROL IDEAL: Promedio Tradicional (K = 600)
    % =====================================================================
    promedio_ideal(c, :) = mean(x_completo, 2)'; 

    % =====================================================================
    % PREPARACIÓN PARA LAS PRUEBAS CON POCAS ÉPOCAS (K = 20)
    % =====================================================================
    x_prueba = x_completo(:, 1:K_prueba); 
    promedio_pocos = mean(x_prueba, 2); % Promedio ruidoso base para K=20

    % =====================================================================
    % 2. MÉTODO A: Apilamiento Ponderado por Fase (PWS)
    % =====================================================================
    fases = zeros(num_muestras, K_prueba);
    for k = 1:K_prueba
        senal_analitica = hilbert(x_prueba(:, k));
        fases(:, k) = angle(senal_analitica);
    end

    suma_vectores_fase = sum(exp(1i * fases), 2);
    c_t = (1 / K_prueba) * (abs(suma_vectores_fase).^v);

    pws_prueba(c, :) = (promedio_pocos .* c_t)'; 

    % =====================================================================
    % 3. MÉTODO B: Transformada Discreta Wavelet (DWT)
    % =====================================================================
    % Aplicamos la metodología del paper: Wavelet Biortogonal 5.5 con 5 niveles
    % wdenoise aplica la descomposición, umbralamiento de ruido y reconstrucción
    dwt_prueba(c, :) = wdenoise(promedio_pocos, 5, 'Wavelet', 'bior5.5', 'DenoisingMethod', 'UniversalThreshold')';

    % Nota: Si tu MATLAB es de una versión más antigua y tira error con 'wdenoise', 
    % reemplazá la línea de arriba por esta:
    % dwt_prueba(c, :) = wden(promedio_pocos, 'sqtwolog', 's', 'mln', 5, 'bior5.5')';
end

% =========================================================================
% GRAFICACIÓN COMPARATIVA (3 SUBPLOTS)
% =========================================================================
figure(1);

% --- 1. Estándar de Oro ---
subplot(3,1,1);
plot(promedio_ideal', 'LineWidth', 1.2);
title(['Control Ideal: Promedio Aritmético (K = ' num2str(K_total) ' épocas)']);
ylabel('Amplitud (\muV)');
grid on;
legend('Fz','Cz','Pz','Oz','C3','C4'); 

% --- 2. Método PWS ---
subplot(3,1,2);
plot(pws_prueba', 'LineWidth', 1.2);
title(['Método A: Apilamiento Ponderado por Fase - PWS (K = ' num2str(K_prueba) ' épocas)']);
ylabel('Amplitud (\muV)');
grid on;

% --- 3. Método DWT ---
subplot(3,1,3);
plot(dwt_prueba', 'LineWidth', 1.2);
title(['Método B: Transformada Wavelet DWT Bior5.5 (K = ' num2str(K_prueba) ' épocas)']);
xlabel('Muestras (Tiempo)');
ylabel('Amplitud (\muV)');
grid on;