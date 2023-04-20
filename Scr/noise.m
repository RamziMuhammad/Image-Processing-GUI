
function g = noise(img_path, type,a, b)
% Hint: the built-in "imnoise" function doesn't add salt noise only without pepper noise, and vice versa.
% This is because it can't add salt & pepper noise with different probabilites.
% Moreover, it can't add uniform, exponential, rayleigh and erlang noise.

f=imread(img_path);
[m,n]=size(f);

switch lower(type)
    case 'exponential'
        r=imnoise2(type,m,n,a);        
    otherwise
        r=imnoise2(type,m,n,a,b);
end    

switch lower(type)
    case 'salt & pepper'
        info=imfinfo(img_path);
        b=info.BitDepth;
        L=2.^b;
        k=L-1;
        g=f;
        g(r==0)=0;
        g(r==1)=k;
    otherwise
        h= im2uint8(log(1+double(r)));
        g= im2uint8(h+f);
end


