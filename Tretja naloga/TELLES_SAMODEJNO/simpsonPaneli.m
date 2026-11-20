function [I, paneli, H] = simpsonPaneli(g, a, b, N)
% SIMPSONPANELI Sestavljeno Simpsonovo pravilo na N enakih panelih.
%
% Za panel [L,R] z M=(L+R)/2 je:
%    Ik = (R-L)/6 * (g(L) + 4*g(M) + g(R)).
%
% I = vsota N prispevkov. Brez rekurzije in tolerance.
% paneli = [L, M, R, prispevek] za vsak panel.

    if ~isscalar(N) || ~isfinite(N) || N < 1 || N ~= floor(N)
        error('N mora biti pozitivno celo stevilo.');
    end
    if ~(isscalar(a) && isscalar(b) && isfinite(a) && isfinite(b) && a<b)
        error('Pricakujemo koncna krajsisca z a < b.');
    end

    H = (b-a)/N;
    I = 0;
    paneli = zeros(N,4);

    for k = 1:N
        L = a+(k-1)*H;
        R = a+k*H;
        M = (L+R)/2;

        gl=g(L); gm=g(M); gr=g(R);
        if any(~isfinite([gl gm gr]))
            error('Na panelu %d je integrand neskoncen ali NaN.', k);
        end
        Ik=H/6*(gl+4*gm+gr);
        I=I+Ik;
        paneli(k,:)=[L M R Ik];
    end
end
