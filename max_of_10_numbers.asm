0: CPi 100 501 // int i = 501 in 100th address in memory
1: CP 600 500 // Put first number to 600
// start of the loop
2: CP 101 100 // tempi = i
3: CPI 102 101 // get value at address i to address 102
4: ADDi 101 1
5: LTi 101 510 // if tempi < 510 tempi = 1 else tempi = 0
6: BZJ 98 101 // jump to 14 (end of the loop) if tempi = 0 else continue
7: ADDi 100 1 // i = i+1
8: CP 103 102 // temp of value at address i = value at add. i
9: LT 102 600 // if (number at add. 102 < max) num. at add. 102 = 1, else num at add. 102 = 0
10: BZJ 97 102 // if num. at add. 102 = 0 jump to 12 (to copy new max), else continue
11: BZJi 99 2 // jump to start of the loop (current number is not greater)
12: CP 600 103 // put new number to the max
13: BZJi 99 2 // jump to start of the loop
// end of the loop
97: 12 // static 12
98: 14 // end of the loop
99: 0 // static 0
100: 0 // i
101: 0 // tempi
102: 0 // value at address i
103: 0 // temp of value at address i
// our numbers
500: 7
501: 2 
502: 4 
503: 8
504: 6
505: 5
506: 11
507: 4
508: 5
509: 6 
510: 2 
511: 16 // shouldn't be involved to calc.
// Max value
600: 0 