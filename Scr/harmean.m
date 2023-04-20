function f = harmean(g,m,n)
% Implemets the harmonic mean filter.
inclass = class(g);
g = im2double(g);
%   h = m * n ./ imfilter(1./(g + eps),ones(m,n),'replicate');

 gg=1./(g);
 g1=imfilter(gg,ones(m,n),'replicate');
 h = (m * n) ./ g1;
f = changeclass(inclass,h);



















