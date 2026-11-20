%% NALOGA 2 - ULTIMATE PRIPRAVA NA KVIZ (MATLAB)
% Datoteka adaptiveSimpson.m MORA biti v isti mapi.
% Najprej spremeni samo PODATKE. Nato zazeni celotno skripto.
% Vse rezultate dobis spodaj; zahtevnejse analize lahko izklopis.
%
% PRI KVIZU POZOR:
% 1. I1 in I2 sta VEDNO na istem trenutnem intervalu [a,b].
% 2. I1 je en Simpson; I2 je vsota dveh Simpsonov.
% 3. Pogoj iz osnutka je abs(I2-I1) <= tol*(b-a).
% 4. Richardsonov popravek je (I2-I1)/15 (s predznakom!).
% 5. Pri tol=inf ni nadaljnjih delitev, ampak popravek SE VEDNO uporabimo.
% 6. Glavno opozorilo: stari kviz je potrdil globino 15. Nasa funkcija
%    pri istem primeru vrne 13 (prvi klic ima nivo 0). Tega ne skrivamo
%    s samodejnim +2; za drugacen kviz preveri profesorjevo predlogo.

clear
clc
format long

%% ================================================================
%% 0. PODATKI - TUKAJ SPREMINJAS VREDNOSTI PRI NOVI NALOGI
%% ================================================================

f = @(x) sin(1./(x+0.01));  % FUNKCIJA. Uporabljaj .*, ./, .^ za vektorje.
a = 0;                       % leva meja CELOTNEGA integrala
b = 1;                       % desna meja CELOTNEGA integrala
tol = 1e-3;                  % natancnost adaptivne metode; za neadaptivno: inf

% VKLOPI / IZKLOPI DODATNE NALOGE:
DEMO_LOKALNEGA_INTERVALA = true;  % I1 in I2 na npr. levi polovici
PRIMERJAVA_TOLERANC      = true;  % vrednosti za razlicne tolerance
NARISI_GRAFA            = false; % graf funkcije + gostota adaptivne delitve

% Zahtevnejsa vaja: seznam toleranc; spremeni po potrebi.
tolSeznam = [inf 1e-2 1e-3 1e-4 1e-5];

%% ================================================================
%% 1. REFERENCA - KAJ JE 'PRAVA' VREDNOST ZA PRIMERJAVO?
%% ================================================================

% Kviza: za referenco uporabi TOCNO predpisani ukaz 'integral'.
Iref = integral(f,a,b);

%% ================================================================
%% 2. SIMPSONOVA PRIMERJAVA NA CELOTNEM INTERVALU [a,b]
%% ================================================================

m = (a+b)/2;   % sredina [a,b]
l = (a+m)/2;   % sredina [a,m]
r = (m+b)/2;   % sredina [m,b]

% I1: ENA parabola (tri tocke a,m,b).
I1 = (b-a)/6*(f(a)+4*f(m)+f(b));

% I2: DVE paraboli na ISTEM [a,b] (pet razlicnih tock a,l,m,r,b).
I21 = (m-a)/6*(f(a)+4*f(l)+f(m));  % leva polovica
I22 = (b-m)/6*(f(m)+4*f(r)+f(b));  % desna polovica
I2  = I21+I22;

% Primerjava + popravek:
delta = abs(I2-I1);             % samo za PRESOJO delitve (pozitivna vrednost)
prag = tol*(b-a);              % kriterij za trenutno dolzino intervala
popravek = (I2-I1)/15;         % podpisana korekcija, NE abs(...)
I_R = I2+popravek;             % Richardsonov priblizek

if delta <= prag
    odlocitev = 'sprejmemo zacetni interval';
else
    odlocitev = 'zacetni interval razdelimo';
end

%% ================================================================
%% 3. NEADAPTIVNO (tol=inf), NATO ADAPTIVNO (tol = nastavljena)
%% ================================================================

[Iinf, Linf, infoInf] = adaptiveSimpson(f,a,b,inf);
[Iadapt, Ladapt, info] = adaptiveSimpson(f,a,b,tol);

