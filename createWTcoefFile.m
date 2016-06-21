function createWTcoefFile(patient)

matObj = matfile(patient);
filtMatObj = matfile('filteredLeads.mat');

wtMatObj = matfile(strcat(patient, '_WT'), 'Writable', true);

leads = {'I', 'II', 'III', 'aVF', 'aVL', 'aVR', ...
    'V1', 'V2', 'V3', 'V4', 'V5', 'V6'};

halfLen = 300;
decLevel = 5;

beatPos_ms = 1000*matObj.beatpos(1, 11:end-10);
numBeats = length(beatPos_ms);

for l = 1:length(leads)
    
    signal = filtMatObj.(leads{l});
    
    idxMat = int32(beatPos_ms'*ones(1, 2*halfLen+1) + ...
        ones(numBeats, 1)*(-halfLen:halfLen));
     
    [C, L] = wavedec(double(signal), decLevel, 'db8');
    
    subSampIdxMat = idxMat(:, round(...
        linspace(1, 2*halfLen+1, round((2*halfLen+1)./(2^decLevel)))));
    appSignal = recDecSignal(C, L, 'db8', decLevel + 1);
    
    wtFeats = appSignal(subSampIdxMat);
    
    wtMatObj.(leads{l}) = wtFeats;
end
wtMatObj.beatPos = beatPos_ms;


% Calculate PCA and other features for each beat
ev = zeros(3, numBeats);
pc1 = zeros(numBeats, size(subSampIdxMat,2));
pc2 = zeros(numBeats, size(subSampIdxMat,2));
pc3 = zeros(numBeats, size(subSampIdxMat,2));

AUC = zeros(3, numBeats);
energy = zeros(3, numBeats);
average = zeros(3, numBeats);

appCoefMat = [wtMatObj.I; wtMatObj.II; wtMatObj.III; ...
    wtMatObj.aVF; wtMatObj.aVL; wtMatObj.aVR; ...
    wtMatObj.V1; wtMatObj.V2; wtMatObj.V3; ...
    wtMatObj.V4; wtMatObj.V5; wtMatObj.V6];

for k = 1:numBeats
    [~, pcaScore, latent] = pca((appCoefMat(k:numBeats:end, :))');
    
    ev(:, k) = latent(1:3);
    pc1(k, :) = pcaScore(:, 1)';
    pc2(k, :) = pcaScore(:, 2)';
    pc3(k, :) = pcaScore(:, 3)';
    
    AUC(1, k) = sum(abs(pcaScore(:, 1)'));
    AUC(2, k) = sum(abs(pcaScore(:, 2)'));
    AUC(3, k) = sum(abs(pcaScore(:, 3)'));
    
    energy(1, k) = dot(pcaScore(:, 1), pcaScore(:, 1));
    energy(2, k) = dot(pcaScore(:, 2), pcaScore(:, 2));
    energy(3, k) = dot(pcaScore(:, 3), pcaScore(:, 3));
    
    average(1, k) = mean(pcaScore(:, 1));
    average(2, k) = mean(pcaScore(:, 2));
    average(3, k) = mean(pcaScore(:, 3));
end
    wtMatObj.ev = ev;
    wtMatObj.pc1 = pc1;
    wtMatObj.pc2 = pc2;
    wtMatObj.pc3 = pc3;
    wtMatObj.AUC = AUC;
    wtMatObj.energy = energy;
    wtMatObj.average = average;
end