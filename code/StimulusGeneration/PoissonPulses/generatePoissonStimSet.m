%  generates a full block of stimuli
%     a fixed number of each stimulus condition (temporal frequency) are
%     shown in a permuted order between presentations of a frozen noise
%     stimulus. 
%
%  inputs:
%      nTrials = total number of trials to generate
%      frozenNoiseCondition = stimulus condition (row of stimulusConditions, see below) that is used for frozen noise trials
%      blocksBetweenFrozenStim = how many trials of each stimulus condition
%                                are shown between presentations of the frozen stim (default = 1)
%      randomSeed = random seed used to generate trial order and pulse
%                   times for each stimulus (fixed default seed used if not specified) 
%      randomSeed_frozen = random seed used to generate the frozen noise stimulus 
%                   (fixed default seed used if not specified) 
%      stimulusConditions = matrix of different stimulus conditions. Each row contains a condition
%                           column 1 contains the pulse rate
%                           column 2 contains the trial duration (seconds)
%                            (optional, default list of conditions used)
%      pauseLen = length of pauses between trials in seconds (optional, default = 5s)
%                 Used only for outputs StimLong and TS
%      frameLen = frame length in seconds to use for generating discrete stimulus
%                 (optional, default = 10ms)
%  outputs:
%      Stim = matrix of stimuli for each trial. Each entry is a single frame (num rows=nTrials,num columns=maximum trial length in frames)
%             Trials that are shorter than maximum trial length are padded with nans at
%             the end of the row. Stimulus entries are only 1s and 0s
%      TL = length of each trial, in terms of number of frames (vector, length=nTrials)
%      TF = temporal frequency for each trial (vector, length=nTrials)
%      SC = integer label of stimulus condition for each trial. With the default set of conditions this is equivalent to TF (vector, length=nTrials)
%      frozenNoiseTrials = whether a trial was a frozen noise trial or not, (vector, length=nTrials)

%      randomSeed,randomSeed_frozen = the random seeds used to generate the stimuli
%                                     (specified either by input or the default seeds) 
%      StimLong          = the entire stimulus unraveled into a vector with padding between trials (specified by pauseLen) 
%                          (and padded at the beginning and end)
%      TS = start times each trial within StimLong (vector, length=nTrials)
function [Stim,TL,TF,SC,frozenNoiseTrials,randomSeed,randomSeed_frozen,StimLong,TS] = generatePoissonStimSet(nTrials,frozenNoiseCondition,blocksBetweenFrozenStim,randomSeed,randomSeed_frozen,stimulusConditions,pauseLen,frameLen)

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

maxTrialLength = ceil(max(stimulusConditions(:,2)/frameLen)); %max length of each trial (in frames)
NC = size(stimulusConditions,1); %number of stim conditions

%% generate frozen noise trial
if(nargin < 5 || isempty(randomSeed_frozen))
    %setup seed to use for frozen noise trials
    randomSeed_frozen = rng(98112,'twister');
end

y_frozen = generateTrial(stimulusConditions(frozenNoiseCondition,2),frameLen,stimulusConditions(frozenNoiseCondition,1),randomSeed_frozen);

%% generate stimulus block
%  draws a trial from each of the conditions frozenInterval times in randomly permuted order
%  then shows the frozen noise trial
if(nargin < 3 || isempty(blocksBetweenFrozenStim))
    blocksBetweenFrozenStim = 1; %there are blocksBetweenFrozenStim number of each stimulus condition between presentations of the frozen stimulus
end
if(nargin < 4 || isempty(randomSeed))
    %setup random seed to use
    randomSeed = rng(57812,'twister');
end
rng(randomSeed);

frozenNoiseTrials = false(nTrials,1); 
SC          = randi(NC,[nTrials,1]);   
TL          = nan(nTrials,1);
Stim        = nan(nTrials,maxTrialLength);


for ii = 1:(NC*blocksBetweenFrozenStim+1):nTrials
    order = [(mod(randperm(NC*blocksBetweenFrozenStim),NC)+1)';frozenNoiseCondition];
    SC(ii:min(ii+NC*blocksBetweenFrozenStim,nTrials)) = order(1:length(SC(ii:min(ii+NC*blocksBetweenFrozenStim,nTrials))));
end


for ii = 1:nTrials
    if(mod(ii,NC*blocksBetweenFrozenStim+1) == 0)
        frozenNoiseTrials(ii) = true;
        y_curr = y_frozen;
    else
        y_curr = generateTrial(stimulusConditions(SC(ii),2),frameLen,stimulusConditions(SC(ii),1));
    end
    TL(ii) = length(y_curr);
    Stim(ii,1:TL(ii)) = y_curr;
end

TF = stimulusConditions(SC,1); 


%% Reshapes the stimulus into one long array with padding between trials
if(nargin < 7 || isempty(pauseLen))
    pauseLen = 5; %seconds
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
