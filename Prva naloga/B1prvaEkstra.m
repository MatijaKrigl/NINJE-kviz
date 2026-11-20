% NUMERICNI KVIZ: NALOGE IN RESITVE
%
% Namen: vadba nalog, pri katerih v kviz vpisujes STEVILCNE odgovore.
% Vsak razdelek vsebuje BESEDILO, PODATKE, RESITEV, ODGOVORE in KONTROLO.
%
% UPORABA:
% - Za vajo najprej preberi samo BESEDILO in PODATKE.
% - Svojo resitev lahko napises v prazno skripto in jo primerjas s spodnjo.
% - Posamezno nalogo zazenes z Run Section; celotno datoteko z Run.
% - Pomozna funkcija nSimDer je na koncu: drugih datotek ne potrebujes.
% - Ne zaokrozuj vmesnih rezultatov. Kontrole so priblizne.
%
% Naloge 1-5: Taylorjevi priblizki, njihovi odvodi in integrali.
% Naloge 6-9: optimalni korak in zgornje meje napak.
% Naloga 10: red metode in Richardsonova ekstrapolacija.
% Naloga 11: tezja uporaba optimalnega koraka pri konkretnem odvodu.
% Naloga 12: povezava z numericno integracijo.
%
% POVEZAVE Z VAJAMI:
% 2NumericnoOdvajanje-2.pdf, naloge 3-6: pravila, napake in optimalni korak.
% 3NumericnaIntegracija-3.pdf, naloga 2: integracijsko pravilo z odvodoma.
% Taylorjeve razsiritve in Richardson so dodatne vadbene naloge.
%
% KONVENCIJA:
% Pri nSimDer je h razdalja med sosednjima tockama pravila.
% Za prvi odvod zato vzamemo x-h/2 in x+h/2.

clear
clc
format long


%% NALOGA 1: TAYLOR OKOLI TOCKE, KI NI NIC
% BESEDILO
% Za f(x)=exp(x) sestavi Taylorjev priblizek stopnje 4 okoli x0=0.5.
% Vse odvode izracunaj z nSimDer s korakom h=0.1.
% (a) Izracunaj priblizek za f(0.7).
% (b) Izracunaj absolutno napako glede na exp(0.7).

format long

% PODATKI
f = @(x) exp(x);
x0 = 0.5;
z = 0.7;
h = 0.1;
m = 4;

% RESITEV
P = 0;

for k = 0:m
    odvod = nSimDer(f,x0,h,k);
    clen = odvod/factorial(k)*(z-x0)^k;
    P = P + clen;
end

napaka = abs(P - f(z));

% ODGOVORI ZA VPIS
odgovor_1a = P
odgovor_1b = napaka

% KONTROLA:
% 1a: 2.01391599118
% 1b: 1.63283712518e-4


%% NALOGA 2: LOGARITEM IN TAYLORJEV POLINOM STOPNJE 5
% BESEDILO
% Za f(x)=log(1+x) uporabi Taylorjev priblizek stopnje 5 okoli x0=1.
% Numericne odvode izracunaj s korakom h=0.1.
% (a) Izracunaj priblizek za f(1.25).
% (b) Izracunaj absolutno napako glede na log(2.25).

format long

% PODATKI
f = @(x) log(1+x);
x0 = 1;
z = 1.25;
h = 0.1;
m = 5;

% RESITEV
P = 0;

for k = 0:m
    odvod = nSimDer(f,x0,h,k);
    clen = odvod/factorial(k)*(z-x0)^k;
    P = P + clen;
end

napaka = abs(P - f(z));

% ODGOVORI ZA VPIS
odgovor_2a = P
odgovor_2b = napaka

% KONTROLA:
% 2a: 0.810949095459
% 2b: 1.88792424549e-5


%% NALOGA 3: ISTI TAYLORJEV POLINOM V VEC TOCKAH
% BESEDILO
% Za f(x)=sin(x)^2 sestavi numericni Taylorjev priblizek stopnje 4
% okoli x0=0.3 s korakom h=0.08.
% Ovrednoti ISTI polinom pri z=0.1,0.2,0.4,0.5.
% (a) Koliksna je najvecja absolutna napaka v teh stirih tockah?
% (b) Pri kateri od podanih tock je dosezena?
% (c) Koliksna je vrednost polinoma v tej tocki?

format long

% PODATKI
f = @(x) sin(x).^2;
x0 = 0.3;
Z = [0.1 0.2 0.4 0.5];
h = 0.08;
m = 4;