% Napaka pomeni razliko do REFERENCE, ne abs(I2-I1)!
Einf   = abs(Iref-Iinf);
Eadapt = abs(Iref-Iadapt);

% Relativna napaka je smiselna, ce referenca ni blizu nicli.
if abs(Iref) > 1e-14
    relativnaNapaka = Eadapt/abs(Iref);
else
    relativnaNapaka = NaN;  % integral je lahko 0
end

if Eadapt > 0
    faktorIzboljsanja = Einf/Eadapt;
else
    faktorIzboljsanja = inf;
end

%% ================================================================
%% 4. PREGLED REZULTATOV - KOPIRAJ PRAVO KOLICINO V UCILNICO
%% ================================================================

fprintf('\n============== PODATKI ==============\n');
fprintf('Celotni interval         = [%.15g, %.15g]\n',a,b);
fprintf('tol                      = %.6g\n',tol);
fprintf('Iref = integral(f,a,b)   = %.15f\n',Iref);

fprintf('\n======== PRVI KORAK SIMPSONA ========\n');
fprintf('I1 (1 parabola)          = %.15f\n',I1);
fprintf('I21 (leva parabola)      = %.15f\n',I21);
fprintf('I22 (desna parabola)     = %.15f\n',I22);
fprintf('I2 = I21 + I22           = %.15f\n',I2);
fprintf('abs(I2-I1)               = %.15g\n',delta);
fprintf('tol*(b-a)                = %.15g\n',prag);
fprintf('Odlocitev                = %s\n',odlocitev);
fprintf('Richardsonov popravek   = %.15g\n',popravek);
fprintf('I_R = I2 + popravek      = %.15f\n',I_R);

fprintf('\n===== NEADAPTIVNA METODA (Inf) =====\n');
fprintf('Iinf                     = %.15f\n',Iinf);
fprintf('ABS NAPAKA do reference  = %.15g\n',Einf);
fprintf('Globina, prvi klic = 0   = %d\n',Linf);

fprintf('\n======= ADAPTIVNA METODA ===========\n');
fprintf('Iadapt                   = %.15f\n',Iadapt);
fprintf('ABS NAPAKA do reference  = %.15g\n',Eadapt);
fprintf('Relativna napaka         = %.15g\n',relativnaNapaka);
fprintf('Faktor izboljsanja       = %.15g\n',faktorIzboljsanja);

fprintf('\n=== REKURZIJA IN ZAHTEVNEJSE MERE ===\n');
fprintf('Globina: prvi klic nivo 0 = %d\n',Ladapt);
fprintf('Nivoji: prvi klic nivo 1  = %d\n',Ladapt+1);
fprintf('Sprejeti koncni intervali = %d\n',info.nAccepted);
fprintf('Razdelitve (notranji vozli) = %d\n',info.nSplits);
fprintf('Stevilo vseh rekurzivnih klicev = %d\n',info.nCalls);
fprintf('Klici f v TEJ izvedbi     = %d\n',info.nFEvals);
fprintf('Razlicna vzorcna vozlisca (teoreticno) = %d\n',4*info.nAccepted+1);
fprintf('Vsota ocen lokalnih |napak| = %.15g\n',info.estimatedAbsError);
fprintf('Vsota popravkov         = %.15g\n',info.sumCorrections);

% Najgloblji KONCNI podinterval (za razumevanje globine).
[~,idxNajglob] = max(info.leaves(:,3));
najglob = info.leaves(idxNajglob,:);
fprintf('Primer najglobljega [a,b] = [%.15g, %.15g]\n',najglob(1),najglob(2));
fprintf('Sirina najglobljega dela = %.15g\n',najglob(2)-najglob(1));

% Kontrole implementacije; veljajo za binarno rekurzivno drevo.
assert(info.nCalls == 2*info.nAccepted-1, 'Nepricakovano stevilo klicev.');
assert(info.nSplits == info.nAccepted-1, 'Nepricakovano stevilo delitev.');
assert(info.nFEvals == 5*info.nCalls, 'Nepricakovano stevilo vrednotenj f.');
assert(abs(Iinf-I_R) < 1e-12*max(1,abs(I_R)), 'Neujemanje Iinf in I_R.');

