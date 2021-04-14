function [K, R, t] = estimate_params(P)
% ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
% given camera matrix P.
% https://math.stackexchange.com/questions/1640695/rq-decomposition
%% Compute the camera center c by using svd
[~, ~, V] = svd(P);
c = V(:, end);
c = c(1:3);
%% Compute the intrinsic K and rotation R by using RQ decomposition
temp = [0,0,1; 0,1,0; 1,0,0];
A = temp*P(:, 1:3); % reverse rows of A
[q, r] = qr(A');
R = temp*q'; % orthogonal q
K = temp*r'*temp;
%% Compute the translation by t = −Rc
t = -R*c;
