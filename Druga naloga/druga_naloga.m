clear
clc
format long

%% PODATKI

f = @(x) sin(1./(x + 0.01));

a = 0;
b = 1;

tol = 1e-3 %inf;


%% PRIBLIZEK PO NASI METODI

[I_izracunan,maxLevel] = adaptiveSimpson(f,a,b,tol);


%% REFERENCA PO NAVODILU

I_referenca = integral(f,a,b);


%% ZAHTEVANA ABSOLUTNA RAZLIKA

odgovor_1 = abs(I_referenca - I_izracunan);


%% IZPIS
I_izracunan
I_referenca
odgovor_1
maxLevel