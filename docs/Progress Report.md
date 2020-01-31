# Progress Report

## Checkpoint 1
11:59 PM, 10/25/2019

As required, we have developed a basic pipeline structure that supports all basic RISC-Vi instructions
without handling any control hazards or data hazards. We tested all instructions by having NOPs between
any of those that could cause any hazards. For now, our CPU directly interacts with the physical memory
without handling stalling. This is done by having the "magic" memory as specified in the MP3 documentation.

In preparation of CP2, we also have a brief sketch of memory hierarchy and designs for the arbiter and L2 
cache.

Group members contribute to this checkpoint in the following manner:

- All of us worked together to design the basic pipeline. (This was actually done in CP0.)
- Roger created basic file organizations.
- Yuqi and Nickel wrote the codes for CPU.
- Roger wrote testbenches and debugged the codes.
- Yuqi and Nickel worked on the designs for the arbiter and L2 cache for the next checkpoint.

## Checkpoint 2
As required by the document, we have a pipelined design that can handle all of the RV32I base instructions.
We also implemented a pipelined I/D cache and a arbiter. Similar to CP1, we tested all instructions by having
NOPs between instructions.

- In this Checkpoint, all group members contributed to the overall cache design. 
- Roger wrote the control for the cache.
- Yuqi and Nickel wrote the datapath of the cache. 
- Yuqi also wrote the arbiter state machine.
- Nickel finished the higher level inter-connection
- In preparation of CP3, we also have a sketch of data forwarding added to the data path.

## Checkpoint 3
As required by the document, we have a cpu design that is capable of handling all RV32i instructions in a 
pipelined manner. We have added a data forwarding logic, flushing logic, stalling logic, and static branch
prediction logic in our pipelined datapath. In the meantime, we have adopted our previous cache design into
our L2 cache.

- In this checkpoint, all group members contributed to the overall cache design.
- Roger implemented the data forwarding and control hazard logics in the pipelined datapath.
- Yuqi implemented the L2 cache for the CPU.
- Nickel only worked on the paper works, due to the heavy work load on his research work this week. He will catch up in the next checkpoint.
- In preparation of CP4, we also discussed the advanced features we would like to implement in our design.

## Checkpoint 4
As mentioned in the previous RoadMap docs, in this checkpoint we implemented a branch predictor, 
parameterized I/D/L2 cache, RV32-M extension, and EWB.
We also added an performance counter in the branch predictor.
We also fixed some minor bugs in our exisisting pipeline design.

- In this checkpoint, all group memebers came to an agreement on what advanced feature we should implement.
- Roger implemented M extension and added a really well-written automated test for the overall design.
- Yuqi implemented a branch predictor, performance counter, and EWB.
- Nickel implemented parameterized I/D/L2 cache and finished the report and road map.
- In preparation of CP5/Competition, we also discussed what should we do to further optimize our design during the Thanksgiving break.