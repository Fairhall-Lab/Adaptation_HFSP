
%%
stimBlock = 1;
frameLen = 20e-3;

nTrials         = (8+1)*50;
frozenCondition = 6;
generationInfo.randomSeed        = 81473;
generationInfo.randomSeed_frozen = 12699;
[Stim,trialLength,trialFrequency,~,frozenNoiseTrials] = generatePoissonStimSet(nTrials,frozenCondition,1,generationInfo.randomSeed,generationInfo.randomSeed_frozen,[],[],frameLen);
generationInfo.stimGenerateCommand = sprintf('[Stim,trialLength,TF,~,frozenNoiseTrials] = generatePoissonStimSet(%d,%d,1,%d,%d,[],[],frameLen)',nTrials,frozenCondition,generationInfo.randomSeed,generationInfo.randomSeed_frozen);
generationInfo.gitRevision = getGitCommit();
generationInfo.createdOn   = datestr(now);
save(sprintf('Stimuli/PoissonPulse/StimBlock%d.mat',stimBlock),'Stim','trialLength','trialFrequency','frozenNoiseTrials','frameLen','generationInfo');

%%
stimBlock = 2;
frameLen = 20e-3;

nTrials         = (8+1)*50;
frozenCondition = 5;
generationInfo.randomSeed        = 81473;
generationInfo.randomSeed_frozen = 12699;
[Stim,trialLength,trialFrequency,~,frozenNoiseTrials] = generatePoissonStimSet(nTrials,frozenCondition,1,generationInfo.randomSeed,generationInfo.randomSeed_frozen,[],[],frameLen);
generationInfo.stimGenerateCommand = sprintf('[Stim,trialLength,TF,~,frozenNoiseTrials] = generatePoissonStimSet(%d,%d,1,%d,%d,[],[],frameLen)',nTrials,frozenCondition,generationInfo.randomSeed,generationInfo.randomSeed_frozen);
generationInfo.gitRevision = getGitCommit();
generationInfo.createdOn   = datestr(now);
save(sprintf('Stimuli/PoissonPulse/StimBlock%d.mat',stimBlock),'Stim','trialLength','trialFrequency','frozenNoiseTrials','frameLen','generationInfo');
