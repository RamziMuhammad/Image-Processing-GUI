function f = geomean(g,m,n)
% Implements the geometric mean filter.
inclass = class(g);
g = im2double(g);

geomean = imfilter(log(g), ones(m,n), 'replicate');
geomean = exp(geomean);
f = geomean .^ (1/(m*n));

f = changeclass(inclass,f);

