%Each row contains a condition
%  column 1 contains the pulse rate
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

randomSeed_frozen = rng(98112,'twister'); %random seed used only to generate the frozen noise stimulus
randomSeed_init   = rng(55584,'twister'); %random seed used to generate pulse patterns and select pulse rate on each trial
randomSeed_curr   = randomSeed_init;

frozenInterval = 10; %show fixed stimulus at this interval
frozenCondition = 6; % stimulus condition number (row of stimulusConditions) to use for the frozen noise trial

nTrials = 500;%how many trials to do


frozenNoiseTrials = false(nTrials,1); %if a trial used the frozen noise or not
SC          = nan(nTrials,1);   %stimulus condition for each trial


y_frozen = generateTrial(stimulusConditions(frozenCondition,2),frameLen,stimulusConditions(frozenCondition,1),randomSeed_frozen);

%loop over trials
for ii = 1:nTrials
    if(mod(ii,frozenInterval) == 0) %frozen stim trial
        SC(ii) = frozenNoiseCondition;
        frozenNoiseTrials(ii) = true;
        y_curr = y_frozen;
    else
        rng(randomSeed_curr);
        
        %randomly select condition (Poisson rate) for this trial
        SC(ii) = randi(NC);
        
        %generate stimulus
        y_curr = generateTrial(stimulusConditions(SC(ii),2),frameLen,stimulusConditions(SC(ii),1));
        
        randomSeed_curr = rng();
    end
    
    %% y_curr now contains a Poisson stimulus to present to animal...
    % ...record here...
    % ...wait 5s until next trial...
end