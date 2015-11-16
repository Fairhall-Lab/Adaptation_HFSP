%%
%
%  timeConstant = time constant of process in seconds
%  frameLen     = length of each frame in seconds (inverse of frame rate)
%  T            = length of desired process in seconds
%  sig          = standard deviation of noise process (default = 0.01)
%
%  y_scaled = AR1 process scaled to be from 0-1
function [y_scaled,y] = generateAR1(timeConstant,frameLen,T,sig,seed)
if(nargin < 5)
    seed = [];
end
seed = checkSeed(seed);

if(nargin < 4 || isempty(sig))
    sig = 0.01;
end

T = ceil(T/frameLen);

y = randn(seed,[T,1]);

timeConstant = timeConstant./frameLen;
phi = exp(-1/timeConstant);

y(1) = y(1)*sig/sqrt(1-phi.^2);

for tt = 2:T
    y(tt) = y(tt)*sig + phi*y(tt-1);
end


y_scaled = y - min(y);
y_scaled = y_scaled./max(y_scaled);
end