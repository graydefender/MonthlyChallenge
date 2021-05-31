.label ScreenRam = $057d
.label ColorRam = $d97d

.label CharRomVector = $0e // and $0f

.label CharLoopIndex = $20
.label ByteLoopIndex = $21

* = $c000 "Attempt 21"

    Initialise:                                                                 // 3b 4c (x 1)
        // Iniitialise char loop index
        ldx #$02                                                        // 2b 2c
        sec                                                             // 1b 2c


    NextChar:                                                                   // 20b 27c (x 3)
        // Setup screen/color ram locations
        lda Vectors, x                                                  // 3b 4c
        sta Screen                                                      // 3b 4c
        sta Color                                                       // 3b 4c
        adc #40                                                         // 2b 2c
        sta Shadow                                                      // 3b 4c

        // Get next char code
        stx CharLoopIndex                                               // 2b 3c
        lda $02, x                                                      // 2b 4c

        // Set counter to read bytes from char rom
        // (only 7 bytes as byte 7 is always zero)
        ldy #$06                                                        // 2b 2c

    ConvertToCharRom:                                                           // 11b 16c (x 3)
        // Convert char code into char rom location
        asl                                                             // 1b 2c
        asl                                                             // 1b 2c
        asl                                                             // 1b 2c
        sta CharRomVector + 0                                           // 2b 3c
        lda #$d0                                                        // 2b 2c
        adc #$00                                                        // 2b 2c
        sta CharRomVector + 1                                           // 2b 3c



    LoadNextByte:                                                               // 16b 24c (x 7 x 3)
        sty ByteLoopIndex                                               // 2b 3c

        // Find offset position for drawing bits
        ldx Offsets, y                                                  // 3b 4c

        // Update flags to see char rom at $d000
        lda #$31                                                        // 2b 2c
        sta $01                                                         // 2b 3c

        // Read byte from char rom
        lda (CharRomVector), y                                          // 2b 5c
        asl // Ignore bit 7 (it's always zero)                          // 1b 2c

        // Reset, to see the i/o at $d000 again
        ldy #$35                                                        // 2b 2c
        sty $01                                                         // 2b 3c



    NextBit:                                                                    // 3b 4c (7 x 7 x 3)
        // Check next char bit (no drawing if it's 0)
        asl                                                             // 1b 2c
        bcc Skip                                                        // 2b 2c (+1c if taken)

    DrawLargeChar:                                                              // 13b 23c (x ~5 x 7 x 3)
        tay                                                             // 1b 2c

        // Draw shadow/black
        lda #160                                                        // 2b 2c
        sta Shadow: ScreenRam + 41, x                                   // 3b 5c

        // Draw foreground/white
        sta Screen: ScreenRam, x                                        // 3b 5c
        inc Color: ColorRam, x                                          // 3b 7c

        tya                                                             // 1b 2c

    Skip:                                                                       // 5b 6c (x 7 x 7 x 3)
        // Drawing all bits that are set
        inx                                                             // 1b 2c
        cmp #$00                                                        // 2b 2c
        bne NextBit                                                     // 2b 2c (+1c if taken)



    MoveToNextByte:                                                             // 5b 7c (x 7 x 3)
        ldy ByteLoopIndex                                               // 2b 3c
        dey                                                             // 1b 2c
        bpl LoadNextByte                                                // 2b 2c (+1c if taken)

    MoveToNextChar:                                                             // 5b 7c (x 3)
        ldx CharLoopIndex                                               // 2b 3c
        dex                                                             // 1b 2c
        bpl NextChar                                                    // 2b 2c (+1c if taken)

    Finish:                                                                     // 1b 6c (x 1)
        rts                                                             // 1b 6c

Vectors:
    .byte $69, $73, $7d

Offsets:
    .fill 7, i * 40
