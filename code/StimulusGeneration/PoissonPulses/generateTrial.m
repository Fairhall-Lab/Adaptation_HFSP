%% generateTrial
%  makes a Poisson pulse stimulus for a single trial with a constant rate
%      trialLen    = length of the trial to simulate (in seconds)
%                    if rate is a vector (rate on each frame), then this
%                    variable is ignored
%      frameLen    = frame length (or inverse of sampling rate) of the 
%                    monitor. The stimulus is generated at this discrete scale
%                    (in seconds)
%      rate        = rate of the Poisson process of the pulse stimulus
%                    (pulses/sec)
%                    can be a single value or a vector of values for each
%                    frame
%      seed        = (optional) random seed to use - either a numeric value for a seed
%                     or a RandStream object (RandStream object recommended)
%                     The state of the RandStream is pass-by-reference
%                             (this function will change the statestored in this variable after generating numbers)
%
%  outputs:
%      y           = the stimulus in descrete bins of width frameLen
%
%  example function call
%    y = generarteTrial(5,10e-3,10);
%      returns a 5 second long trial, with frame lengths of 10ms, and a pulse rate of 10pulses/second.
%    seed = the RandStream object
function [y,seed] = generateTrial(trialLen,frameLen,rate,seed)

%sets the random seed if given

if(nargin < 4)
    seed = [];
end
seed = checkSeed(seed);

%number of bins in the trial
if(length(rate) == 1)
    T = ceil(trialLen/frameLen);
else
    T = length(rate);
end

%probability of at least one pulse occuring within a bin from the Poisson distribution
%because of the course frame rate, this will generally produce a lower number
%of pulses per second than desired
%p1 = 1-exp(-frameLen*rate); 

%probability of pulsing in a bin so that expected number of pulses matches
%rate (up to a maximum rate of 1 pulse per bin)
p1 = min(1,frameLen*rate(:));

%samples the trial
y = double(rand(seed,T,1) < p1);