% RESITEV
% P vsebuje po eno vrednost polinoma za vsak element Z.
P = zeros(size(Z));

for k = 0:m
    odvod = nSimDer(f,x0,h,k);

    % .^ potencira vsak odmik posebej.
    clen = odvod/factorial(k)*(Z-x0).^k;

    P = P + clen;
end

napake = abs(P - f(Z));

% max vrne najvecjo vrednost in njeno mesto v vektorju.
[najvecja_napaka,indeks] = max(napake);
z_najvecja = Z(indeks);
P_najvecja = P(indeks);

% ODGOVORI ZA VPIS
odgovor_3a = najvecja_napaka
odgovor_3b = z_najvecja
odgovor_3c = P_najvecja

% KONTROLA:
% 3a: 2.05630144752e-4
% 3b: 0.5
% 3c: 0.229643216921
% Vse vrednosti P:
% [0.0100306712282 0.0395117498560 0.151569375186 0.229643216921]


%% NALOGA 4: ODVODA ZE SESTAVLJENEGA TAYLORJEVEGA POLINOMA
% BESEDILO
% Za f(x)=log(1+x) sestavi numericni Taylorjev polinom P stopnje 4
% okoli x0=0.5. Uporabi h=0.1.
% (a) Izracunaj P'(0.7).
% (b) Izracunaj P''(0.7).
% (c) Izracunaj napako P'(0.7) glede na f'(0.7).
% (d) Izracunaj napako P''(0.7) glede na f''(0.7).
%
% Odvajamo ze sestavljeni polinom. Numericne odvode funkcije f
% za njegove koeficiente racunamo samo v razvojni tocki x0.

format long

% PODATKI
f = @(x) log(1+x);
x0 = 0.5;
z = 0.7;
h = 0.1;
m = 4;

% RESITEV
% Najprej shranimo numericne odvode v razvojni tocki.
% odvodi(k+1) predstavlja priblizek f^(k)(x0).
odvodi = zeros(1,m+1);

for k = 0:m
    odvodi(k+1) = nSimDer(f,x0,h,k);
end

% Prvi odvod:
% (d_k/k!)*(z-x0)^k po odvajanju postane
% (d_k/(k-1)!)*(z-x0)^(k-1).
P_prvi = 0;

for k = 1:m
    clen = odvodi(k+1)/factorial(k-1)*(z-x0)^(k-1);
    P_prvi = P_prvi + clen;
end

% Drugi odvod: zacnemo pri k=2.
P_drugi = 0;

for k = 2:m
    clen = odvodi(k+1)/factorial(k-2)*(z-x0)^(k-2);
    P_drugi = P_drugi + clen;
end

tocni_prvi = 1/(1+z);
tocni_drugi = -1/(1+z)^2;

% ODGOVORI ZA VPIS
odgovor_4a = P_prvi
odgovor_4b = P_drugi
odgovor_4c = abs(P_prvi - tocni_prvi)
odgovor_4d = abs(P_drugi - tocni_drugi)

% KONTROLA:
% 4a: 0.588154186800
% 4b: -0.350180499540
% 4c: 8.11073177983e-5
% 4d: 0.00415973829480


%% NALOGA 5: INTEGRAL TAYLORJEVEGA POLINOMA
% BESEDILO
% Za f(x)=sin(x)^2 sestavi numericni Taylorjev polinom P stopnje 4
% okoli x0=0.2 s korakom h=0.1.
% (a) Izracunaj integral P(t) od 0.2 do 0.5.
% (b) Izracunaj absolutno napako glede na integral prvotne funkcije.
% Za tocni integral uporabi F(t)=t/2-sin(2*t)/4.

format long

% PODATKI
f = @(x) sin(x).^2;
x0 = 0.2;
z = 0.5;
h = 0.1;
m = 4;
F = @(t) t/2 - sin(2*t)/4;

% RESITEV
I = 0;

for k = 0:m
    odvod = nSimDer(f,x0,h,k);

    % Integral clena d_k/k!*(t-x0)^k od x0 do z:
    % d_k/(k+1)!*(z-x0)^(k+1).
    clen_integrala = odvod/factorial(k+1)*(z-x0)^(k+1);

    I = I + clen_integrala;
end

tocni_integral = F(z) - F(x0);
napaka = abs(I - tocni_integral);

% ODGOVORI ZA VPIS
odgovor_5a = I
odgovor_5b = napaka

% KONTROLA:
% 5a: 0.0369261264694
% 5b: 6.07129058105e-5
% Tocni integral: 0.0369868393752


