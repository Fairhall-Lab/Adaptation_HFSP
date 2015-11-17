%% generatePoissonPulseTrial
%  makes a Poisson pulse stimulus for a single trial with a constant rate
%      trialLen    = length of the trial to simulate (in seconds)
%                    if rate is a vector (rate on each frame), then this
%                    variable is ignored
%      frameLen    = frame length (or inverse of sampling rate) of the 
%                    monitor. The stimulus is generated at this discrete scale
%                    (in seconds)
%      noiseMean   = mean of noise process
%      noiseStd    = standard deviation of noise process
%      heightRange = clips stimulus to be within this range (ex. [0 1])
%                    std and mean of noise process included before clipping
%      seed        = (optional) random seed to use - either a numeric value for a seed
%                     or a RandStream object (RandStream object recommended)
%                     The state of the RandStream is pass-by-reference
%                             (this function will change the statestored in this variable after generating numbers)
%
%  outputs:
%      y_clipped     = the stimulus in descrete bins of width frameLen
%                     clipped so that the values are within a valid range
%
%  example function call
%    y = generatePinkNoiseTrial(5,10e-3,0.5,0.25,[0 1]);
%       y will be 5 seconds of stimulus at a frame frame of 100Hz. The
%       noise process will have a mean of 0.5 and std of 0.25. Values
%       greater than 1 or less than 0 will be clipped.
function [y_clipped,seed,y] = generatePinkNoiseTrial(trialLen,frameLen,noiseMean,noiseStd,heightRange,seed)

%sets the random seed if given

if(nargin < 6)
    seed = [];
end
seed = checkSeed(seed);

%number of bins in the trial
T = ceil(trialLen/frameLen);
    
%samples the trial
y = generatePinkNoise(T,seed)*noiseStd + noiseMean;
y_clipped = min(heightRange(2), max(heightRange(1),y));

