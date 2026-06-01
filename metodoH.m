clear all;
clc;
close all;

v = 1; % Parámetro de sensibilidad del PWS (podés probar con 1 o 2)

for c = 1:6
    % =====================================================================
    % 1. PROCESAMIENTO DE ÉPOCAS CON P300 (TARGET)
    % =====================================================================
    archivo = ['epocas_P300_C' int2str(c) '.dat'];
    x = load(archivo); 
    % x tiene dimensión [Muestras x Épocas]. Cada columna es un ensayo.
    
    [num_muestras, K] = size(x);
    
    % a) Promedio Aritmético Tradicional
    % mean(x, 2) promedia a lo largo de las columnas (épocas)
    promedios(c, :) = mean(x, 2)'; 
    
    % b) Método PWS
    fases = zeros(num_muestras, K);
    for k = 1:K
        % Calculamos la analítica de cada época (cada columna)
        senal_analitica = hilbert(x(:, k));
        fases(:, k) = angle(senal_analitica);
    end
    
    % Coherencia de fase
    suma_vectores_fase = sum(exp(1i * fases), 2);
    c_t = (1 / K) * (abs(suma_vectores_fase).^v);
    
    % El PWS es el promedio ponderado por la coherencia c(t)
    pws_promedios(c, :) = (mean(x, 2) .* c_t)'; 
end

% =========================================================================
% GRAFICACIÓN COMPARATIVA DE LOS 6 CANALES (SOLO P300)
% =========================================================================
figure(1);

% --- Gráfica Superior: Promedio Tradicional ---
subplot(2,1,1);
plot(promedios');
title('Promedio Aritmético Tradicional (6 Canales - Solo P300)');
ylabel('Amplitud (\muV)');
grid on;
legend('Fz','Cz','Pz','Oz','C3','C4'); 

% --- Gráfica Inferior: Apilamiento Ponderado por Fase (PWS) ---
subplot(2,1,2);
plot(pws_promedios');
title('Apilamiento Ponderado por Fase - PWS (6 Canales - Solo P300)');
xlabel('Muestras (Tiempo)');
ylabel('Amplitud (\muV)');
grid on;
legend('Fz','Cz','Pz','Oz','C3','C4');