clear all; clc; clf; close all;

%-----------------------------Wavelet transform part--------------------

patient = 'MG002_short';
matObj = matfile(patient);
filtMatObj = matfile('filteredLeads_short.mat');

% wtMatObj = matfile(strcat(patient, '_WT'), 'Writable', true);

leads = {'I', 'II', 'III', 'aVF', 'aVL', 'aVR', ...
    'V1', 'V2', 'V3', 'V4', 'V5', 'V6'};

halfLen = 300;
decLevel = 5;

beatPos_ms = 1000*matObj.beatpos;
numBeats = length(beatPos_ms);
% 
% for l = 1:length(leads)
%     
    signal = filtMatObj.(leads{1});
    
    idxMat = int32(beatPos_ms'*ones(1, 2*halfLen+1) + ...
        ones(numBeats, 1)*(-halfLen:halfLen));
     
    [C, L] = wavedec(double(signal), decLevel, 'db8');
    
    subSampIdxMat = idxMat(:, round(...
        linspace(1, 2*halfLen+1, round((2*halfLen+1)./(2^decLevel)))));
    appSignal = recDecSignal(C, L, 'db8', decLevel + 1);
    
%     wtFeats = appSignal(subSampIdxMat);
%     
%     wtMatObj.(leads{l}) = wtFeats;
% end
% wtMatObj.beatPos = beatPos_ms;

%-------------PCA, eigenvalues energy--------------------------
%     
% wtMatObj = matfile('MG002_short_WT');
% L(1) = 112514; numBeats = 5387;
% ev = zeros(3, numBeats);
% pc1 = zeros(numBeats, L(1));
% pc2 = zeros(numBeats, L(1));
% pc3 = zeros(numBeats, L(1));
% 
% AUC = zeros(3, numBeats);
% energy = zeros(3, numBeats);
% average = zeros(3, numBeats);
% 
% appCoefMat = [wtMatObj.I; wtMatObj.II; wtMatObj.III; ...
%     wtMatObj.aVF; wtMatObj.aVL; wtMatObj.aVR; ...
%     wtMatObj.V1; wtMatObj.V2; wtMatObj.V3; ...
%     wtMatObj.V4; wtMatObj.V5; wtMatObj.V6];