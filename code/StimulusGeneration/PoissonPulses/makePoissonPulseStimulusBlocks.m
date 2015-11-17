
%%
stimBlock = 1;
frameLen  = 20e-3;

nTrials         = (8+1)*50;
frozenNoiseInfo.length = 20;
frozenNoiseInfo.timeConstant = 1;
frozenNoiseInfo.minRate = 0.5;
frozenNoiseInfo.maxRate = 20;

generationInfo.randomSeed        = 81473;
generationInfo.randomSeed_frozen = 21796;
generationInfo.upsampleRate      = 1;
[Stim,trialLength,trialFrequency,~,frozenNoiseTrials,frozenNoiseRate] = generatePoissonStimSet(nTrials,frozenNoiseInfo,1,generationInfo.randomSeed,generationInfo.randomSeed_frozen,[],[],frameLen);
generationInfo.stimGenerateCommand = sprintf('[Stim,trialLength,TF,~,frozenNoiseTrials] = generatePoissonStimSet(%d,frozenNoiseInfo,1,%d,%d,[],[],frameLen)',nTrials,generationInfo.randomSeed,generationInfo.randomSeed_frozen);
generationInfo.gitRevision = getGitCommit();
generationInfo.createdOn   = datestr(now);
%save(sprintf('Stimuli/PoissonPulse/StimBlock%d.mat',stimBlock),'Stim','trialLength','trialFrequency','frozenNoiseTrials','frozenNoiseRate','frozenNoiseInfo','frameLen','generationInfo');

generationInfo.upsampleRate = 2;
[Stim,trialLength,frameLen] = upsampleTrialBlock(Stim,trialLength,frameLen,generationInfo.upsampleRate);
frozenNoiseRate             = upsampleTrialBlock(frozenNoiseRate',[],[],generationInfo.upsampleRate)';
generationInfo.stimGenerateCommand = sprintf('%s\n[Stim,trialLength,frameLen] = upsampleTrialBlock(Stim,trialLength,frameLen,generationInfo.upsampleRate);\nfrozenNoiseRate             = upsampleTrialBlock(frozenNoiseRate'',[],[],generationInfo.upsampleRate)'';',generationInfo.stimGenerateCommand);
%save(sprintf('Stimuli/PoissonPulse/StimBlock%d_upsampled.mat',stimBlock),'Stim','trialLength','trialFrequency','frozenNoiseTrials','frozenNoiseRate','frozenNoiseInfo','frameLen','generationInfo');
