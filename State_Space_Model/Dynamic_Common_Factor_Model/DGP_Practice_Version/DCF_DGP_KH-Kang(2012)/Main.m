%% State-Space Model
% Dynamic Common Factor Model
% y(1t) = Lambda(1row)*B(t) + e1(t), e1(t) ~ iidN(0, sig2e1)
% y(2t) = Lambda(2row)*B(t) + e2(t), e2(t) ~ iidN(0, sig2e2)
% y(3t) = Lambda(3row)*B(t) + e3(t), e3(t) ~ iidN(0, sig2e3)
% y(4t) = Lambda(4row)*B(t) + e4(t), e4(t) ~ iidN(0, sig2e4)
% y(5t) = Lambda(5row)*B(t) + e5(t), e5(t) ~ iidN(0, sig2e5)
% y(6t) = Lambda(6row)*B(t) + e6(t), e6(t) ~ iidN(0, sig2e6)
% y(7t) = Lambda(7row)*B(t) + e7(t), e7(t) ~ iidN(0, sig2e7)
% y(8t) = Lambda(8row)*B(t) + e8(t), e8(t) ~ iidN(0, sig2e8)
% y(9t) = Lambda(9row)*B(t) + e9(t), e9(t) ~ iidN(0, sig2e9)
% y(10t) = Lambda(10row)*B(t) + e10(t), e10(t) ~ iidN(0, sig2e10)

% tau = [3 6 9 12 18 24 30 36 60 120]
% lambda = 0.15

% Measurement equation 
% Y(t) = L*B(t) + e(t) ~ iidN(0,R)

% Transition equation
% B(t) = [bL(t) bS(t) bC(t)]'
% B(t) = mu + F*B(t-1) + v(t), v(t) ~ iidN(0, Q) 


% SS Parameter
% C = [0 0 0 0 0 0 0 0 0 0]', 
% H = Lambda Matrix,
% R = diag([sig2e1; sig2e2; sig2e3; sig2e4; sig2e5; sig2e6; sig2e7; sig2e8;
% sig2e9; sig2e10])

% Mu = [Mu1 Mu2 Mu3]' 
% F = diag([phi1;phi2;phi3]) 
% Q = [sig2v1 Cov1 Cov2 ; Cov1 sig2v2 Cov3 ; Cov2 Cov3 sig2v3]

clear; 
clc; 
warning('off','all')

%% Step 1: DGP
% Data information
T = 3000;     % Sample size 
cut = 500;    % Burn-in size              
k = 3;        % Three common factor

% True Parameter
% T.E.
sig2e1 = 0.1; 
sig2e2 = 0.6; 
sig2e3 = 0.4; 
sig2e4 = 0.1; 
sig2e5 = 0.2; 
sig2e6 = 0.3; 
sig2e7 = 0.5; 
sig2e8 = 0.1; 
sig2e9 = 0.1; 
sig2e10 = 0.1; 

% M.E.
mu1 = 1;
mu2 = 2;
mu3 = 1;

phi1 = 0.5;
phi2 = 0.3;
phi3 = 0.1;

sig2v1 = 0.1;
sig2v2 = 0.1;
sig2v3 = 0.1;
Cov1 = 0.3;
Cov2 = 0.2;
Cov3 = 0.1;

tru_para = [sig2e1;sig2e2;sig2e3;sig2e4;sig2e5;sig2e6;sig2e7;sig2e8;sig2e9;sig2e10;mu1;mu2;mu3;phi1;phi2;phi3;sig2v1;sig2v2;sig2v3;Cov1;Cov2;Cov3]; 

% Pre-allocation for B(t)
bl1 = zeros(T,1);
bs2 = zeros(T,1);
bc3 = zeros(T,1);

% Initial B(t), for t = 1
bl_1 = mu1 + randn(1,1)*sqrt(sig2v1);
bl1(1) = bl_1;

bs_1 = mu1 + randn(1,1)*sqrt(sig2v2);
bs2(1) = bs_1;

bc_1 = mu1 + randn(1,1)*sqrt(sig2v3);
bc3(1) = bc_1;

% Generate c(t) for t = 2 ~ T
for t = 2:T 
    bl1(t) = mu1 + phi1*bl1(t-1) + sqrt(sig2v1)*randn(1,1);
    bs2(t) = mu2 + phi1*bs2(t-1) + sqrt(sig2v2)*randn(1,1); 
    bc3(t) = mu3 + phi1*bc3(t-1) + sqrt(sig2v3)*randn(1,1); 
