function [S, p, dp, pogoji] = tellesIzPogojev(s, stopnja)
% TELLESIZPOGOJEV Iz s avtomatsko doloci S, polinom T in T'.
%
% PODATKI:
% s       singularnost prvotnega integrala, s v [-1,1]
% stopnja 3 (kubik) ali 5 (dodatno sploscenje)
%
% STANDARDNI POGOJI:
% T(-1)=-1, T(1)=1;
% T'(S)=...=T^(stopnja-1)(S)=0;
% T(S)=s.
%
% IZHOD:
% S       lokacija singularnosti v novi spremenljivki
% p       koeficienti polinoma T (za polyval)
% dp      koeficienti odvoda T' (za polyval)
% pogoji  matrika uporabljenih pogojev [x, red, vrednost]

    if ~isscalar(s) || ~isreal(s) || ~isfinite(s) || abs(s)>1
        error('Mali s mora biti koncna realna vrednost v [-1,1].');
    end
    if ~isscalar(stopnja) || ~ismember(stopnja, [3 5])
        error('Podprti sta stopnji 3 in 5.');
    end

    % Neznani S dobimo iz T(S)=s. Za vsak kandidat S polinom
    % sestavimo IZ POGOJEV; ne potrebujemo vnaprej izpeljane formule.
    if s == -1
        S = -1;
    elseif s == 1
        S = 1;
    else
        S = fzero(@(kandidat) vrednostTS(kandidat, stopnja)-s, [-1,1]);
    end

    pogoji = sestaviPogoje(S,stopnja);
    p = polinomIzPogojev(pogoji,stopnja);
    dp = polyder(p);   % MATLAB sam izracuna odvod polinoma!
end

function pogoji = sestaviPogoje(S,stopnja)
    % Dva robna pogoja in (stopnja-1) pogojev za odvode.
    pogoji = [-1 0 -1; 1 0 1; ...
        repmat(S,stopnja-1,1), (1:stopnja-1)', zeros(stopnja-1,1)];
end

function vrednost = vrednostTS(S,stopnja)
    p = polinomIzPogojev(sestaviPogoje(S,stopnja),stopnja);
    vrednost = polyval(p,S);
end
