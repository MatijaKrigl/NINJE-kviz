function g = tellesNovIntegrand(u, S, p, dp, f)
% TELLESNOVINTEGRAND Po substituciji t=T(u) sestavi novi integrand:
%
%     g(u) = log(abs(s-T(u))) * f(T(u)) * T'(u).
%
% Pri standardnih Tellesovih pogojih je polinom oblike
%     T(u) = alfa*(u-S)^m + s,
% ker so vsi odvodi od 1 do m-1 v S enaki nic.
%
% Zato je log(abs(s-T(u))) = log(abs(alfa)) + m*log(abs(u-S)).
% To je stabilneje kot racunanje log(abs(s-polyval(p,u))).
% Pri u=S matematicno definiramo g(S)=0 (limitna vrednost).
%
% VELJA SAMO za standardni polinom, sestavljen v tellesIzPogojev.

    m = numel(p)-1;
    alfa = p(1);          % Vodilni koeficient, ki ga vrne resevanje sistema
    delta = u-S;

    g = zeros(size(u));
    mask = (delta~=0);

    if any(mask(:))
        v = u(mask);
        logjedro = log(abs(alfa)) + m*log(abs(v-S));
        t = polyval(p,v);
        fv = arrayfun(f,t);             % Deluje tudi, ce f=@(t) 1
        jacobi = polyval(dp,v);        % Odvod iz polyder, ne rocni odvod
        g(mask) = logjedro .* fv .* jacobi;
    end

    if ~isreal(g) || any(~isfinite(g(:)))
        error('Novi integrand ni koncen ali realen na vseh potrebnih tockah.');
    end
end