%% NALOGA 6: OPTIMALNI KORAK ZA DRUGI ODVOD
% BESEDILO
% Za pet-tockovno pravilo za drugi odvod velja zgornja meja napake:
%
% B(h) = M6*h^4/90 + 16*delta/(3*h^2).
%
% M6 omejuje absolutno vrednost sestega odvoda funkcije.
% delta omejuje absolutno napako posamezne funkcijske vrednosti.
%
% Za M6=100 in delta=5e-6 izracunaj:
% (a) optimalni korak h, ki minimizira B(h) za h>0;
% (b) najmanjso vrednost zgornje meje B(h);
% (c) prispevek M6*h^4/90 pri optimalnem koraku;
% (d) prispevek 16*delta/(3*h^2) pri optimalnem koraku.

format long

% PODATKI
M6 = 100;
delta = 5e-6;

% RESITEV
% B'(h)=0:
% 4*M6*h^3/90 - 32*delta/(3*h^3) = 0.
% Od tod h^6 = 240*delta/M6.
h_opt = (240*delta/M6)^(1/6);

prispevek_metode = M6*h_opt^4/90;
prispevek_podatkov = 16*delta/(3*h_opt^2);
B_min = prispevek_metode + prispevek_podatkov;

% ODGOVORI ZA VPIS
odgovor_6a = h_opt
odgovor_6b = B_min
odgovor_6c = prispevek_metode
odgovor_6d = prispevek_podatkov

% KONTROLA:
% 6a: 0.151308574942
% 6b: 0.00174716092947
% 6c: 0.000582386976491
% 6d: 0.00116477395298
% Pri optimalnem koraku je prispevek podatkov dvakrat vecji od prvega.


%% NALOGA 7: STOKRAT NATANCNEJSE FUNKCIJSKE VREDNOSTI
% BESEDILO
% Uporabi model B(h)=M6*h^4/90+16*delta/(3*h^2), kjer je M6=100.
% Napako funkcijskih vrednosti zmanjsamo s 5e-6 na 5e-8.
% V obeh primerih izberi korak, ki minimizira model B(h).
% (a) Koliksen je novi optimalni korak?
% (b) Koliksna je nova najmanjsa zgornja meja napake?
% (c) Koliksno je razmerje h_novi/h_stari?
% (d) Za koliksen faktor se zmanjsa meja: B_stara/B_nova?

format long

% PODATKI
M6 = 100;
delta_stara = 5e-6;
delta_nova = 5e-8;

% RESITEV
h_stari = (240*delta_stara/M6)^(1/6);
h_novi = (240*delta_nova/M6)^(1/6);

B_stara = M6*h_stari^4/90 + 16*delta_stara/(3*h_stari^2);
B_nova = M6*h_novi^4/90 + 16*delta_nova/(3*h_novi^2);

razmerje_korakov = h_novi/h_stari;
faktor_izboljsanja = B_stara/B_nova;

% ODGOVORI ZA VPIS
odgovor_7a = h_novi
odgovor_7b = B_nova
odgovor_7c = razmerje_korakov
odgovor_7d = faktor_izboljsanja

% KONTROLA:
% 7a: 0.0702312191882
% 7b: 8.10960266076e-5
% 7c: 0.464158883361
% 7d: 21.5443469003


%% NALOGA 8: KAKO NATANCNE PODATKE POTREBUJEMO?
% BESEDILO
% Spet velja B(h)=M6*h^4/90+16*delta/(3*h^2), kjer je M6=100.
% Zelimo, da je najmanjsa mogoca vrednost te meje najvec tol=1e-4.
% (a) Koliksna je najvecja se dopustna delta po tem modelu?
% (b) Kateri optimalni korak pripada tej delta?
% (c) Izracunaj B(h) pri dobljenih podatkih.
%
% Iscemo najvecjo delta, za katero obstaja h>0 z B(h)<=tol.

format long

% PODATKI
M6 = 100;
tol = 1e-4;

% RESITEV
% Pri optimumu velja:
% prispevek_podatkov = 2*prispevek_metode.
% Zato je B_min = M6*h_opt^4/30.
%
% Na meji dopustnosti velja B_min=tol:
h_opt = (30*tol/M6)^(1/4);

% Iz pogoja h_opt^6=240*delta/M6 dobimo delta:
delta_max = M6*h_opt^6/240;

B = M6*h_opt^4/90 + 16*delta_max/(3*h_opt^2);

% ODGOVORI ZA VPIS
odgovor_8a = delta_max
odgovor_8b = h_opt
odgovor_8c = B

