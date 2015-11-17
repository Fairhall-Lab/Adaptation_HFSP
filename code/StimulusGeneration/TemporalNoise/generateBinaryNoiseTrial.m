%% generatePoissonPulseTrial
%  makes a Poisson pulse stimulus for a single trial with a constant rate
%      trialLen    = length of the trial to simulate (in seconds)
%                    if rate is a vector (rate on each frame), then this
%                    variable is ignored
%      frameLen    = frame length (or inverse of sampling rate) of the 
%                    monitor. The stimulus is generated at this discrete scale
%                    (in seconds)
%      seed        = (optional) random seed to use - either a numeric value for a seed
%                     or a RandStream object (RandStream object recommended)
%                     The state of the RandStream is pass-by-reference
%                             (this function will change the statestored in this variable after generating numbers)
%      p1          = (optional, default = 0.5) probability that a frame
%                    will be white
%
%  outputs:
%      y           = the stimulus (vector of 0's and 1's)
%
%  example function call
%    y = generateBinaryNoiseTrial(5,10e-3);
%       y will be 5 seconds of stimulus at a frame frame of 100Hz. Of
%       binary noise (takes 0 and 1 values).
function [y,seed] = generateBinaryNoiseTrial(trialLen,frameLen,seed,p1)

%sets the random seed if given

if(nargin < 3)
    seed = [];
end
seed = checkSeed(seed);

%number of bins in the trial
T = ceil(trialLen/frameLen);

%probability of a white frame
if(nargin < 4)
    p1 = 0.5;
end
    
%samples the trial
y = double(rand(T,1) < p1);
