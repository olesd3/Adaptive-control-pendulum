%% Model parameters and initial conditions
m = 0.2;
beta = 0.05;
l = 0.1;
g = 9.81;
a = [m*l^2; beta; m*g*l];
noise_power = (0.1* pi/180)^2;
tau_q = 0.1;

q_0 = 20 * pi/180;
qdot_0 = 50 * pi/180;

%% Setpoint generation
qd = 0 * pi/180;
qd_0 = [q_0; 0; 0];
k = 10;
[A,B,~,~] = tf2ss([k^3],[1 3*k 3*k^2 k^3]);
A = [0 1 0;
     0 0 1;
     -k^3 -3*k^2 -3*k];
B = [0; 0; k^3];
C = [1 0 0;
     0 1 0;
     0 0 1];
D = [0; 0; 0];

T = 1.5;
f = 1/T;
qd_freq_rad = 2*pi*f;

% State estimation
tau_KF = m*l^2/beta *5;
A_c_KF = [0 1;
          0 -1/tau_KF];
B_c_KF = [];
C_KF = [1 0];
D_KF = [];
% sys_c = ss(A_c_KF, B_c_KF, C_KF, D_KF)
% sysd = c2d(sys_c, h_KF)

G_KF = [0;
     1/tau_KF];
R_KF = noise_power;
Q_KF = 1e-3;


Gamma = diag([0.1,1,1]);
a_hat_0 = 1*a; %[1; 1; 1];
sigma = 0.1;
Kp = 6;
Kd = 1;
lambda = Kp/Kd;