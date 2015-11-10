%% generateTrial
%  makes a Poisson pulse stimulus for a single trial with a constant rate
%      trialLen    = length of the trial to simulate (in seconds)
%      frameLen    = frame length (or inverse of sampling rate) of the 
%                    monitor. The stimulus is generated at this discrete scale
%                    (in seconds)
%      rate        = rate of the Poisson process of the pulse stimulus
%                    (pulses/sec)
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

useSeed = (nargin >= 4 && ~isempty(seed));
if(~useSeed)
    %if a seed is not given, uses the current global seed
    v = version('-release'); %version check because matlab changed the method name for this default random number generator stream
    if(str2double(v(1:4)) >= 2012)
        seed = RandStream.getGlobalStream();
    else
        seed = RandStream.getDefaultStream(); %#ok<GETRS>
    end
    warning('No random seed given. Using default/global seed.');
end
%makes sure the seed is a RandStream object
if(isnumeric(seed))
    seed = RandStream.create('mt19937ar','seed',seed);
    warning('The random seed given is a number instead of a RandStream object - if this function is called again with the same number as seed, it will produce the same stimulus.');
elseif(~isa(seed,'RandStream'))
    error('seed is not a valid RandStream object.');
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
y = double(rand(seed,T,1) < p1);

