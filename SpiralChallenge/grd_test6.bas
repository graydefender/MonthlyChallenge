40 dim cnt(26)
100 print "{clear}{home}";
110 cd$="rdilurdlurdlurdlurdlurdlur"
130 for i=1 to 26
135   read cnt(i)
140   gosub 170
150 next i
165 goto 165:end
170 for x=1 to cnt(i)
180 if mid$(cd$,i,1)="r" then print "@";
190 if mid$(cd$,i,1)="d" then print "{down}@{left}";
195 if mid$(cd$,i,1)="i" then print "{left}{down}@{left}{148} ";
210 if mid$(cd$,i,1)="l" then print "{left}@{left}";
220 if mid$(cd$,i,1)="u" then print "{up}@{left}";
230 next x
235 if mid$(cd$,i,1)="r" then print "{left}";
240 return
250 data 40,23,1,39,22,38,20,35,18,34,16,31,14,30,12,27,10,26,8
260 data 23,6,22,4,19,2,18