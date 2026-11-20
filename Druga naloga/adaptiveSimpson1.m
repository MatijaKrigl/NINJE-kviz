function [val,maxLevel] = adaptiveSimpson(f,a,b,tol)
% Adaptivno Simpsonovo pravilo po osnutku naloge.
% Predpostavimo a < b in tol > 0; dovoljen je tudi tol = inf.
% Funkcija f naj v uporabljenih tockah vraca koncne skalarne vrednosti.

    % Sredina trenutnega intervala.
    m = (a+b)/2;

    % Sredini leve in desne polovice.
    l = (a+m)/2;
    r = (m+b)/2;

    % Vrednosti, ki jih potrebujemo veckrat.
    fa = f(a);
    fm = f(m);
    fb = f(b);

    % I1: en Simpson na celotnem trenutnem intervalu [a,b].
    I1 = (b-a)/6 * (fa + 4*fm + fb);

    % I2: vsota Simpsonov na obeh polovicah istega intervala.
    Ileft  = (m-a)/6 * (fa + 4*f(l) + fm);
    Iright = (b-m)/6 * (fm + 4*f(r) + fb);

    I2 = Ileft + Iright;

    % Primerjava dveh priblizkov ISTEGA integrala.
    if abs(I2-I1) <= tol*(b-a)

        % Interval sprejmemo in uporabimo Richardsonov popravek.
        val = I2 + (I2-I1)/15;

        % Nobenega nadaljnjega rekurzivnega klica.
        maxLevel = 1;

    else

        % Vsako polovico obravnavamo kot nov problem.
        % tol ostane isti; dolzina intervala se zmanjsa.
        [valLeft,levelLeft] = adaptiveSimpson(f,a,m,tol);
        [valRight,levelRight] = adaptiveSimpson(f,m,b,tol);

        % Integral je vsota prispevkov obeh polovic.
        val = valLeft + valRight;

        % Globina sledi daljsi poti rekurzije.
        maxLevel = 1 + max(levelLeft,levelRight);

    end
end