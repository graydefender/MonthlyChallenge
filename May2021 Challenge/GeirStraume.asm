; ----------------------------------------------------------------------------------------------------
; An entry for Shallan's "Big Chars Challenge" (May 2021)
;
; Code by Geir Straume (Discord: TheNewGuy#7311, Web: https://gstraume.itch.io/)
; ----------------------------------------------------------------------------------------------------

                processor 6502      ; This source file is in DASM format

; Zero-page variables
CharIdx         =    $80            ; Index to char being processed

; The code itself starts here
                org  $c000          ;

                ldy  #2             ; Start with the 3rd char
CharLoop:       sty  CharIdx        ; Save char index
                lax  AddrLo,y       ; Get lo byte of base screen address for white text char
                sta  TextAddr+1     ; Self-modifying code
                sta  ColorAddr+1    ;
                sbx  #-41           ; Calculate lo byte of base screen address for drop shadow char
                stx  ShadowAddr+1   ; Self-modifying code
                lsr  $89            ; Set hi byte of address of char data to $68 for now (see Note 1 below)
                lax  2,y            ; Get char to display (using 'lax' instead of 'lda' just to save a byte)
                ldx  #249           ; Initial offset value (40 * 6 + 9) to add to base screen address
                ldy  #6             ; Index to last byte of char data to process (the 8th byte is known to be zero for all alphanumeric chars)
                asl                 ;
                asl                 ;
                asl                 ; Multiply char value by 8 to get address of first data byte
                rol  $89            ; Adjust hi byte
                dc.b $85            ; Set lo byte ('sta $88': using opcode for 'dey' as the zp address)
ByteLoop:       dey                 ; This instruction is skipped in the first loop iteration, due to the 'sta' above
                lsr  1              ; Enable char ROM
                lda  ($88),y        ; Get current data byte for char
                rol  1              ; Enable I/O and color RAM
                asl                 ; Leftmost bit is known to be clear in all alphanumeric chars, so it's skipped early to save some cycles
                dc.b $84            ; Save data byte index ('sty $e8': using opcode for 'inx' as the zp address)
BitLoop:        inx                 ; This instruction is skipped in the first loop iteration, due to the 'sty' above
                asl                 ; Shift out next bit in current data byte
                bcc  BitLoop        ; Loop until a set bit is found (see Note 2 below)
                tay                 ; Save current data byte
                lda  #160           ; Block char (inverted space)
TextAddr:       sta  $0560,x        ; Put text char on screen
ColorAddr:      inc  $d960,x        ; Change color from black to white for text char
ShadowAddr:     sta  $0589,x        ; Put drop shadow char on screen
                tya                 ; Restore current data byte
Skip:           bne  BitLoop        ; Loop until there are no more bits set in it
                lda  #$f8           ; Mask to clear lower 3 bits of x in the next instruction
                sbx  #39            ; Adjust screen offset value
                ldy  $e8            ; Restore data byte index
                bne  ByteLoop       ; Loop for all bytes
                ldy  CharIdx        ; Restore char index
                dey                 ;
                bpl  CharLoop       ; Loop for all chars
AddrLo:         rts                 ; Also using opcode $60 as lo byte of base screen address to use for the 1st char
                dc.b $6a,$74        ; Lo byte of base screen address for the 2nd and 3rd char

; NOTES:
;
; 1. The CHRGET routine used by BASIC starts at zero-page location $73 (see https://www.c64-wiki.com/wiki/115-138). Location $89
;    contains the value $d0, which also happens to be the hi byte of the char ROM address. Therefore, locations $88-$89 are very
;    suitable for storing the address of the first data byte for the char. The fact that $88 is also the opcode for 'dey' enables
;    another optimisation, at the start of 'ByteLoop'.
;
; 2. This was originally 'bcc Skip'. However, rule 1 for the challenge specifies "letters or numbers from the default c64 uppercase
;    ROM font". The instruction could therefore be changed to 'bcc BitLoop', because all these alphanumeric chars have at least one
;    bit set in all of their data bytes (except the 8th byte, but that byte is not included in 'ByteLoop' anyway.)
;
; A final note: Thanks to Shallan for a fun and interesting challenge!
