function [del_ar eps_ar] = damping_ratio(filename,cal_fac)
%Computes damping ratio for displacement curve
%First select 0 displacement, then successive peaks in descending order
%[eps] = damping_ratio(filename)

%Import data and convert from .lvm
lvmdata = lvm_import(filename);
rawdata = lvmdata.Segment1;
t = rawdata.data(:,1);
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

%Output truncated plot
f1 = figure;

%d(t)
figure(f1);
plot(tn,dn);
title('Deflection d(t)')
xlabel('t (s)')
ylabel('d (mm)')

% Initialize data cursor object
cursorobj = datacursormode(f1);

while ~waitforbuttonpress 
    % waitforbuttonpress returns 0 with click, 1 with key press
    % Does not trigger on ctrl, shift, alt, caps lock, num lock, or scroll lock
    cursorobj.Enable = 'on'; % Turn on the data cursor, hold alt to select multiple points
end
cursorobj.Enable = 'off';

%Get data from cursor points
pts = getCursorInfo(cursorobj);

%Form array of data points (t;d)
ptar = reshape([pts.Position],2,[]);

%Extract array of d values, take size
dar = fliplr(ptar(2,:));
[d_s1 d_s2] = size(dar);

%Select baseline deflection and zero all elements w.r.t base d
d0 = dar(1);
dar = dar-d0;

%Initialize arrays
del_ar = 1:d_s2-2;
eps_ar = 1:d_s2-2;

%Compute log decrement
for m = 1:(d_s2 - 2)
    del = log(dar(2)/dar(m+2))/m;
    del_ar(m) = del;
end

%Compute damping ratio
for n = 1:(d_s2 - 2)
    eps = 1/sqrt(1+(2*pi/del_ar(n))^2);
    eps_ar(n) = eps;
end