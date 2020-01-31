# Roadmap

## Checkpoint 1
In checkpoint 2, our CPU should be able to handle all RV32i instructions (except for FENCE, ECALL, EBREAK,
and CSRR). We should also have implemented the separate L1 caches (arbiter, instruction cache, and data
cache) and the L2 cache. For detailed paper designs of CP2, see the other file.

In preparation of CP3, we will have the paper design for hazard detection, data forwarding, and a
static-not-taken branch prediction. 

Tentative assignments of work:

- Yuqi will write code for the arbiter and  and verify the module separately before connecting to the CPU.
- Nickel will write code for the L1 data cache and the L1 instruction cache and verify these modules separately before connecting to the CPU.
- Roger will connect these caches to the CPU and verify the whole design.
- If there is enough time, we will decide who wants to work on the L2 cache.
- All of us will work on the paper design for CP3.

## Checkpoint 2
In checkpoint 3, our CPU should be able to handle all hazards and get rid of all the NOPs in the test file.
We will also discuss about the advanced features we may implement within our group. After we dicides which advanced features we
should implement, we will do more research and read more documents regards to that feature. Then we will come up with some
written discription or datapath design and bring it to our TA meeting times.

Tentative assignments of work:
- Nickel will write code for the L2 cache and verify the module separately.
- Yuqi will work on the data forwarding and handle all control hazards.
- Roger will write a more detailed testbench that is capable of handling potential error on the datapath.
- All of us will work together and discuss the advanced features we would like to implement.
- All of us will divide the work and do more research on the advanced features we decided to implement.

## Checkpoint 3
In checkpoint 4, our team would like to be able to have a pipelined, parameterized cahce working for our CPU.
We will also implement the RV32-M extension, which gives our CPU multiplication and division capability.

Tentative assignments of work:
- Nickel will parameterize our previous working I-Cache, D-Cache, and L2 Cache.
- Yuqi will work on the pipeled cache control.
- Roger will work on the testbench for M extension and improve previous testbenches.
- All of us will work together to design and implement the multiplication / division extension.

## Checkpoint 4
In Checkpoint 5 / Before competition, our team would like to take some effort on tuning our design. 
We will tune the parameter of our branch predictor, I / D cache, and L2 cache.
We will also test our code against the competition code, and make further optimizations on our datapath.

Tentative assignments of work:
- Nickel will tune the parameter of all the caches, and also redraw the datapath diagram to give us a clearer picture of our design.
- Yuqi will work on tuning the branch predictor
- Roger will work on the testbench and testcode, and minor optimizations for our deisn.
- All of us will work together to prepare for the presentation and final competition.
