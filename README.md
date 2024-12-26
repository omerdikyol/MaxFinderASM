# MaxFinderASM

This project finds the maximum of 10 numbers using a simple assembly-like language. It includes an assembly program, a testbench, and a simple CPU implementation to execute the code.

## Project Overview

The project consists of three main files:
1. **`max_of_10_numbers.asm`**: Assembly-like code to find the maximum of 10 numbers.
2. **`testbench.v`**: A Verilog testbench to simulate the execution of the assembly code.
3. **`VerySimpleCPU.v`**: A simple CPU implementation in Verilog that executes the assembly instructions.

## How It Works

1. **Assembly Code**: The assembly program iterates through a list of 10 numbers stored in memory and determines the maximum value.
2. **Simple CPU**: The `VerySimpleCPU.v` module executes the assembly instructions step by step.
3. **Testbench**: The `testbench.v` file simulates the execution of the assembly code and verifies the result.

## Files

- **`max_of_10_numbers.asm`**: Contains the assembly-like code to find the maximum number.
- **`testbench.v`**: Verilog testbench for simulating the assembly code.
- **`VerySimpleCPU.v`**: A simple CPU implementation in Verilog.

## How to Run

### Prerequisites
- A Verilog simulator (e.g., [Icarus Verilog](http://iverilog.icarus.com/)).

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/MaxFinderASM.git
   cd MaxFinderASM
   ```
2. Compile and run the testbench using Icarus Verilog:
   ```bash
   iverilog -o sim testbench.v VerySimpleCPU.v
   vvp sim
   ```
3. Observe the simulation output to verify the maximum value found by the assembly program.

## Example Output
The simulation will output the maximum value from the list of numbers. For the provided numbers in **`max_of_10_numbers.asm`**, the expected output is **`16`**.

## License
This project is open-source and available under the MIT License. Feel free to use, modify, and distribute it as needed.





