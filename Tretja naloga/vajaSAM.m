%% KVIZ 3 - HITRA RESITEV (VSE V ENEM RAZDELKU)
% ================================================================
% NAVODILO: 1) Izberi TIP_NALOGE, 2) spremeni podatke, 3) klikni RUN.
% NIKOLI ni treba spreminjati kode pod crto "IZRACUN".
%
% TIP 1 = profesor poda VELIKI S; poiscemo polinom T in vrednost T(z).
% TIP 2 = profesor poda MALI s; najprej poiscemo S, nato T(z).
% TIP 3 = profesor poda DRUGACNE POGOJE; sestavimo splosni polinom.
%
% Pomembno:
%   S = tocka v NOVI spremenljivki u, kjer se T splosci.
%   s = singularna tocka v STARI spremenljivki t.
%   Povezava: T(S)=s.
%   z = tocka, v kateri zelimo vrednost T(z). To NI nujno S ali s.
%
% Primer originalnega kviza (1. podvprasanje): TIP_NALOGE=1, S_podan=0.5, z=0
% Primer originalnega kviza (2. podvprasanje): TIP_NALOGE=2, s_podan=0.5, z=0

clear
clc
format long

% ========================================================================
% 1. SAMO TUKAJ SPREMINJAJ PODATKE
% ========================================================================

TIP_NALOGE = 2;      % 1 = podan S | 2 = podan s | 3 = drugi pogoji

% --- Vprasanje: KOLIKO JE T(z)? ---
z = 0.25;              % Na primer: 0, 0.2 ali [0, 0.2, 0.5]

% --- Za TIP 1: poznamo VELIKI S ---
S_podan = - 0.25;

% --- Za TIP 2: poznamo MALI s ---
s_podan = -0.6;
velja = abs(s_podan-0.227023580871381)

% --- Za TIP 1 in 2: standardni Tellesovi pogoji ---
stopnja = 3;         % 3 = kubicni polinom; 5 = peta stopnja; 7 = sedma ...
yL = -1;             % T(-1)=yL
yD = 1;             % T(1)=yD
% Poleg robov zahtevamo T'(S)=...=T^(stopnja-1)(S)=0.
% S temi posebnimi pogoji so dovoljene samo LIHE stopnje 3,5,7,...

% --- Za TIP 3: SPLOSNI POGOJI, npr. drugacni odvodi ---
% Vsaka vrstica je: [tocka u, red odvoda, zahtevana vrednost].
% 0 = vrednost T, 1 = prvi odvod T', 2 = drugi odvod T'' itd.
% Za stopnjo 3 morajo biti 4 neodvisni pogoji, za stopnjo 5 pa 6.
S_za_pogoje = 0.5;
pogoji = [-1,           0, -1;    % T(-1)  = -1
           1,           0,  1;    % T(1)   =  1
           S_za_pogoje,1,  0;    % T'(S)  =  0
           S_za_pogoje,2,  0];   % T''(S) =  0


% ========================================================================
% 2. IZRACUN - TEGA DELA TI NI TREBA SPREMINJATI
% ========================================================================

fprintf('\n======================================================\n');
fprintf('               REZITEV ZA KVIZ 3\n');
fprintf('======================================================\n');

switch TIP_NALOGE
    case 1
        % Profesor poda S: neposredno sestavimo polinom.
        S = S_podan;
        [T, dT, a, b] = tellesPolinom(S, stopnja, yL, yD);
        fprintf('TIP 1: Podan je VELIKI S = %.15f.\n', S);
        fprintf('T(u) = a*(u-S)^%d + b\n', stopnja);
        fprintf('a = %.15f\nb = %.15f\n', a, b);

    case 2
        % Profesor poda s: najprej numerično poiscemo veliki S.
        [S, T, dT] = tellesIzs(s_podan, stopnja, yL, yD);
        [~, ~, a, b] = tellesPolinom(S, stopnja, yL, yD);
        fprintf('TIP 2: Podan je MALI s = %.15f.\n', s_podan);
        fprintf('Najdeni VELIKI S = %.15f\n', S);
        fprintf('T(u) = a*(u-S)^%d + b\n', stopnja);
        fprintf('a = %.15f\nb = %.15f\n', a, b);

    case 3
        % Poljuben sistem neodvisnih pogojev za koeficiente polinoma.
        [koef, A, B] = polinomIzPogojev(pogoji, stopnja);
        T = @(u) polyval(koef, u);
        dT = @(u) polyval(polyder(koef), u);
        fprintf('TIP 3: Splosni polinom stopnje najvec %d.\n', stopnja);
        fprintf('Koeficienti [od najvisje potence do konstante]:\n');
        disp(koef)
        fprintf('Najvecja napaka pri izpolnjevanju pogojev: %.3e\n', ...
            max(abs(A*koef(:)-B)));

    otherwise
        error('TIP_NALOGE mora biti 1, 2 ali 3.');
end

% ========================================================================
% 3. ODGOVOR - TO STEVILKO PREPISES V KVIZ
% ========================================================================

odgovor = T(z);
fprintf('\n--------------- ODGOVOR ZA KVIZ -----------------\n');
for j = 1:numel(z)
    fprintf('T(%.15g) = %.15f\n', z(j), odgovor(j));
end
fprintf('-------------------------------------------------\n');

% ========================================================================
% 4. KONTROLA (za TIP 1 in TIP 2)
% ========================================================================

if TIP_NALOGE == 1 || TIP_NALOGE == 2
    fprintf('\nKONTROLA: T(-1)=%.12f, T(1)=%.12f\n', T(-1), T(1));
    fprintf('T''(S)=%.3e (mora biti priblizno 0)\n', dT(S));
    fprintf('T(S)=%.15f (to je mali s)\n', T(S));
end

% Spremenljivka 'odgovor' ostane v Workspace. Ce je z vektor,
% je tudi odgovor vektor. Posamezna stevila so izpisana zgoraj.
