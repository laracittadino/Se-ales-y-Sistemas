clear all;
clc;
close all;

% 1. Configura el canal y el número de época que quieres ver
canal_interes = 3;       % 1=Fz, 2=Cz, 3=Pz, 4=Oz, 5=C3, 6=C4
numero_de_epoca = 1;     % Cambia este número para ver la época 2, 3, etc.
nombres_canales = {'Fz','Cz','Pz','Oz','C3','C4'};

% 2. Cargar archivo CON P300 y extraer la época elegida
archivo_con = ['epocas_P300_C' int2str(canal_interes) '.dat'];
x_con = load(archivo_con); 
% Al trasponer, cada fila suele pasar a ser una muestra y cada columna una época.
% Aseguramos la orientación para extraer:
xcp300 = x_con'; 
una_epoca_con = xcp300(:, numero_de_epoca); 

% 3. Cargar archivo SIN P300 y extraer la misma época
archivo_sin = ['epocas_sinP300_C' int2str(canal_interes) '.dat'];
x_sin = load(archivo_sin);
xsp300 = x_sin';
una_epoca_sin = xsp300(:, numero_de_epoca);

% 4. Graficar la época individual
figure(1);
plot(una_epoca_con, 'b', 'LineWidth', 1.5); % Una sola época con P300 en azul
hold on;
plot(una_epoca_sin, 'r', 'LineWidth', 1.5); % Una sola época sin P300 en rojo

grid on;
title(['Canal: ' nombres_canales{canal_interes} ' - Época Individual Nº ' num2str(numero_de_epoca)]);
xlabel('Muestras (Tiempo)');
ylabel('Amplitud (\muV)');
legend('Una época con P300 (Target)', 'Una época sin P300 (No-Target)');