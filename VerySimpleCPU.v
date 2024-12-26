
module VerySimpleCPU(clk, rst, data_fromRAM, wrEn, addr_toRAM, data_toRAM);

  parameter SIZE = 14;

  input clk, rst;
  input wire [31:0] data_fromRAM;
  output reg wrEn;
  output reg [SIZE-1:0] addr_toRAM;
  output reg [31:0] data_toRAM;
  
  reg [2:0] st, stN; 
  reg [13:0] PC,PCN;
  reg [31:0] IW, IWN;
  reg [31:0] R1, R1N, R2, R2N;
  
  always @ (posedge clk) begin
    st <= stN;
    PC <= PCN;
    IW <= IWN;
    R1 <= R1N;
    R2 <= R2N;   
  end
  
  always @* begin
    stN = 3'hX;
    PCN = PC;
    IWN = IW;
    R1N= 32'dX;
    R2N= 32'dX;
    wrEn = 1'b0;
    
    if (rst) begin
      PCN = 14'd0;
      stN = 3'h0;
    end
    else begin
      case (st)
        3'h0: begin
          addr_toRAM = PC; // fetch the instruction
          stN = 3'h1;
        end
        3'h1: begin // decode the instruction
          IWN = data_fromRAM;
          if ((data_fromRAM[31:28] == 4'b0000) 	  // ADD
              || (data_fromRAM[31:28] == 4'b0001) // ADDi
              || (data_fromRAM[31:28] == 4'b0010) // NAND
              || (data_fromRAM[31:28] == 4'b0011) // NANDi
              || (data_fromRAM[31:28] == 4'b0100) // SRL
              || (data_fromRAM[31:28] == 4'b0101) // SRLi
              || (data_fromRAM[31:28] == 4'b0110) // LT
              || (data_fromRAM[31:28] == 4'b0111) // LTi
              || (data_fromRAM[31:28] == 4'b1110) // MUL
              || (data_fromRAM[31:28] == 4'b1111) // MULi
              || (data_fromRAM[31:28] == 4'b1011) // CPIi
              || (data_fromRAM[31:28] == 4'b1100) // BZJ
              || (data_fromRAM[31:28] == 4'b1101))// BZJi 
            begin
              addr_toRAM = data_fromRAM[27:14]; // read *A
              stN = 3'h2;
            end
          else if((data_fromRAM[31:28] == 4'b1000)   // CP
                  ||(data_fromRAM[31:28] == 4'b1010))// CPI
            begin
              addr_toRAM = data_fromRAM[13:0]; // read *B
              stN = 3'h2;
            end
          else if((data_fromRAM[31:28] == 4'b1001))// CPi
            begin
              stN = 3'h2;
            end
        end
             
        //************************************************************
        
      	3'h2: begin
          if ((IW[31:28] == 4'b0010)     // NAND
              || (IW[31:28] == 4'b0000)  // ADD
              || (IW[31:28] == 4'b0100)  // SRL
              || (IW[31:28] == 4'b0110)  // LT
              || (IW[31:28] == 4'b1110)  // MUL
              || (IW[31:28] == 4'b1011)  // CPIi
              || (IW[31:28] == 4'b1100)) // BZJ
            begin 
              R1N = data_fromRAM; // store the content *A in A
              addr_toRAM = IW[13:0]; // read *B
              stN = 3'h3;
            end
          else if (IW[31:28] == 4'b0001)begin // ADDi
            wrEn = 1'b1;
            addr_toRAM = IW[27:14]; //write back to address A
            data_toRAM = data_fromRAM + IW[13:0]; // *A + B
            PCN = PC + 14'd1;
            stN = 3'h0;  
          end
          else if (IW[31:28] == 4'b0011)begin // NANDi
            wrEn = 1'b1;
            addr_toRAM = IW[27:14]; //write back to address A
            data_toRAM = ~(data_fromRAM & IW[13:0]); // ~(*A & B)
            PCN = PC + 14'd1;
            stN = 3'h0;  
          end
          else if (IW[31:28] == 4'b0101)begin // SRLi
            wrEn = 1'b1;
            addr_toRAM = IW[27:14]; //write back to address A
            if(IW[13:0] < 32'd32)begin // if (R2 < 32)
              data_toRAM = (data_fromRAM >> IW[13:0]); // (R1 >> R2) 
            end
            else begin
              data_toRAM = (data_fromRAM << (IW[13:0]-14'd32)); // (R1 << (R2-32))
            end
            PCN = PC + 14'd1;
            stN = 3'h0;  
          end
          else if (IW[31:28] == 4'b0111)begin // LTi
            wrEn = 1'b1;
            addr_toRAM = IW[27:14]; //write back to address A
            data_toRAM = (data_fromRAM < IW[13:0]) ? 1 : 0; // (*A < B) ? 1 : 0
            PCN = PC + 14'd1;
            stN = 3'h0;  
          end
          else if (IW[31:28] == 4'b1111)begin // MULi
            wrEn = 1'b1;
            addr_toRAM = IW[27:14]; //write back to address A
            data_toRAM = (data_fromRAM * IW[13:0]); // (*A * B)
            PCN = PC + 14'd1;
            stN = 3'h0;  
          end
          else if (IW[31:28] == 4'b1000)begin // CP
            wrEn = 1'b1;
            addr_toRAM = IW[27:14]; //write back to address A
            data_toRAM = data_fromRAM;
            PCN = PC + 14'd1;
            stN = 3'h0;  
          end
          else if (IW[31:28] == 4'b1001)begin // CPi
            wrEn = 1'b1;
            addr_toRAM = IW[27:14]; //write back to address A
            data_toRAM = IW[13:0];
            PCN = PC + 14'd1;
            stN = 3'h0;  
          end
          else if (IW[31:28] == 4'b1010)begin // CPI
            addr_toRAM = data_fromRAM;
            stN = 3'h3;
          end
          else if (IW[31:28] == 4'b1101) begin // BZJi
            PCN = data_fromRAM + IW[13:0];
            stN = 3'h0;
          end
        end
      	
        //************************************************************
 
        3'h3: begin
          if (IW[31:28] == 4'b0010) begin // NAND 
            data_toRAM= ~(R1 & data_fromRAM); // execute nand and write back
           	addr_toRAM = IW[27:14]; // write back to A
           	wrEn = 1'b1;
           	PCN = PC + 14'd1;
          	stN = 3'h0;
          end
          else if (IW[31:28] == 4'b0000) begin // ADD 
            data_toRAM= R1 + data_fromRAM; // execute add and write back
           	addr_toRAM = IW[27:14]; // write back to A
           	wrEn = 1'b1;
           	PCN = PC + 14'd1;
          	stN = 3'h0;
          end
          else if (IW[31:28] == 4'b0100) begin // SRL 
           	addr_toRAM = IW[27:14]; // write back to A
            if(data_fromRAM < 32'd32)begin
              data_toRAM = (R1 >> data_fromRAM);
            end
            else begin
              data_toRAM = (R1 << (data_fromRAM-32));
            end
           	wrEn = 1'b1;
           	PCN = PC + 14'd1;
          	stN = 3'h0;
          end
          else if (IW[31:28] == 4'b0110) begin // LT 
           	addr_toRAM = IW[27:14]; // write back to A
            data_toRAM = (R1 < data_fromRAM) ? 1 : 0; // (A < B) ? 1 : 0
           	wrEn = 1'b1;
           	PCN = PC + 14'd1;
          	stN = 3'h0;
          end
          else if (IW[31:28] == 4'b1110) begin // MUL 
            data_toRAM= (R1 * data_fromRAM); // (A * B)
           	addr_toRAM = IW[27:14]; // write back to A
           	wrEn = 1'b1;
           	PCN = PC + 14'd1;
          	stN = 3'h0;
          end
          else if(IW[31:28] == 4'b1010) begin // CPI
           	wrEn = 1'b1;
           	PCN = PC + 14'd1;
          	stN = 3'h0;
            addr_toRAM = IW[27:14]; // write back to A
            data_toRAM = data_fromRAM;
          end
          else if(IW[31:28] == 4'b1011) begin // CPIi
           	wrEn = 1'b1;
            addr_toRAM = R1; // write back to A
            data_toRAM = data_fromRAM;
            PCN = PC + 14'd1;
          	stN = 3'h0;
          end
          else if(IW[31:28] == 4'b1100) begin // BZJ
            PCN = (data_fromRAM == 32'd0) ? R1 : (PC + 14'd1);
            stN = 3'h0;
          end
        end
      endcase
    end
    
  end
  
endmodule