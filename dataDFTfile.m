function [d, t, f, P1] = dataDFTfile(filename)
%Import data from .lvm files, takes Discrete Fourier Transform of data
%Plots data, DFT, and DFT log. Returns data, time, frequency, and power
%dataDFT('filename.lvm') = [v, t, f, P1]
%Note: open lvm_import.m in same path

%Import data
lvmdata = lvm_import(filename);
rawdata = lvmdata.Segment1;
t = rawdata.data(:,1);
dt = rawdata.Delta_X;
V = rawdata.data(:,2);

%Convert voltage to displacement
d = V.*(.67);

%Compute Discrete Fourier Transform
L = length(d);
Z = fft(d);

P2 = abs(Z/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
Fs = dt^-1;
f = Fs*(0:(L/2))/L;

%find peak magnitude and location
%[pks, loc] = findpeaks(P1, f);

%sort from highest to lowest, take first 10 modes
%[psor, lsor] = findpeaks(P1, f, 'SortStr','descend');
%psor = psor(1:10);
%lsor = lsor(1:10);

%Output plots
f1 = figure;
f2 = figure;
f3 = figure;
%V(t)
figure(f1);
plot(t,d);
title('Deflection d(t)')
xlabel('t (s)')
ylabel('d (mm)')
%{
%F(V(t))
figure(f2);
plot(f,P1);
%findpeaks(P1,f)
title('Frequency spectrum of d(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%log(F)
figure(f3);
plot(f,P1);
%findpeaks(P1,f)
title('Log Frequency spectrum of V(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
set(gca,'yscale','log');
%}