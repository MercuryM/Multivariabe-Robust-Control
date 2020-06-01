%% model
ag =[
-2.2567e-02  -3.6617e+01  -1.8897e+01  -3.2090e+01   3.2509e+00  -7.6257e-01;
9.2572e-05  -1.8997e+00   9.8312e-01  -7.2562e-04  -1.7080e-01  -4.9652e-03;
1.2338e-02   1.1720e+01  -2.6316e+00   8.7582e-04  -3.1604e+01   2.2396e+01;
0            0   1.0000e+00            0            0            0;
0            0            0            0  -3.0000e+01            0;
0            0            0            0            0  -3.0000e+01];
bg = [0     0;
      0     0;
      0     0;
      0     0;
     30     0;
      0    30];
cg = [0     1     0     0     0     0;
      0     0     0     1     0     0];
dg = [0     0;
      0     0];
G = [ag,bg;cg,dg];
%% preliminary analysis
poles = eig(ag);
zeros = tzero(ag,bg,cg,dg) ;
w = logspace(-3,5,50);
svg = sigma(ag,bg,cg,dg,1,w); 
svg = 20*log10(svg);
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1000 500]);
semilogx(w,svg)
title('MIMO Fighter Pitch Axis Open Loop')
xlabel('Frequency - Rad/Sec')
ylabel('SV - db')
grid on
%% controller design
Gam = 12;
k = 1000;
tau = 5.0000e-04;
% dnw1i = [0 1]; nuw1i = [1 0.01];
% dnw1 = [1 0.01]; nuw1 = [0 1];
% dnw1i = [1 10]; nuw1i = [10 1];
% dnw1 = [10 1]; nuw1 = [1 10];
dnw1i = [0.01 1]; nuw1i = [1 0.01];
dnw1 = [1 0.01]; nuw1 = [0.01 1];
% dnw2 = 1; nuw2 = 0.0001;
dnw2 = [1 30000]; nuw2 = [1 0];
dnw2i = nuw2; nuw2i = dnw2;
% dnw3 = [k 2*10^5*k 10^10*k]; nuw3 = [1 0 0];
dnw3 = [0 0 k]; nuw3 = [1 0 0];
dnw3i = nuw3;nuw3i = dnw3;
% [aw1,bw1,cw1,dw1] = tf2ss(dnw1i*Gam,nuw1i);
% [aw3,bw3,cw3,dw3] = tf2ss(dnw3i,nuw3i);
sysg = ss(ag,bg,cg,dg); 
sysw1 = [Gam*dnw1i;nuw1i;Gam*dnw1i;nuw1i];
% sysw3 = [0 1 0 0;0 k 2*10^5*k 10^10*k;tau 1 0 0;0 k 2*10^5*k 10^10*k];
sysw3 = [0 1 0 0;0 0 0 k;tau 1 0 0;0 0 0 k];
[rdg,cdg] = size(dg);
sysw2 = [dnw2i;nuw2i;dnw2i;nuw2i]; 
svw1i = bode(nuw1i,dnw1i,w);
svw1i = 20*log10(svw1i);
svw2i = bode(nuw2i,dnw2i,w);
svw2i = 20*log10(svw2i);
svw3i = bode(nuw3i,dnw3i,w);
svw3i = 20*log10(svw3i);
fig2 = figure('Renderer', 'painters', 'Position', [10 10 1000 500]);
figure(2);
semilogx(w,svw1i,w,svw2i,w,svw3i);
legend('1/W_1','1/W_2','1/W_3')
grid on
title('MIMO Fighter Design Example -- Design Specifications')
xlabel('Frequency - Rad/Sec')
ylabel('1/W1 & 1/W3 - db')
text(0.01,-50,'Sensitivity Spec.')
text(0.01,-70,'1/W1(s)')
text(1000,-30,'Robustness Spec.')
text(1000,-50,'1/W3(s)')
drawnow
%% Q7
P = augtf(sysg,sysw1,sysw2,sysw3);
[K,CL,gamma2] = hinfsyn(P,2,2);
%% Defining the input values for pltopt
acp = K.A;
bcp = K.B;
ccp = K.C;
dcp = K.D;
acl = CL.A;
bcl = CL.B;
ccl = CL.C;
dcl = CL.D;
[al,bl,cl,dl] = series(acp,bcp,ccp,dcp,ag,bg,cg,dg);
[als,bls,cls,dls] = feedbk(al,bl,cl,dl,1);
% fig = figure('Renderer', 'painters', 'Position', [10 10 1000 500]);
% semilogx(w,svw3i,w,svt)
% hold on
% semilogx([10^-3,10^5],[-20,-20])
% text(0.05,-30,'-20dB')
% title('COMP. SENSITIVITY FUNCTION AND 1/W3');
% xlabel('Frequency - Rad/Sec')
% ylabel('SV - db')
% grid on
sysk = ss(acp,bcp,ccp,dcp);
syss = ss(als,bls,cls,dls);
sysks = series(sysk,syss);
svk = sigma(sysks,w);
svk = 20*log10(svk);
svw2i = bode(nuw2i,dnw2i,w); svw2i = 20*log10(svw2i);
fig3 = figure('Renderer', 'painters', 'Position', [10 10 1000 500]);
figure(3);
semilogx(w,svw2i,w,svk);
title('CONTROL EFFORT AND 1/W2');
xlabel('Frequency - Rad/Sec');
ylabel('SV - db');
grid on
%% Find the closed -loop poles
clp = eig(CL.A);
[a1,b1]= ss2tf(CL.A,CL.B,CL.C,CL.D,2);
% figure(2)
% rlocus(gs)
%% Q9
[ak,bk]= ss2tf(K.A,K.B,K.C,K.D,2);
% k = tf(ak,bk);
kpoles = eig(K.A);
% kzeros = tzero(k);
% figure(3)
% pzmap(k)
% 
