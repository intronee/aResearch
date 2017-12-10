% Amy, December
% Version 0.1

addpath('/Users/ahao/GitHub/eeglab14_0_0b');
WP = '/Users/ahao/GitHub/aResearch/eegraw/';

% Load EEG data
[EEG] = eeglab;
EEG = pop_loadset('EcEotest/ceoe10.set', WP);
%EEG.chanlocs = readlocs(WP + '../../../eeglab14_0_0b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');
%EEG = pop_eegfilt( EEG, 1, 0, [], [0]);
%EEG.setname='Continuous EEG Data';
%EEG = pop_epoch( EEG, [], [-2 1], 'Continuous EEG Data epochs');
%EEG = pop_rmbase( EEG, [-1000 0]);
%EEG = pop_reref(EEG, 39);
%[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
%pop_eegplot(EEG,1,1,1)


L = EEG.pnts;
T = EEG.times; 
window = EEG.srate;
%for idx=1:1:L/window
for idx=1:1:1
    %chnnl = EEG.data(3, 1:L);
    %S = reshape(chnnl, [window, L/window]);
    chnnls = EEG.data(3:16, (1+window*(idx-1)):(window*idx));
    S = chnnls';
    FS = fft(S);
    tmp = 20*log10(abs(FS(1:end/2,1)));
    plot(tmp);
    title('FFT of first window from ceoe10.edf');
    xlabel('Frequency Range');
    ylabel('dB(20*log10)');

    mesh(abs(20*log10(FS(1:end/2,:))));
    title('FFT of 14 channels at 1st second');
    ylabel('Frequency Range');
    zlabel('dB(20*log10)');
    xlabel('Channels');
    xticklabels({EEG.chanlocs(3:16).labels});

    %Band Power  Alpha/Beta/Gamma/Delta/Theta
    tmp = 20*log10(abs(FS(1:end/2,:)));
    theta = tmp(4:8,:);
    theta = bandarea(max(theta),min(theta),8-4);
    alpha = tmp(8:12,:);
    alpha = bandarea(max(alpha),min(alpha),12-8);
    lbeta = tmp(12:16,:);
    lbeta = bandarea(max(lbeta),min(lbeta),16-12);
    hbeta = tmp(16:25,:);
    hbeta = bandarea(max(hbeta),min(hbeta),25-16);
    gamma = tmp(25:45,:);
    gamma = bandarea(max(gamma),min(gamma),45-25);

    bandpower = [theta,alpha,lbeta,hbeta,gamma];
    bar3(bandpower);
    title('Band Power');
    xlabel('Frequency(Hz)');
    ylabel('Channels');
    zlabel('dB');

    xticklabels({'Theta(4-8Hz)', 'Alpha(8-12)', ...
        'Low Beta(12-16)', 'High Beta(16-25)', ...
        'Gamma(25-45)'});
    yticklabels({EEG.chanlocs(3:16).labels});
    
    
end
%%
% 
%  PREFORMATTED
%  TEXT
% 
function area=bandarea(max, min, len)
    area = mean([max',min'],2).*len;
end


