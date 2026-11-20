function [S, T, dT] = tellesIzs(s, m, yL, yD)
% tellesIzs: podan MALI s; numerično poiscemo VELIKI S.
%
% UPORABA:
%   [S,T] = tellesIzs(0.5)            % standardna kubicna preslikava
%   [S,T] = tellesIzs(0.5,5)          % stopnja 5
%   [S,T] = tellesIzs(0.7,3,0,1)      % robova T(-1)=0, T(1)=1
%
% POGOJ: T(S) = s.
% Pri m=3 in robovih -1,1 dobimo kubicno enacbo:
%   S^3 - 3*s*S^2 + 3*S - s = 0.
% Spodaj uporabimo fzero na ekvivalentni splosni enacbi.
%
% IZHOD:
%   S  - tocka nove parametrizacije, kjer je T'(S)=0
%   T  - ustrezna polinomska preslikava
%   dT - odvod preslikave

    if nargin < 2 || isempty(m)
        m = 3;
    end
    if nargin < 3 || isempty(yL)
        yL = -1;
    end
    if nargin < 4 || isempty(yD)
        yD = 1;
    end

    if ~isscalar(m) || ~isreal(m) || ~isfinite(m) || m < 3 || m ~= floor(m) || mod(m,2) ~= 1
        error('Stopnja m mora biti liho celo stevilo >= 3.');
    end
    if ~isscalar(yL) || ~isscalar(yD) || ~isreal(yL) || ~isreal(yD) || ~isfinite(yL) || ~isfinite(yD) || yL == yD
        error('Robni vrednosti morata biti realni in razlicni.');
    end
    if ~isscalar(s) || ~isreal(s) || ~isfinite(s) || s < min(yL,yD) || s > max(yL,yD)
        error('Mali s mora lezati med robnima vrednostma yL in yD.');
    end

    % Za liho stopnjo velja:
    % T(S) = yL + (yD-yL)*(1+S)^m/((1-S)^m+(1+S)^m).
    % S poiscemo kot niclo enacbe T(S)-s=0.
    enacba = @(q) yL + (yD-yL)*(1+q).^m ./ ...
                    ((1-q).^m+(1+q).^m) - s;

    if s == yL
        S = -1;
    elseif s == yD
        S = 1;
    else
        S = fzero(enacba, [-1, 1]);
    end

    [T, dT] = tellesPolinom(S, m, yL, yD);
end
