function [f, P1] = dataDFT(V, t, dt)
%Discrete Fourier Transform of input data
%Plots data, DFT, and DFT log. Returns peaks and FT function
%dataDFT(V, t, dt) = [P1 f p l]

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
title('Log Frequency spectrum of d(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
set(gca,'yscale','log');