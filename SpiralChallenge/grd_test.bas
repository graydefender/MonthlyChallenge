100 x=27
110 y=12
115 xw=16
118 yh=1
200 gosub 1000
210 gosub 1000
215 gosub 1000
218 gosub 1000
219 gosub 1000
222 gosub 1000
224 gosub 1005
230 end
1000 gosub 1005:gosub 1025:return
1005 for x=x to x-xw step -1
1010 poke 1024+y*40+x,0
1020 next
1022 return
1025 xw=xw+2
2000 for y=y to y+yh 
2010 poke 1024+y*40+x,1
2020 next
2030 yh=yh+2
3000 for x=x to x+xw
3010 poke 1024+y*40+x,0
3020 next
3030 xw=xw+2
4000 for y=y to y-yh step -1
4010 poke 1024+y*40+x,0
4020 next
4030 yh=yh+2
4040 return
