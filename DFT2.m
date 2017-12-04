function [P1, f, dn, tn] = DFT2(filename,cal_fac)
%Import PSD file, choose time range, performs DFT on data.
%Plots deflection and freq. spectrum. Returns calibrated deflection, time, 
%power, and frequency arrays
%[p(power),f(frequency),dn(deflection),tn(time)] = DFT2(filename,cal_factor)

%Import data and convert from .lvm
lvmdata = lvm_import(filename);
rawdata = lvmdata.Segment1;
t = rawdata.data(:,1);
dt = rawdata.Delta_X;
V = rawdata.data(:,2);

%Convert voltage to displacement
d = V.*(cal_fac);

%Plot deflection for time range selection
dfig = figure;
figure(dfig);
plot(t,d);
title('Deflection d(t)')
xlabel('t (s)')
ylabel('d (mm)')

% Initialize data cursor object
cursorobj = datacursormode(dfig);

while ~waitforbuttonpress 
    % waitforbuttonpress returns 0 with click, 1 with key press
    % Does not trigger on ctrl, shift, alt, caps lock, num lock, or scroll lock
    cursorobj.Enable = 'on'; % Turn on the data cursor, hold alt to select multiple points
end
cursorobj.Enable = 'off';

%Get data from cursor points
pts = getCursorInfo(cursorobj);

%Extract t data
[pos2, pos1] = pts.Position;
t1 = pos1(1);
t2 = pos2(1);

%Compute average 0 point
d01 = pos1(2);
d02 = pos2(2);

d0_av = mean([d01 d02]);

%Order t points
if t1 > t2
    t11 = t1;
    t22 = t2;
    t1 = t22;
    t2 = t11;
end

%Define variables over new range
tn = t(t1*10000:t2*10000);
dn = d(t1*10000:t2*10000)-d0_av;

%Compute DFT
L = length(dn);
Z = fft(dn);

P2 = abs(Z/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
Fs = dt^-1;
f = Fs*(0:(L/2))/L;

%Output plots
f1 = figure;
%f2 = figure;

%d(t)
figure(f1);
plot(tn,dn);
title('Deflection d(t)')
xlabel('t (s)')
ylabel('d (mm)')
%{
%F(d(t))
figure(f2);
plot(f,P1);
%findpeaks(P1,f)
title('Frequency spectrum of d(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
%}