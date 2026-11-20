%% TESTIRANJE PRIPRAVLJENIH FUNKCIJ
% To datoteko lahko zazenes po razsiritvi ZIP; glavna koda je v 00_...m.

clear
clc
format long

% 1) Originalni primer
[S,p,dp] = tellesIzPogojev(1,3);
g = @(u) tellesNovIntegrand(u,S,p,dp,@(t) 1);
[I,~,H] = simpsonPaneli(g,-1,1,5);
assert(abs(S-1)<1e-12);
assert(abs(polyval(p,0)-0.75)<1e-12);
assert(abs(polyval(dp,S))<1e-10);
assert(abs(g(S))<1e-14);
assert(abs(I-(-0.614416448885995))<1e-11);
assert(abs(H-0.4)<1e-12);

% 2) Primer iz 2. podvprasanja (s=0.5)
[S,p,dp] = tellesIzPogojev(0.5,3);
assert(abs(S-0.181082873627752)<1e-10);
assert(abs(polyval(p,S)-0.5)<1e-10);
assert(abs(polyval(p,0)-0.494593922389593)<1e-10);
assert(abs(polyval(dp,S))<1e-9);

% 3) Razsiritev na peto stopnjo (S je avtomatsko najden)
[S,p,dp] = tellesIzPogojev(0.5,5);
assert(abs(polyval(p,S)-0.5)<1e-8);
assert(abs(polyval(p,-1)+1)<1e-8);
assert(abs(polyval(p,1)-1)<1e-8);
assert(abs(polyval(dp,S))<1e-7);

disp('VSE KONTROLE SO USPELE.')
