if(~exist('ce','var'))
    load('/home/latimerk/Dropbox/HFSPshare/flashcells4to26.mat');
end

sampleRate= 25e3;
T = 160e3;
resampleWidth = 500;
T2 = ceil(T/resampleWidth);

dt2 = resampleWidth/sampleRate;

for ii = 1:length(ce)
    
    if(~isempty(ce(ii).spkt))
        
        figure(ii)
        clf
        
        for jj = 1:size(ce(ii).spkt,1)
            r = zeros(T2,1);
            NT = 0;
            for kk = 1:size(ce(ii).spkt,2)
                a = ce(ii).spkt(jj,kk);
                if(length(a{1}) >= T)
                    r = r + sum(reshape(a{1}(1:T)',resampleWidth,[]),1)';
                    NT = NT+1;
                end
            end
            r = r/(NT*resampleWidth)*sampleRate;
            
            a = ce(ii).stim(jj,1).command{1}(3:end-1);
            stim = str2num(a);
            stim = (stim(3:end) - 1)*100;
            
            subplot(size(ce(ii).spkt,1),1,jj);
            hold on
            xx = (1:length(stim))*10e-3 + ce(ii).stim(jj,1).bldur;
            area([xx 0],[stim 0],'FaceColor',[0.8 0.8 0.8],'LineWidth',0.5,'EdgeColor',[0.2 0.2 0.2]);
            xx2 = (0:length(r)-1)*dt2 + dt2/2;
            %plot(xx2,r);
            bar(xx2,r,1);
            
            ylim([0 max(r)*1.1]);
            
            set(gca,'box','off','tickdir','out')
            
            if(jj == size(ce(ii).spkt,1))
                xlabel('time (s)');
                ylabel('spk rate');
            end
            
            hold off
        end
    end
end