end

Bt = [bl1 bs2 bc3]';

% Generate Lambda Matrix
tau = [3 6 9 12 18 24 30 36 60 120];
lambda = 0.15;

Lambda_M = makeLambda(lambda,tau);

% Generate y(t)
y1 = zeros(T,1);
y2 = zeros(T,1);
y3 = zeros(T,1);
y4 = zeros(T,1);
y5 = zeros(T,1);
y6 = zeros(T,1);
y7 = zeros(T,1);
y8 = zeros(T,1);
y9 = zeros(T,1);
y10 = zeros(T,1);

for t = 1:T
y1(t) = Lambda_M(1,:)*Bt(:,t) + sqrt(sig2e1)*randn(1,1); 
y2(t) = Lambda_M(2,:)*Bt(:,t) + sqrt(sig2e2)*randn(1,1); 
y3(t) = Lambda_M(3,:)*Bt(:,t) + sqrt(sig2e3)*randn(1,1); 
y4(t) = Lambda_M(4,:)*Bt(:,t) + sqrt(sig2e4)*randn(1,1); 
y5(t) = Lambda_M(5,:)*Bt(:,t) + sqrt(sig2e5)*randn(1,1); 
y6(t) = Lambda_M(6,:)*Bt(:,t) + sqrt(sig2e6)*randn(1,1); 
y7(t) = Lambda_M(7,:)*Bt(:,t) + sqrt(sig2e7)*randn(1,1); 
y8(t) = Lambda_M(8,:)*Bt(:,t) + sqrt(sig2e8)*randn(1,1); 
y9(t) = Lambda_M(9,:)*Bt(:,t) + sqrt(sig2e9)*randn(1,1); 
y10(t) = Lambda_M(10,:)*Bt(:,t) + sqrt(sig2e10)*randn(1,1); 
end

Ym = [y1 y2 y3 y4 y5 y6 y7 y8 y9 y10];

% Burn-in
Ym = Ym(cut+1:end,:);
Bt = Bt(:,cut+1:end);

%% Step 2: Maxmimum Likelihood Estimation
% Data
data = Ym;

% SS Parameter
% C = [0 0 0 0 0 0 0 0 0 0]', 
% H = Lambda Matrix,
% R = diag([sig2e1; sig2e2; sig2e3; sig2e4; sig2e5; sig2e6; sig2e7; sig2e8;
% sig2e9; sig2e10])

% Mu = [Mu1 Mu2 Mu3]' 
% F = diag([phi1;phi2;phi3]) 
% Q = [sig2v1 Cov1 Cov2 ; Cov1 sig2v2 Cov3 ; Cov2 Cov3 sig2v3]


% Block for each parameters
indR = [1;2;3;4;5;6;7;8;9;10];
indMu = [11;12;13];
indF = [14;15;16];
indQ = [17;18;19;20;21;22];

% Structure variables
Sn.data = data;
Sn.indR = indR;
Sn.indMu = indMu;
Sn.indF = indF;
Sn.indQ = indQ;

% Initial values
psi0 = [sig2e1;sig2e2;sig2e3;sig2e4;sig2e5;sig2e6;sig2e7;sig2e8;sig2e9;sig2e10;mu1;mu2;mu3;phi1;phi2;phi3;sig2v1;sig2v2;sig2v3;Cov1;Cov2;Cov3]; 

% Index
indbj = 1:rows(psi0);
indbj = indbj';
% printi = 1 => See the opimization produdure
% printi = 0 => NOT see the opimization produdure
printi = 1; 

% Optimization
[psimx, fmax,Vj, Vinv] = SA_Newton(@lnlik,@paramconst,psi0,Sn,printi,indbj);

% Estimates by Deltamethod
thetamx = maketheta(psimx,Sn);                  % Transform psi -> theta
grad = Gradpnew1(@maketheta,psimx,indbj,Sn);    % Gradient
cov_fnl = grad*Vj*grad';                        % Covariance Matrix
diag_cov = diag(cov_fnl);                       % Variance (diagonal)
stde = sqrt(diag_cov);                          % Standard deviation
t_val = thetamx./stde;                          % t-value
p_val = 2*(1 - cdf('t',abs(t_val),T-k));        % p-value

