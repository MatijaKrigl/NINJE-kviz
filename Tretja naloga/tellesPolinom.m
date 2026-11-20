function [T, dT, a, b] = tellesPolinom(S, m, yL, yD)
% tellesPolinom: polinomska preslikava za podani VELIKI S.
%
% UPORABA:
%   T = tellesPolinom(S)                % kubicni T, robova -1 in 1
%   T = tellesPolinom(S,5)              % stopnja 5
%   T = tellesPolinom(S,3,0,1)          % robna pogoja T(-1)=0, T(1)=1
%   [T,dT,a,b] = tellesPolinom(S,m,yL,yD)
%
% POGOJI:
%   T(-1) = yL; T(1) = yD
%   T'(S) = T''(S) = ... = T^(m-1)(S) = 0
%
% OBLIKA:
%   T(u) = a*(u-S)^m + b
%   Velja za liho stopnjo m >= 3 in razlicna robova yL, yD.
%
% IZHOD:
%   T  - funkcijski predpis; klices ga z T(0), T(0.2) ...
%   dT - prvi odvod T kot funkcija, za substitucijo integrala
%   a,b - koeficienta zgornjega zapisa

    if nargin < 2 || isempty(m)
        m = 3;
    end
    if nargin < 3 || isempty(yL)
        yL = -1;
    end
    if nargin < 4 || isempty(yD)
        yD = 1;
    end

    if ~isscalar(S) || ~isreal(S) || ~isfinite(S) || S < -1 || S > 1
        error('S mora biti realno stevilo na intervalu [-1,1].');
    end
    if ~isscalar(m) || ~isreal(m) || ~isfinite(m) || m < 3 || m ~= floor(m) || mod(m,2) ~= 1
        error('Stopnja m mora biti liho celo stevilo >= 3.');
    end
    if ~isscalar(yL) || ~isscalar(yD) || ~isreal(yL) || ~isreal(yD) || ~isfinite(yL) || ~isfinite(yD) || yL == yD
        error('Robni vrednosti morata biti realni in razlicni.');
    end

    % Iz T(-1)=yL in T(1)=yD dobimo 2 enacbi za a in b.
    a = (yD-yL) / ((1-S)^m - (-1-S)^m);
    b = yL - a*(-1-S)^m;

    T  = @(u) a*(u-S).^m + b;
    dT = @(u) m*a*(u-S).^(m-1);
end
