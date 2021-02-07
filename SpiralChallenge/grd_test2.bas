10 sys 58692
20 for y=0 to 12 step 2
30 x=xw-1
40 poke 1024+(y)*40+x,1
50 if x>21-xw then goto 90
60 poke 1024+(x+3)*40+y,3
80 poke 1024+(x+2)*40+(39-y),4
90 x=x+1: if x<40-xw then poke 1024+(24-y)*40+x,2:goto 40
110 xw=xw+2
120 next y
