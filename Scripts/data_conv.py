import numpy as np
import sys
import struct

val = 2
while (val < len(sys.argv)):
    if sys.argv[1] == 'HalfFloat': 
    
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
            
    elif sys.argv[1] == 'HalfInt': 
     
        if(val == len(sys.argv) - 1):
        
            data_hex= struct.pack('>h', np.int16(sys.argv[val])).hex()
                    
            output = '.word 0x0000' + data_hex + ' # XXXX | ' + sys.argv[val]
            print (output)
            val=val+1
            
        else:
            
            data_hex_lower = struct.pack('>h', np.int16(sys.argv[val])).hex()
            data_hex_upper = struct.pack('>h', np.int16(sys.argv[val+1])).hex()   
                    
                      
            output = '.word 0x' + data_hex_upper + data_hex_lower + ' # ' + sys.argv[val+1] +' | '+ sys.argv[val]    
            print (output)
            val=val+2
                
    elif sys.argv[1] == 'ByteInt':
         
        if(val == len(sys.argv) - 1):
        
            data_hex= struct.pack('>b', np.int8(sys.argv[val])).hex()
                    
            output = '.word 0x000000' + data_hex + ' # XXXX | XXXX | XXXX |' + sys.argv[val]
            print (output)
            val=val+1
            
        elif(val == len(sys.argv) - 2):
        
            data_hex_b1= struct.pack('>b', np.int8(sys.argv[val])).hex()
            data_hex_b2= struct.pack('>b', np.int8(sys.argv[val+1])).hex()
                    
            output = '.word 0x0000' + data_hex_b2 + data_hex_b1 + ' # XXXX | XXXX | ' + sys.argv[val+1] + ' | ' + sys.argv[val]
            print (output)
            val=val+2
            
            
        elif(val == len(sys.argv) - 3):
        
            data_hex_b1= struct.pack('>b', np.int8(sys.argv[val])).hex()
            data_hex_b2= struct.pack('>b', np.int8(sys.argv[val+1])).hex()
            data_hex_b3= struct.pack('>b', np.int8(sys.argv[val+2])).hex()
                    
            output = '.word 0x00'+ data_hex_b3 + data_hex_b2 + data_hex_b1 + ' # XXXX | '+sys.argv[val+2]+ ' | ' + sys.argv[val+1] + ' | ' + sys.argv[val]
            print (output)
            val=val+3
            
            
            
        else:
            
            data_hex_b1= struct.pack('>b', np.int8(sys.argv[val])).hex()
            data_hex_b2= struct.pack('>b', np.int8(sys.argv[val+1])).hex()
            data_hex_b3= struct.pack('>b', np.int8(sys.argv[val+2])).hex()
            data_hex_b4= struct.pack('>b', np.int8(sys.argv[val+3])).hex()
                    
                      
            output = '.word 0x'+ data_hex_b4 + data_hex_b3 + data_hex_b2 + data_hex_b1 + ' # '+sys.argv[val+3] + ' | '+sys.argv[val+2] + ' | ' + sys.argv[val+1] + ' | ' + sys.argv[val]
            print (output)
            val=val+4
            
            
 
                 
    else:
         
        print("BAD OUPUT TYPE:  Valid are: HalfFloat | HalfInt | ByteInt")
        exit()



