100 sys 58692
110 a$="{A*40}"
120 b$="@ @ @ @ @ @ @ @"
130 lf=1:off=1:rr=38:cc=0
140 for y=0 to 24 step 1
150 if (y and 1)=0 then print left$(b$,lf);mid$(a$,lf,rr);right$(b$,lf-cc);
160 if (y and 1)=1 then print left$(b$,lf);spc(rr);right$(b$,lf-cc);
170 if y=12 then off=-1:cc=3:rr=rr-1:lf=lf+2
180 lf=lf+off
190 rr=rr-(2*off)
200 next
210 goto 210
