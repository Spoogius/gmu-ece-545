clear; clc;
tt = table();
for u_val = fi([0:31],false,5,0)
    tt.addr_val(u_val+1) = reinterpretcast( u_val, numerictype(1,5,0));
    tt.addr_bin(u_val+1) = string(tt.addr_val(u_val+1).bin);
    tt.dout_val(u_val+1) = tt.addr_val(u_val+1)*tt.addr_val(u_val+1);
    tt.dout_bin(u_val+1) = string(tt.dout_val(u_val+1).bin);

end
tt