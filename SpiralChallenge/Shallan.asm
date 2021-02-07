
.label DELTA_HI = $3ffd       //Pattern FF 00 00 FF FF
* = $46
     DELTA_LO:
               .byte -40,  1 , 40, -1    
     DELTA_LEN:
               .byte 26,  45 , 28, 43   
     Start:
               // X startings at 01 we can keep this and make the 
               // direction index use the repeating pattern 3,0,1,2
               // so tables adjusted as such     


               //Decrease the length first, this saves having to reload the
               //value twice but means the length table needs to be all +4
               lda DELTA_LEN, x
               sec
               sbc #$04
               sta DELTA_LEN,x
               
               tay
     !l1:   
               // .break
               lda #$80
               sta DrawPos:$03fe

               add:
                    lda DELTA_LO,x
                    clc   
                    adc DrawPos
                    sta DrawPos

                    lda DELTA_HI,x
                    adc DrawPos + 1
                    sta DrawPos + 1
               dey
               bmi *
               bne !l1-


               inx
               xaa #$03  //VERY unstable opcode - equivalent to doing:
                         //TXA
                         //AND #$03
               tax 


               .byte $24 //This is a "BIT $nn" opcode 
                         //Causes the next byte to be ignored and
                         //allows us to fallthrough to "BVC Start" 
                         //saving a byte over doing a "BPL Start" here

* = $73   //This CHRGET routine is run on boot up
          //So we can use it as an entry point
               jsr $e544 //Clear screen, however, when the JSR is 
                         // ignored (see above) becomes "SBC $e5"
                         //which has no impact on the code or the following branch
               bvc Start //overflow always clear














// .label DELTA_HI = $3ffc       //Pattern FF 00 00 FF

// * = $45
//      DELTA_LO:
//                .byte -1, -40,  1 , 40   
//      DELTA_LEN:
//                .byte 42,  26
//      Start:
//           // .break
//                dec DELTA_LEN + 1
//                dec DELTA_LEN

//                // X starts at 01 we can keep this and make the 
//                // direction index use the repeating pattern 3,0,1,2
//                // so tables adjusted as such     

//                // Decrease the length first, this saves having to reload the
//                // value twice but means the length table needs to be all +4
//                inx 
//                xaa #$03
//                pha
//                and #$01
//                tax
//                ldy DELTA_LEN, x 
//                pla 
//                tax

//      !l1:   
//                // .break 
//                // .break
//                lda #$80
//                sta DrawPos:$03fe

//                     lda DELTA_LO,x
//                     clc  
//                     adc DrawPos
//                     sta DrawPos

//                     lda DELTA_HI,x
//                     adc DrawPos + 1
//                     sta DrawPos + 1
                    
//                dey
//                bmi *
//                bne !l1-

//                // bpl *
//                .byte $24 //This is a "BIT $nn" opcode 
//                          //Causes the next byte to be ignored and
//                          //allows us to fallthrough to "BVC Start" 
//                          //saving a byte over doing a "BPL Start" here

// * = $73   //This CHRGET routine is run on boot up
//           //So we can use it as an entry point
          
//                jsr $e544 //Clear screen, however, when the JSR is 
//                          // ignored (see above) becomes "SBC $e5"
//                          //which has no impact on the code or the following branch
               
//                //A:D8 X:01 Y:84 SP:f9 N.-....C
                


//                bvc Start //overflow always clear
 














// .label DELTA_HI = $3ffd       //Pattern FF 00 00 FF FF
// * = $46
//      DELTA_LO:
//                .byte -40,  1 , 40, -1    
//      DELTA_LEN:
//                .byte 26,  45 , 28, 43   
//      Start:
//                // X startings at 01 we can keep this and make the 
//                // direction index use the repeating pattern 3,0,1,2
//                // so tables adjusted as such     

