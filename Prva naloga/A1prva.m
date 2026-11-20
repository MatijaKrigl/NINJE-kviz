%% 1) SESTI ODVOD PRI pi - ABSOLUTNA NAPAKA
% Datoteka nSimDer.m naj bo v isti mapi.
% Vsako podvprasanje ima svoje podatke, izracun in odgovor.

clear
clc
format long

% 1. PODATKI

f = @(x) sin(x).^2;    % Funkcija.
x_odvod = pi;         % Kje racunamo odvod?
n_odvod = 6;          % Kateri odvod racunamo?
h = 0.1;              % Razdalja med sosednjima tockama pravila.

tocna_resitev = 32;    % Tocna vrednost sestega odvoda sin(x)^2 pri pi.
% Pri drugi funkciji, tocki ali redu odvoda popravi tudi tocna_resitev.

% 2. IZRACUN

priblizek_odvoda = nSimDer(f, x_odvod, h, n_odvod);

% 3. ODGOVOR ZA VPIS V KVIZ: ABSOLUTNA NAPAKA

odgovor_1 = abs(priblizek_odvoda - tocna_resitev)


%% 2) TAYLORJEV POLINOM - PRIBLIZEK ZA f(0.1)

format long

% 1. PODATKI

f = @(x) sin(x).^2;    % Funkcija.
x0 = 0;               % Okoli katere tocke razvijamo polinom?
z = 0.1;              % V kateri tocki zelimo priblizek f(z)?
h = 0.1;              % Korak za numericno racunanje odvodov.
stopnja = 4;          % Najvisja potenca v Taylorjevem polinomu.

% 2. IZRACUN
% VSE odvode racunamo v x0; polinom vrednotimo pri z.
% Za stopnjo 4 uporabimo k = 0, 1, 2, 3, 4.

P = 0;                % Zacetna vsota.

for k = 0:stopnja

    % a) Izracunamo priblizek k-tega odvoda v x0.
    % Pri k = 0 dobimo kar f(x0).
    odvod = nSimDer(f, x0, h, k);

    % b) Iz odvoda sestavimo k-ti clen Taylorjevega polinoma.
    clen = odvod / factorial(k) * (z - x0)^k;

    % c) Ta clen pristejemo dosedanji vsoti.
    P = P + clen;

end

% 3. ODGOVOR ZA VPIS V KVIZ: VREDNOST POLINOMA PRI z

odgovor_2 = P