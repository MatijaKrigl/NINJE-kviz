function [val,maxLevel,info] = adaptiveSimpson(f,a,b,tol)
% ADAPTIVESIMPSON  Adaptivno Simpsonovo pravilo s podatki o delitvah.
%
% UPORABA:
%   [val,maxLevel]      = adaptiveSimpson(f,a,b,tol)
%   [val,maxLevel,info] = adaptiveSimpson(f,a,b,tol)
%
% VHOD:
%   f    - funkcijski rocaj, npr. @(x) sin(1./(x+0.01))
%   a,b  - krajsisci CELOTNEGA intervala v zunanjem klicu.
%          Pri notranjem rekurzivnem klicu sta to meji TRENUTNEGA dela.
%   tol  - lokalni prag je tol * (b-a); inf ustavi rekurzijo na zacetku.
%
% IZHOD:
%   val       - integral kot vsota Richardsonovo popravljenih prispevkov
%   maxLevel  - stevilo razpolovitev na najdaljsi poti; prvi klic je NIVO 0
%   info      - diagnostika; polja nCalls, nAccepted, nSplits,
%               nFEvals, estimatedAbsError, sumCorrections in leaves
%
% info.leaves: vsaka vrstica =
%   [levi_rob, desni_rob, globina, I1, I2, abs(I2-I1), prag, prispevek]
%
% POMEMBNO: Ta funkcija sledi pogoju iz podanega osnutka:
%       abs(I2-I1) <= tol*(b-a)
% in popravku
%       I2 + (I2-I1)/15.
% Ne uporablja drugacnega pogoja abs(I2-I1)/15 <= tol*(b-a).
%
% Za primer iz starega kviza je bilo v kvizu potrjeno maxLevel=15,
% najina prvotna definicija (zacetni nivo 0) pa je dala 13.
% Razlike NE odpravljamo z dodajanjem konstante, ker razlog ni potrjen.
% Pred oddajo preveri originalno predlogo profesorja.

    if ~isa(f,'function_handle')
        error('Prvi vhod f mora biti funkcijski rocaj, npr. @(x) exp(x).');
    end
    if ~isscalar(a) || ~isscalar(b) || ~isreal(a) || ~isreal(b) || ...
            ~isfinite(a) || ~isfinite(b) || ~(a < b)
        error('Pricakovana sta koncna realna krajsisca, pri katerih velja a < b.');
    end
    if ~isscalar(tol) || ~isreal(tol) || isnan(tol) || ~(tol > 0)
        error('tol mora biti pozitivno stevilo (dovoljen je tudi Inf).');
    end

    [val,maxLevel,info] = obdelajInterval(f,a,b,tol,0);
end

function [val,maxLevel,info] = obdelajInterval(f,a,b,tol,depth)
    % V vsakem klicu je [a,b] TRENUTNI interval.
    m = (a+b)/2;       % sredina celotnega trenutnega intervala
    l = (a+m)/2;       % sredina leve polovice
    r = (m+b)/2;       % sredina desne polovice

    % Natanko 5 klicev f na vozliscih (brez ponovne uporabe/cachinga).
    fa = f(a);
    fl = f(l);
    fm = f(m);
    fr = f(r);
    fb = f(b);

    y = [fa fl fm fr fb];
    if ~isreal(y) || any(~isfinite(y)) || numel(y) ~= 5
        error('f mora v vsakem vozliscu vrniti koncno realno skalarno vrednost.');
    end

    % I1: en osnovni Simpson na ISTEM [a,b].
    I1 = (b-a)/6 * (fa+4*fm+fb);

    % I2: vsota DVEH Simpsonov na ISTEM [a,b].
    I21 = (m-a)/6 * (fa+4*fl+fm);
    I22 = (b-m)/6 * (fm+4*fr+fb);
    I2 = I21 + I22;

    delta = abs(I2-I1);       % razlika med dvema priblizkoma
    prag  = tol*(b-a);        % dovoljena razlika za TRENUTNI interval

    if delta <= prag
        % TERMINALNI INTERVAL: uporabi Richardsonovo ekstrapolacijo.
        popravek = (I2-I1)/15;
        val = I2 + popravek;
        maxLevel = depth;    % prvi zunanji klic ima depth=0

        info.nCalls = 1;
        info.nAccepted = 1;
        info.nSplits = 0;
        info.nFEvals = 5;
        info.estimatedAbsError = delta/15; % samo hevristicna ocena
        info.sumCorrections = popravek;
        info.leaves = [a b depth I1 I2 delta prag val];
    else
        % Ustavimo, ce razpolavljanje ni vec mozno (varovalka).
        if m == a || m == b || depth >= 45
            error(['Dosezena je meja delitev. Funkcija lahko mocno niha, ' ...
                   'je problematicna ali pa je tol premajhen.']);
        end

        % Rekurzija: vsak del preverimo posebej, tol ostane isti.
        [vL,dL,iL] = obdelajInterval(f,a,m,tol,depth+1);
        [vR,dR,iR] = obdelajInterval(f,m,b,tol,depth+1);

        val = vL+vR;             % integral: SESTEJEMO oba prispevka
        maxLevel = max(dL,dR);   % globina: vzamemo MAKSIMUM

        info.nCalls = 1+iL.nCalls+iR.nCalls;
        info.nAccepted = iL.nAccepted+iR.nAccepted;
        info.nSplits = 1+iL.nSplits+iR.nSplits;
        info.nFEvals = 5+iL.nFEvals+iR.nFEvals;
        info.estimatedAbsError = iL.estimatedAbsError+iR.estimatedAbsError;
        info.sumCorrections = iL.sumCorrections+iR.sumCorrections;
        info.leaves = [iL.leaves; iR.leaves];
    end
end
