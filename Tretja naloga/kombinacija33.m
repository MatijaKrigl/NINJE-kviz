
clear
clc
format long

%% 1. PODATKI - TUKAJ SPREMINJAS PODATKE

f = @(t) ones(size(t));  % Original: f(t) = 1

a = -1;                   % Spodnja meja prvotnega integrala
b = 1;                    % Zgornja meja prvotnega integrala
n = 5;                    % Stevilo Simpsonovih panelov

TIP = 1;                  % 1 = podan mali s
                          % 2 = podan veliki S

s_podan = 1;              % Za TIP = 1
S_podan = 0.5;            % Za TIP = 2

tocna = log(4)-2;        % Tocna vrednost za originalno nalogo
                          % Za drugo nalogo popravi ali nastavi NaN


%% 2. POISCEMO VELIKI S OZIROMA MALI s

% Normalizacija na interval [-1,1].
% Pri originalnih mejah a=-1, b=1 velja s_norm=s.

if TIP == 1

    s = s_podan;

    s_norm = (2*s-a-b)/(b-a);

    % Iz pogoja T(S)=s nastane kubicna enacba.
    enacba = @(S) S.^3 - 3*s_norm*S.^2 + 3*S - s_norm;

    S = fzero(enacba, [-1,1]);

elseif TIP == 2

    S = S_podan;

    % Iz velikega S dobimo mali s.
    s_norm = S*(3+S^2)/(1+3*S^2);

    s = (a+b)/2 + (b-a)/2*s_norm;

end


%% 3. SESTAVIMO TELLESOV POLINOM

% Polinom ima obliko T(u) = c*(u-S)^3 + d.

c = (b-a)/(2*(1+3*S^2));

d = (a+b)/2 + (b-a)/2 * S*(3+S^2)/(1+3*S^2);

T  = @(u) c*(u-S).^3 + d;

% Odvod polinoma - potreben zaradi substitucije.
dT = @(u) 3*c*(u-S).^2;


%% 4. SESTAVIMO NOVO INTEGRACIJSKO FUNKCIJO

% Prvotni integrand:
% log(abs(s-t))*f(t)
%
% Po substituciji:
% log(abs(s-T(u)))*f(T(u))*T'(u)
%
% Ker T(S)=s, lahko logaritem stabilneje zapisemo kot:
% log(c) + 3*log(abs(u-S))
%
% max(...,realmin) poskrbi, da pri u=S dobimo
% pravilno limitno vrednost g(S)=0, ne NaN.

g = @(u) f(T(u)) .* dT(u) .* ...
         (log(c) + 3*log(max(abs(u-S),realmin)));


%% 5. SESTAVLJENO SIMPSONOVO PRAVILO

% Nova spremenljivka u je vedno na [-1,1].

H = 2/n;

I = 0;

for k = 1:n

    L = -1 + (k-1)*H;  % Levo krajisce
    R = -1 + k*H;      % Desno krajisce
    M = (L+R)/2;       % Sredina

    % Simpson na enem panelu
    clen = H/6*(g(L) + 4*g(M) + g(R));

    % Dodamo prispevek panela
    I = I + clen;

end


%% 6. ODGOVOR ZA KVIZ

odgovor_3 = I

% Preverimo transformacijo.
kontrola = abs(T(S)-s)


%% 7. ABSOLUTNA NAPAKA

if ~isnan(tocna)
    abs_napaka = abs(I-tocna)
end
