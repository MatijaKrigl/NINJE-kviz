function p = polinomIzPogojev(pogoji, stopnja)
% POLINOMIZPOGOJEV Sestavi polinom iz poljubnih linearnih pogojev.
%
% Vsaka vrstica matrike pogoji je [x, red_odvoda, zahtevana_vrednost].
%
% Primer za kubik:
%  pogoji = [-1 0 -1; 1 0 1; S 1 0; S 2 0];
%  p = polinomIzPogojev(pogoji,3);
%
% Rezultat p = [a b c d] so koeficienti T(u)=a*u^3+b*u^2+c*u+d.
% Izracun je numericen (A\B); symbolic toolbox ni potreben.

    if ~isscalar(stopnja) || stopnja < 0 || stopnja ~= floor(stopnja)
        error('Stopnja mora biti nenegativno celo stevilo.');
    end
    if ~isnumeric(pogoji) || size(pogoji,2) ~= 3 || ...
            any(~isfinite(pogoji(:)))
        error('Pogoji morajo biti koncna numericna matrika s 3 stolpci.');
    end
    if size(pogoji,1) ~= stopnja+1
        error('Za stopnjo %d potrebujemo %d neodvisnih pogojev.', ...
            stopnja, stopnja+1);
    end

    m = stopnja+1;
    A = zeros(m,m);
    B = pogoji(:,3);

    for i = 1:m
        x = pogoji(i,1);
        red = pogoji(i,2);
        if red < 0 || red ~= floor(red)
            error('Red odvoda mora biti nenegativno celo stevilo.');
        end

        % Pogoju za vrednost ali odvod pripada ena vrstica matrike.
        for j = 1:m
            potenca = stopnja - (j-1);
            if potenca >= red
                A(i,j) = prod((potenca-red+1):potenca) * x^(potenca-red);
            end
        end
    end

    if rank(A) < m
        error('Pogoji niso neodvisni: polinom ni enolicno dolocen.');
    end

    p = (A\B).';
end
