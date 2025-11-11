program test(i2c_intf intf);
  
  environment env;
  
  initial begin
    env = new(intf);
    env.run();
  end
  
endprogram