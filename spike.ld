/*
 * Linker script for bare-metal RISC-V programs running on Spike.
 */

ENTRY(_start)

MEMORY
{
  /* Spike default RAM starts at 0x800000000 */
  RAM (rwx) : ORIGIN = 0x800000000, LENGTH = 128M
}

SECTIONS
{
  /* Start of RAM */
  . = ORIGIN(RAM);

  /* The program code and other read-only data. */
  .text :
  {
    . = ALIGN(4);
    _start = .;
    *(.text .text.*)
    *(.rodata .rodata.*)
    . = ALIGN(4);
    _etext = .;        /* End of code/rodata */
  } > RAM

  /* Initialized data section. */
  .data :
  {
    . = ALIGN(4);
    _sdata = .;        /* Start of data */
    *(.data .data.*)
    . = ALIGN(4);
    _edata = .;        /* End of data */
  } > RAM

  /* Uninitialized data section. */
  .bss :
  {
    . = ALIGN(4);
    _sbss = .;         /* Start of bss */
    *(.bss .bss.*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;         /* End of bss */
  } > RAM

  _end = .;            /* End of program */

  /*
   * The stack pointer is set to the end of RAM.
   * It grows downwards. The startup code should initialize 'sp' to _stack_top.
   */
  .stack (NOLOAD) :
  {
    . = ALIGN(16);
    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
  } > RAM
}
