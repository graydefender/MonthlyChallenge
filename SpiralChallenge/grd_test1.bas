505 sys 58692
508 gosub 2000
1000 for y=0 to 12 step 2
1010 for x=xw to 40-xw
1020 poke 1024+y*40+x-1,1
1030 if x>xw then poke 1024+(24-y)*40+x-1,2
1035 rem if x<>(39-xw) then 
1040 next x
1050 xw=xw+2
1060 next y
1065 goto 1065
1070 goto 1070
2000 xw=0: yw=0
2005 rem for x=0+xw to 39-xw step 2
2008 for x=0 to 10 step 2
2010 for y=yw+1 to 23-yw
2020  poke 1024+(y+1)*40+x,3
2022 poke 1024+(y)*40+(39-x),4
2040 next y
2050 yw=yw+2
2060 next x
2070 return

