%% NINDE - 3. naloga (3. podvprasanje): SAMODEJNA TELLES + SIMPSON
% Napisano za integral na [-1,1]:
%
%   I = integral_{-1}^{1} log(abs(s-t)) * f(t) dt
%
% Funkcija sama:
%  1) poisce veliki S iz malega s,
%  2) sestavi T iz robnih pogojev in pogojev za odvode,
%  3) iz polinoma avtomatsko doloci T' s polyder,
%  4) sestavi novi integrand g(u) s substitucijo t=T(u),
%  5) izracuna integral s sestavljenim Simpsonom na N panelih.
%
% Za uporabnika ni racunanja odvodov ali koeficientov na roke.
% To NI adaptivni Simpson: N panelov je vnaprej dolocenih.
%
% Vse pomocne .m datoteke morajo biti v isti mapi.

clear
clc
format long

%% 1. PODATKI IZ KVIZA - SPREMENI SAMO TO

s = 1;                 % MALI s: singularna tocka (od -1 do 1)
f = @(t) 1;           % Regularni del f(t), npr. @(t) 1+t.^2
N = 5;                 % Stevilo Simpsonovih PANELOV (ne globina!)
stopnja = 3;           % Standardna Telles: 3; opcijsko 5

% POZOR: pri stopnji 5 samodejno postavimo dodatne pogoje:
% T'(S)=T''(S)=T'''(S)=T''''(S)=0.
% Ce profesor zahteva drugacne pogoje, ta predloga NE velja neposredno.

%% 2. SAMODEJNO SESTAVIMO POLINOM IN ODVOD

% Pomozna funkcija postavi sistem za koeficiente in resi A\B.
[S, p, dp, pogoji] = tellesIzPogojev(s, stopnja);

% polyval izracuna vrednosti polinoma p.
% polyder izracuna koeficiente odvoda (dp); brez rocnega odvajanja.
T  = @(u) polyval(p, u);
dT = @(u) polyval(dp, u);

fprintf('\nVELIKI S = %.15f\n', S);
fprintf('Pogoji [tocka u, red odvoda, zahtevana vrednost]:\n');
disp(pogoji)
fprintf('Koeficienti T (od najvisje potence):\n');
disp(p)
fprintf('Koeficienti odvoda T'':\n');
disp(dp)

% Kontrola obveznih pogojev.
preveri_pogoje = [T(-1)+1, T(1)-1, T(S)-s];
fprintf('Najvecja napaka robov in T(S)=s: %.3e\n', max(abs(preveri_pogoje)));

%% 3. SAMODEJNO SESTAVIMO NOVI INTEGRAND g(u)

% Matematicno: g(u) = log(abs(s-T(u))) * f(T(u)) * T'(u).
% Pomozna funkcija to sestavi NUMERICNO STABILNO:
% - blizu singularnosti uporabi znano niclo polinoma,
% - neposredno pri u=S vrne pravo limitno vrednost g(S)=0,
% - vključi Jakobijan dT(u) in regularni del f(T(u)).

g = @(u) tellesNovIntegrand(u, S, p, dp, f);

%% 4. SESTAVLJENO SIMPSONOVO PRAVILO

% Obmocje nove spremenljivke u je [-1,1].
% Uporabimo NATANKO N panelov, vsak ima levo, srednjo in desno tocko.

[odgovor_3, paneli, H] = simpsonPaneli(g, -1, 1, N);

fprintf('\nH = %.15f je sirina enega panela.\n', H);
fprintf('Panel |      L       M       R      | prispevek\n');
for k = 1:N
    fprintf('%5d | %+7.3f %+7.3f %+7.3f | %+.15f\n', ...
        k, paneli(k,1), paneli(k,2), paneli(k,3), paneli(k,4));
end

%% 5. STEVILCNI ODGOVOR ZA KVIZ

fprintf('\n-----------------------------------------------\n');
fprintf('ODGOVOR ZA KVIZ: %.15f\n', odgovor_3);
fprintf('-----------------------------------------------\n');

% Samo za ORIGINALNO nalogo (s=1, f=1, N=5):
% pricakovani odgovor = -0.614416448885995
% tocna vrednost = log(4)-2
% Pri drugem s ali f slednja tocna vrednost na splosno ne velja.

% Za primerjavo s tocno vrednostjo originalne naloge rocno uporabi:
% tocna_original = log(4)-2;
% abs_napaka_original = abs(odgovor_3-tocna_original);
% To velja SAMO za originalni integrand s=1 in f(t)=1.
