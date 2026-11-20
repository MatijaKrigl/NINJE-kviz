%% VAJA 1 - PODAN VELIKI S (ORIGINALNO PRVO PODVPRASANJE)
% NAVODILO: T(-1)=-1, T(1)=1, T'(S)=T''(S)=0.
% Za S=1/2 doloci kubicni polinom T in izracunaj T(0).
% Ideja: T(u)=a*(u-S)^3+b. Robna pogoja dolocita a in b.
clear; clc; format long

% PODATKI
S = 1/2;
z = 0;

% RESITEV
[T, dT, a, b] = tellesPolinom(S, 3);

% ODGOVOR
odgovor_1 = T(z)
% KONTROLA: 0.857142857142857; a=4/7; b=13/14.


%% VAJA 2 - PODAN MALI s (ORIGINALNO DRUGO PODVPRASANJE)
% NAVODILO: Singularnost je pri s=1/2. Doloci veliki S (T(S)=s)
% in nato izracunaj T(0). Vsi ostali pogoji so standardni.
clear; clc; format long

% PODATKI
s = 1/2;
z = 0;

% RESITEV
[S, T] = tellesIzs(s, 3);

% ODGOVORA
veliki_S = S
odgovor_2 = T(z)
% KONTROLA: S = 0.181082873627752; T(0) = 0.494593922389593.


%% VAJA 3 - DRUG VELIKI S IN DRUGA TOCKA VREDNOTENJA
% NAVODILO: S=-1/3. Koliko je T(0.2)?
clear; clc; format long

% PODATKI
S = -1/3;
z = 0.2;

% RESITEV
T = tellesPolinom(S, 3);

% ODGOVOR
odgovor_3 = T(z)
% KONTROLA: -0.664000000000000.


%% VAJA 4 - SPREMENJENA ROBNA POGOJA
% NAVODILO: S=1/2, T(-1)=0, T(1)=1, T'(S)=T''(S)=0.
% Koliko je T(0)?
clear; clc; format long

% PODATKI
S = 1/2;
yL = 0;         % T(-1) = 0
yD = 1;         % T(1) = 1
z = 0;

% RESITEV
T = tellesPolinom(S, 3, yL, yD);

% ODGOVOR
odgovor_4 = T(z)
% KONTROLA: 0.928571428571429.


%% VAJA 5 - DRUGACNE VREDNOSTI ODVODOV
% NAVODILO: Polinom T je kubicen in izpolnjuje:
% T(-1)=-1, T(1)=1, T'(0.5)=0.2, T''(0.5)=0.
% Koliko je T(0)?
% Pozor: to NI standardna Tellesova transformacija, ker T'(S) ni nic.
clear; clc; format long

% PODATKI
S = 0.5;
z = 0;
stopnja = 3;   % Kubicni polinom -> stiri koeficienti.

% Vsaka vrstica pomeni [tocka, red odvoda, vrednost].
pogoji = [-1 0 -1;
           1 0  1;
           S 1  0.2;
           S 2  0];

% RESITEV
koef = polinomIzPogojev(pogoji, stopnja);
T = @(u) polyval(koef, u);

% ODGOVOR
odgovor_5 = T(z)
% KONTROLA: 0.685714285714286.


