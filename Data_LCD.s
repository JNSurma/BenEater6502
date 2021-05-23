LCD = $6000
LCD0 = $6000
LCD1 = $6001

  .org $8000

reset:
  ldx #$ff	; Setup stack pointer
  txs

  jsr lint
  jsr LCDSTRING  

loop:
  jmp loop


message: .asciiz "Stinky Lights!!!"

lcd2busy:
  pha
lcd2wait:
  lda LCD0
  and #$80
  bne lcd2wait
  pla
  rts
  
lint:
  lda #$38
  sta LCD0
  jsr lcd2busy
  
  lda #$06
  sta LCD0
  jsr lcd2busy
  
  lda #$0E
  sta LCD0
  jsr lcd2busy
  
  lda #$01
  sta LCD0
  jsr lcd2busy
  
  lda #$80
  sta LCD0
  jsr lcd2busy
  rts

LCDPRINT:
  pha
  sta LCD1
  jsr lcd2busy
  lda LCD0
  and #$7F
  cmp #$14
  bne LCDPRINT0
  lda #$C0
  sta LCD0
  jsr lcd2busy
LCDPRINT0:
  pla
  rts
  
LCDSTRING:
  pha
  tya
  ldy #$00
LCDSTR0
  lda message,y
  beq LCDSTR1
  jsr LCDPRINT
  iny
  bne LCDSTR0
LCDSTR1:
  pla
  tay
  pla
  rts

  .org $fffc
  .word reset
  .word $0000
