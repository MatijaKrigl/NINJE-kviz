function [koef, A, B] = polinomIzPogojev(pogoji, stopnja)
% polinomIzPogojev: poisce polinom iz SPLOSNIH pogojev.
%
% pogoji je matrika s tremi stolpci:
%     [tocka, red_odvoda, zahtevana_vrednost]
%
% PRIMER: kubik, T(-1)=-1, T(1)=1, T'(S)=0, T''(S)=0
%     pogoji = [-1 0 -1; 1 0 1; S 1 0; S 2 0];
%     koef = polinomIzPogojev(pogoji,3);
%     odgovor = polyval(koef,0);
%
% koef so koeficienti v vrstnem redu od najvisje potence
% do konstante, tako kot jih pricakuje MATLAB-ov polyval.
%
% Zahtevamo tocno (stopnja+1) NEODVISNIH pogojev.
% Zato 4 pogoji sami NE dolocijo enolicnega polinoma stopnje 5.

    if ~isscalar(stopnja) || ~isreal(stopnja) || ~isfinite(stopnja) || ...
            stopnja < 0 || stopnja ~= floor(stopnja)
        error('Stopnja mora biti nenegativno celo stevilo.');
    end
    if ~isnumeric(pogoji) || size(pogoji,2) ~= 3 || any(~isfinite(pogoji(:)))
        error('pogoji mora biti koncna numericna matrika s 3 stolpci.');
    end
    if size(pogoji,1) ~= stopnja + 1
        error('Za polinom stopnje <= %d potrebujes %d neodvisnih pogojev; podanih je %d.', ...
              stopnja, stopnja+1, size(pogoji,1));
    end

    m = stopnja+1;
    A = zeros(m,m);
    B = pogoji(:,3);

    % T(u) = c_m*u^m + ... + c_1*u + c_0.
    % V vsako vrstico matrike vstavimo zahtevani odvod.
    for i = 1:m
        x = pogoji(i,1);
        r = pogoji(i,2);  % red odvoda

        if ~isreal(r) || r < 0 || r ~= floor(r)
            error('Red odvoda mora biti nenegativno celo stevilo.');
        end

        for j = 1:m
            p = stopnja-(j-1);  % potenca, ki pripada j-temu koeficientu

            if p >= r
                % r-ti odvod od u^p je p!/(p-r)! * u^(p-r).
                A(i,j) = factorial(p)/factorial(p-r)*x^(p-r);
            end
            % Ce je p<r, je odvod enak nic (ostane 0 v A).
        end
    end

    if rank(A) < m
        error('Pogoji niso neodvisni: polinom ni enolicno dolocen.');
    end

    koef = (A\B).';  % koeficienti kot vrsticni vektor za polyval
end