% KONTROLA:
% 8a: 6.84653196881e-8
% 8b: 0.0740082804492
% 8c: 1e-4


%% NALOGA 9: OPTIMALNI KORAK ZA PRVI ODVOD
% BESEDILO
% Za pet-tockovno pravilo za prvi odvod velja meja:
% B(h)=M5*h^4/30+3*delta/(2*h).
%
% Obravnavaj f(x)=1/(1+x), x=0.5 in delta=5e-6.
% Na [0,1] lahko vzames M5=120, saj je
% f^(5)(x)=-120/(1+x)^6.
%
% (a) Doloci korak, ki minimizira B(h).
% (b) Izracunaj najmanjso vrednost te meje.
% (c) S tem korakom izracunaj priblizek prvega odvoda:
%     D=[f(x-2h)-8*f(x-h)+8*f(x+h)-f(x+2h)]/(12*h).
% (d) Izracunaj dejansko absolutno napako D glede na f'(0.5).
%
% Pri izracunu D uporabi neposredno vrednotenje f.
% delta nastopa v teoreticni meji; umetnih motenj ne dodajamo.

format long

% PODATKI
f = @(x) 1./(1+x);
x = 0.5;
M5 = 120;
delta = 5e-6;

% RESITEV
% B'(h)=0:
% 4*M5*h^3/30 - 3*delta/(2*h^2) = 0.
% Zato h^5 = 45*delta/(4*M5).
h_opt = (45*delta/(4*M5))^(1/5);

B_min = M5*h_opt^4/30 + 3*delta/(2*h_opt);

D = (f(x-2*h_opt) - 8*f(x-h_opt) ...
     + 8*f(x+h_opt) - f(x+2*h_opt))/(12*h_opt);

tocni_odvod = -1/(1+x)^2;
dejanska_napaka = abs(D - tocni_odvod);

% ODGOVORI ZA VPIS
odgovor_9a = h_opt
odgovor_9b = B_min
odgovor_9c = D
odgovor_9d = dejanska_napaka

% KONTROLA:
% 9a: 0.0542235885599
% 9b: 1.72895233403e-4
% 9c: -0.444441388754
% 9d: 3.05569052522e-6
% Vzorci lezijo od priblizno 0.39155 do 0.60845, torej znotraj [0,1].
% B_min je meja z dopuscenimi napakami podatkov, ne dejanska napaka D.


%% NALOGA 10: RED METODE IN RICHARDSONOV PRIBLIZEK
% BESEDILO
% Za f(x)=exp(2*x) z nSimDer priblizaj f''(0) pri
% h=0.2,0.1,0.05. Tocna vrednost je 4.
% Iz napak E(h) izracunaj:
% (a) p1=log2(E(0.2)/E(0.1));
% (b) p2=log2(E(0.1)/E(0.05));
% (c) R=(4*D(0.05)-D(0.1))/3;
% (d) dejansko absolutno napako R;
% (e) oceno napake D(0.05): abs(D(0.05)-D(0.1))/3.
%
% Kolicina iz (e) ocenjuje napako D(0.05), ne napake izboljsanega R.

format long

% PODATKI
f = @(x) exp(2*x);
x = 0;
n = 2;
H = [0.2 0.1 0.05];
tocni_odvod = 4;

% RESITEV
D = zeros(size(H));

for j = 1:numel(H)
    D(j) = nSimDer(f,x,H(j),n);
end

E = abs(D - tocni_odvod);

p1 = log2(E(1)/E(2));
p2 = log2(E(2)/E(3));

% D(2) je izracunan pri 0.1, D(3) pri 0.05.
R = (4*D(3) - D(2))/3;
napaka_R = abs(R - tocni_odvod);
ocena_finega = abs(D(3) - D(2))/3;

% ODGOVORI ZA VPIS
odgovor_10a = p1
odgovor_10b = p2
odgovor_10c = R
odgovor_10d = napaka_R
odgovor_10e = ocena_finega

% KONTROLA:
% 10a: 2.00577214903
% 10b: 2.00144278083
% 10c: 3.99999555159
% 10d: 4.4484145e-6
% 10e: 0.00333889305743
% D = [4.05361859192 4.01335112382 4.00333444464].


