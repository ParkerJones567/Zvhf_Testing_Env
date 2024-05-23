OUTPUT_ARCH( "riscv" )
ENTRY( _start )
SECTIONS
{

   
  . = 0x80000000;
  
    .vectors : {
        *(.vectors)
    }
    
  .text : { *(.text) }

  .data : { *(.data) }

  _end = .;
}
