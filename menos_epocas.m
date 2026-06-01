clear all;
clc;
close all;

% =========================================================================
% PARÁMETROS CONFIGURABLES
% =========================================================================
v = 1;          % Parámetro de sensibilidad del PWS (1 o 2)
K_pws = 200;     % <--- CAMBIÁ ESTE VALOR para controlar épocas del PWS

% =========================================================================
% PROCESAMIENTO DE ÉPOCAS CON P300 (TARGET)
% =========================================================================
for c = 1:6
    archivo = ['epocas_P300_C' int2str(c) '.dat'];
    x = load(archivo);
    % x tiene dimensión [Muestras x Épocas]. Cada columna es un ensayo.
    [num_muestras, K_total] = size(x);

    % -----------------------------------------------------------------
    % a) Promedio Aritmético Tradicional — USA TODAS LAS ÉPOCAS (K_total)
    % -----------------------------------------------------------------
    promedios(c, :) = mean(x, 2)';

    % -----------------------------------------------------------------
    % b) Método PWS — USA SOLO K_pws ÉPOCAS (subconjunto)
    % -----------------------------------------------------------------
    % Validación: no pedir más épocas de las disponibles
    K_usar = min(K_pws, K_total);
    x_sub = x(:, 1:K_usar);   % Tomamos las primeras K_usar épocas

    fases = zeros(num_muestras, K_usar);
    for k = 1:K_usar
        senal_analitica = hilbert(x_sub(:, k));
        fases(:, k) = angle(senal_analitica);
    end

    % Coherencia de fase
    suma_vectores_fase = sum(exp(1i * fases), 2);
    c_t = (1 / K_usar) * (abs(suma_vectores_fase).^v);

    % PWS = promedio aritmético del subconjunto × coherencia de fase
    pws_promedios(c, :) = (mean(x_sub, 2) .* c_t)';
end

% =========================================================================
% GRAFICACIÓN COMPARATIVA DE LOS 6 CANALES
% =========================================================================
eje_tiempo = (0:num_muestras-1);   % eje X en muestras

figure(1);
set(gcf, 'Name', 'Comparación Promedio Aritmético vs PWS', 'NumberTitle', 'off');

% --- Gráfica Superior: Promedio Aritmético con TODAS las épocas ---
subplot(2,1,1);
plot(eje_tiempo, promedios');
title(sprintf('Promedio Aritmético Tradicional — TODAS las épocas (K = %d)', K_total));
ylabel('Amplitud (\muV)');
grid on;
legend('Fz','Cz','Pz','Oz','C3','C4', 'Location', 'best');
xlim([0, num_muestras-1]);

% --- Gráfica Inferior: PWS con K_pws épocas (configurable) ---
subplot(2,1,2);
plot(eje_tiempo, pws_promedios');
title(sprintf('Apilamiento Ponderado por Fase (PWS) — K = %d épocas  |  v = %d', K_usar, v));
xlabel('Muestras');
ylabel('Amplitud (\muV)');
grid on;
legend('Fz','Cz','Pz','Oz','C3','C4', 'Location', 'best');
xlim([0, num_muestras-1]);