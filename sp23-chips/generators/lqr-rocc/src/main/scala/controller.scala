package lqrRoCC

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._

import freechips.rocketchip.util._

import freechips.rocketchip.rocket.constants.MemoryOpConstants
import freechips.rocketchip.tile.HasCoreParameters


class controller(val data_w: Int = 32, val n: Int = 16)(implicit val p: Parameters) extends Module with HasCoreParameters
  with MemoryOpConstants {
    val io = IO(
        new Bundle{
            // declare ports facing RoCC Core
            val core_rs1_data = Input(Bits(64.W))
            val core_rs2_data = Input(Bits(64.W))
            val core_funct   = Input(Bits(7.W))  // how many bit?
            val core_inst_rd      = Input(Bits(5.W))
		    val core_req_val = Input(Bool())
		    val core_req_fire    = Input(Bool())
            val core_resp_ready   = Input(Bool())

            val core_req_rdy = Output(Bool())
            val core_resp_rd      = Output(Bits(5.W))
            val core_resp_data    = Output(UInt(data_w.W))
		    val core_resp_valid   = Output(Bool())

            // declare ports facing RoCC Mem
            val mem_req_rdy  =  Input(Bool())
		    val mem_resp_val  =  Input(Bool())
		    val mem_resp_tag  =  Input(UInt(7.W)) // 7 bits enough, even for 32 len vectors
		    val mem_resp_data =  Input(UInt(64.W))
      
            val mem_req_val  =  Output(Bool())
		    val mem_req_tag  =  Output(UInt(7.W))
		    val mem_req_cmd  =  Output(UInt(M_SZ.W))
		    val mem_req_size  =  Output(UInt(log2Ceil(coreDataBytes + 1).W))
		    val mem_req_addr =  Output(UInt(coreMaxAddrBits.W))

         

            // declare ports facing muladd tree
            val comp_result =  Input(UInt(data_w.W))
		    val comp_valid = Input(Bool())
            val comp_enable = Output(Bool())
		    val vec1   = Output(Vec(n, UInt(data_w.W)))
		    val vec2   = Output(Vec(n, UInt(data_w.W)))

            val isHandling   = Output(Bool())
        }
    )

    
    val vec1_head = RegInit(0.U(64.W)) // from core_rs1_data   
	val vec2_head = RegInit(0.U(64.W))  
       
    // +1 here is crucial!!!
    // otherwise might latch when vector length is exactly 1 less than acc size
    val vec1_index = RegInit(0.U((log2Ceil(n)+1).W))    
	val vec2_index = RegInit(0.U((log2Ceil(n)+1).W)) 
    val vec_len = RegInit(0.U((log2Ceil(n)+1).W))
    
    
       
    val rd_reg = RegInit(0.U(5.W))
    

    val vec1_reg  = RegInit(VecInit(Seq.fill(n)(0.U(32.W))))
    val vec2_reg  = RegInit(VecInit(Seq.fill(n)(0.U(32.W))))
    val result_reg = RegInit(0.U(data_w.W))

    val isHandling_reg = RegInit(false.B)


    io.mem_req_size := log2Ceil(4).U
	io.mem_req_val := false.B
	io.mem_req_tag := 0.U(7.W)
	io.mem_req_cmd := M_XRD // only load data from memory, not storing
	//io.mem_req_typ := MT_W  // load word (W)
	io.mem_req_addr:= 0.U(coreMaxAddrBits.W)
	io.core_req_rdy := !isHandling_reg   
    io.core_resp_rd := rd_reg
    io.core_resp_valid := false.B  
    io.core_resp_data    := result_reg
    io.comp_enable  := false.B

    io.isHandling := isHandling_reg // for debug
    
    // connect vector outputs to buffer regs
    for(i <- 0 until n){
        io.vec1(i) := vec1_reg(i)
        io.vec2(i) := vec2_reg(i)
    }

    // controller states
    val idle  :: compute :: wait_result :: to_rocc :: done :: Nil =Enum(5)
    val ctrl_state = RegInit(idle)

    // memory
    val m_idle :: m_read_v1 :: m_wait_v1 :: m_read_v2 :: m_wait_v2 ::Nil = Enum(5)   
    val m_state = RegInit(m_idle)

    // ------------------------------- Step 1: Getting RoCC instr Pair -----------------------
    when (!isHandling_reg && (io.core_req_val && io.core_req_fire)){
        when (io.core_funct === 0.U){
            vec1_head := io.core_rs1_data
            vec2_head := io.core_rs2_data
        }.elsewhen(io.core_funct === 1.U){
            vec_len := io.core_rs1_data
            rd_reg := io.core_inst_rd 
            isHandling_reg := true.B  // finished getting all instr need and disable the ready
        }
    }
    // ------------------------------- ------------------------------- -----------------------

    // ------------------------------- Step 2: Load vectors from mem -----------------------
    switch(m_state){
        is(m_idle){
            // start loading the first vector
            // only if: 1. got both instr 2. Vector length from registers are valid 
            // 3. vector pointers set to zero
            when(isHandling_reg && !(vec_len === 0.U) && (vec1_index < vec_len) && (vec2_index < vec_len)){
                m_state := m_read_v1
            }.otherwise{
                m_state := m_idle
            }
        }
        is(m_read_v1){
            val finish_v1 = !(vec1_index < vec_len)
                  
            when (!finish_v1){
                io.mem_req_val := true.B // issue a mem req
	            io.mem_req_tag := vec1_index
	            io.mem_req_cmd := M_XRD // only load data from memory, not storing
	            //io.mem_req_typ := MT_W  // load word (W)
	            io.mem_req_addr:= vec1_head(31,0)
                io.mem_req_size:= log2Ceil(8).U

                when(io.mem_req_rdy) {  
                    m_state := m_wait_v1                   
                }.otherwise {
                    m_state := m_read_v1
                }                
            }.otherwise{
                
                when ((vec_len < n.U)){
                    for (i <- 0 until n){
                        when(!(i.U < vec_len)){
                            vec1_reg(i) := 0.U
                        }
                    }
                }
                 m_state := m_read_v2 // all elements of v1 are fetched, now go to v2
            }
        }
        is(m_wait_v1){
            val odd_v1_length = !(vec_len % 2.U === 0.U)
            val alomst_finish_v1 = !(vec1_index < vec_len - 2.U)
            when (io.mem_resp_val) {
                // upon response valid, store that data in vector buffer
                // and move the pointer and counter
                when(alomst_finish_v1){
                    when (odd_v1_length){
                        vec1_reg(vec1_index) := io.mem_resp_data(data_w-1, 0)      
                        vec1_reg(vec1_index + 1.U) := 0.U   
                        vec1_index := vec1_index + 2.U
                        vec1_head := vec1_head + 8.U
                    }.otherwise{
                        vec1_reg(vec1_index) := io.mem_resp_data(data_w-1, 0)      
                        vec1_reg(vec1_index + 1.U) := io.mem_resp_data(63, 32)   
                        vec1_index := vec1_index + 2.U
                        vec1_head := vec1_head + 8.U 
                    }
                }.otherwise{
                    vec1_reg(vec1_index) := io.mem_resp_data(data_w-1, 0)      
                    vec1_reg(vec1_index + 1.U) := io.mem_resp_data(63, 32)   
                    vec1_index := vec1_index + 2.U
                    vec1_head := vec1_head + 8.U 
                }
				  

                m_state := m_read_v1 // go to read the next one
            }.otherwise{
                m_state := m_wait_v1  // wait for memory to finish
            }

        }
        is(m_read_v2){
            val finish_v2 = !(vec2_index < vec_len)

           // val finish_v2 = !(vec2_index < vec_len)
            when (!finish_v2){
                io.mem_req_val := true.B // issue a mem req
	            io.mem_req_tag := vec2_index
	            io.mem_req_cmd := M_XRD // only load data from memory, not storing
	            //io.mem_req_typ := MT_W  // load word (W)
	            io.mem_req_addr:= vec2_head(31,0)
                io.mem_req_size:= log2Ceil(8).U

                when(io.mem_req_rdy) {  
                    m_state := m_wait_v2                   
                } .otherwise {
                    m_state := m_read_v2
                }                
            }.otherwise{
                when ((vec_len < n.U)){
                    for (i <- 0 until n){
                        when(!(i.U < vec_len)){
                            vec2_reg(i) := 0.U
                        }
                    }
                }
                 m_state := m_idle // mem stage finished!
            }
        }
        is(m_wait_v2){
            val odd_v2_length = !(vec_len % 2.U === 0.U)
            val alomst_finish_v2 = !(vec2_index < vec_len - 2.U)
            when (io.mem_resp_val) {
                // upon response valid, store that data in vector buffer
                // and move the pointer and counter
				when(alomst_finish_v2){
                    when (odd_v2_length){
                        vec2_reg(vec2_index) := io.mem_resp_data(data_w-1, 0)      
                        vec2_reg(vec2_index + 1.U) := 0.U   
                        vec2_index := vec2_index + 2.U
                        vec2_head := vec2_head + 8.U
                    }.otherwise{
                        vec2_reg(vec2_index) := io.mem_resp_data(data_w-1, 0)      
                        vec2_reg(vec2_index + 1.U) := io.mem_resp_data(63, 32)   
                        vec2_index := vec2_index + 2.U
                        vec2_head := vec2_head + 8.U 
                    }
                }.otherwise{
                    vec2_reg(vec2_index) := io.mem_resp_data(data_w-1, 0)      
                    vec2_reg(vec2_index + 1.U) := io.mem_resp_data(63, 32)   
                    vec2_index := vec2_index + 2.U
                    vec2_head := vec2_head + 8.U 
                }    

                m_state := m_read_v2 // go to read the next one
            }.otherwise{
                m_state := m_wait_v2  // wait for memory to finish
            }

        }
    }
    // ------------------------------- ----------------------------- -----------------------

    // ----------------- Step 3: send data to compute, get result, and send to core --------
    switch(ctrl_state){
        is(idle){
            // check once more that all inputs are received
            when(m_state === m_idle && !(vec2_index < vec_len) && !(vec1_index < vec_len) && !(vec_len === 0.U)){
                ctrl_state := compute
            }.otherwise{
                ctrl_state := idle
            }
        }
        is(compute){
            io.comp_enable := true.B                         
            ctrl_state := wait_result
        }
        is(wait_result){
            when( io.comp_valid){  
                result_reg := io.comp_result
                ctrl_state := to_rocc
            }.otherwise{
                ctrl_state := wait_result
            }
        }
        is(to_rocc){
            io.core_resp_data  := result_reg // make sure ports are really wired
            io.core_resp_valid := true.B // response valid bit !!
            io.comp_enable     := false.B

            when(io.core_resp_ready){
                ctrl_state := done
            }.otherwise{
                ctrl_state := to_rocc
            }
        }
        is(done){
            ctrl_state  := idle

            // reset counter to zero
            vec2_index := 0.U
            vec1_index := 0.U
            
            // tell core: ready for next instr
            io.core_resp_valid := false.B
            isHandling_reg   := false.B 
        }
    }
    // ----------------- ---------------------------------------------------------- --------

    //TODO: This module is probably done
    // but need to add handshake fsm (valid) at the tree adder side





}
