%%
%
%  timeConstant = time constant of process in seconds
%  frameLen     = length of each frame in seconds (inverse of frame rate)
%  T            = length of desired process in seconds
%  noiseStd     = standard deviation of the process (default = 1) (mean is
%                 fixed at 0)
%
%  y_scaled = AR1 process scaled to be from 0-1
%  y        = unscaled process
function [y_scaled,y] = generateAR1(timeConstant,frameLen,T,noiseStd,seed)
if(nargin < 5)
    seed = [];
end
seed = checkSeed(seed);

if(nargin < 4 || isempty(noiseStd))
    noiseStd = 1;
end

T = ceil(T/frameLen);

y = randn(seed,[T,1]);

timeConstant = timeConstant./frameLen;
phi = exp(-1/timeConstant);
sig = sqrt(1-phi^2)*noiseStd;
fprintf('phi = %2.2f, sig = %2.2f\n',phi,sig);

y(1) = y(1)*noiseStd;

for tt = 2:T
    y(tt) = y(tt)*sig + phi*y(tt-1);
end


y_scaled = y - min(y);
y_scaled = y_scaled./max(y_scaled);
end