%% NALOGA 11: OPTIMALNI KORAK IN KONKRETEN DRUGI ODVOD
% BESEDILO
% Za f(x)=sin(x) racunamo f''(0.7) s pet-tockovnim pravilom:
%
% D=[-f(x-2h)+16*f(x-h)-30*f(x)+16*f(x+h)-f(x+2h)]/(12*h^2).
%
% Meja napake je B(h)=M6*h^4/90+16*delta/(3*h^2).
% Uporabi M6=1 in delta=1e-7.
% (a) Izracunaj korak, ki minimizira B(h).
% (b) Izracunaj D pri tem koraku.
% (c) Izracunaj dejansko napako glede na -sin(0.7).
% (d) Izracunaj B_min.
%
% Pri D funkcijo sin vrednotimo neposredno, brez dodanih motenj.
% Optimalni korak se nanasa na dano zgornjo mejo B(h).

format long

% PODATKI
f = @(x) sin(x);
x = 0.7;
M6 = 1;
delta = 1e-7;

% RESITEV
h_opt = (240*delta/M6)^(1/6);

D = (-f(x-2*h_opt) + 16*f(x-h_opt) - 30*f(x) ...
     + 16*f(x+h_opt) - f(x+2*h_opt))/(12*h_opt^2);

tocni_odvod = -sin(x);
dejanska_napaka = abs(D - tocni_odvod);
B_min = M6*h_opt^4/90 + 16*delta/(3*h_opt^2);

% ODGOVORI ZA VPIS
odgovor_11a = h_opt
odgovor_11b = D
odgovor_11c = dejanska_napaka
odgovor_11d = B_min

% KONTROLA:
% 11a: 0.169838132956
% 11b: -0.644211746881
% 11c: 5.94035674e-6
% 11d: 2.77344509740e-5


%% NALOGA 12: INTEGRACIJA S POMOCJO NUMERICNIH ODVODOV
% BESEDILO
% Priblizaj integral f(x)=1/(1+x) na [0,1].
% Najprej uporabi sestavljeno trapezno pravilo z N=10 podintervali.
% Nato uporabi popravek:
%
% I = T + H^2/12*(D_a-D_b),  H=(b-a)/N.
%
% D_a in D_b sta priblizka prvih odvodov na krajiscih;
% izracunaj ju z nSimDer in korakom h_odvod=0.02.
% (a) Izracunaj T.
% (b) Izracunaj I.
% (c) Izracunaj absolutno napako I glede na log(2).
%
% H je korak integracije; h_odvod je razmik tock za odvajanje.
% Podana f je definirana tudi malo zunaj [0,1].

format long

% PODATKI
f = @(x) 1./(1+x);
a = 0;
b = 1;
N = 10;
h_odvod = 0.02;

% RESITEV
H = (b-a)/N;
X = linspace(a,b,N+1);
Y = f(X);

% Krajiscni vrednosti imata polovicni utezi.
T = H*(Y(1)/2 + sum(Y(2:end-1)) + Y(end)/2);

D_a = nSimDer(f,a,h_odvod,1);
D_b = nSimDer(f,b,h_odvod,1);

I = T + H^2/12*(D_a-D_b);
napaka = abs(I - log(2));

% ODGOVORI ZA VPIS
odgovor_12a = T
odgovor_12b = I
odgovor_12c = napaka

% KONTROLA:
% 12a: 0.693771403175428
% 12b: 0.693146325042224
% 12c: 8.5551772133e-7


%% POMOZNA FUNKCIJA: nSimDer
% Lokalna funkcija je namenjena klicem iz zgornjih nalog.
% Vse lokalne funkcije so na koncu skripte.

function df = nSimDer(f,x,h,n)
% Priblizek n-tega odvoda funkcije f v skalarni tocki x.
% h je razdalja med sosednjima tockama; n je nenegativno celo stevilo.
% Predpostavimo h>0 in da je f definirana v uporabljenih tockah.

    % 1. Sestavimo n+1 simetricno razporejenih tock.
    % Za n=1: [x-h/2, x+h/2].
    % Za n=2: [x-h, x, x+h].
    tocke = x + ((0:n)-n/2)*h;

    % 2. Funkcijo ovrednotimo v vsaki tocki posebej.
    vrednosti = arrayfun(f,tocke);

    % 3. n-krat izracunamo razlike sosednjih vrednosti.
    % Desni izsek: vsi elementi razen prvega.
    % Levi izsek: vsi elementi razen zadnjega.
    % Vsak prehod skrajsa vektor za ena.
    for i = 1:n
        vrednosti = vrednosti(2:end) - vrednosti(1:end-1);
    end

    % 4. Ostane ena razlika; delimo jo s h^n.
    % Pri n=0 se zanka ne izvede, zato dobimo f(x).
    df = vrednosti(1)/h^n;

end
