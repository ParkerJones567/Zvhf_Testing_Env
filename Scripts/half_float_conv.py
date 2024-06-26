import numpy as np
import sys
import struct

val = 1
while (val < len(sys.argv)):
    
    if(val == len(sys.argv) - 1):
        
    
        if sys.argv[val] == 'sNaN':
            data_hex = '7c01'
        elif sys.argv[val] == 'XXXX':
            data_hex = '0000' 
        else:
            data_hex= struct.pack('>e', np.float16(sys.argv[val])).hex()
            
        output = '.word 0x0000' + data_hex + ' # XXXX | ' + sys.argv[val]
        print (output)
        val=val+1
        
    else:
        
        if sys.argv[val] == 'sNaN':
            data_hex_lower = '7c01'
        elif sys.argv[val] == 'XXXX':
            data_hex_lower = '0000' 
        else:
            data_hex_lower = struct.pack('>e', np.float16(sys.argv[val])).hex()
        
        if sys.argv[val+1] == 'sNaN':
            data_hex_upper = '7c01'
        elif sys.argv[val+1] == 'XXXX':
            data_hex_upper = '0000' 
        else:
            data_hex_upper = struct.pack('>e', np.float16(sys.argv[val+1])).hex()   
            
              
        output = '.word 0x' + data_hex_upper + data_hex_lower + ' # ' + sys.argv[val+1] +' | '+ sys.argv[val]    
        print (output)
        val=val+2


