clear all;
clc;
close all;

for c=1:6
    archivo=['epocas_P300_C' int2str(c) '.dat'];
    x=load(archivo);
    xcp300=x';
   promedios(c,:)=mean(xcp300);
    archivo=['epocas_sinP300_C' int2str(c) '.dat'];
    x=load(archivo);
    xsp300=x';
    promedios_sp(c,:)=mean(xsp300);
end;

% Graficación del promedios en un solo canal
figure(1);
plot(promedios');
legend('Fz','Cz','Pz','Oz','C3','C4');
hold on;
plot(promedios_sp','r');
legend('Fz','Cz','Pz','Oz','C3','C4');

