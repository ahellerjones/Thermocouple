% Graph temperature readings
% Andrew Heller-Jones
% Version 01/27/2019
table = csvread('2019.1.27tempData.csv', 1, 1);
X = table(2:50,1);
plot(X);
title("Ambient temperature of the Living Room in C");
xlabel("Entry number over the course of 2 minutes");
ylabel("Temp in Celsius");

% Can eventually read this out for time rather than
% entry number, but the readings need to be time stamped for
% milliseconds.
% Y = table(2:50,3);
% 
% minutes = string(table(2:50,3));
% seconds = string(table(2:50,4));
% axis([0 50 10 40]);
% Z = (2:50);

% s = strcat(minutes,":",seconds)
% final_time = datenum(s,'mm:ss');
% plot(final_time, X)
% datetick('x','mm:ss', 'keepticks');
