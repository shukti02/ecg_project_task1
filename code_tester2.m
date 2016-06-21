pc1 = zeros(numBeats, 19);
pc2 = zeros(numBeats, 19);
pc3 = zeros(numBeats, 19);
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