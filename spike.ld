ENTRY(_start)

MEMORY
{
  RAM (rwx) : ORIGIN = 0x40000000, LENGTH = 128M
}

SECTIONS
{
  . = ORIGIN(RAM);

  .text :
  {
    _start = .;
  } > RAM

}
