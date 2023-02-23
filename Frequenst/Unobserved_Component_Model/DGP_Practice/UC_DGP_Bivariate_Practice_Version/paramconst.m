%% Parameter constraint
% input: psi, Sn (paramters, structure parameters)
% output: valid = 1, parameter constraint satisfied
%         valid = 0, otherwise

function [valid] = paramconst(psi,Sn)

% Define structural parameters
indQ = Sn.indQ;
indF = Sn.indF;

% Pre-allocation
validm = ones(30,1);

% Except for "NAN" parameters 
if maxc(isnan(psi)') == 1
    validm(1) = 0;
end 

% Transition equation variance > 0
validm(2) = minc(psi(indQ)) > -5;
validm(3) = minc(psi(indF)) > -5;

% Stationarity condition
Phim = psi(indF);
F = [Phim(1) Phim(2);1 0];
eigF = eig(F);
validm(4) = maxc(abs(eigF)) < 1;

% Check whether all constranit satisfied
valid = minc(validm); 

end