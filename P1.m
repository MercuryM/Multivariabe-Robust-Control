%% Q1
num1 = [1 -2];
num2 = [1 1 1.25];
num3 = [1 0.6 9.09];
num = conv(conv(num1,num2),num3);
den1 = [1 -1];
den2 = [1 0.2 1.01];
den3 = [1 0.2 25.01];
den = conv(conv(den1,den2),den3);
gs = tf(num,den)% the tranfer function G(s)
%% Q2
[ag,bg,cg,dg] = tf2ss(num,den);
G = [ag,bg;cg,dg];
%% Q3
poles = eig(ag);
zeros = tzero(gs);
%% Q4
w = logspace(-2,3,150);
fig1 = figure('Renderer', 'painters', 'Position', [10 10 1000 500]);
mag = bode(num,den,w);
figure(1)
semilogx(w, 20*log10(mag));
title('The Frequency Response','FontName', 'Arial', 'FontWeight','bold');
xlabel('Frequency (rad/s)');
ylabel('Magnitude (dB)');
% sisotool(gs)
grid on;
%% Q6
Gam = 15;
dnw1i = 1; nuw1i = [1,10,25];
dnw1 = [1,10,25]; nuw1 = 1;
dnw2 = 1; nuw2 = 0.0001;
dnw2i = nuw2; nuw2i = dnw2;
dnw3 = 1; nuw3 = 0.0001;
dnw3i = nuw3;nuw3i = dnw3;
[aw1,bw1,cw1,dw1] = tf2ss(dnw1i*Gam,nuw1i);
sysg = [ag,bg;cg,dg]; 
sysw1 = [aw1,bw1;cw1,dw1];
[rdg,cdg] = size(dg);
sysw2 = [0.0001]; 
sysw3 = [0.0001];
dim = [5,2,0,0];
[A,B1,B2,C1,C2,D11,D12,D21,D22] = augment(sysg,sysw1,sysw2,sysw3,dim);     
%% Q7
P = ss(A,[B1,B2],[C1;C2],[D11,D12;D21,D22]);
[K,CL,gamma2] = hinfsyn(P,1,1);
%% Defining the input values for pltopt
acp = K.A;
bcp = K.B;
ccp = K.C;
dcp = K.D;
acl = CL.A;
bcl = CL.B;
ccl = CL.C;
dcl = CL.D;
w = logspace(-2,3,150);
%% Find the closed -loop poles
clp = eig(CL.A);
[a1,b1]= ss2tf(CL.A,CL.B,CL.C,CL.D);
% figure(2)
% rlocus(gs)
%% Q9
[ak,bk]= ss2tf(K.A,K.B,K.C,K.D);
k = tf(ak,bk);
kpoles = eig(K.A);
kzeros = tzero(k);
% figure(3)
% pzmap(k)

