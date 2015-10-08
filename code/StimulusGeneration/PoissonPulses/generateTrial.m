%% generateTrial
%  makes a Poisson pulse stimulus for a single trial with a constant rate
%      trialLen    = length of the trial to simulate (in seconds)
%      frameLen    = frame length (or inverse of sampling rate) of the 
%                    monitor. The stimulus is generated at this discrete scale
%                    (in seconds)
%      rate        = rate of the Poisson process of the pulse stimulus
%                    (pulses/sec)
%      seed        = (optional) random seed to use
%  outputs:
%      y           = the stimulus in descrete bins of width frameLen
%
function [y] = generateTrial(trialLen,frameLen,rate,seed)

%sets the random seed if given
if(nargin >= 4 && ~isempty(seed))
    rng(seed);
end

%number of bins in the trial
T = ceil(trialLen/frameLen);

%probability of at least one pulse occuring within a bin from the Poisson distribution
%because of the course frame rate, this will generally produce a lower number
%of pulses per second than desired
%p1 = 1-exp(-frameLen*rate); 

%probability of pulsing in a bin so that expected number of pulses matches
%rate (up to a maximum rate of 1 pulse per bin)
p1 = min(1,frameLen*rate);

%samples the trial
y = double(rand(T,1) < p1);