//                 .break
//                //Decrease the length first, this saves having to reload the
//                //value twice but means the length table needs to be all +4
//                lda DELTA_LEN, x
//                sec
//                sbc #$04
//                sta DELTA_LEN,x
               
//                tay
//      !l1:   
//                // .break
//                lda #$80
//                sta DrawPos:$03fe

//                add:
//                     lda DELTA_LO,x
//                     clc   
//                     adc DrawPos
//                     sta DrawPos

//                     lda DELTA_HI,x
//                     adc DrawPos + 1
//                     sta DrawPos + 1
//                dey
//                bmi *
//                bne !l1-


//                inx
//                xaa #$03  //VERY unstable opcode - equivalent to doing:
//                          //TXA
//                          //AND #$03
//                tax 


//                .byte $24 //This is a "BIT $nn" opcode 
//                          //Causes the next byte to be ignored and
//                          //allows us to fallthrough to "BVC Start" 
//                          //saving a byte over doing a "BPL Start" here

// * = $73   //This CHRGET routine is run on boot up
//           //So we can use it as an entry point
//                jsr $e544 //Clear screen, however, when the JSR is 
//                          // ignored (see above) becomes "SBC $e5"
//                          //which has no impact on the code or the following branch
//                bvc Start //overflow always clear
 
 






















// .label DELTA_HI = $3ffe       //Pattern 00 00 FF FF

// .label DrawPos = $b2          //Contains 3c 03 but we'll use 
//                               // Y of $c4 to offset

// * = $1f8
//           .word $e543 //cls
//           .word Start - 1

// DELTA_LO:
//           .byte 40,  1 , -40, -1    

// DELTA_LEN:
//           .byte 24,  41 , 22, 39    
 
// !l3:
//           pla
//           sec
//           sbc #$04
//           sta DELTA_LEN,x

//           dex
//           xaa #$03
//           tax 



// Start:

//           // X startings at 01 we can keep this and make the 
//           // direction index use the repeating pattern 1,0,3,2
//           // so tables adjusted as such     
//           ldy #$c2  // we're using indirect zpy starting with $033c
          

//           lda DELTA_LEN, x
//           pha
// !l1:   
//           //Fun way to turn #$20 into #$80
//           //that just happens to clear carry as bit 7 is clear prior to shift!!
//           slo (DrawPos), y
//           slo (DrawPos), y
//           //Leaves carry flag clear

//           add:
//                lda DELTA_LO,x
//                //clc   //Not needeed thanks to SLO!!!! 
//                adc DrawPos
//                sta DrawPos

//                lda DELTA_HI,x
//                adc DrawPos + 1
//                sta DrawPos + 1
          

//           dec DELTA_LEN, x

//           bmi *
//           bne !l1-
//           bpl !l3-

         
          


























// .label DELTA_HI = $3ffd //Pattern FF 00 00 FF

// .label DrawPos = $99 //Contains 00 03 but we'll use a Y of $fe to offset

// // .label DrawPos = $52

// * = $1f8
//           .word $e543 //cls
//           .word Start - 1

// Start:    
//           ldy #$fe
//           //X starts at 01 we can keep this and make the 
//           //direction index use the repeating pattern 1,2,3,0
//           // so tables adjusted as such
// !l2:        
//           lda DELTA_LEN,x
//           pha       
// !l1:       
//           lda #$80 
//           sta (DrawPos), y
          
//           lda DELTA_LO,x
//           clc
//           adc DrawPos
//           sta DrawPos
//           lda DELTA_HI,x
//           adc DrawPos + 1
//           sta DrawPos + 1
          
//           dec DELTA_LEN, x
       
//           bmi *
//           bne !l1-


//           pla
//           sec
//           sbc #$04
//           sta DELTA_LEN,x

//           inx 
//           xaa #$03
//           tax          
    
//           bpl !l2-
          
          
// DELTA_LO:
//           .byte -40,1,40,-1
// DELTA_LEN:
//           .byte 22,41,24,39