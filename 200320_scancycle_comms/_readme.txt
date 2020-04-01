
Experiments with UnityPro interacting with Matlab using Modbus
--------------------------------------------------------------

Setup:
open "tst.stu" with UnityPro
open "tst.m" with Matlab and choose a test to run


-- Exp1: Matlab sends "coils write" to the PLC simulator exp:

Found no cases where multiple messages could enter the PLC simulator in a single scan cycle
(maximum one message received per scan cycle?)

Problem with Matlab 2016 (ok on 2018): cannot send multiple messages while keeping the socket open
(maybe a message sent needs to be be acknowledged by Matlab and only a socket close/open clears that requirement)


-- Exp2: Matlab send "coils read" to the PLC simulator exp:

Found no cases where the remote reading of PLC memory bits occurred during the execution time. More in detail, multiple changes on the PLC memory bits during a single scan cycle were not noticed by the remote client.


2020.3.20 JG
