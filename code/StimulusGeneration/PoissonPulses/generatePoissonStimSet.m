%  generates a full block of stimuli
%     a fixed number of each stimulus condition (temporal frequency) are
%     shown in a permuted order between presentations of a frozen noise
%     stimulus. 
%
%  inputs:
%      nTrials = total number of trials to generate
%      frozenNoiseInfo = struct with values:
%          length = stimulus length for frozen noise trials (in seconds)
%          timeConstant =  rate for frozen noise is drawn from an AR1 process with time
%                          constant 1
%          minRate      = minimum rate to use
%          maxRate      = maximum rate (AR1 scaled to span this range)
%      blocksBetweenFrozenStim = how many trials of each stimulus condition
%                                are shown between presentations of the frozen stim (default = 1)
%      randomSeed = RandStream object used to generate trial order and pulse
%                   times for each stimulus (fixed default seed used if not specified) 
%      randomSeed_frozen = RandStream object used to generate the frozen noise stimulus 
%                   (fixed default seed used if not specified) 
%      stimulusConditions = matrix of different stimulus conditions. Each row contains a condition
%                           column 1 contains the pulse rate
%                           column 2 contains the trial duration (seconds)
%                            (optional, default list of conditions used)
%      pauseLen = length of pauses between trials in seconds (optional, default = 2s)
%                 Used only for outputs StimLong and TS
%      frameLen = frame length in seconds to use for generating discrete stimulus
%                 (optional, default = 10ms)
%  outputs:
%      Stim = matrix of stimuli for each trial. 
%             Each entry is a single frame (num rows=nTrials,num columns=maximum trial length in frames)
%             Trials that are shorter than maximum trial length are padded with nans at
%             the end of the row. Stimulus entries are only 1s and 0s
%      TL = length of each trial, in terms of number of frames (vector, length=nTrials)
%      TF = temporal frequency for each trial (vector, length=nTrials)
%      SC = integer label of stimulus condition for each trial. With the default set of conditions this
%           is equivalent to TF (vector, length=nTrials)
%      frozenNoiseTrials = whether a trial was a frozen noise trial or not, (vector, length=nTrials)
%      randomSeed,randomSeed_frozen = the random seeds used to generate the stimuli
%                                     (specified either by input or the default seeds) 
%      StimLong = the entire stimulus unraveled into a vector with padding between trials (specified by pauseLen) 
%                          (and padded at the beginning and end)
%      TS = start times each trial within StimLong (vector, length=nTrials)
%
%   example function call
%      [Stim,TL,TF,SC,frozenNoiseTrials,randomSeed,randomSeed_frozenStimLong,TS] = generatePoissonStimSet(500,6,1);
%
%      This generates 500 trials. Every 9th trial is a fixed trial of 10pulses/second (the 6th stimulus condition).
%      The 8 trials between each frozen noise presentation consist of 1 trial of each pulse frequency, in some shuffled
%      order. This offers some randomization of the order of the pulse rates used, but it ensures that the frequencies
%      are presented equally often.
%
function [Stim,TL,TF,SC,frozenNoiseTrials,frozenNoiseRate,randomSeed,randomSeed_frozen,StimLong,TS] = generatePoissonStimSet(nTrials,frozenNoiseInfo,blocksBetweenFrozenStim,randomSeed,randomSeed_frozen,stimulusConditions,pauseLen,frameLen)

if(nargin < 8)
    frameLen = 10e-3; %frame length in seconds
end

if(nargin < 6 || isempty(stimulusConditions))
    %stim conditions
    stimulusConditions = [0.5, 20;
        1, 10;
        2, 5;
        4, 5;
        8.3, 5;
        10, 5;
        14.3, 5;
        20, 5];
end

maxTrialLength = ceil(max([stimulusConditions(:,2);frozenNoiseInfo.length]./frameLen)); %max length of each trial (in frames)
NC = size(stimulusConditions,1); %number of stim conditions

%% random seed setup
%sets up some random seeds based on time in case no seeds are given
seed1 = randi(intmax('int32'));
seed2 = randi(intmax('int32'));
if(nargin < 5 || isempty(randomSeed_frozen))
    %setup seed to use for frozen noise trials
    randomSeed_frozen = RandStream.create('mt19937ar','seed',seed1);
elseif(isnumeric(randomSeed_frozen))
    randomSeed_frozen = RandStream.create('mt19937ar','seed',randomSeed_frozen);
elseif(~isa(seed,'RandStream'))
    error('The frozen seed provided is not a valid RandStream object.');
end

if(nargin < 4 || isempty(randomSeed))
    %setup random seed to use
    randomSeed = RandStream.create('mt19937ar','seed',seed2);
elseif(isnumeric(randomSeed))
    randomSeed = RandStream.create('mt19937ar','seed',randomSeed);
elseif(~isa(seed,'RandStream'))
    error('The frozen seed provided is not a valid RandStream object.');
end


%% generate frozen noise trial

frozenNoiseRate = generateAR1(frozenNoiseInfo.timeConstant,frameLen,frozenNoiseInfo.length,0.01,randomSeed_frozen);
frozenNoiseRate = frozenNoiseRate*(frozenNoiseInfo.maxRate-frozenNoiseInfo.minRate)+frozenNoiseInfo.minRate;
y_frozen = generateTrial([],frameLen,frozenNoiseRate,randomSeed_frozen);

%% generate stimulus block
%  draws a trial from each of the conditions frozenInterval times in randomly permuted order
%  then shows the frozen noise trial
if(nargin < 3 || isempty(blocksBetweenFrozenStim))
    blocksBetweenFrozenStim = 1; %there are blocksBetweenFrozenStim number of each stimulus condition between presentations of the frozen stimulus
end


frozenNoiseTrials = false(nTrials,1); 
SC          = randi(randomSeed,NC,[nTrials,1]);   
TL          = nan(nTrials,1);
Stim        = nan(nTrials,maxTrialLength);

for ii = 1:(NC*blocksBetweenFrozenStim+1):nTrials
    order = [(mod(randperm(NC*blocksBetweenFrozenStim),NC)+1)';-1];
    SC(ii:min(ii+NC*blocksBetweenFrozenStim,nTrials)) = order(1:length(SC(ii:min(ii+NC*blocksBetweenFrozenStim,nTrials))));
end


for ii = 1:nTrials
    if(mod(ii,NC*blocksBetweenFrozenStim+1) == 0)
        frozenNoiseTrials(ii) = true;
        y_curr = y_frozen;
    else
        y_curr = generateTrial(stimulusConditions(SC(ii),2),frameLen,stimulusConditions(SC(ii),1),randomSeed);
    end
    TL(ii) = length(y_curr);
    Stim(ii,1:TL(ii)) = y_curr;
end

TF = SC;
TF(SC > 0) = stimulusConditions(SC(SC>0),1);


%% Reshapes the stimulus into one long array with padding between trials
if(nargin < 7 || isempty(pauseLen))
    pauseLen = 2; %seconds
end
pauseLenFrames = ceil(pauseLen/frameLen);

TS = cumsum([1;TL(1:end-1)]) + (1:nTrials)'*pauseLenFrames; %trial start times (in frames)
StimLong = zeros(sum(TL) + (nTrials+1)*pauseLenFrames,1);

for ii = 1:nTrials
    tt = TS(ii):(TS(ii) + TL(ii)-1);
    StimLong(tt) = Stim(ii,1:TL(ii));
end

totalStimLength = length(StimLong)*frameLen;

fprintf('Total padded stimulus length: %3.1f seconds\n',totalStimLength);
