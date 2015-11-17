%This sample script shows how to generate pulse stimuli one at a time during an experiment using the generateTrial.m
% function. A frozen noise stimulus is shown every frozenInterval trials throughout. This function sets up the random
% number generator seeds to use. Right now, it will generate the same set of trials every time it is run!


%The stimulus conditions to use for the experiment
%Each row contains a condition
%  column 1 contains the pulse rate (pulses/second)
%  column 2 contains the trial duration (seconds)
stimulusConditions = [0.5, 20;
        1, 10;
        2, 5;
        4, 5;
        8.3, 5;
        10, 5;
        14.3, 5;
        20, 5];
    
NC = size(stimulusConditions,1); %number of conditions
frozenNoiseCondition = 6;

frameLen = 10e-3; %frame length in seconds

nTrials = 500;%how many trials to do

%sets up seeds (these are both fixed for now! You can replace the numbers in the seeds with the time to randomize every time the script is run)
randomSeed_frozen = RandStream.create('mt19937ar','Seed',98112); %random seed used only to generate the frozen noise stimulus
randomSeed        = RandStream.create('mt19937ar','Seed',55584); %random seed used to generate pulse patterns and select pulse rate on each trial

%sets up the frozen stimulus conditions
frozenInterval = 10; %show fixed stimulus at this interval
frozenCondition = 6; % stimulus condition number (row of stimulusConditions) to use for the frozen noise trial

%generates the frozen noise pulse sequence
y_frozen = generateTrial(stimulusConditions(frozenCondition,2),frameLen,stimulusConditions(frozenCondition,1),randomSeed_frozen);

%trial information
frozenNoiseTrials = false(nTrials,1); %if a trial used the frozen noise or not
SC          = nan(nTrials,1);   %stimulus condition for each trial

%loop over trials
for ii = 1:nTrials
    if(mod(ii,frozenInterval) == 0) %frozen stim trial
        SC(ii) = frozenNoiseCondition;
        frozenNoiseTrials(ii) = true;
        y_curr = y_frozen;
    else
        
        %randomly select condition (Poisson rate) for this trial
        SC(ii) = randi(randomSeed,NC);
        
        %generate stimulus
        y_curr = generatePoissonPulseTrial(stimulusConditions(SC(ii),2),frameLen,stimulusConditions(SC(ii),1),randomSeed);
        
    end
    
    %% y_curr now contains a Poisson stimulus to present to animal...
    % ...record here...
    % ...wait 5s until next trial...
end