%% VAJA 6 - PETO STOPNJO IZBEREMO Z VEČ NICELNIMI ODVODI
% NAVODILO: T je stopnje 5, T(-1)=-1, T(1)=1, v S=0.5 pa velja
% T'(S)=T''(S)=T'''(S)=T''''(S)=0. Koliko je T(0)?
% Ideja: T(u) = a*(u-S)^5 + b.
clear; clc; format long

% PODATKI
S = 1/2;
stopnja = 5;
z = 0;

% RESITEV
T = tellesPolinom(S, stopnja);

% ODGOVOR
odgovor_6 = T(z)
% KONTROLA: 0.983606557377049 = 60/61.


%% VAJA 7 - ISTI POLINOM PETE STOPNJE, TODA IZ MATRIKE POGOJEV
% NAVODILO: Isti pogoji kot v vaji 6. Polinom sestavi s splosnim
% sistemom za 6 koeficientov. Koliko je T(0)?
clear; clc; format long

% PODATKI
S = 1/2;
stopnja = 5;
z = 0;

pogoji = [-1 0 -1;
           1 0  1;
           S 1  0;
           S 2  0;
           S 3  0;
           S 4  0];

% RESITEV
koef = polinomIzPogojev(pogoji, stopnja);
T = @(u) polyval(koef, u);

% ODGOVOR
odgovor_7 = T(z)
% KONTROLA: 0.983606557377049 (enako kot vaja 6).


%% VAJA 8 - PODAN MALI s PRI PETI STOPNJI
% NAVODILO: Polinom stopnje 5 iz vaje 6; podan je mali s=0.5.
% Doloci veliki S iz T(S)=s in izracunaj T(0).
% Pomembno: pri peti stopnji NE uporabimo kubicne enacbe za S!
clear; clc; format long

% PODATKI
s = 0.5;
stopnja = 5;
z = 0;

% RESITEV
[S, T] = tellesIzs(s, stopnja);

% ODGOVORA
veliki_S = S
odgovor_8 = T(z)
% KONTROLA: S=0.109421362675614; T(0)=0.499986000283779.


%% VAJA 9 - DODATNI POGOJ T(S)=s (KUBIK NI VEDNO MOZEN)
% NAVODILO: S=0.5, s=0.5 in pogoji T(-1)=-1,T(1)=1,
% T'(S)=T''(S)=0,T(S)=s. Ali je resljiv s kubikom?
% Ce zahtevamo POLINOM STOPNJE 4, koliko je T(0)?
clear; clc; format long

% PODATKI
S = 0.5;
s = 0.5;
z = 0;

% 1. PREVERIMO KUBIK: zaradi prvih 4 pogojev je ze dolocen.
T3 = tellesPolinom(S, 3);
razlika = T3(S) - s
% KONTROLA: 0.428571428571429. Ker ni 0, tak kubik ne obstaja.

% 2. DOPUSTIMO STOPNJO 4 IN VSEH 5 POGOJEV.
stopnja = 4;
pogoji = [-1 0 -1;
           1 0  1;
           S 0  s;
           S 1  0;
           S 2  0];
koef = polinomIzPogojev(pogoji, stopnja);
T4 = @(u) polyval(koef, u);

odgovor_9 = T4(z)
% KONTROLA: 0.222222222222222.
% POZOR: poljubni polinom stopnje 4 ni nujno monotona preslikava.


%% VAJA 10 - PREMALO POGOJEV (NI ENOLICNE RESITVE)
% NAVODILO: T(-1)=-1, T(1)=1, T'(0)=T''(0)=0.
% Pokazi z dvema stevilskima rezultatoma, zakaj 4 pogoji
% ne dolocajo enolicnega polinoma stopnje <=5.
clear; clc; format long

% PODATKI
z = 0.4;

% DVA RAZLICNA POLINOMA, KI USTREZATA VSEM STIRIM POGOJEM
T1 = @(u) u.^3;
T2 = @(u) 0.5*u.^3 + 0.5*u.^5;

odgovor_10a = T1(z)
odgovor_10b = T2(z)
% KONTROLA: 0.064 in 0.03712. Zato resitev NI enolicna.


%% VAJA 11 - KOMBINACIJA: PODAN MALI s IN DRUGACNA ROBOVA
% NAVODILO: Podana je singularnost s=0.7; T(-1)=0 in T(1)=1.
% Polinom je kubicen in velja T'(S)=T''(S)=0.
% Doloci veliki S in izracunaj T(0).
clear; clc; format long

% PODATKI
s = 0.7;
stopnja = 3;
yL = 0;
yD = 1;
z = 0;

% RESITEV
[S, T] = tellesIzs(s, stopnja, yL, yD);

% ODGOVORA
veliki_S = S
odgovor_11 = T(z)
% KONTROLA: S = 0.140285023998463; T(0) = 0.698696558000288.


%% OPOMBA O NALOGAH IZ KVIZA
% Ta dokument je za VARIACIJE prvega in drugega podvprasanja.
% Simpsonovo pravilo in singularni integrali (3. in 4. podvprasanje)
% zahtevajo se druga pravila in niso vkljuceni v ta paket.