%% Step 4: Filtering and Smoothing
[C,H,R,Mu,F,Q] = makePara(thetamx,Sn);
[~, Beta_ttm, P_ttm]= KM_filter(C,H,R,Mu,F,Q,data);
Beta_LB = Beta_ttm - 1.95*sqrt(P_ttm); 
Beta_UB = Beta_ttm + 1.95*sqrt(P_ttm);

[Beta_tTm, P_tTm] = KM_smooth(C,H,R,Mu,F,Q,data);
Beta_LB_SM = Beta_tTm - 1.95*sqrt(P_tTm);
Beta_UB_SM = Beta_tTm + 1.95*sqrt(P_tTm);

%% Step 3: Table / Figure Results 
% Table
disp('===========================================================');
disp(['    Index ','  True Para ', ' Estimates ', ' t value ',  ' p value']);
disp('===========================================================');
disp([indbj tru_para thetamx t_val p_val]);
disp('===========================================================');

% Figure
% Index 
i = 1:rows(Beta_ttm); 

% Filtered value
tiledlayout(4,3)
nexttile
plot(i, Bt(1,:) ,'k', i, Beta_ttm(:,1), 'b:', 'LineWidth',1.5);
legend('True','Filtered'); 
title('True and Filtered Common Factor');
nexttile
plot(i, Bt(2,:) ,'k', i, Beta_ttm(:,2), 'b:', 'LineWidth',1.5);
legend('True','Filtered'); 
title('True and Filtered Common Factor');
nexttile
plot(i, Bt(3,:) ,'k', i, Beta_ttm(:,3), 'b:', 'LineWidth',1.5);
legend('True','Filtered'); 
title('True and Filtered Common Factor');
nexttile
plot(i, Beta_ttm(:,1) ,'k', i, Beta_LB(:,1), 'b:', i, Beta_UB(:,1),'r:','LineWidth',1.5)
legend('Common Factor', 'Low Band', 'High Band');
title('Filtered Common Factor and Confidence Interval');
nexttile
plot(i, Beta_ttm(:,2) ,'k', i, Beta_LB(:,2), 'b:', i, Beta_UB(:,2),'r:','LineWidth',1.5)
legend('Common Factor', 'Low Band', 'High Band');
title('Filtered Common Factor and Confidence Interval');
nexttile
plot(i, Beta_ttm(:,3) ,'k', i, Beta_LB(:,3), 'b:', i, Beta_UB(:,3),'r:','LineWidth',1.5)
legend('Common Factor', 'Low Band', 'High Band');
title('Filtered Common Factor and Confidence Interval');


% Smoothed value
nexttile
plot(i, Bt(1,:) ,'k', i, Beta_tTm(:,1), 'b:', 'LineWidth',1.5);
legend('True','Smoothed'); 
title('True and Smoothed Common Factor');
nexttile
plot(i, Bt(2,:) ,'k', i, Beta_tTm(:,2), 'b:', 'LineWidth',1.5);
legend('True','Smoothed'); 
title('True and Smoothed Common Factor');
nexttile
plot(i, Bt(3,:) ,'k', i, Beta_tTm(:,3), 'b:', 'LineWidth',1.5);
legend('True','Smoothed'); 
title('True and Smoothed Common Factor');
nexttile
plot(i, Beta_tTm(:,1) ,'k', i, Beta_LB_SM(:,1), 'b:', i, Beta_UB_SM(:,1),'r:','LineWidth',1.5)
legend('Common Factor', 'Low Band', 'High Band');
title('Smoothed Common Factor and Confidence Interval');
nexttile
plot(i, Beta_tTm(:,2) ,'k', i, Beta_LB_SM(:,2), 'b:', i, Beta_UB_SM(:,2),'r:','LineWidth',1.5)
legend('Common Factor', 'Low Band', 'High Band');
title('Smoothed Common Factor and Confidence Interval');
nexttile
plot(i, Beta_tTm(:,3) ,'k', i, Beta_LB_SM(:,3), 'b:', i, Beta_UB_SM(:,3),'r:','LineWidth',1.5)
legend('Common Factor', 'Low Band', 'High Band');
title('Smoothed Common Factor and Confidence Interval');






