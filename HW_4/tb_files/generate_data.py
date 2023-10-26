import random

for param in [ {'Case':'i','N':16,'W':8}, {'Case':'ii','N':16,'W':16}, {'Case':'iii','N':32,'W':16} ]:
    fout_input  = open(f"case_{param['Case']}/input.ascii" , 'w')
    fout_output = open(f"case_{param['Case']}/output.ascii", 'w')

   
    data_vals = random.sample( range(0, (2**param['W'])-1 ), param['N'] )
    rand_perm = random.sample(data_vals, len(data_vals) )

    HEX_CHARS = int(param['W']/4)
    
    # Write Input
    for addr,data in enumerate(rand_perm):
        fout_input.write(f"{addr:0{HEX_CHARS}X} {data:0{HEX_CHARS}X}\n")
    
    data_vals.sort(reverse=True)
    # Write Output
    for addr in range(param['N']):
        fout_output.write(f"{addr:0{HEX_CHARS}X} {data_vals[addr]:0{HEX_CHARS}X}\n")
    
    fout_input.close()
    fout_output.close()
        
