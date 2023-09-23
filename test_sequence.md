
|Test  |Exit Code|Description
|------|---------|-----------
|addi.s|NA       |Needs manual checking Runs register access test. All registers will have final value of 0x1F
|j.s   |0x0      |A simple test for jump if exit code is 0 then pass otherwise its fail
|beq.s |0x0      |A Simple test for branch equal if exit code is 0 then pass otherwise the exit code is 1 then its not work properly or the exit code  is 2 then its fall
|bne.s |0x0      |A Simple test for branch not equal  if exit code is 0 then pass otherwise the exit code is 1 then its not work properly or the exit code  is 2 then its fall