% Stari kviz je za f=sin(1/(x+0.01)), [0,1], tol=1e-3 potrdil 15.
% Pri nasi definiciji globine (zacetni nivo 0) je bil rezultat 13.
% Brez profesorjeve predloge NE predpostavljaj, da je razlika vedno +2.

%% ================================================================
%% 5. DODATNO: PREVERIMO I1 IN I2 NA MANJSEM PODINTERVALU
%% ================================================================

if DEMO_LOKALNEGA_INTERVALA
    aL = a;
    bL = (a+b)/2;       % primer: LEVA polovica zacetnega intervala
    mL = (aL+bL)/2;
    lL = (aL+mL)/2;
    rL = (mL+bL)/2;

    I1L  = (bL-aL)/6*(f(aL)+4*f(mL)+f(bL));
    I21L = (mL-aL)/6*(f(aL)+4*f(lL)+f(mL));
    I22L = (bL-mL)/6*(f(mL)+4*f(rL)+f(bL));
    I2L  = I21L+I22L;

    fprintf('\n====== PRIMER LOKALNEGA INTERVALA ======\n');
    fprintf('Trenutni interval        = [%.15g, %.15g]\n',aL,bL);
    fprintf('I1 lokalno               = %.15g\n',I1L);
    fprintf('I2 lokalno               = %.15g\n',I2L);
    fprintf('Lokalna razlika          = %.15g\n',abs(I2L-I1L));
    fprintf('Lokalni prag             = %.15g\n',tol*(bL-aL));
end

%% ================================================================
%% 6. ZAHTEVNEJSE: REZULTATI PRI RAZLICNIH TOLERANCAH
%% ================================================================

if PRIMERJAVA_TOLERANC
    fprintf('\n====== TOLERANCNI PREIZKUS ======\n');
    fprintf(' tol           I               abs napaka       globina  sprejeti   klici f\n');
    for k = 1:numel(tolSeznam)
        t = tolSeznam(k);
        [V,L,st] = adaptiveSimpson(f,a,b,t);
        fprintf('%-10.2g  %.12f   %.4e      %3d     %5d    %6d\n', ...
            t,V,abs(Iref-V),L,st.nAccepted,st.nFEvals);
    end
end

%% ================================================================
%% 7. NEOBVEZNO: GRAF FUNKCIJE IN SIRINE SPREJETIH INTERVALOV
%% ================================================================

if NARISI_GRAFA
    xs = linspace(a,b,2500);
    ys = arrayfun(f,xs);
    meje = unique([info.leaves(:,1);info.leaves(:,2)]);

    figure;
    subplot(2,1,1);
    plot(xs,ys,'b-','LineWidth',1);
    grid on; hold on;
    % Najvec 150 crt, da graf ne postane prenatrpan.
    if numel(meje) <= 150
        ylimGrafa = ylim;
        for j = 1:numel(meje)
            line([meje(j),meje(j)],ylimGrafa,'Color',[0.8 0.8 0.8]);
        end
    end
    title('Funkcija f in meje sprejetih intervalov');
    xlabel('x'); ylabel('f(x)');

    subplot(2,1,2);
    centri = (info.leaves(:,1)+info.leaves(:,2))/2;
    sirine = info.leaves(:,2)-info.leaves(:,1);
    semilogy(centri,sirine,'o');
    grid on;
    title('Kje je metoda uporabila manjse intervale?');
    xlabel('Sredina sprejetega intervala');
    ylabel('Sirina sprejetega intervala');
end

%% POVZETEK ZA KVIZ:
% - "Neadaptivna napaka"  -> Einf
% - "Adaptivni integral"  -> Iadapt
% - "Adaptivna napaka"   -> Eadapt
% - "Richardson"         -> I_R ali popravek (preberi vprasanje)
% - "Razlika I1 in I2"    -> delta (NI isto kot napaka do reference)
% - "Najvecja globina"   -> Ladapt, ampak preveri konvencijo profesorja!
% - "Stevilo intervalov"  -> info.nAccepted
% - "Stevilo klicev f"   -> info.nFEvals (nasa implementacija brez cachinga)
