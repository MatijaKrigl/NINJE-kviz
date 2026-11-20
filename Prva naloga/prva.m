format long

% a) 
f = @(x) sin(x).^2;
num_resitev = nSimDer(f, pi, 0.1, 6);

% b)
d0 = nSimDer(f,0,h,0);       % f(x)
d1 = nSimDer(f, x2, 0.1, 1);
d2 = nSimDer(f, x2, 0.1, 2);
d3 = nSimDer(f, x2, 0.1, 3);
d4 = nSimDer(f, x2, 0.1, 4);
P4 = d0 + (d1 .* 0.1) + (d2 .* 0.01 .* 0.5) + (d3 .* 0.001 ./ 6) + (d4 .* 0.0001 ./24)




