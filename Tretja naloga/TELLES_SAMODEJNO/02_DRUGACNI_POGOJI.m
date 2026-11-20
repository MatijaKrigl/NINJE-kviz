%% DODATNI PRIMER: POLINOM IZ DRUGACNIH POGOJEV
% Primer za prvih dveh podvprasanj (racunanje T(z)).
% Ta datoteka NI neposredna predloga za integral iz 3. podvprasanja:
% tam morajo biti pogoji ustrezni za reparametrizacijo na [-1,1].

clear
clc
format long

%% 1. PODATKI

stopnja = 3;
S = 0.5;
z = 0;

% Vsaka vrstica: [tocka, red odvoda, zahtevana vrednost]
% Tukaj spremenimo robova: T(-1)=0, T(1)=1.
pogoji = [-1 0 0; ...
           1 0 1; ...
           S 1 0; ...
           S 2 0];

%% 2. POLINOM IN ODVOD SAMA NASTANETA IZ POGOJEV

p = polinomIzPogojev(pogoji,stopnja);
dp = polyder(p);

T  = @(u) polyval(p,u);
dT = @(u) polyval(dp,u);

%% 3. ODGOVORI

odgovor = T(z)
kontrola = [T(-1), T(1), dT(S)]

% Pricakovano T(0) = 0.928571428571429
