%% PREVERJANJE: ali vse tri funkcije delujejo?
% Odpri vse datoteke v isti mapi in klikni Run.
% Ce je vse pravilno, izpise: VSE KONTROLE SO USPELE.
clear; clc; format long

% TIP 1: S=1/2, kubik.
[T,dT,a,b] = tellesPolinom(0.5,3);
assert(abs(T(0)-6/7)<1e-12)
assert(abs(T(-1)+1)<1e-12)
assert(abs(T(1)-1)<1e-12)
assert(abs(dT(0.5))<1e-12)
assert(abs(a-4/7)<1e-12)
assert(abs(b-13/14)<1e-12)

% TIP 2: s=1/2, kubik.
[S,T] = tellesIzs(0.5,3);
assert(abs(S-0.181082873627752)<1e-10)
assert(abs(T(S)-0.5)<1e-10)
assert(abs(T(0)-0.494593922389593)<1e-10)

% Druga robna pogoja.
T = tellesPolinom(0.5,3,0,1);
assert(abs(T(0)-13/14)<1e-12)

% Obrnjena robova: dopustimo tudi monotono padajoco preslikavo.
T = tellesPolinom(0.5,3,1,0);
assert(abs(T(-1)-1)<1e-12)
assert(abs(T(1)-0)<1e-12)
[S,T] = tellesIzs(0.3,3,1,0);
assert(abs(T(S)-0.3)<1e-10)

% Stopnja 5: posebna formula in splosni sistem data enak odgovor.
T5 = tellesPolinom(0.5,5);
pogoji = [-1 0 -1; 1 0 1; 0.5 1 0; 0.5 2 0; 0.5 3 0; 0.5 4 0];
[koef,A,B] = polinomIzPogojev(pogoji,5);
assert(abs(T5(0)-60/61)<1e-12)
assert(abs(polyval(koef,0)-T5(0))<1e-10)
assert(max(abs(A*koef(:)-B))<1e-10)

% Mali s in stopnja 5.
[S5,T5] = tellesIzs(0.5,5);
assert(abs(S5-0.109421362675614)<1e-10)
assert(abs(T5(S5)-0.5)<1e-10)

% Splosni kubik z drugacnim prvim odvodom.
S = 0.5;
pogoji = [-1 0 -1; 1 0 1; S 1 0.2; S 2 0];
koef = polinomIzPogojev(pogoji,3);
assert(abs(polyval(koef,0)-24/35)<1e-10)

fprintf('\nVSE KONTROLE SO USPELE.\n');
