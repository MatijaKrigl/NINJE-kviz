
function df = nSimDer(f, x, h, n)
% nSimDer izracuna priblizek n-tega odvoda funkcije f v tocki x
% s pomocjo simetricnih diferenc.
%
% VHODNI PODATKI:
% f - funkcija, ki jo odvajamo
% x - tocka, v kateri racunamo odvod
% h - razdalja med sosednjima tockama
% n - red odvoda (1 = prvi, 2 = drugi, ...)
%
% IZHODNI PODATEK:
% df - numericni priblizek n-tega odvoda

    % 1. SESTAVIMO TOCKE OKOLI x
    % Za n-ti odvod potrebujemo n+1 enakomerno razmaknjenih tock.
    % Tocke so simetricno razporejene okoli x.
    %
    % Primer za n=2:
    % tocke = [x-h, x, x+h]
    %
    % Primer za n=4:
    % tocke = [x-2*h, x-h, x, x+h, x+2*h]

    tocke = x + ((0:n) - n/2)*h;


    % 2. IZRACUNAMO VREDNOSTI FUNKCIJE V VSEH TOCKAH
    % arrayfun uporabi funkcijo f na vsaki tocki posebej.
    %
    % Primer:
    % tocke = [1 2 3 4]
    % f(x) = x^2
    % vrednosti = [1 4 9 16]

    vrednosti = arrayfun(f, tocke);


    % 3. RACUNAMO ZAPOREDNE RAZLIKE
    % Postopek ponovimo n-krat.
    %
    % vrednosti(2:end)   = vsi elementi razen prvega
    % vrednosti(1:end-1) = vsi elementi razen zadnjega
    %
    % Odstevamo element po elementu:
    %
    % Zacetek:       [1 4 9 16]
    % Prve razlike:  [3 5 7]    (4-1, 9-4, 16-9)
    % Druge razlike: [2 2]      (5-3, 7-5)
    % Tretja razlika:[0]        (2-2)
    %
    % Vsak prehod skrajsa seznam za en element.
    % Po n ponovitvah ostane samo ena vrednost.

    for i = 1:n
        vrednosti = vrednosti(2:end) - vrednosti(1:end-1);
    end


    % 4. DOBLJENO RAZLIKO DELIMO S h^n
    % Pri prvem odvodu delimo s h.
    % Pri drugem odvodu delimo s h^2.
    % Pri n-tem odvodu delimo s h^n.
    %
    % Ce je n=0, se zanka ne izvede in dobimo df=f(x).

    df = vrednosti(1)/h^n;

end
