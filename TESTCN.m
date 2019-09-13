c=355.969;
d=117.382;
a=378.1951;
b=279.7292;
g=490;
h=215;
i=441;
j=191;
e=437;
f=153;


% c=265.253;
% d=127.4447;
% a=303.0704;
% b=218.8367;
% g=394;
% h=137;
% i=344;
% j=141;
% e=333;
% f=120;







CN=charanums5(a,b,c,d,e,f,g,h,i,j);
CN=((a*d - b*c - a*j + b*i + c*j - d*i)*(a*f - b*e - a*h + b*g + e*h - f*g)*(c*h - d*g - c*j + d*i + g*j - h*i))/...
((a*d - b*c - a*h + b*g + c*h - d*g)*(a*h - b*g - a*j + b*i + g*j - h*i)*(c*f - d*e - c*j + d*i + e*j - f*i));
disp(['本组数值CN为：',CN]);disp(CN);