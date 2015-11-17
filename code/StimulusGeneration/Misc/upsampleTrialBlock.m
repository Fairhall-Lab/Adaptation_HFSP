function [Stim,trialLength,frameLen] = upsampleTrialBlock(Stim,trialLength,frameLen,upsampleRate)

Stim2 = zeros(size(Stim,1),size(Stim,2)*upsampleRate);
for ii = 1:size(Stim,1)
    Stim2(ii,:) = interp1(1:size(Stim,2),Stim(ii,:),1:1/upsampleRate:(size(Stim,2)+0.99),'previous');
end
Stim = Stim2;
trialLength = trialLength*2;
frameLen = frameLen/upsampleRate;