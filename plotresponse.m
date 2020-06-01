figure(1)
plot(out.simout)
ylim([0,2])
grid on
xlabel('time(s)')
legend('Step signal','Response 1', 'Response 2')
title('Response of Step signal')
% title('Response of Pulse signal')
figure(2)
plot(out.simout1)
% xlim([0,2])
% ylim([-40,40])
grid on
xlabel('time(s)')
legend('Control signal u_1','Control signal u_2')
title('Control signal')

