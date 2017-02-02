% add amen & subfolders to path
addpath(genpath('amen'))

% load matrix
load('arlei_dblp.mat')

% score egonets
[amen_ranking, amen_scores] = amen_rank(A, X, 'norm', 'L2', 'min_degree', 1, 'max_degree', inf);

% plot results
histogram(amen_scores)
title('AMEN L2 Scores')

