
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	63010113          	addi	sp,sp,1584 # 8000a630 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04e000ef          	jal	80000064 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000024:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000028:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002c:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80000030:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000034:	577d                	li	a4,-1
    80000036:	177e                	slli	a4,a4,0x3f
    80000038:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8000003a:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003e:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000042:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000046:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    8000004a:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004e:	000f4737          	lui	a4,0xf4
    80000052:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000056:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000058:	14d79073          	csrw	stimecmp,a5
}
    8000005c:	60a2                	ld	ra,8(sp)
    8000005e:	6402                	ld	s0,0(sp)
    80000060:	0141                	addi	sp,sp,16
    80000062:	8082                	ret

0000000080000064 <start>:
{
    80000064:	1141                	addi	sp,sp,-16
    80000066:	e406                	sd	ra,8(sp)
    80000068:	e022                	sd	s0,0(sp)
    8000006a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000070:	7779                	lui	a4,0xffffe
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffda69f>
    80000076:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000078:	6705                	lui	a4,0x1
    8000007a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000080:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000084:	00001797          	auipc	a5,0x1
    80000088:	e0078793          	addi	a5,a5,-512 # 80000e84 <main>
    8000008c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80000090:	4781                	li	a5,0
    80000092:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000096:	67c1                	lui	a5,0x10
    80000098:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000009a:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009e:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000a2:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a6:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000aa:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000ae:	57fd                	li	a5,-1
    800000b0:	83a9                	srli	a5,a5,0xa
    800000b2:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b6:	47bd                	li	a5,15
    800000b8:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000bc:	f61ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000c0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c8:	30200073          	mret
}
    800000cc:	60a2                	ld	ra,8(sp)
    800000ce:	6402                	ld	s0,0(sp)
    800000d0:	0141                	addi	sp,sp,16
    800000d2:	8082                	ret

00000000800000d4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d4:	711d                	addi	sp,sp,-96
    800000d6:	ec86                	sd	ra,88(sp)
    800000d8:	e8a2                	sd	s0,80(sp)
    800000da:	e0ca                	sd	s2,64(sp)
    800000dc:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    800000de:	04c05863          	blez	a2,8000012e <consolewrite+0x5a>
    800000e2:	e4a6                	sd	s1,72(sp)
    800000e4:	fc4e                	sd	s3,56(sp)
    800000e6:	f852                	sd	s4,48(sp)
    800000e8:	f456                	sd	s5,40(sp)
    800000ea:	f05a                	sd	s6,32(sp)
    800000ec:	ec5e                	sd	s7,24(sp)
    800000ee:	8a2a                	mv	s4,a0
    800000f0:	84ae                	mv	s1,a1
    800000f2:	89b2                	mv	s3,a2
    800000f4:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000f6:	faf40b93          	addi	s7,s0,-81
    800000fa:	4b05                	li	s6,1
    800000fc:	5afd                	li	s5,-1
    800000fe:	86da                	mv	a3,s6
    80000100:	8626                	mv	a2,s1
    80000102:	85d2                	mv	a1,s4
    80000104:	855e                	mv	a0,s7
    80000106:	246020ef          	jal	8000234c <either_copyin>
    8000010a:	03550463          	beq	a0,s5,80000132 <consolewrite+0x5e>
      break;
    uartputc(c);
    8000010e:	faf44503          	lbu	a0,-81(s0)
    80000112:	02d000ef          	jal	8000093e <uartputc>
  for(i = 0; i < n; i++){
    80000116:	2905                	addiw	s2,s2,1
    80000118:	0485                	addi	s1,s1,1
    8000011a:	ff2992e3          	bne	s3,s2,800000fe <consolewrite+0x2a>
    8000011e:	894e                	mv	s2,s3
    80000120:	64a6                	ld	s1,72(sp)
    80000122:	79e2                	ld	s3,56(sp)
    80000124:	7a42                	ld	s4,48(sp)
    80000126:	7aa2                	ld	s5,40(sp)
    80000128:	7b02                	ld	s6,32(sp)
    8000012a:	6be2                	ld	s7,24(sp)
    8000012c:	a809                	j	8000013e <consolewrite+0x6a>
    8000012e:	4901                	li	s2,0
    80000130:	a039                	j	8000013e <consolewrite+0x6a>
    80000132:	64a6                	ld	s1,72(sp)
    80000134:	79e2                	ld	s3,56(sp)
    80000136:	7a42                	ld	s4,48(sp)
    80000138:	7aa2                	ld	s5,40(sp)
    8000013a:	7b02                	ld	s6,32(sp)
    8000013c:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    8000013e:	854a                	mv	a0,s2
    80000140:	60e6                	ld	ra,88(sp)
    80000142:	6446                	ld	s0,80(sp)
    80000144:	6906                	ld	s2,64(sp)
    80000146:	6125                	addi	sp,sp,96
    80000148:	8082                	ret

000000008000014a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000014a:	711d                	addi	sp,sp,-96
    8000014c:	ec86                	sd	ra,88(sp)
    8000014e:	e8a2                	sd	s0,80(sp)
    80000150:	e4a6                	sd	s1,72(sp)
    80000152:	e0ca                	sd	s2,64(sp)
    80000154:	fc4e                	sd	s3,56(sp)
    80000156:	f852                	sd	s4,48(sp)
    80000158:	f456                	sd	s5,40(sp)
    8000015a:	f05a                	sd	s6,32(sp)
    8000015c:	1080                	addi	s0,sp,96
    8000015e:	8aaa                	mv	s5,a0
    80000160:	8a2e                	mv	s4,a1
    80000162:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000164:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80000166:	00012517          	auipc	a0,0x12
    8000016a:	4ca50513          	addi	a0,a0,1226 # 80012630 <cons>
    8000016e:	291000ef          	jal	80000bfe <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000172:	00012497          	auipc	s1,0x12
    80000176:	4be48493          	addi	s1,s1,1214 # 80012630 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000017a:	00012917          	auipc	s2,0x12
    8000017e:	54e90913          	addi	s2,s2,1358 # 800126c8 <cons+0x98>
  while(n > 0){
    80000182:	0b305b63          	blez	s3,80000238 <consoleread+0xee>
    while(cons.r == cons.w){
    80000186:	0984a783          	lw	a5,152(s1)
    8000018a:	09c4a703          	lw	a4,156(s1)
    8000018e:	0af71063          	bne	a4,a5,8000022e <consoleread+0xe4>
      if(killed(myproc())){
    80000192:	74a010ef          	jal	800018dc <myproc>
    80000196:	04e020ef          	jal	800021e4 <killed>
    8000019a:	e12d                	bnez	a0,800001fc <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    8000019c:	85a6                	mv	a1,s1
    8000019e:	854a                	mv	a0,s2
    800001a0:	60d010ef          	jal	80001fac <sleep>
    while(cons.r == cons.w){
    800001a4:	0984a783          	lw	a5,152(s1)
    800001a8:	09c4a703          	lw	a4,156(s1)
    800001ac:	fef703e3          	beq	a4,a5,80000192 <consoleread+0x48>
    800001b0:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001b2:	00012717          	auipc	a4,0x12
    800001b6:	47e70713          	addi	a4,a4,1150 # 80012630 <cons>
    800001ba:	0017869b          	addiw	a3,a5,1
    800001be:	08d72c23          	sw	a3,152(a4)
    800001c2:	07f7f693          	andi	a3,a5,127
    800001c6:	9736                	add	a4,a4,a3
    800001c8:	01874703          	lbu	a4,24(a4)
    800001cc:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001d0:	4691                	li	a3,4
    800001d2:	04db8663          	beq	s7,a3,8000021e <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001d6:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001da:	4685                	li	a3,1
    800001dc:	faf40613          	addi	a2,s0,-81
    800001e0:	85d2                	mv	a1,s4
    800001e2:	8556                	mv	a0,s5
    800001e4:	11e020ef          	jal	80002302 <either_copyout>
    800001e8:	57fd                	li	a5,-1
    800001ea:	04f50663          	beq	a0,a5,80000236 <consoleread+0xec>
      break;

    dst++;
    800001ee:	0a05                	addi	s4,s4,1
    --n;
    800001f0:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001f2:	47a9                	li	a5,10
    800001f4:	04fb8b63          	beq	s7,a5,8000024a <consoleread+0x100>
    800001f8:	6be2                	ld	s7,24(sp)
    800001fa:	b761                	j	80000182 <consoleread+0x38>
        release(&cons.lock);
    800001fc:	00012517          	auipc	a0,0x12
    80000200:	43450513          	addi	a0,a0,1076 # 80012630 <cons>
    80000204:	28f000ef          	jal	80000c92 <release>
        return -1;
    80000208:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000020a:	60e6                	ld	ra,88(sp)
    8000020c:	6446                	ld	s0,80(sp)
    8000020e:	64a6                	ld	s1,72(sp)
    80000210:	6906                	ld	s2,64(sp)
    80000212:	79e2                	ld	s3,56(sp)
    80000214:	7a42                	ld	s4,48(sp)
    80000216:	7aa2                	ld	s5,40(sp)
    80000218:	7b02                	ld	s6,32(sp)
    8000021a:	6125                	addi	sp,sp,96
    8000021c:	8082                	ret
      if(n < target){
    8000021e:	0169fa63          	bgeu	s3,s6,80000232 <consoleread+0xe8>
        cons.r--;
    80000222:	00012717          	auipc	a4,0x12
    80000226:	4af72323          	sw	a5,1190(a4) # 800126c8 <cons+0x98>
    8000022a:	6be2                	ld	s7,24(sp)
    8000022c:	a031                	j	80000238 <consoleread+0xee>
    8000022e:	ec5e                	sd	s7,24(sp)
    80000230:	b749                	j	800001b2 <consoleread+0x68>
    80000232:	6be2                	ld	s7,24(sp)
    80000234:	a011                	j	80000238 <consoleread+0xee>
    80000236:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000238:	00012517          	auipc	a0,0x12
    8000023c:	3f850513          	addi	a0,a0,1016 # 80012630 <cons>
    80000240:	253000ef          	jal	80000c92 <release>
  return target - n;
    80000244:	413b053b          	subw	a0,s6,s3
    80000248:	b7c9                	j	8000020a <consoleread+0xc0>
    8000024a:	6be2                	ld	s7,24(sp)
    8000024c:	b7f5                	j	80000238 <consoleread+0xee>

000000008000024e <consputc>:
{
    8000024e:	1141                	addi	sp,sp,-16
    80000250:	e406                	sd	ra,8(sp)
    80000252:	e022                	sd	s0,0(sp)
    80000254:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000256:	10000793          	li	a5,256
    8000025a:	00f50863          	beq	a0,a5,8000026a <consputc+0x1c>
    uartputc_sync(c);
    8000025e:	5fe000ef          	jal	8000085c <uartputc_sync>
}
    80000262:	60a2                	ld	ra,8(sp)
    80000264:	6402                	ld	s0,0(sp)
    80000266:	0141                	addi	sp,sp,16
    80000268:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000026a:	4521                	li	a0,8
    8000026c:	5f0000ef          	jal	8000085c <uartputc_sync>
    80000270:	02000513          	li	a0,32
    80000274:	5e8000ef          	jal	8000085c <uartputc_sync>
    80000278:	4521                	li	a0,8
    8000027a:	5e2000ef          	jal	8000085c <uartputc_sync>
    8000027e:	b7d5                	j	80000262 <consputc+0x14>

0000000080000280 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000280:	7179                	addi	sp,sp,-48
    80000282:	f406                	sd	ra,40(sp)
    80000284:	f022                	sd	s0,32(sp)
    80000286:	ec26                	sd	s1,24(sp)
    80000288:	1800                	addi	s0,sp,48
    8000028a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000028c:	00012517          	auipc	a0,0x12
    80000290:	3a450513          	addi	a0,a0,932 # 80012630 <cons>
    80000294:	16b000ef          	jal	80000bfe <acquire>

  switch(c){
    80000298:	47d5                	li	a5,21
    8000029a:	08f48e63          	beq	s1,a5,80000336 <consoleintr+0xb6>
    8000029e:	0297c563          	blt	a5,s1,800002c8 <consoleintr+0x48>
    800002a2:	47a1                	li	a5,8
    800002a4:	0ef48863          	beq	s1,a5,80000394 <consoleintr+0x114>
    800002a8:	47c1                	li	a5,16
    800002aa:	10f49963          	bne	s1,a5,800003bc <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    800002ae:	0e8020ef          	jal	80002396 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002b2:	00012517          	auipc	a0,0x12
    800002b6:	37e50513          	addi	a0,a0,894 # 80012630 <cons>
    800002ba:	1d9000ef          	jal	80000c92 <release>
}
    800002be:	70a2                	ld	ra,40(sp)
    800002c0:	7402                	ld	s0,32(sp)
    800002c2:	64e2                	ld	s1,24(sp)
    800002c4:	6145                	addi	sp,sp,48
    800002c6:	8082                	ret
  switch(c){
    800002c8:	07f00793          	li	a5,127
    800002cc:	0cf48463          	beq	s1,a5,80000394 <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002d0:	00012717          	auipc	a4,0x12
    800002d4:	36070713          	addi	a4,a4,864 # 80012630 <cons>
    800002d8:	0a072783          	lw	a5,160(a4)
    800002dc:	09872703          	lw	a4,152(a4)
    800002e0:	9f99                	subw	a5,a5,a4
    800002e2:	07f00713          	li	a4,127
    800002e6:	fcf766e3          	bltu	a4,a5,800002b2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800002ea:	47b5                	li	a5,13
    800002ec:	0cf48b63          	beq	s1,a5,800003c2 <consoleintr+0x142>
      consputc(c);
    800002f0:	8526                	mv	a0,s1
    800002f2:	f5dff0ef          	jal	8000024e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002f6:	00012797          	auipc	a5,0x12
    800002fa:	33a78793          	addi	a5,a5,826 # 80012630 <cons>
    800002fe:	0a07a683          	lw	a3,160(a5)
    80000302:	0016871b          	addiw	a4,a3,1
    80000306:	863a                	mv	a2,a4
    80000308:	0ae7a023          	sw	a4,160(a5)
    8000030c:	07f6f693          	andi	a3,a3,127
    80000310:	97b6                	add	a5,a5,a3
    80000312:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000316:	47a9                	li	a5,10
    80000318:	0cf48963          	beq	s1,a5,800003ea <consoleintr+0x16a>
    8000031c:	4791                	li	a5,4
    8000031e:	0cf48663          	beq	s1,a5,800003ea <consoleintr+0x16a>
    80000322:	00012797          	auipc	a5,0x12
    80000326:	3a67a783          	lw	a5,934(a5) # 800126c8 <cons+0x98>
    8000032a:	9f1d                	subw	a4,a4,a5
    8000032c:	08000793          	li	a5,128
    80000330:	f8f711e3          	bne	a4,a5,800002b2 <consoleintr+0x32>
    80000334:	a85d                	j	800003ea <consoleintr+0x16a>
    80000336:	e84a                	sd	s2,16(sp)
    80000338:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    8000033a:	00012717          	auipc	a4,0x12
    8000033e:	2f670713          	addi	a4,a4,758 # 80012630 <cons>
    80000342:	0a072783          	lw	a5,160(a4)
    80000346:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	00012497          	auipc	s1,0x12
    8000034e:	2e648493          	addi	s1,s1,742 # 80012630 <cons>
    while(cons.e != cons.w &&
    80000352:	4929                	li	s2,10
      consputc(BACKSPACE);
    80000354:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80000358:	02f70863          	beq	a4,a5,80000388 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000035c:	37fd                	addiw	a5,a5,-1
    8000035e:	07f7f713          	andi	a4,a5,127
    80000362:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000364:	01874703          	lbu	a4,24(a4)
    80000368:	03270363          	beq	a4,s2,8000038e <consoleintr+0x10e>
      cons.e--;
    8000036c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000370:	854e                	mv	a0,s3
    80000372:	eddff0ef          	jal	8000024e <consputc>
    while(cons.e != cons.w &&
    80000376:	0a04a783          	lw	a5,160(s1)
    8000037a:	09c4a703          	lw	a4,156(s1)
    8000037e:	fcf71fe3          	bne	a4,a5,8000035c <consoleintr+0xdc>
    80000382:	6942                	ld	s2,16(sp)
    80000384:	69a2                	ld	s3,8(sp)
    80000386:	b735                	j	800002b2 <consoleintr+0x32>
    80000388:	6942                	ld	s2,16(sp)
    8000038a:	69a2                	ld	s3,8(sp)
    8000038c:	b71d                	j	800002b2 <consoleintr+0x32>
    8000038e:	6942                	ld	s2,16(sp)
    80000390:	69a2                	ld	s3,8(sp)
    80000392:	b705                	j	800002b2 <consoleintr+0x32>
    if(cons.e != cons.w){
    80000394:	00012717          	auipc	a4,0x12
    80000398:	29c70713          	addi	a4,a4,668 # 80012630 <cons>
    8000039c:	0a072783          	lw	a5,160(a4)
    800003a0:	09c72703          	lw	a4,156(a4)
    800003a4:	f0f707e3          	beq	a4,a5,800002b2 <consoleintr+0x32>
      cons.e--;
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	00012717          	auipc	a4,0x12
    800003ae:	32f72323          	sw	a5,806(a4) # 800126d0 <cons+0xa0>
      consputc(BACKSPACE);
    800003b2:	10000513          	li	a0,256
    800003b6:	e99ff0ef          	jal	8000024e <consputc>
    800003ba:	bde5                	j	800002b2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003bc:	ee048be3          	beqz	s1,800002b2 <consoleintr+0x32>
    800003c0:	bf01                	j	800002d0 <consoleintr+0x50>
      consputc(c);
    800003c2:	4529                	li	a0,10
    800003c4:	e8bff0ef          	jal	8000024e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003c8:	00012797          	auipc	a5,0x12
    800003cc:	26878793          	addi	a5,a5,616 # 80012630 <cons>
    800003d0:	0a07a703          	lw	a4,160(a5)
    800003d4:	0017069b          	addiw	a3,a4,1
    800003d8:	8636                	mv	a2,a3
    800003da:	0ad7a023          	sw	a3,160(a5)
    800003de:	07f77713          	andi	a4,a4,127
    800003e2:	97ba                	add	a5,a5,a4
    800003e4:	4729                	li	a4,10
    800003e6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003ea:	00012797          	auipc	a5,0x12
    800003ee:	2ec7a123          	sw	a2,738(a5) # 800126cc <cons+0x9c>
        wakeup(&cons.r);
    800003f2:	00012517          	auipc	a0,0x12
    800003f6:	2d650513          	addi	a0,a0,726 # 800126c8 <cons+0x98>
    800003fa:	3ff010ef          	jal	80001ff8 <wakeup>
    800003fe:	bd55                	j	800002b2 <consoleintr+0x32>

0000000080000400 <consoleinit>:

void
consoleinit(void)
{
    80000400:	1141                	addi	sp,sp,-16
    80000402:	e406                	sd	ra,8(sp)
    80000404:	e022                	sd	s0,0(sp)
    80000406:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000408:	00007597          	auipc	a1,0x7
    8000040c:	bf858593          	addi	a1,a1,-1032 # 80007000 <etext>
    80000410:	00012517          	auipc	a0,0x12
    80000414:	22050513          	addi	a0,a0,544 # 80012630 <cons>
    80000418:	762000ef          	jal	80000b7a <initlock>

  uartinit();
    8000041c:	3ea000ef          	jal	80000806 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000420:	00023797          	auipc	a5,0x23
    80000424:	ba878793          	addi	a5,a5,-1112 # 80022fc8 <devsw>
    80000428:	00000717          	auipc	a4,0x0
    8000042c:	d2270713          	addi	a4,a4,-734 # 8000014a <consoleread>
    80000430:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000432:	00000717          	auipc	a4,0x0
    80000436:	ca270713          	addi	a4,a4,-862 # 800000d4 <consolewrite>
    8000043a:	ef98                	sd	a4,24(a5)
}
    8000043c:	60a2                	ld	ra,8(sp)
    8000043e:	6402                	ld	s0,0(sp)
    80000440:	0141                	addi	sp,sp,16
    80000442:	8082                	ret

0000000080000444 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000444:	7179                	addi	sp,sp,-48
    80000446:	f406                	sd	ra,40(sp)
    80000448:	f022                	sd	s0,32(sp)
    8000044a:	ec26                	sd	s1,24(sp)
    8000044c:	e84a                	sd	s2,16(sp)
    8000044e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000450:	c219                	beqz	a2,80000456 <printint+0x12>
    80000452:	06054a63          	bltz	a0,800004c6 <printint+0x82>
    x = -xx;
  else
    x = xx;
    80000456:	4e01                	li	t3,0

  i = 0;
    80000458:	fd040313          	addi	t1,s0,-48
    x = xx;
    8000045c:	869a                	mv	a3,t1
  i = 0;
    8000045e:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000460:	00007817          	auipc	a6,0x7
    80000464:	37880813          	addi	a6,a6,888 # 800077d8 <digits>
    80000468:	88be                	mv	a7,a5
    8000046a:	0017861b          	addiw	a2,a5,1
    8000046e:	87b2                	mv	a5,a2
    80000470:	02b57733          	remu	a4,a0,a1
    80000474:	9742                	add	a4,a4,a6
    80000476:	00074703          	lbu	a4,0(a4)
    8000047a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000047e:	872a                	mv	a4,a0
    80000480:	02b55533          	divu	a0,a0,a1
    80000484:	0685                	addi	a3,a3,1
    80000486:	feb771e3          	bgeu	a4,a1,80000468 <printint+0x24>

  if(sign)
    8000048a:	000e0c63          	beqz	t3,800004a2 <printint+0x5e>
    buf[i++] = '-';
    8000048e:	fe060793          	addi	a5,a2,-32
    80000492:	00878633          	add	a2,a5,s0
    80000496:	02d00793          	li	a5,45
    8000049a:	fef60823          	sb	a5,-16(a2)
    8000049e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    800004a2:	fff7891b          	addiw	s2,a5,-1
    800004a6:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    800004aa:	fff4c503          	lbu	a0,-1(s1)
    800004ae:	da1ff0ef          	jal	8000024e <consputc>
  while(--i >= 0)
    800004b2:	397d                	addiw	s2,s2,-1
    800004b4:	14fd                	addi	s1,s1,-1
    800004b6:	fe095ae3          	bgez	s2,800004aa <printint+0x66>
}
    800004ba:	70a2                	ld	ra,40(sp)
    800004bc:	7402                	ld	s0,32(sp)
    800004be:	64e2                	ld	s1,24(sp)
    800004c0:	6942                	ld	s2,16(sp)
    800004c2:	6145                	addi	sp,sp,48
    800004c4:	8082                	ret
    x = -xx;
    800004c6:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004ca:	4e05                	li	t3,1
    x = -xx;
    800004cc:	b771                	j	80000458 <printint+0x14>

00000000800004ce <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004ce:	7155                	addi	sp,sp,-208
    800004d0:	e506                	sd	ra,136(sp)
    800004d2:	e122                	sd	s0,128(sp)
    800004d4:	f0d2                	sd	s4,96(sp)
    800004d6:	0900                	addi	s0,sp,144
    800004d8:	8a2a                	mv	s4,a0
    800004da:	e40c                	sd	a1,8(s0)
    800004dc:	e810                	sd	a2,16(s0)
    800004de:	ec14                	sd	a3,24(s0)
    800004e0:	f018                	sd	a4,32(s0)
    800004e2:	f41c                	sd	a5,40(s0)
    800004e4:	03043823          	sd	a6,48(s0)
    800004e8:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004ec:	00012797          	auipc	a5,0x12
    800004f0:	2047a783          	lw	a5,516(a5) # 800126f0 <pr+0x18>
    800004f4:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004f8:	e3a1                	bnez	a5,80000538 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004fa:	00840793          	addi	a5,s0,8
    800004fe:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000502:	00054503          	lbu	a0,0(a0)
    80000506:	26050663          	beqz	a0,80000772 <printf+0x2a4>
    8000050a:	fca6                	sd	s1,120(sp)
    8000050c:	f8ca                	sd	s2,112(sp)
    8000050e:	f4ce                	sd	s3,104(sp)
    80000510:	ecd6                	sd	s5,88(sp)
    80000512:	e8da                	sd	s6,80(sp)
    80000514:	e0e2                	sd	s8,64(sp)
    80000516:	fc66                	sd	s9,56(sp)
    80000518:	f86a                	sd	s10,48(sp)
    8000051a:	f46e                	sd	s11,40(sp)
    8000051c:	4981                	li	s3,0
    if(cx != '%'){
    8000051e:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000522:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80000526:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000052a:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    8000052e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000532:	07000d93          	li	s11,112
    80000536:	a80d                	j	80000568 <printf+0x9a>
    acquire(&pr.lock);
    80000538:	00012517          	auipc	a0,0x12
    8000053c:	1a050513          	addi	a0,a0,416 # 800126d8 <pr>
    80000540:	6be000ef          	jal	80000bfe <acquire>
  va_start(ap, fmt);
    80000544:	00840793          	addi	a5,s0,8
    80000548:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054c:	000a4503          	lbu	a0,0(s4)
    80000550:	fd4d                	bnez	a0,8000050a <printf+0x3c>
    80000552:	ac3d                	j	80000790 <printf+0x2c2>
      consputc(cx);
    80000554:	cfbff0ef          	jal	8000024e <consputc>
      continue;
    80000558:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000055a:	2485                	addiw	s1,s1,1
    8000055c:	89a6                	mv	s3,s1
    8000055e:	94d2                	add	s1,s1,s4
    80000560:	0004c503          	lbu	a0,0(s1)
    80000564:	1e050b63          	beqz	a0,8000075a <printf+0x28c>
    if(cx != '%'){
    80000568:	ff5516e3          	bne	a0,s5,80000554 <printf+0x86>
    i++;
    8000056c:	0019879b          	addiw	a5,s3,1
    80000570:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    80000572:	00fa0733          	add	a4,s4,a5
    80000576:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000057a:	1e090063          	beqz	s2,8000075a <printf+0x28c>
    8000057e:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    80000582:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    80000584:	c701                	beqz	a4,8000058c <printf+0xbe>
    80000586:	97d2                	add	a5,a5,s4
    80000588:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    8000058c:	03690763          	beq	s2,s6,800005ba <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    80000590:	05890163          	beq	s2,s8,800005d2 <printf+0x104>
    } else if(c0 == 'u'){
    80000594:	0d990b63          	beq	s2,s9,8000066a <printf+0x19c>
    } else if(c0 == 'x'){
    80000598:	13a90163          	beq	s2,s10,800006ba <printf+0x1ec>
    } else if(c0 == 'p'){
    8000059c:	13b90b63          	beq	s2,s11,800006d2 <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800005a0:	07300793          	li	a5,115
    800005a4:	16f90a63          	beq	s2,a5,80000718 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800005a8:	1b590463          	beq	s2,s5,80000750 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005ac:	8556                	mv	a0,s5
    800005ae:	ca1ff0ef          	jal	8000024e <consputc>
      consputc(c0);
    800005b2:	854a                	mv	a0,s2
    800005b4:	c9bff0ef          	jal	8000024e <consputc>
    800005b8:	b74d                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005ba:	f8843783          	ld	a5,-120(s0)
    800005be:	00878713          	addi	a4,a5,8
    800005c2:	f8e43423          	sd	a4,-120(s0)
    800005c6:	4605                	li	a2,1
    800005c8:	45a9                	li	a1,10
    800005ca:	4388                	lw	a0,0(a5)
    800005cc:	e79ff0ef          	jal	80000444 <printint>
    800005d0:	b769                	j	8000055a <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005d2:	03670663          	beq	a4,s6,800005fe <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005d6:	05870263          	beq	a4,s8,8000061a <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    800005da:	0b970463          	beq	a4,s9,80000682 <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    800005de:	fda717e3          	bne	a4,s10,800005ac <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    800005e2:	f8843783          	ld	a5,-120(s0)
    800005e6:	00878713          	addi	a4,a5,8
    800005ea:	f8e43423          	sd	a4,-120(s0)
    800005ee:	4601                	li	a2,0
    800005f0:	45c1                	li	a1,16
    800005f2:	6388                	ld	a0,0(a5)
    800005f4:	e51ff0ef          	jal	80000444 <printint>
      i += 1;
    800005f8:	0029849b          	addiw	s1,s3,2
    800005fc:	bfb9                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800005fe:	f8843783          	ld	a5,-120(s0)
    80000602:	00878713          	addi	a4,a5,8
    80000606:	f8e43423          	sd	a4,-120(s0)
    8000060a:	4605                	li	a2,1
    8000060c:	45a9                	li	a1,10
    8000060e:	6388                	ld	a0,0(a5)
    80000610:	e35ff0ef          	jal	80000444 <printint>
      i += 1;
    80000614:	0029849b          	addiw	s1,s3,2
    80000618:	b789                	j	8000055a <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000061a:	06400793          	li	a5,100
    8000061e:	02f68863          	beq	a3,a5,8000064e <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000622:	07500793          	li	a5,117
    80000626:	06f68c63          	beq	a3,a5,8000069e <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000062a:	07800793          	li	a5,120
    8000062e:	f6f69fe3          	bne	a3,a5,800005ac <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    80000632:	f8843783          	ld	a5,-120(s0)
    80000636:	00878713          	addi	a4,a5,8
    8000063a:	f8e43423          	sd	a4,-120(s0)
    8000063e:	4601                	li	a2,0
    80000640:	45c1                	li	a1,16
    80000642:	6388                	ld	a0,0(a5)
    80000644:	e01ff0ef          	jal	80000444 <printint>
      i += 2;
    80000648:	0039849b          	addiw	s1,s3,3
    8000064c:	b739                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    8000064e:	f8843783          	ld	a5,-120(s0)
    80000652:	00878713          	addi	a4,a5,8
    80000656:	f8e43423          	sd	a4,-120(s0)
    8000065a:	4605                	li	a2,1
    8000065c:	45a9                	li	a1,10
    8000065e:	6388                	ld	a0,0(a5)
    80000660:	de5ff0ef          	jal	80000444 <printint>
      i += 2;
    80000664:	0039849b          	addiw	s1,s3,3
    80000668:	bdcd                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000066a:	f8843783          	ld	a5,-120(s0)
    8000066e:	00878713          	addi	a4,a5,8
    80000672:	f8e43423          	sd	a4,-120(s0)
    80000676:	4601                	li	a2,0
    80000678:	45a9                	li	a1,10
    8000067a:	4388                	lw	a0,0(a5)
    8000067c:	dc9ff0ef          	jal	80000444 <printint>
    80000680:	bde9                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000682:	f8843783          	ld	a5,-120(s0)
    80000686:	00878713          	addi	a4,a5,8
    8000068a:	f8e43423          	sd	a4,-120(s0)
    8000068e:	4601                	li	a2,0
    80000690:	45a9                	li	a1,10
    80000692:	6388                	ld	a0,0(a5)
    80000694:	db1ff0ef          	jal	80000444 <printint>
      i += 1;
    80000698:	0029849b          	addiw	s1,s3,2
    8000069c:	bd7d                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    8000069e:	f8843783          	ld	a5,-120(s0)
    800006a2:	00878713          	addi	a4,a5,8
    800006a6:	f8e43423          	sd	a4,-120(s0)
    800006aa:	4601                	li	a2,0
    800006ac:	45a9                	li	a1,10
    800006ae:	6388                	ld	a0,0(a5)
    800006b0:	d95ff0ef          	jal	80000444 <printint>
      i += 2;
    800006b4:	0039849b          	addiw	s1,s3,3
    800006b8:	b54d                	j	8000055a <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006ba:	f8843783          	ld	a5,-120(s0)
    800006be:	00878713          	addi	a4,a5,8
    800006c2:	f8e43423          	sd	a4,-120(s0)
    800006c6:	4601                	li	a2,0
    800006c8:	45c1                	li	a1,16
    800006ca:	4388                	lw	a0,0(a5)
    800006cc:	d79ff0ef          	jal	80000444 <printint>
    800006d0:	b569                	j	8000055a <printf+0x8c>
    800006d2:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006d4:	f8843783          	ld	a5,-120(s0)
    800006d8:	00878713          	addi	a4,a5,8
    800006dc:	f8e43423          	sd	a4,-120(s0)
    800006e0:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006e4:	03000513          	li	a0,48
    800006e8:	b67ff0ef          	jal	8000024e <consputc>
  consputc('x');
    800006ec:	07800513          	li	a0,120
    800006f0:	b5fff0ef          	jal	8000024e <consputc>
    800006f4:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f6:	00007b97          	auipc	s7,0x7
    800006fa:	0e2b8b93          	addi	s7,s7,226 # 800077d8 <digits>
    800006fe:	03c9d793          	srli	a5,s3,0x3c
    80000702:	97de                	add	a5,a5,s7
    80000704:	0007c503          	lbu	a0,0(a5)
    80000708:	b47ff0ef          	jal	8000024e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070c:	0992                	slli	s3,s3,0x4
    8000070e:	397d                	addiw	s2,s2,-1
    80000710:	fe0917e3          	bnez	s2,800006fe <printf+0x230>
    80000714:	6ba6                	ld	s7,72(sp)
    80000716:	b591                	j	8000055a <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80000718:	f8843783          	ld	a5,-120(s0)
    8000071c:	00878713          	addi	a4,a5,8
    80000720:	f8e43423          	sd	a4,-120(s0)
    80000724:	0007b903          	ld	s2,0(a5)
    80000728:	00090d63          	beqz	s2,80000742 <printf+0x274>
      for(; *s; s++)
    8000072c:	00094503          	lbu	a0,0(s2)
    80000730:	e20505e3          	beqz	a0,8000055a <printf+0x8c>
        consputc(*s);
    80000734:	b1bff0ef          	jal	8000024e <consputc>
      for(; *s; s++)
    80000738:	0905                	addi	s2,s2,1
    8000073a:	00094503          	lbu	a0,0(s2)
    8000073e:	f97d                	bnez	a0,80000734 <printf+0x266>
    80000740:	bd29                	j	8000055a <printf+0x8c>
        s = "(null)";
    80000742:	00007917          	auipc	s2,0x7
    80000746:	8c690913          	addi	s2,s2,-1850 # 80007008 <etext+0x8>
      for(; *s; s++)
    8000074a:	02800513          	li	a0,40
    8000074e:	b7dd                	j	80000734 <printf+0x266>
      consputc('%');
    80000750:	02500513          	li	a0,37
    80000754:	afbff0ef          	jal	8000024e <consputc>
    80000758:	b509                	j	8000055a <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000075a:	f7843783          	ld	a5,-136(s0)
    8000075e:	e385                	bnez	a5,8000077e <printf+0x2b0>
    80000760:	74e6                	ld	s1,120(sp)
    80000762:	7946                	ld	s2,112(sp)
    80000764:	79a6                	ld	s3,104(sp)
    80000766:	6ae6                	ld	s5,88(sp)
    80000768:	6b46                	ld	s6,80(sp)
    8000076a:	6c06                	ld	s8,64(sp)
    8000076c:	7ce2                	ld	s9,56(sp)
    8000076e:	7d42                	ld	s10,48(sp)
    80000770:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000772:	4501                	li	a0,0
    80000774:	60aa                	ld	ra,136(sp)
    80000776:	640a                	ld	s0,128(sp)
    80000778:	7a06                	ld	s4,96(sp)
    8000077a:	6169                	addi	sp,sp,208
    8000077c:	8082                	ret
    8000077e:	74e6                	ld	s1,120(sp)
    80000780:	7946                	ld	s2,112(sp)
    80000782:	79a6                	ld	s3,104(sp)
    80000784:	6ae6                	ld	s5,88(sp)
    80000786:	6b46                	ld	s6,80(sp)
    80000788:	6c06                	ld	s8,64(sp)
    8000078a:	7ce2                	ld	s9,56(sp)
    8000078c:	7d42                	ld	s10,48(sp)
    8000078e:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000790:	00012517          	auipc	a0,0x12
    80000794:	f4850513          	addi	a0,a0,-184 # 800126d8 <pr>
    80000798:	4fa000ef          	jal	80000c92 <release>
    8000079c:	bfd9                	j	80000772 <printf+0x2a4>

000000008000079e <panic>:

void
panic(char *s)
{
    8000079e:	1101                	addi	sp,sp,-32
    800007a0:	ec06                	sd	ra,24(sp)
    800007a2:	e822                	sd	s0,16(sp)
    800007a4:	e426                	sd	s1,8(sp)
    800007a6:	1000                	addi	s0,sp,32
    800007a8:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007aa:	00012797          	auipc	a5,0x12
    800007ae:	f407a323          	sw	zero,-186(a5) # 800126f0 <pr+0x18>
  printf("panic: ");
    800007b2:	00007517          	auipc	a0,0x7
    800007b6:	86650513          	addi	a0,a0,-1946 # 80007018 <etext+0x18>
    800007ba:	d15ff0ef          	jal	800004ce <printf>
  printf("%s\n", s);
    800007be:	85a6                	mv	a1,s1
    800007c0:	00007517          	auipc	a0,0x7
    800007c4:	86050513          	addi	a0,a0,-1952 # 80007020 <etext+0x20>
    800007c8:	d07ff0ef          	jal	800004ce <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007cc:	4785                	li	a5,1
    800007ce:	0000a717          	auipc	a4,0xa
    800007d2:	e0f72923          	sw	a5,-494(a4) # 8000a5e0 <panicked>
  for(;;)
    800007d6:	a001                	j	800007d6 <panic+0x38>

00000000800007d8 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007d8:	1101                	addi	sp,sp,-32
    800007da:	ec06                	sd	ra,24(sp)
    800007dc:	e822                	sd	s0,16(sp)
    800007de:	e426                	sd	s1,8(sp)
    800007e0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007e2:	00012497          	auipc	s1,0x12
    800007e6:	ef648493          	addi	s1,s1,-266 # 800126d8 <pr>
    800007ea:	00007597          	auipc	a1,0x7
    800007ee:	83e58593          	addi	a1,a1,-1986 # 80007028 <etext+0x28>
    800007f2:	8526                	mv	a0,s1
    800007f4:	386000ef          	jal	80000b7a <initlock>
  pr.locking = 1;
    800007f8:	4785                	li	a5,1
    800007fa:	cc9c                	sw	a5,24(s1)
}
    800007fc:	60e2                	ld	ra,24(sp)
    800007fe:	6442                	ld	s0,16(sp)
    80000800:	64a2                	ld	s1,8(sp)
    80000802:	6105                	addi	sp,sp,32
    80000804:	8082                	ret

0000000080000806 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000806:	1141                	addi	sp,sp,-16
    80000808:	e406                	sd	ra,8(sp)
    8000080a:	e022                	sd	s0,0(sp)
    8000080c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000080e:	100007b7          	lui	a5,0x10000
    80000812:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000816:	10000737          	lui	a4,0x10000
    8000081a:	f8000693          	li	a3,-128
    8000081e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000822:	468d                	li	a3,3
    80000824:	10000637          	lui	a2,0x10000
    80000828:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000082c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000830:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000834:	8732                	mv	a4,a2
    80000836:	461d                	li	a2,7
    80000838:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000083c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000840:	00006597          	auipc	a1,0x6
    80000844:	7f058593          	addi	a1,a1,2032 # 80007030 <etext+0x30>
    80000848:	00012517          	auipc	a0,0x12
    8000084c:	eb050513          	addi	a0,a0,-336 # 800126f8 <uart_tx_lock>
    80000850:	32a000ef          	jal	80000b7a <initlock>
}
    80000854:	60a2                	ld	ra,8(sp)
    80000856:	6402                	ld	s0,0(sp)
    80000858:	0141                	addi	sp,sp,16
    8000085a:	8082                	ret

000000008000085c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000085c:	1101                	addi	sp,sp,-32
    8000085e:	ec06                	sd	ra,24(sp)
    80000860:	e822                	sd	s0,16(sp)
    80000862:	e426                	sd	s1,8(sp)
    80000864:	1000                	addi	s0,sp,32
    80000866:	84aa                	mv	s1,a0
  push_off();
    80000868:	356000ef          	jal	80000bbe <push_off>

  if(panicked){
    8000086c:	0000a797          	auipc	a5,0xa
    80000870:	d747a783          	lw	a5,-652(a5) # 8000a5e0 <panicked>
    80000874:	e795                	bnez	a5,800008a0 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000876:	10000737          	lui	a4,0x10000
    8000087a:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000087c:	00074783          	lbu	a5,0(a4)
    80000880:	0207f793          	andi	a5,a5,32
    80000884:	dfe5                	beqz	a5,8000087c <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    80000886:	0ff4f513          	zext.b	a0,s1
    8000088a:	100007b7          	lui	a5,0x10000
    8000088e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000892:	3b0000ef          	jal	80000c42 <pop_off>
}
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	addi	sp,sp,32
    8000089e:	8082                	ret
    for(;;)
    800008a0:	a001                	j	800008a0 <uartputc_sync+0x44>

00000000800008a2 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008a2:	0000a797          	auipc	a5,0xa
    800008a6:	d467b783          	ld	a5,-698(a5) # 8000a5e8 <uart_tx_r>
    800008aa:	0000a717          	auipc	a4,0xa
    800008ae:	d4673703          	ld	a4,-698(a4) # 8000a5f0 <uart_tx_w>
    800008b2:	08f70163          	beq	a4,a5,80000934 <uartstart+0x92>
{
    800008b6:	7139                	addi	sp,sp,-64
    800008b8:	fc06                	sd	ra,56(sp)
    800008ba:	f822                	sd	s0,48(sp)
    800008bc:	f426                	sd	s1,40(sp)
    800008be:	f04a                	sd	s2,32(sp)
    800008c0:	ec4e                	sd	s3,24(sp)
    800008c2:	e852                	sd	s4,16(sp)
    800008c4:	e456                	sd	s5,8(sp)
    800008c6:	e05a                	sd	s6,0(sp)
    800008c8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ca:	10000937          	lui	s2,0x10000
    800008ce:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008d0:	00012a97          	auipc	s5,0x12
    800008d4:	e28a8a93          	addi	s5,s5,-472 # 800126f8 <uart_tx_lock>
    uart_tx_r += 1;
    800008d8:	0000a497          	auipc	s1,0xa
    800008dc:	d1048493          	addi	s1,s1,-752 # 8000a5e8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008e0:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008e4:	0000a997          	auipc	s3,0xa
    800008e8:	d0c98993          	addi	s3,s3,-756 # 8000a5f0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ec:	00094703          	lbu	a4,0(s2)
    800008f0:	02077713          	andi	a4,a4,32
    800008f4:	c715                	beqz	a4,80000920 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008f6:	01f7f713          	andi	a4,a5,31
    800008fa:	9756                	add	a4,a4,s5
    800008fc:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80000900:	0785                	addi	a5,a5,1
    80000902:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80000904:	8526                	mv	a0,s1
    80000906:	6f2010ef          	jal	80001ff8 <wakeup>
    WriteReg(THR, c);
    8000090a:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000090e:	609c                	ld	a5,0(s1)
    80000910:	0009b703          	ld	a4,0(s3)
    80000914:	fcf71ce3          	bne	a4,a5,800008ec <uartstart+0x4a>
      ReadReg(ISR);
    80000918:	100007b7          	lui	a5,0x10000
    8000091c:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80000920:	70e2                	ld	ra,56(sp)
    80000922:	7442                	ld	s0,48(sp)
    80000924:	74a2                	ld	s1,40(sp)
    80000926:	7902                	ld	s2,32(sp)
    80000928:	69e2                	ld	s3,24(sp)
    8000092a:	6a42                	ld	s4,16(sp)
    8000092c:	6aa2                	ld	s5,8(sp)
    8000092e:	6b02                	ld	s6,0(sp)
    80000930:	6121                	addi	sp,sp,64
    80000932:	8082                	ret
      ReadReg(ISR);
    80000934:	100007b7          	lui	a5,0x10000
    80000938:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    8000093c:	8082                	ret

000000008000093e <uartputc>:
{
    8000093e:	7179                	addi	sp,sp,-48
    80000940:	f406                	sd	ra,40(sp)
    80000942:	f022                	sd	s0,32(sp)
    80000944:	ec26                	sd	s1,24(sp)
    80000946:	e84a                	sd	s2,16(sp)
    80000948:	e44e                	sd	s3,8(sp)
    8000094a:	e052                	sd	s4,0(sp)
    8000094c:	1800                	addi	s0,sp,48
    8000094e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000950:	00012517          	auipc	a0,0x12
    80000954:	da850513          	addi	a0,a0,-600 # 800126f8 <uart_tx_lock>
    80000958:	2a6000ef          	jal	80000bfe <acquire>
  if(panicked){
    8000095c:	0000a797          	auipc	a5,0xa
    80000960:	c847a783          	lw	a5,-892(a5) # 8000a5e0 <panicked>
    80000964:	efbd                	bnez	a5,800009e2 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000966:	0000a717          	auipc	a4,0xa
    8000096a:	c8a73703          	ld	a4,-886(a4) # 8000a5f0 <uart_tx_w>
    8000096e:	0000a797          	auipc	a5,0xa
    80000972:	c7a7b783          	ld	a5,-902(a5) # 8000a5e8 <uart_tx_r>
    80000976:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	00012997          	auipc	s3,0x12
    8000097e:	d7e98993          	addi	s3,s3,-642 # 800126f8 <uart_tx_lock>
    80000982:	0000a497          	auipc	s1,0xa
    80000986:	c6648493          	addi	s1,s1,-922 # 8000a5e8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000098a:	0000a917          	auipc	s2,0xa
    8000098e:	c6690913          	addi	s2,s2,-922 # 8000a5f0 <uart_tx_w>
    80000992:	00e79d63          	bne	a5,a4,800009ac <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000996:	85ce                	mv	a1,s3
    80000998:	8526                	mv	a0,s1
    8000099a:	612010ef          	jal	80001fac <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099e:	00093703          	ld	a4,0(s2)
    800009a2:	609c                	ld	a5,0(s1)
    800009a4:	02078793          	addi	a5,a5,32
    800009a8:	fee787e3          	beq	a5,a4,80000996 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009ac:	00012497          	auipc	s1,0x12
    800009b0:	d4c48493          	addi	s1,s1,-692 # 800126f8 <uart_tx_lock>
    800009b4:	01f77793          	andi	a5,a4,31
    800009b8:	97a6                	add	a5,a5,s1
    800009ba:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009be:	0705                	addi	a4,a4,1
    800009c0:	0000a797          	auipc	a5,0xa
    800009c4:	c2e7b823          	sd	a4,-976(a5) # 8000a5f0 <uart_tx_w>
  uartstart();
    800009c8:	edbff0ef          	jal	800008a2 <uartstart>
  release(&uart_tx_lock);
    800009cc:	8526                	mv	a0,s1
    800009ce:	2c4000ef          	jal	80000c92 <release>
}
    800009d2:	70a2                	ld	ra,40(sp)
    800009d4:	7402                	ld	s0,32(sp)
    800009d6:	64e2                	ld	s1,24(sp)
    800009d8:	6942                	ld	s2,16(sp)
    800009da:	69a2                	ld	s3,8(sp)
    800009dc:	6a02                	ld	s4,0(sp)
    800009de:	6145                	addi	sp,sp,48
    800009e0:	8082                	ret
    for(;;)
    800009e2:	a001                	j	800009e2 <uartputc+0xa4>

00000000800009e4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e4:	1141                	addi	sp,sp,-16
    800009e6:	e406                	sd	ra,8(sp)
    800009e8:	e022                	sd	s0,0(sp)
    800009ea:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009ec:	100007b7          	lui	a5,0x10000
    800009f0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009f4:	8b85                	andi	a5,a5,1
    800009f6:	cb89                	beqz	a5,80000a08 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009f8:	100007b7          	lui	a5,0x10000
    800009fc:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a00:	60a2                	ld	ra,8(sp)
    80000a02:	6402                	ld	s0,0(sp)
    80000a04:	0141                	addi	sp,sp,16
    80000a06:	8082                	ret
    return -1;
    80000a08:	557d                	li	a0,-1
    80000a0a:	bfdd                	j	80000a00 <uartgetc+0x1c>

0000000080000a0c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a0c:	1101                	addi	sp,sp,-32
    80000a0e:	ec06                	sd	ra,24(sp)
    80000a10:	e822                	sd	s0,16(sp)
    80000a12:	e426                	sd	s1,8(sp)
    80000a14:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a16:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a18:	fcdff0ef          	jal	800009e4 <uartgetc>
    if(c == -1)
    80000a1c:	00950563          	beq	a0,s1,80000a26 <uartintr+0x1a>
      break;
    consoleintr(c);
    80000a20:	861ff0ef          	jal	80000280 <consoleintr>
  while(1){
    80000a24:	bfd5                	j	80000a18 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a26:	00012497          	auipc	s1,0x12
    80000a2a:	cd248493          	addi	s1,s1,-814 # 800126f8 <uart_tx_lock>
    80000a2e:	8526                	mv	a0,s1
    80000a30:	1ce000ef          	jal	80000bfe <acquire>
  uartstart();
    80000a34:	e6fff0ef          	jal	800008a2 <uartstart>
  release(&uart_tx_lock);
    80000a38:	8526                	mv	a0,s1
    80000a3a:	258000ef          	jal	80000c92 <release>
}
    80000a3e:	60e2                	ld	ra,24(sp)
    80000a40:	6442                	ld	s0,16(sp)
    80000a42:	64a2                	ld	s1,8(sp)
    80000a44:	6105                	addi	sp,sp,32
    80000a46:	8082                	ret

0000000080000a48 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a48:	1101                	addi	sp,sp,-32
    80000a4a:	ec06                	sd	ra,24(sp)
    80000a4c:	e822                	sd	s0,16(sp)
    80000a4e:	e426                	sd	s1,8(sp)
    80000a50:	e04a                	sd	s2,0(sp)
    80000a52:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a54:	03451793          	slli	a5,a0,0x34
    80000a58:	e7a9                	bnez	a5,80000aa2 <kfree+0x5a>
    80000a5a:	84aa                	mv	s1,a0
    80000a5c:	00023797          	auipc	a5,0x23
    80000a60:	70478793          	addi	a5,a5,1796 # 80024160 <end>
    80000a64:	02f56f63          	bltu	a0,a5,80000aa2 <kfree+0x5a>
    80000a68:	47c5                	li	a5,17
    80000a6a:	07ee                	slli	a5,a5,0x1b
    80000a6c:	02f57b63          	bgeu	a0,a5,80000aa2 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a70:	6605                	lui	a2,0x1
    80000a72:	4585                	li	a1,1
    80000a74:	25a000ef          	jal	80000cce <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a78:	00012917          	auipc	s2,0x12
    80000a7c:	cb890913          	addi	s2,s2,-840 # 80012730 <kmem>
    80000a80:	854a                	mv	a0,s2
    80000a82:	17c000ef          	jal	80000bfe <acquire>
  r->next = kmem.freelist;
    80000a86:	01893783          	ld	a5,24(s2)
    80000a8a:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a8c:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a90:	854a                	mv	a0,s2
    80000a92:	200000ef          	jal	80000c92 <release>
}
    80000a96:	60e2                	ld	ra,24(sp)
    80000a98:	6442                	ld	s0,16(sp)
    80000a9a:	64a2                	ld	s1,8(sp)
    80000a9c:	6902                	ld	s2,0(sp)
    80000a9e:	6105                	addi	sp,sp,32
    80000aa0:	8082                	ret
    panic("kfree");
    80000aa2:	00006517          	auipc	a0,0x6
    80000aa6:	59650513          	addi	a0,a0,1430 # 80007038 <etext+0x38>
    80000aaa:	cf5ff0ef          	jal	8000079e <panic>

0000000080000aae <freerange>:
{
    80000aae:	7179                	addi	sp,sp,-48
    80000ab0:	f406                	sd	ra,40(sp)
    80000ab2:	f022                	sd	s0,32(sp)
    80000ab4:	ec26                	sd	s1,24(sp)
    80000ab6:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab8:	6785                	lui	a5,0x1
    80000aba:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000abe:	00e504b3          	add	s1,a0,a4
    80000ac2:	777d                	lui	a4,0xfffff
    80000ac4:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac6:	94be                	add	s1,s1,a5
    80000ac8:	0295e263          	bltu	a1,s1,80000aec <freerange+0x3e>
    80000acc:	e84a                	sd	s2,16(sp)
    80000ace:	e44e                	sd	s3,8(sp)
    80000ad0:	e052                	sd	s4,0(sp)
    80000ad2:	892e                	mv	s2,a1
    kfree(p);
    80000ad4:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad6:	89be                	mv	s3,a5
    kfree(p);
    80000ad8:	01448533          	add	a0,s1,s4
    80000adc:	f6dff0ef          	jal	80000a48 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae0:	94ce                	add	s1,s1,s3
    80000ae2:	fe997be3          	bgeu	s2,s1,80000ad8 <freerange+0x2a>
    80000ae6:	6942                	ld	s2,16(sp)
    80000ae8:	69a2                	ld	s3,8(sp)
    80000aea:	6a02                	ld	s4,0(sp)
}
    80000aec:	70a2                	ld	ra,40(sp)
    80000aee:	7402                	ld	s0,32(sp)
    80000af0:	64e2                	ld	s1,24(sp)
    80000af2:	6145                	addi	sp,sp,48
    80000af4:	8082                	ret

0000000080000af6 <kinit>:
{
    80000af6:	1141                	addi	sp,sp,-16
    80000af8:	e406                	sd	ra,8(sp)
    80000afa:	e022                	sd	s0,0(sp)
    80000afc:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000afe:	00006597          	auipc	a1,0x6
    80000b02:	54258593          	addi	a1,a1,1346 # 80007040 <etext+0x40>
    80000b06:	00012517          	auipc	a0,0x12
    80000b0a:	c2a50513          	addi	a0,a0,-982 # 80012730 <kmem>
    80000b0e:	06c000ef          	jal	80000b7a <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b12:	45c5                	li	a1,17
    80000b14:	05ee                	slli	a1,a1,0x1b
    80000b16:	00023517          	auipc	a0,0x23
    80000b1a:	64a50513          	addi	a0,a0,1610 # 80024160 <end>
    80000b1e:	f91ff0ef          	jal	80000aae <freerange>
}
    80000b22:	60a2                	ld	ra,8(sp)
    80000b24:	6402                	ld	s0,0(sp)
    80000b26:	0141                	addi	sp,sp,16
    80000b28:	8082                	ret

0000000080000b2a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b2a:	1101                	addi	sp,sp,-32
    80000b2c:	ec06                	sd	ra,24(sp)
    80000b2e:	e822                	sd	s0,16(sp)
    80000b30:	e426                	sd	s1,8(sp)
    80000b32:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b34:	00012497          	auipc	s1,0x12
    80000b38:	bfc48493          	addi	s1,s1,-1028 # 80012730 <kmem>
    80000b3c:	8526                	mv	a0,s1
    80000b3e:	0c0000ef          	jal	80000bfe <acquire>
  r = kmem.freelist;
    80000b42:	6c84                	ld	s1,24(s1)
  if(r)
    80000b44:	c485                	beqz	s1,80000b6c <kalloc+0x42>
    kmem.freelist = r->next;
    80000b46:	609c                	ld	a5,0(s1)
    80000b48:	00012517          	auipc	a0,0x12
    80000b4c:	be850513          	addi	a0,a0,-1048 # 80012730 <kmem>
    80000b50:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b52:	140000ef          	jal	80000c92 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b56:	6605                	lui	a2,0x1
    80000b58:	4595                	li	a1,5
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	172000ef          	jal	80000cce <memset>
  return (void*)r;
}
    80000b60:	8526                	mv	a0,s1
    80000b62:	60e2                	ld	ra,24(sp)
    80000b64:	6442                	ld	s0,16(sp)
    80000b66:	64a2                	ld	s1,8(sp)
    80000b68:	6105                	addi	sp,sp,32
    80000b6a:	8082                	ret
  release(&kmem.lock);
    80000b6c:	00012517          	auipc	a0,0x12
    80000b70:	bc450513          	addi	a0,a0,-1084 # 80012730 <kmem>
    80000b74:	11e000ef          	jal	80000c92 <release>
  if(r)
    80000b78:	b7e5                	j	80000b60 <kalloc+0x36>

0000000080000b7a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b7a:	1141                	addi	sp,sp,-16
    80000b7c:	e406                	sd	ra,8(sp)
    80000b7e:	e022                	sd	s0,0(sp)
    80000b80:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b82:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b84:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b88:	00053823          	sd	zero,16(a0)
}
    80000b8c:	60a2                	ld	ra,8(sp)
    80000b8e:	6402                	ld	s0,0(sp)
    80000b90:	0141                	addi	sp,sp,16
    80000b92:	8082                	ret

0000000080000b94 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b94:	411c                	lw	a5,0(a0)
    80000b96:	e399                	bnez	a5,80000b9c <holding+0x8>
    80000b98:	4501                	li	a0,0
  return r;
}
    80000b9a:	8082                	ret
{
    80000b9c:	1101                	addi	sp,sp,-32
    80000b9e:	ec06                	sd	ra,24(sp)
    80000ba0:	e822                	sd	s0,16(sp)
    80000ba2:	e426                	sd	s1,8(sp)
    80000ba4:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000ba6:	6904                	ld	s1,16(a0)
    80000ba8:	515000ef          	jal	800018bc <mycpu>
    80000bac:	40a48533          	sub	a0,s1,a0
    80000bb0:	00153513          	seqz	a0,a0
}
    80000bb4:	60e2                	ld	ra,24(sp)
    80000bb6:	6442                	ld	s0,16(sp)
    80000bb8:	64a2                	ld	s1,8(sp)
    80000bba:	6105                	addi	sp,sp,32
    80000bbc:	8082                	ret

0000000080000bbe <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bbe:	1101                	addi	sp,sp,-32
    80000bc0:	ec06                	sd	ra,24(sp)
    80000bc2:	e822                	sd	s0,16(sp)
    80000bc4:	e426                	sd	s1,8(sp)
    80000bc6:	1000                	addi	s0,sp,32

static inline uint64
r_sstatus()
{
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bc8:	100024f3          	csrr	s1,sstatus
    80000bcc:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bd0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bd2:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bd6:	4e7000ef          	jal	800018bc <mycpu>
    80000bda:	5d3c                	lw	a5,120(a0)
    80000bdc:	cb99                	beqz	a5,80000bf2 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bde:	4df000ef          	jal	800018bc <mycpu>
    80000be2:	5d3c                	lw	a5,120(a0)
    80000be4:	2785                	addiw	a5,a5,1
    80000be6:	dd3c                	sw	a5,120(a0)
}
    80000be8:	60e2                	ld	ra,24(sp)
    80000bea:	6442                	ld	s0,16(sp)
    80000bec:	64a2                	ld	s1,8(sp)
    80000bee:	6105                	addi	sp,sp,32
    80000bf0:	8082                	ret
    mycpu()->intena = old;
    80000bf2:	4cb000ef          	jal	800018bc <mycpu>
// are device interrupts enabled?
static inline int
intr_get()
{
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
    80000bf6:	8085                	srli	s1,s1,0x1
    80000bf8:	8885                	andi	s1,s1,1
    80000bfa:	dd64                	sw	s1,124(a0)
    80000bfc:	b7cd                	j	80000bde <push_off+0x20>

0000000080000bfe <acquire>:
{
    80000bfe:	1101                	addi	sp,sp,-32
    80000c00:	ec06                	sd	ra,24(sp)
    80000c02:	e822                	sd	s0,16(sp)
    80000c04:	e426                	sd	s1,8(sp)
    80000c06:	1000                	addi	s0,sp,32
    80000c08:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c0a:	fb5ff0ef          	jal	80000bbe <push_off>
  if(holding(lk))
    80000c0e:	8526                	mv	a0,s1
    80000c10:	f85ff0ef          	jal	80000b94 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c14:	4705                	li	a4,1
  if(holding(lk))
    80000c16:	e105                	bnez	a0,80000c36 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c18:	87ba                	mv	a5,a4
    80000c1a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c1e:	2781                	sext.w	a5,a5
    80000c20:	ffe5                	bnez	a5,80000c18 <acquire+0x1a>
  __sync_synchronize();
    80000c22:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c26:	497000ef          	jal	800018bc <mycpu>
    80000c2a:	e888                	sd	a0,16(s1)
}
    80000c2c:	60e2                	ld	ra,24(sp)
    80000c2e:	6442                	ld	s0,16(sp)
    80000c30:	64a2                	ld	s1,8(sp)
    80000c32:	6105                	addi	sp,sp,32
    80000c34:	8082                	ret
    panic("acquire");
    80000c36:	00006517          	auipc	a0,0x6
    80000c3a:	41250513          	addi	a0,a0,1042 # 80007048 <etext+0x48>
    80000c3e:	b61ff0ef          	jal	8000079e <panic>

0000000080000c42 <pop_off>:

void
pop_off(void)
{
    80000c42:	1141                	addi	sp,sp,-16
    80000c44:	e406                	sd	ra,8(sp)
    80000c46:	e022                	sd	s0,0(sp)
    80000c48:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c4a:	473000ef          	jal	800018bc <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c4e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c52:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c54:	e39d                	bnez	a5,80000c7a <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c56:	5d3c                	lw	a5,120(a0)
    80000c58:	02f05763          	blez	a5,80000c86 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80000c5c:	37fd                	addiw	a5,a5,-1
    80000c5e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c60:	eb89                	bnez	a5,80000c72 <pop_off+0x30>
    80000c62:	5d7c                	lw	a5,124(a0)
    80000c64:	c799                	beqz	a5,80000c72 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c66:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c6a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c6e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c72:	60a2                	ld	ra,8(sp)
    80000c74:	6402                	ld	s0,0(sp)
    80000c76:	0141                	addi	sp,sp,16
    80000c78:	8082                	ret
    panic("pop_off - interruptible");
    80000c7a:	00006517          	auipc	a0,0x6
    80000c7e:	3d650513          	addi	a0,a0,982 # 80007050 <etext+0x50>
    80000c82:	b1dff0ef          	jal	8000079e <panic>
    panic("pop_off");
    80000c86:	00006517          	auipc	a0,0x6
    80000c8a:	3e250513          	addi	a0,a0,994 # 80007068 <etext+0x68>
    80000c8e:	b11ff0ef          	jal	8000079e <panic>

0000000080000c92 <release>:
{
    80000c92:	1101                	addi	sp,sp,-32
    80000c94:	ec06                	sd	ra,24(sp)
    80000c96:	e822                	sd	s0,16(sp)
    80000c98:	e426                	sd	s1,8(sp)
    80000c9a:	1000                	addi	s0,sp,32
    80000c9c:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c9e:	ef7ff0ef          	jal	80000b94 <holding>
    80000ca2:	c105                	beqz	a0,80000cc2 <release+0x30>
  lk->cpu = 0;
    80000ca4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca8:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000cac:	0310000f          	fence	rw,w
    80000cb0:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cb4:	f8fff0ef          	jal	80000c42 <pop_off>
}
    80000cb8:	60e2                	ld	ra,24(sp)
    80000cba:	6442                	ld	s0,16(sp)
    80000cbc:	64a2                	ld	s1,8(sp)
    80000cbe:	6105                	addi	sp,sp,32
    80000cc0:	8082                	ret
    panic("release");
    80000cc2:	00006517          	auipc	a0,0x6
    80000cc6:	3ae50513          	addi	a0,a0,942 # 80007070 <etext+0x70>
    80000cca:	ad5ff0ef          	jal	8000079e <panic>

0000000080000cce <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cce:	1141                	addi	sp,sp,-16
    80000cd0:	e406                	sd	ra,8(sp)
    80000cd2:	e022                	sd	s0,0(sp)
    80000cd4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd6:	ca19                	beqz	a2,80000cec <memset+0x1e>
    80000cd8:	87aa                	mv	a5,a0
    80000cda:	1602                	slli	a2,a2,0x20
    80000cdc:	9201                	srli	a2,a2,0x20
    80000cde:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce6:	0785                	addi	a5,a5,1
    80000ce8:	fee79de3          	bne	a5,a4,80000ce2 <memset+0x14>
  }
  return dst;
}
    80000cec:	60a2                	ld	ra,8(sp)
    80000cee:	6402                	ld	s0,0(sp)
    80000cf0:	0141                	addi	sp,sp,16
    80000cf2:	8082                	ret

0000000080000cf4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf4:	1141                	addi	sp,sp,-16
    80000cf6:	e406                	sd	ra,8(sp)
    80000cf8:	e022                	sd	s0,0(sp)
    80000cfa:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cfc:	ca0d                	beqz	a2,80000d2e <memcmp+0x3a>
    80000cfe:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d02:	1682                	slli	a3,a3,0x20
    80000d04:	9281                	srli	a3,a3,0x20
    80000d06:	0685                	addi	a3,a3,1
    80000d08:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d0a:	00054783          	lbu	a5,0(a0)
    80000d0e:	0005c703          	lbu	a4,0(a1)
    80000d12:	00e79863          	bne	a5,a4,80000d22 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000d16:	0505                	addi	a0,a0,1
    80000d18:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d1a:	fed518e3          	bne	a0,a3,80000d0a <memcmp+0x16>
  }

  return 0;
    80000d1e:	4501                	li	a0,0
    80000d20:	a019                	j	80000d26 <memcmp+0x32>
      return *s1 - *s2;
    80000d22:	40e7853b          	subw	a0,a5,a4
}
    80000d26:	60a2                	ld	ra,8(sp)
    80000d28:	6402                	ld	s0,0(sp)
    80000d2a:	0141                	addi	sp,sp,16
    80000d2c:	8082                	ret
  return 0;
    80000d2e:	4501                	li	a0,0
    80000d30:	bfdd                	j	80000d26 <memcmp+0x32>

0000000080000d32 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d32:	1141                	addi	sp,sp,-16
    80000d34:	e406                	sd	ra,8(sp)
    80000d36:	e022                	sd	s0,0(sp)
    80000d38:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d3a:	c205                	beqz	a2,80000d5a <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d3c:	02a5e363          	bltu	a1,a0,80000d62 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d40:	1602                	slli	a2,a2,0x20
    80000d42:	9201                	srli	a2,a2,0x20
    80000d44:	00c587b3          	add	a5,a1,a2
{
    80000d48:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d4a:	0585                	addi	a1,a1,1
    80000d4c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdaea1>
    80000d4e:	fff5c683          	lbu	a3,-1(a1)
    80000d52:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d56:	feb79ae3          	bne	a5,a1,80000d4a <memmove+0x18>

  return dst;
}
    80000d5a:	60a2                	ld	ra,8(sp)
    80000d5c:	6402                	ld	s0,0(sp)
    80000d5e:	0141                	addi	sp,sp,16
    80000d60:	8082                	ret
  if(s < d && s + n > d){
    80000d62:	02061693          	slli	a3,a2,0x20
    80000d66:	9281                	srli	a3,a3,0x20
    80000d68:	00d58733          	add	a4,a1,a3
    80000d6c:	fce57ae3          	bgeu	a0,a4,80000d40 <memmove+0xe>
    d += n;
    80000d70:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d72:	fff6079b          	addiw	a5,a2,-1
    80000d76:	1782                	slli	a5,a5,0x20
    80000d78:	9381                	srli	a5,a5,0x20
    80000d7a:	fff7c793          	not	a5,a5
    80000d7e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d80:	177d                	addi	a4,a4,-1
    80000d82:	16fd                	addi	a3,a3,-1
    80000d84:	00074603          	lbu	a2,0(a4)
    80000d88:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d8c:	fee79ae3          	bne	a5,a4,80000d80 <memmove+0x4e>
    80000d90:	b7e9                	j	80000d5a <memmove+0x28>

0000000080000d92 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d92:	1141                	addi	sp,sp,-16
    80000d94:	e406                	sd	ra,8(sp)
    80000d96:	e022                	sd	s0,0(sp)
    80000d98:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d9a:	f99ff0ef          	jal	80000d32 <memmove>
}
    80000d9e:	60a2                	ld	ra,8(sp)
    80000da0:	6402                	ld	s0,0(sp)
    80000da2:	0141                	addi	sp,sp,16
    80000da4:	8082                	ret

0000000080000da6 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da6:	1141                	addi	sp,sp,-16
    80000da8:	e406                	sd	ra,8(sp)
    80000daa:	e022                	sd	s0,0(sp)
    80000dac:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dae:	ce11                	beqz	a2,80000dca <strncmp+0x24>
    80000db0:	00054783          	lbu	a5,0(a0)
    80000db4:	cf89                	beqz	a5,80000dce <strncmp+0x28>
    80000db6:	0005c703          	lbu	a4,0(a1)
    80000dba:	00f71a63          	bne	a4,a5,80000dce <strncmp+0x28>
    n--, p++, q++;
    80000dbe:	367d                	addiw	a2,a2,-1
    80000dc0:	0505                	addi	a0,a0,1
    80000dc2:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dc4:	f675                	bnez	a2,80000db0 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000dc6:	4501                	li	a0,0
    80000dc8:	a801                	j	80000dd8 <strncmp+0x32>
    80000dca:	4501                	li	a0,0
    80000dcc:	a031                	j	80000dd8 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000dce:	00054503          	lbu	a0,0(a0)
    80000dd2:	0005c783          	lbu	a5,0(a1)
    80000dd6:	9d1d                	subw	a0,a0,a5
}
    80000dd8:	60a2                	ld	ra,8(sp)
    80000dda:	6402                	ld	s0,0(sp)
    80000ddc:	0141                	addi	sp,sp,16
    80000dde:	8082                	ret

0000000080000de0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000de0:	1141                	addi	sp,sp,-16
    80000de2:	e406                	sd	ra,8(sp)
    80000de4:	e022                	sd	s0,0(sp)
    80000de6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de8:	87aa                	mv	a5,a0
    80000dea:	86b2                	mv	a3,a2
    80000dec:	367d                	addiw	a2,a2,-1
    80000dee:	02d05563          	blez	a3,80000e18 <strncpy+0x38>
    80000df2:	0785                	addi	a5,a5,1
    80000df4:	0005c703          	lbu	a4,0(a1)
    80000df8:	fee78fa3          	sb	a4,-1(a5)
    80000dfc:	0585                	addi	a1,a1,1
    80000dfe:	f775                	bnez	a4,80000dea <strncpy+0xa>
    ;
  while(n-- > 0)
    80000e00:	873e                	mv	a4,a5
    80000e02:	00c05b63          	blez	a2,80000e18 <strncpy+0x38>
    80000e06:	9fb5                	addw	a5,a5,a3
    80000e08:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e0a:	0705                	addi	a4,a4,1
    80000e0c:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e10:	40e786bb          	subw	a3,a5,a4
    80000e14:	fed04be3          	bgtz	a3,80000e0a <strncpy+0x2a>
  return os;
}
    80000e18:	60a2                	ld	ra,8(sp)
    80000e1a:	6402                	ld	s0,0(sp)
    80000e1c:	0141                	addi	sp,sp,16
    80000e1e:	8082                	ret

0000000080000e20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e20:	1141                	addi	sp,sp,-16
    80000e22:	e406                	sd	ra,8(sp)
    80000e24:	e022                	sd	s0,0(sp)
    80000e26:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e28:	02c05363          	blez	a2,80000e4e <safestrcpy+0x2e>
    80000e2c:	fff6069b          	addiw	a3,a2,-1
    80000e30:	1682                	slli	a3,a3,0x20
    80000e32:	9281                	srli	a3,a3,0x20
    80000e34:	96ae                	add	a3,a3,a1
    80000e36:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e38:	00d58963          	beq	a1,a3,80000e4a <safestrcpy+0x2a>
    80000e3c:	0585                	addi	a1,a1,1
    80000e3e:	0785                	addi	a5,a5,1
    80000e40:	fff5c703          	lbu	a4,-1(a1)
    80000e44:	fee78fa3          	sb	a4,-1(a5)
    80000e48:	fb65                	bnez	a4,80000e38 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e4a:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e4e:	60a2                	ld	ra,8(sp)
    80000e50:	6402                	ld	s0,0(sp)
    80000e52:	0141                	addi	sp,sp,16
    80000e54:	8082                	ret

0000000080000e56 <strlen>:

int
strlen(const char *s)
{
    80000e56:	1141                	addi	sp,sp,-16
    80000e58:	e406                	sd	ra,8(sp)
    80000e5a:	e022                	sd	s0,0(sp)
    80000e5c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e5e:	00054783          	lbu	a5,0(a0)
    80000e62:	cf99                	beqz	a5,80000e80 <strlen+0x2a>
    80000e64:	0505                	addi	a0,a0,1
    80000e66:	87aa                	mv	a5,a0
    80000e68:	86be                	mv	a3,a5
    80000e6a:	0785                	addi	a5,a5,1
    80000e6c:	fff7c703          	lbu	a4,-1(a5)
    80000e70:	ff65                	bnez	a4,80000e68 <strlen+0x12>
    80000e72:	40a6853b          	subw	a0,a3,a0
    80000e76:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e78:	60a2                	ld	ra,8(sp)
    80000e7a:	6402                	ld	s0,0(sp)
    80000e7c:	0141                	addi	sp,sp,16
    80000e7e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e80:	4501                	li	a0,0
    80000e82:	bfdd                	j	80000e78 <strlen+0x22>

0000000080000e84 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e84:	1141                	addi	sp,sp,-16
    80000e86:	e406                	sd	ra,8(sp)
    80000e88:	e022                	sd	s0,0(sp)
    80000e8a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e8c:	21d000ef          	jal	800018a8 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e90:	00009717          	auipc	a4,0x9
    80000e94:	76870713          	addi	a4,a4,1896 # 8000a5f8 <started>
  if(cpuid() == 0){
    80000e98:	c51d                	beqz	a0,80000ec6 <main+0x42>
    while(started == 0)
    80000e9a:	431c                	lw	a5,0(a4)
    80000e9c:	2781                	sext.w	a5,a5
    80000e9e:	dff5                	beqz	a5,80000e9a <main+0x16>
      ;
    __sync_synchronize();
    80000ea0:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000ea4:	205000ef          	jal	800018a8 <cpuid>
    80000ea8:	85aa                	mv	a1,a0
    80000eaa:	00006517          	auipc	a0,0x6
    80000eae:	1ee50513          	addi	a0,a0,494 # 80007098 <etext+0x98>
    80000eb2:	e1cff0ef          	jal	800004ce <printf>
    kvminithart();    // turn on paging
    80000eb6:	080000ef          	jal	80000f36 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eba:	60e010ef          	jal	800024c8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ebe:	71a040ef          	jal	800055d8 <plicinithart>
  }

  scheduler();        
    80000ec2:	7b1000ef          	jal	80001e72 <scheduler>
    consoleinit();
    80000ec6:	d3aff0ef          	jal	80000400 <consoleinit>
    printfinit();
    80000eca:	90fff0ef          	jal	800007d8 <printfinit>
    printf("\n");
    80000ece:	00006517          	auipc	a0,0x6
    80000ed2:	1aa50513          	addi	a0,a0,426 # 80007078 <etext+0x78>
    80000ed6:	df8ff0ef          	jal	800004ce <printf>
    printf("xv6 kernel is booting\n");
    80000eda:	00006517          	auipc	a0,0x6
    80000ede:	1a650513          	addi	a0,a0,422 # 80007080 <etext+0x80>
    80000ee2:	decff0ef          	jal	800004ce <printf>
    printf("\n");
    80000ee6:	00006517          	auipc	a0,0x6
    80000eea:	19250513          	addi	a0,a0,402 # 80007078 <etext+0x78>
    80000eee:	de0ff0ef          	jal	800004ce <printf>
    kinit();         // physical page allocator
    80000ef2:	c05ff0ef          	jal	80000af6 <kinit>
    kvminit();       // create kernel page table
    80000ef6:	2ce000ef          	jal	800011c4 <kvminit>
    kvminithart();   // turn on paging
    80000efa:	03c000ef          	jal	80000f36 <kvminithart>
    procinit();      // process table
    80000efe:	0fb000ef          	jal	800017f8 <procinit>
    trapinit();      // trap vectors
    80000f02:	5a2010ef          	jal	800024a4 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f06:	5c2010ef          	jal	800024c8 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f0a:	6b4040ef          	jal	800055be <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f0e:	6ca040ef          	jal	800055d8 <plicinithart>
    binit();         // buffer cache
    80000f12:	631010ef          	jal	80002d42 <binit>
    iinit();         // inode table
    80000f16:	3fc020ef          	jal	80003312 <iinit>
    fileinit();      // file table
    80000f1a:	1ca030ef          	jal	800040e4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f1e:	7aa040ef          	jal	800056c8 <virtio_disk_init>
    userinit();      // first user process
    80000f22:	43f000ef          	jal	80001b60 <userinit>
    __sync_synchronize();
    80000f26:	0330000f          	fence	rw,rw
    started = 1;
    80000f2a:	4785                	li	a5,1
    80000f2c:	00009717          	auipc	a4,0x9
    80000f30:	6cf72623          	sw	a5,1740(a4) # 8000a5f8 <started>
    80000f34:	b779                	j	80000ec2 <main+0x3e>

0000000080000f36 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f36:	1141                	addi	sp,sp,-16
    80000f38:	e406                	sd	ra,8(sp)
    80000f3a:	e022                	sd	s0,0(sp)
    80000f3c:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f3e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f42:	00009797          	auipc	a5,0x9
    80000f46:	6be7b783          	ld	a5,1726(a5) # 8000a600 <kernel_pagetable>
    80000f4a:	83b1                	srli	a5,a5,0xc
    80000f4c:	577d                	li	a4,-1
    80000f4e:	177e                	slli	a4,a4,0x3f
    80000f50:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f52:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f56:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f5a:	60a2                	ld	ra,8(sp)
    80000f5c:	6402                	ld	s0,0(sp)
    80000f5e:	0141                	addi	sp,sp,16
    80000f60:	8082                	ret

0000000080000f62 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f62:	7139                	addi	sp,sp,-64
    80000f64:	fc06                	sd	ra,56(sp)
    80000f66:	f822                	sd	s0,48(sp)
    80000f68:	f426                	sd	s1,40(sp)
    80000f6a:	f04a                	sd	s2,32(sp)
    80000f6c:	ec4e                	sd	s3,24(sp)
    80000f6e:	e852                	sd	s4,16(sp)
    80000f70:	e456                	sd	s5,8(sp)
    80000f72:	e05a                	sd	s6,0(sp)
    80000f74:	0080                	addi	s0,sp,64
    80000f76:	84aa                	mv	s1,a0
    80000f78:	89ae                	mv	s3,a1
    80000f7a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f7c:	57fd                	li	a5,-1
    80000f7e:	83e9                	srli	a5,a5,0x1a
    80000f80:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f82:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f84:	04b7e263          	bltu	a5,a1,80000fc8 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f88:	0149d933          	srl	s2,s3,s4
    80000f8c:	1ff97913          	andi	s2,s2,511
    80000f90:	090e                	slli	s2,s2,0x3
    80000f92:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f94:	00093483          	ld	s1,0(s2)
    80000f98:	0014f793          	andi	a5,s1,1
    80000f9c:	cf85                	beqz	a5,80000fd4 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f9e:	80a9                	srli	s1,s1,0xa
    80000fa0:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000fa2:	3a5d                	addiw	s4,s4,-9
    80000fa4:	ff6a12e3          	bne	s4,s6,80000f88 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000fa8:	00c9d513          	srli	a0,s3,0xc
    80000fac:	1ff57513          	andi	a0,a0,511
    80000fb0:	050e                	slli	a0,a0,0x3
    80000fb2:	9526                	add	a0,a0,s1
}
    80000fb4:	70e2                	ld	ra,56(sp)
    80000fb6:	7442                	ld	s0,48(sp)
    80000fb8:	74a2                	ld	s1,40(sp)
    80000fba:	7902                	ld	s2,32(sp)
    80000fbc:	69e2                	ld	s3,24(sp)
    80000fbe:	6a42                	ld	s4,16(sp)
    80000fc0:	6aa2                	ld	s5,8(sp)
    80000fc2:	6b02                	ld	s6,0(sp)
    80000fc4:	6121                	addi	sp,sp,64
    80000fc6:	8082                	ret
    panic("walk");
    80000fc8:	00006517          	auipc	a0,0x6
    80000fcc:	0e850513          	addi	a0,a0,232 # 800070b0 <etext+0xb0>
    80000fd0:	fceff0ef          	jal	8000079e <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fd4:	020a8263          	beqz	s5,80000ff8 <walk+0x96>
    80000fd8:	b53ff0ef          	jal	80000b2a <kalloc>
    80000fdc:	84aa                	mv	s1,a0
    80000fde:	d979                	beqz	a0,80000fb4 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000fe0:	6605                	lui	a2,0x1
    80000fe2:	4581                	li	a1,0
    80000fe4:	cebff0ef          	jal	80000cce <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fe8:	00c4d793          	srli	a5,s1,0xc
    80000fec:	07aa                	slli	a5,a5,0xa
    80000fee:	0017e793          	ori	a5,a5,1
    80000ff2:	00f93023          	sd	a5,0(s2)
    80000ff6:	b775                	j	80000fa2 <walk+0x40>
        return 0;
    80000ff8:	4501                	li	a0,0
    80000ffa:	bf6d                	j	80000fb4 <walk+0x52>

0000000080000ffc <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000ffc:	57fd                	li	a5,-1
    80000ffe:	83e9                	srli	a5,a5,0x1a
    80001000:	00b7f463          	bgeu	a5,a1,80001008 <walkaddr+0xc>
    return 0;
    80001004:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001006:	8082                	ret
{
    80001008:	1141                	addi	sp,sp,-16
    8000100a:	e406                	sd	ra,8(sp)
    8000100c:	e022                	sd	s0,0(sp)
    8000100e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001010:	4601                	li	a2,0
    80001012:	f51ff0ef          	jal	80000f62 <walk>
  if(pte == 0)
    80001016:	c105                	beqz	a0,80001036 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80001018:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000101a:	0117f693          	andi	a3,a5,17
    8000101e:	4745                	li	a4,17
    return 0;
    80001020:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001022:	00e68663          	beq	a3,a4,8000102e <walkaddr+0x32>
}
    80001026:	60a2                	ld	ra,8(sp)
    80001028:	6402                	ld	s0,0(sp)
    8000102a:	0141                	addi	sp,sp,16
    8000102c:	8082                	ret
  pa = PTE2PA(*pte);
    8000102e:	83a9                	srli	a5,a5,0xa
    80001030:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001034:	bfcd                	j	80001026 <walkaddr+0x2a>
    return 0;
    80001036:	4501                	li	a0,0
    80001038:	b7fd                	j	80001026 <walkaddr+0x2a>

000000008000103a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000103a:	715d                	addi	sp,sp,-80
    8000103c:	e486                	sd	ra,72(sp)
    8000103e:	e0a2                	sd	s0,64(sp)
    80001040:	fc26                	sd	s1,56(sp)
    80001042:	f84a                	sd	s2,48(sp)
    80001044:	f44e                	sd	s3,40(sp)
    80001046:	f052                	sd	s4,32(sp)
    80001048:	ec56                	sd	s5,24(sp)
    8000104a:	e85a                	sd	s6,16(sp)
    8000104c:	e45e                	sd	s7,8(sp)
    8000104e:	e062                	sd	s8,0(sp)
    80001050:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001052:	03459793          	slli	a5,a1,0x34
    80001056:	e7b1                	bnez	a5,800010a2 <mappages+0x68>
    80001058:	8aaa                	mv	s5,a0
    8000105a:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000105c:	03461793          	slli	a5,a2,0x34
    80001060:	e7b9                	bnez	a5,800010ae <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    80001062:	ce21                	beqz	a2,800010ba <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001064:	77fd                	lui	a5,0xfffff
    80001066:	963e                	add	a2,a2,a5
    80001068:	00b609b3          	add	s3,a2,a1
  a = va;
    8000106c:	892e                	mv	s2,a1
    8000106e:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001072:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001074:	6c05                	lui	s8,0x1
    80001076:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000107a:	865e                	mv	a2,s7
    8000107c:	85ca                	mv	a1,s2
    8000107e:	8556                	mv	a0,s5
    80001080:	ee3ff0ef          	jal	80000f62 <walk>
    80001084:	c539                	beqz	a0,800010d2 <mappages+0x98>
    if(*pte & PTE_V)
    80001086:	611c                	ld	a5,0(a0)
    80001088:	8b85                	andi	a5,a5,1
    8000108a:	ef95                	bnez	a5,800010c6 <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000108c:	80b1                	srli	s1,s1,0xc
    8000108e:	04aa                	slli	s1,s1,0xa
    80001090:	0164e4b3          	or	s1,s1,s6
    80001094:	0014e493          	ori	s1,s1,1
    80001098:	e104                	sd	s1,0(a0)
    if(a == last)
    8000109a:	05390963          	beq	s2,s3,800010ec <mappages+0xb2>
    a += PGSIZE;
    8000109e:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    800010a0:	bfd9                	j	80001076 <mappages+0x3c>
    panic("mappages: va not aligned");
    800010a2:	00006517          	auipc	a0,0x6
    800010a6:	01650513          	addi	a0,a0,22 # 800070b8 <etext+0xb8>
    800010aa:	ef4ff0ef          	jal	8000079e <panic>
    panic("mappages: size not aligned");
    800010ae:	00006517          	auipc	a0,0x6
    800010b2:	02a50513          	addi	a0,a0,42 # 800070d8 <etext+0xd8>
    800010b6:	ee8ff0ef          	jal	8000079e <panic>
    panic("mappages: size");
    800010ba:	00006517          	auipc	a0,0x6
    800010be:	03e50513          	addi	a0,a0,62 # 800070f8 <etext+0xf8>
    800010c2:	edcff0ef          	jal	8000079e <panic>
      panic("mappages: remap");
    800010c6:	00006517          	auipc	a0,0x6
    800010ca:	04250513          	addi	a0,a0,66 # 80007108 <etext+0x108>
    800010ce:	ed0ff0ef          	jal	8000079e <panic>
      return -1;
    800010d2:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010d4:	60a6                	ld	ra,72(sp)
    800010d6:	6406                	ld	s0,64(sp)
    800010d8:	74e2                	ld	s1,56(sp)
    800010da:	7942                	ld	s2,48(sp)
    800010dc:	79a2                	ld	s3,40(sp)
    800010de:	7a02                	ld	s4,32(sp)
    800010e0:	6ae2                	ld	s5,24(sp)
    800010e2:	6b42                	ld	s6,16(sp)
    800010e4:	6ba2                	ld	s7,8(sp)
    800010e6:	6c02                	ld	s8,0(sp)
    800010e8:	6161                	addi	sp,sp,80
    800010ea:	8082                	ret
  return 0;
    800010ec:	4501                	li	a0,0
    800010ee:	b7dd                	j	800010d4 <mappages+0x9a>

00000000800010f0 <kvmmap>:
{
    800010f0:	1141                	addi	sp,sp,-16
    800010f2:	e406                	sd	ra,8(sp)
    800010f4:	e022                	sd	s0,0(sp)
    800010f6:	0800                	addi	s0,sp,16
    800010f8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010fa:	86b2                	mv	a3,a2
    800010fc:	863e                	mv	a2,a5
    800010fe:	f3dff0ef          	jal	8000103a <mappages>
    80001102:	e509                	bnez	a0,8000110c <kvmmap+0x1c>
}
    80001104:	60a2                	ld	ra,8(sp)
    80001106:	6402                	ld	s0,0(sp)
    80001108:	0141                	addi	sp,sp,16
    8000110a:	8082                	ret
    panic("kvmmap");
    8000110c:	00006517          	auipc	a0,0x6
    80001110:	00c50513          	addi	a0,a0,12 # 80007118 <etext+0x118>
    80001114:	e8aff0ef          	jal	8000079e <panic>

0000000080001118 <kvmmake>:
{
    80001118:	1101                	addi	sp,sp,-32
    8000111a:	ec06                	sd	ra,24(sp)
    8000111c:	e822                	sd	s0,16(sp)
    8000111e:	e426                	sd	s1,8(sp)
    80001120:	e04a                	sd	s2,0(sp)
    80001122:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001124:	a07ff0ef          	jal	80000b2a <kalloc>
    80001128:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000112a:	6605                	lui	a2,0x1
    8000112c:	4581                	li	a1,0
    8000112e:	ba1ff0ef          	jal	80000cce <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001132:	4719                	li	a4,6
    80001134:	6685                	lui	a3,0x1
    80001136:	10000637          	lui	a2,0x10000
    8000113a:	85b2                	mv	a1,a2
    8000113c:	8526                	mv	a0,s1
    8000113e:	fb3ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001142:	4719                	li	a4,6
    80001144:	6685                	lui	a3,0x1
    80001146:	10001637          	lui	a2,0x10001
    8000114a:	85b2                	mv	a1,a2
    8000114c:	8526                	mv	a0,s1
    8000114e:	fa3ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001152:	4719                	li	a4,6
    80001154:	040006b7          	lui	a3,0x4000
    80001158:	0c000637          	lui	a2,0xc000
    8000115c:	85b2                	mv	a1,a2
    8000115e:	8526                	mv	a0,s1
    80001160:	f91ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001164:	00006917          	auipc	s2,0x6
    80001168:	e9c90913          	addi	s2,s2,-356 # 80007000 <etext>
    8000116c:	4729                	li	a4,10
    8000116e:	80006697          	auipc	a3,0x80006
    80001172:	e9268693          	addi	a3,a3,-366 # 7000 <_entry-0x7fff9000>
    80001176:	4605                	li	a2,1
    80001178:	067e                	slli	a2,a2,0x1f
    8000117a:	85b2                	mv	a1,a2
    8000117c:	8526                	mv	a0,s1
    8000117e:	f73ff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001182:	4719                	li	a4,6
    80001184:	46c5                	li	a3,17
    80001186:	06ee                	slli	a3,a3,0x1b
    80001188:	412686b3          	sub	a3,a3,s2
    8000118c:	864a                	mv	a2,s2
    8000118e:	85ca                	mv	a1,s2
    80001190:	8526                	mv	a0,s1
    80001192:	f5fff0ef          	jal	800010f0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001196:	4729                	li	a4,10
    80001198:	6685                	lui	a3,0x1
    8000119a:	00005617          	auipc	a2,0x5
    8000119e:	e6660613          	addi	a2,a2,-410 # 80006000 <_trampoline>
    800011a2:	040005b7          	lui	a1,0x4000
    800011a6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011a8:	05b2                	slli	a1,a1,0xc
    800011aa:	8526                	mv	a0,s1
    800011ac:	f45ff0ef          	jal	800010f0 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011b0:	8526                	mv	a0,s1
    800011b2:	5a8000ef          	jal	8000175a <proc_mapstacks>
}
    800011b6:	8526                	mv	a0,s1
    800011b8:	60e2                	ld	ra,24(sp)
    800011ba:	6442                	ld	s0,16(sp)
    800011bc:	64a2                	ld	s1,8(sp)
    800011be:	6902                	ld	s2,0(sp)
    800011c0:	6105                	addi	sp,sp,32
    800011c2:	8082                	ret

00000000800011c4 <kvminit>:
{
    800011c4:	1141                	addi	sp,sp,-16
    800011c6:	e406                	sd	ra,8(sp)
    800011c8:	e022                	sd	s0,0(sp)
    800011ca:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011cc:	f4dff0ef          	jal	80001118 <kvmmake>
    800011d0:	00009797          	auipc	a5,0x9
    800011d4:	42a7b823          	sd	a0,1072(a5) # 8000a600 <kernel_pagetable>
}
    800011d8:	60a2                	ld	ra,8(sp)
    800011da:	6402                	ld	s0,0(sp)
    800011dc:	0141                	addi	sp,sp,16
    800011de:	8082                	ret

00000000800011e0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011e0:	715d                	addi	sp,sp,-80
    800011e2:	e486                	sd	ra,72(sp)
    800011e4:	e0a2                	sd	s0,64(sp)
    800011e6:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011e8:	03459793          	slli	a5,a1,0x34
    800011ec:	e39d                	bnez	a5,80001212 <uvmunmap+0x32>
    800011ee:	f84a                	sd	s2,48(sp)
    800011f0:	f44e                	sd	s3,40(sp)
    800011f2:	f052                	sd	s4,32(sp)
    800011f4:	ec56                	sd	s5,24(sp)
    800011f6:	e85a                	sd	s6,16(sp)
    800011f8:	e45e                	sd	s7,8(sp)
    800011fa:	8a2a                	mv	s4,a0
    800011fc:	892e                	mv	s2,a1
    800011fe:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001200:	0632                	slli	a2,a2,0xc
    80001202:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001206:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001208:	6b05                	lui	s6,0x1
    8000120a:	0735ff63          	bgeu	a1,s3,80001288 <uvmunmap+0xa8>
    8000120e:	fc26                	sd	s1,56(sp)
    80001210:	a0a9                	j	8000125a <uvmunmap+0x7a>
    80001212:	fc26                	sd	s1,56(sp)
    80001214:	f84a                	sd	s2,48(sp)
    80001216:	f44e                	sd	s3,40(sp)
    80001218:	f052                	sd	s4,32(sp)
    8000121a:	ec56                	sd	s5,24(sp)
    8000121c:	e85a                	sd	s6,16(sp)
    8000121e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001220:	00006517          	auipc	a0,0x6
    80001224:	f0050513          	addi	a0,a0,-256 # 80007120 <etext+0x120>
    80001228:	d76ff0ef          	jal	8000079e <panic>
      panic("uvmunmap: walk");
    8000122c:	00006517          	auipc	a0,0x6
    80001230:	f0c50513          	addi	a0,a0,-244 # 80007138 <etext+0x138>
    80001234:	d6aff0ef          	jal	8000079e <panic>
      panic("uvmunmap: not mapped");
    80001238:	00006517          	auipc	a0,0x6
    8000123c:	f1050513          	addi	a0,a0,-240 # 80007148 <etext+0x148>
    80001240:	d5eff0ef          	jal	8000079e <panic>
      panic("uvmunmap: not a leaf");
    80001244:	00006517          	auipc	a0,0x6
    80001248:	f1c50513          	addi	a0,a0,-228 # 80007160 <etext+0x160>
    8000124c:	d52ff0ef          	jal	8000079e <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001250:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001254:	995a                	add	s2,s2,s6
    80001256:	03397863          	bgeu	s2,s3,80001286 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000125a:	4601                	li	a2,0
    8000125c:	85ca                	mv	a1,s2
    8000125e:	8552                	mv	a0,s4
    80001260:	d03ff0ef          	jal	80000f62 <walk>
    80001264:	84aa                	mv	s1,a0
    80001266:	d179                	beqz	a0,8000122c <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001268:	6108                	ld	a0,0(a0)
    8000126a:	00157793          	andi	a5,a0,1
    8000126e:	d7e9                	beqz	a5,80001238 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001270:	3ff57793          	andi	a5,a0,1023
    80001274:	fd7788e3          	beq	a5,s7,80001244 <uvmunmap+0x64>
    if(do_free){
    80001278:	fc0a8ce3          	beqz	s5,80001250 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    8000127c:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000127e:	0532                	slli	a0,a0,0xc
    80001280:	fc8ff0ef          	jal	80000a48 <kfree>
    80001284:	b7f1                	j	80001250 <uvmunmap+0x70>
    80001286:	74e2                	ld	s1,56(sp)
    80001288:	7942                	ld	s2,48(sp)
    8000128a:	79a2                	ld	s3,40(sp)
    8000128c:	7a02                	ld	s4,32(sp)
    8000128e:	6ae2                	ld	s5,24(sp)
    80001290:	6b42                	ld	s6,16(sp)
    80001292:	6ba2                	ld	s7,8(sp)
  }
}
    80001294:	60a6                	ld	ra,72(sp)
    80001296:	6406                	ld	s0,64(sp)
    80001298:	6161                	addi	sp,sp,80
    8000129a:	8082                	ret

000000008000129c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000129c:	1101                	addi	sp,sp,-32
    8000129e:	ec06                	sd	ra,24(sp)
    800012a0:	e822                	sd	s0,16(sp)
    800012a2:	e426                	sd	s1,8(sp)
    800012a4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800012a6:	885ff0ef          	jal	80000b2a <kalloc>
    800012aa:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800012ac:	c509                	beqz	a0,800012b6 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800012ae:	6605                	lui	a2,0x1
    800012b0:	4581                	li	a1,0
    800012b2:	a1dff0ef          	jal	80000cce <memset>
  return pagetable;
}
    800012b6:	8526                	mv	a0,s1
    800012b8:	60e2                	ld	ra,24(sp)
    800012ba:	6442                	ld	s0,16(sp)
    800012bc:	64a2                	ld	s1,8(sp)
    800012be:	6105                	addi	sp,sp,32
    800012c0:	8082                	ret

00000000800012c2 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800012c2:	7179                	addi	sp,sp,-48
    800012c4:	f406                	sd	ra,40(sp)
    800012c6:	f022                	sd	s0,32(sp)
    800012c8:	ec26                	sd	s1,24(sp)
    800012ca:	e84a                	sd	s2,16(sp)
    800012cc:	e44e                	sd	s3,8(sp)
    800012ce:	e052                	sd	s4,0(sp)
    800012d0:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012d2:	6785                	lui	a5,0x1
    800012d4:	04f67063          	bgeu	a2,a5,80001314 <uvmfirst+0x52>
    800012d8:	8a2a                	mv	s4,a0
    800012da:	89ae                	mv	s3,a1
    800012dc:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012de:	84dff0ef          	jal	80000b2a <kalloc>
    800012e2:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012e4:	6605                	lui	a2,0x1
    800012e6:	4581                	li	a1,0
    800012e8:	9e7ff0ef          	jal	80000cce <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012ec:	4779                	li	a4,30
    800012ee:	86ca                	mv	a3,s2
    800012f0:	6605                	lui	a2,0x1
    800012f2:	4581                	li	a1,0
    800012f4:	8552                	mv	a0,s4
    800012f6:	d45ff0ef          	jal	8000103a <mappages>
  memmove(mem, src, sz);
    800012fa:	8626                	mv	a2,s1
    800012fc:	85ce                	mv	a1,s3
    800012fe:	854a                	mv	a0,s2
    80001300:	a33ff0ef          	jal	80000d32 <memmove>
}
    80001304:	70a2                	ld	ra,40(sp)
    80001306:	7402                	ld	s0,32(sp)
    80001308:	64e2                	ld	s1,24(sp)
    8000130a:	6942                	ld	s2,16(sp)
    8000130c:	69a2                	ld	s3,8(sp)
    8000130e:	6a02                	ld	s4,0(sp)
    80001310:	6145                	addi	sp,sp,48
    80001312:	8082                	ret
    panic("uvmfirst: more than a page");
    80001314:	00006517          	auipc	a0,0x6
    80001318:	e6450513          	addi	a0,a0,-412 # 80007178 <etext+0x178>
    8000131c:	c82ff0ef          	jal	8000079e <panic>

0000000080001320 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001320:	1101                	addi	sp,sp,-32
    80001322:	ec06                	sd	ra,24(sp)
    80001324:	e822                	sd	s0,16(sp)
    80001326:	e426                	sd	s1,8(sp)
    80001328:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000132a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000132c:	00b67d63          	bgeu	a2,a1,80001346 <uvmdealloc+0x26>
    80001330:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001332:	6785                	lui	a5,0x1
    80001334:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001336:	00f60733          	add	a4,a2,a5
    8000133a:	76fd                	lui	a3,0xfffff
    8000133c:	8f75                	and	a4,a4,a3
    8000133e:	97ae                	add	a5,a5,a1
    80001340:	8ff5                	and	a5,a5,a3
    80001342:	00f76863          	bltu	a4,a5,80001352 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001346:	8526                	mv	a0,s1
    80001348:	60e2                	ld	ra,24(sp)
    8000134a:	6442                	ld	s0,16(sp)
    8000134c:	64a2                	ld	s1,8(sp)
    8000134e:	6105                	addi	sp,sp,32
    80001350:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001352:	8f99                	sub	a5,a5,a4
    80001354:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001356:	4685                	li	a3,1
    80001358:	0007861b          	sext.w	a2,a5
    8000135c:	85ba                	mv	a1,a4
    8000135e:	e83ff0ef          	jal	800011e0 <uvmunmap>
    80001362:	b7d5                	j	80001346 <uvmdealloc+0x26>

0000000080001364 <uvmalloc>:
  if(newsz < oldsz)
    80001364:	0ab66363          	bltu	a2,a1,8000140a <uvmalloc+0xa6>
{
    80001368:	715d                	addi	sp,sp,-80
    8000136a:	e486                	sd	ra,72(sp)
    8000136c:	e0a2                	sd	s0,64(sp)
    8000136e:	f052                	sd	s4,32(sp)
    80001370:	ec56                	sd	s5,24(sp)
    80001372:	e85a                	sd	s6,16(sp)
    80001374:	0880                	addi	s0,sp,80
    80001376:	8b2a                	mv	s6,a0
    80001378:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    8000137a:	6785                	lui	a5,0x1
    8000137c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000137e:	95be                	add	a1,a1,a5
    80001380:	77fd                	lui	a5,0xfffff
    80001382:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001386:	08ca7463          	bgeu	s4,a2,8000140e <uvmalloc+0xaa>
    8000138a:	fc26                	sd	s1,56(sp)
    8000138c:	f84a                	sd	s2,48(sp)
    8000138e:	f44e                	sd	s3,40(sp)
    80001390:	e45e                	sd	s7,8(sp)
    80001392:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    80001394:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001396:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    8000139a:	f90ff0ef          	jal	80000b2a <kalloc>
    8000139e:	84aa                	mv	s1,a0
    if(mem == 0){
    800013a0:	c515                	beqz	a0,800013cc <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800013a2:	864e                	mv	a2,s3
    800013a4:	4581                	li	a1,0
    800013a6:	929ff0ef          	jal	80000cce <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800013aa:	875e                	mv	a4,s7
    800013ac:	86a6                	mv	a3,s1
    800013ae:	864e                	mv	a2,s3
    800013b0:	85ca                	mv	a1,s2
    800013b2:	855a                	mv	a0,s6
    800013b4:	c87ff0ef          	jal	8000103a <mappages>
    800013b8:	e91d                	bnez	a0,800013ee <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800013ba:	994e                	add	s2,s2,s3
    800013bc:	fd596fe3          	bltu	s2,s5,8000139a <uvmalloc+0x36>
  return newsz;
    800013c0:	8556                	mv	a0,s5
    800013c2:	74e2                	ld	s1,56(sp)
    800013c4:	7942                	ld	s2,48(sp)
    800013c6:	79a2                	ld	s3,40(sp)
    800013c8:	6ba2                	ld	s7,8(sp)
    800013ca:	a819                	j	800013e0 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    800013cc:	8652                	mv	a2,s4
    800013ce:	85ca                	mv	a1,s2
    800013d0:	855a                	mv	a0,s6
    800013d2:	f4fff0ef          	jal	80001320 <uvmdealloc>
      return 0;
    800013d6:	4501                	li	a0,0
    800013d8:	74e2                	ld	s1,56(sp)
    800013da:	7942                	ld	s2,48(sp)
    800013dc:	79a2                	ld	s3,40(sp)
    800013de:	6ba2                	ld	s7,8(sp)
}
    800013e0:	60a6                	ld	ra,72(sp)
    800013e2:	6406                	ld	s0,64(sp)
    800013e4:	7a02                	ld	s4,32(sp)
    800013e6:	6ae2                	ld	s5,24(sp)
    800013e8:	6b42                	ld	s6,16(sp)
    800013ea:	6161                	addi	sp,sp,80
    800013ec:	8082                	ret
      kfree(mem);
    800013ee:	8526                	mv	a0,s1
    800013f0:	e58ff0ef          	jal	80000a48 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013f4:	8652                	mv	a2,s4
    800013f6:	85ca                	mv	a1,s2
    800013f8:	855a                	mv	a0,s6
    800013fa:	f27ff0ef          	jal	80001320 <uvmdealloc>
      return 0;
    800013fe:	4501                	li	a0,0
    80001400:	74e2                	ld	s1,56(sp)
    80001402:	7942                	ld	s2,48(sp)
    80001404:	79a2                	ld	s3,40(sp)
    80001406:	6ba2                	ld	s7,8(sp)
    80001408:	bfe1                	j	800013e0 <uvmalloc+0x7c>
    return oldsz;
    8000140a:	852e                	mv	a0,a1
}
    8000140c:	8082                	ret
  return newsz;
    8000140e:	8532                	mv	a0,a2
    80001410:	bfc1                	j	800013e0 <uvmalloc+0x7c>

0000000080001412 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001412:	7179                	addi	sp,sp,-48
    80001414:	f406                	sd	ra,40(sp)
    80001416:	f022                	sd	s0,32(sp)
    80001418:	ec26                	sd	s1,24(sp)
    8000141a:	e84a                	sd	s2,16(sp)
    8000141c:	e44e                	sd	s3,8(sp)
    8000141e:	e052                	sd	s4,0(sp)
    80001420:	1800                	addi	s0,sp,48
    80001422:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001424:	84aa                	mv	s1,a0
    80001426:	6905                	lui	s2,0x1
    80001428:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000142a:	4985                	li	s3,1
    8000142c:	a819                	j	80001442 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000142e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001430:	00c79513          	slli	a0,a5,0xc
    80001434:	fdfff0ef          	jal	80001412 <freewalk>
      pagetable[i] = 0;
    80001438:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000143c:	04a1                	addi	s1,s1,8
    8000143e:	01248f63          	beq	s1,s2,8000145c <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001442:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001444:	00f7f713          	andi	a4,a5,15
    80001448:	ff3703e3          	beq	a4,s3,8000142e <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000144c:	8b85                	andi	a5,a5,1
    8000144e:	d7fd                	beqz	a5,8000143c <freewalk+0x2a>
      panic("freewalk: leaf");
    80001450:	00006517          	auipc	a0,0x6
    80001454:	d4850513          	addi	a0,a0,-696 # 80007198 <etext+0x198>
    80001458:	b46ff0ef          	jal	8000079e <panic>
    }
  }
  kfree((void*)pagetable);
    8000145c:	8552                	mv	a0,s4
    8000145e:	deaff0ef          	jal	80000a48 <kfree>
}
    80001462:	70a2                	ld	ra,40(sp)
    80001464:	7402                	ld	s0,32(sp)
    80001466:	64e2                	ld	s1,24(sp)
    80001468:	6942                	ld	s2,16(sp)
    8000146a:	69a2                	ld	s3,8(sp)
    8000146c:	6a02                	ld	s4,0(sp)
    8000146e:	6145                	addi	sp,sp,48
    80001470:	8082                	ret

0000000080001472 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001472:	1101                	addi	sp,sp,-32
    80001474:	ec06                	sd	ra,24(sp)
    80001476:	e822                	sd	s0,16(sp)
    80001478:	e426                	sd	s1,8(sp)
    8000147a:	1000                	addi	s0,sp,32
    8000147c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000147e:	e989                	bnez	a1,80001490 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001480:	8526                	mv	a0,s1
    80001482:	f91ff0ef          	jal	80001412 <freewalk>
}
    80001486:	60e2                	ld	ra,24(sp)
    80001488:	6442                	ld	s0,16(sp)
    8000148a:	64a2                	ld	s1,8(sp)
    8000148c:	6105                	addi	sp,sp,32
    8000148e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001490:	6785                	lui	a5,0x1
    80001492:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001494:	95be                	add	a1,a1,a5
    80001496:	4685                	li	a3,1
    80001498:	00c5d613          	srli	a2,a1,0xc
    8000149c:	4581                	li	a1,0
    8000149e:	d43ff0ef          	jal	800011e0 <uvmunmap>
    800014a2:	bff9                	j	80001480 <uvmfree+0xe>

00000000800014a4 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800014a4:	ca4d                	beqz	a2,80001556 <uvmcopy+0xb2>
{
    800014a6:	715d                	addi	sp,sp,-80
    800014a8:	e486                	sd	ra,72(sp)
    800014aa:	e0a2                	sd	s0,64(sp)
    800014ac:	fc26                	sd	s1,56(sp)
    800014ae:	f84a                	sd	s2,48(sp)
    800014b0:	f44e                	sd	s3,40(sp)
    800014b2:	f052                	sd	s4,32(sp)
    800014b4:	ec56                	sd	s5,24(sp)
    800014b6:	e85a                	sd	s6,16(sp)
    800014b8:	e45e                	sd	s7,8(sp)
    800014ba:	e062                	sd	s8,0(sp)
    800014bc:	0880                	addi	s0,sp,80
    800014be:	8baa                	mv	s7,a0
    800014c0:	8b2e                	mv	s6,a1
    800014c2:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    800014c4:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014c6:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    800014c8:	4601                	li	a2,0
    800014ca:	85ce                	mv	a1,s3
    800014cc:	855e                	mv	a0,s7
    800014ce:	a95ff0ef          	jal	80000f62 <walk>
    800014d2:	cd1d                	beqz	a0,80001510 <uvmcopy+0x6c>
    if((*pte & PTE_V) == 0)
    800014d4:	6118                	ld	a4,0(a0)
    800014d6:	00177793          	andi	a5,a4,1
    800014da:	c3a9                	beqz	a5,8000151c <uvmcopy+0x78>
    pa = PTE2PA(*pte);
    800014dc:	00a75593          	srli	a1,a4,0xa
    800014e0:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014e4:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014e8:	e42ff0ef          	jal	80000b2a <kalloc>
    800014ec:	892a                	mv	s2,a0
    800014ee:	c121                	beqz	a0,8000152e <uvmcopy+0x8a>
    memmove(mem, (char*)pa, PGSIZE);
    800014f0:	8652                	mv	a2,s4
    800014f2:	85e2                	mv	a1,s8
    800014f4:	83fff0ef          	jal	80000d32 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014f8:	8726                	mv	a4,s1
    800014fa:	86ca                	mv	a3,s2
    800014fc:	8652                	mv	a2,s4
    800014fe:	85ce                	mv	a1,s3
    80001500:	855a                	mv	a0,s6
    80001502:	b39ff0ef          	jal	8000103a <mappages>
    80001506:	e10d                	bnez	a0,80001528 <uvmcopy+0x84>
  for(i = 0; i < sz; i += PGSIZE){
    80001508:	99d2                	add	s3,s3,s4
    8000150a:	fb59efe3          	bltu	s3,s5,800014c8 <uvmcopy+0x24>
    8000150e:	a805                	j	8000153e <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    80001510:	00006517          	auipc	a0,0x6
    80001514:	c9850513          	addi	a0,a0,-872 # 800071a8 <etext+0x1a8>
    80001518:	a86ff0ef          	jal	8000079e <panic>
      panic("uvmcopy: page not present");
    8000151c:	00006517          	auipc	a0,0x6
    80001520:	cac50513          	addi	a0,a0,-852 # 800071c8 <etext+0x1c8>
    80001524:	a7aff0ef          	jal	8000079e <panic>
      kfree(mem);
    80001528:	854a                	mv	a0,s2
    8000152a:	d1eff0ef          	jal	80000a48 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000152e:	4685                	li	a3,1
    80001530:	00c9d613          	srli	a2,s3,0xc
    80001534:	4581                	li	a1,0
    80001536:	855a                	mv	a0,s6
    80001538:	ca9ff0ef          	jal	800011e0 <uvmunmap>
  return -1;
    8000153c:	557d                	li	a0,-1
}
    8000153e:	60a6                	ld	ra,72(sp)
    80001540:	6406                	ld	s0,64(sp)
    80001542:	74e2                	ld	s1,56(sp)
    80001544:	7942                	ld	s2,48(sp)
    80001546:	79a2                	ld	s3,40(sp)
    80001548:	7a02                	ld	s4,32(sp)
    8000154a:	6ae2                	ld	s5,24(sp)
    8000154c:	6b42                	ld	s6,16(sp)
    8000154e:	6ba2                	ld	s7,8(sp)
    80001550:	6c02                	ld	s8,0(sp)
    80001552:	6161                	addi	sp,sp,80
    80001554:	8082                	ret
  return 0;
    80001556:	4501                	li	a0,0
}
    80001558:	8082                	ret

000000008000155a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000155a:	1141                	addi	sp,sp,-16
    8000155c:	e406                	sd	ra,8(sp)
    8000155e:	e022                	sd	s0,0(sp)
    80001560:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001562:	4601                	li	a2,0
    80001564:	9ffff0ef          	jal	80000f62 <walk>
  if(pte == 0)
    80001568:	c901                	beqz	a0,80001578 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000156a:	611c                	ld	a5,0(a0)
    8000156c:	9bbd                	andi	a5,a5,-17
    8000156e:	e11c                	sd	a5,0(a0)
}
    80001570:	60a2                	ld	ra,8(sp)
    80001572:	6402                	ld	s0,0(sp)
    80001574:	0141                	addi	sp,sp,16
    80001576:	8082                	ret
    panic("uvmclear");
    80001578:	00006517          	auipc	a0,0x6
    8000157c:	c7050513          	addi	a0,a0,-912 # 800071e8 <etext+0x1e8>
    80001580:	a1eff0ef          	jal	8000079e <panic>

0000000080001584 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001584:	c2d9                	beqz	a3,8000160a <copyout+0x86>
{
    80001586:	711d                	addi	sp,sp,-96
    80001588:	ec86                	sd	ra,88(sp)
    8000158a:	e8a2                	sd	s0,80(sp)
    8000158c:	e4a6                	sd	s1,72(sp)
    8000158e:	e0ca                	sd	s2,64(sp)
    80001590:	fc4e                	sd	s3,56(sp)
    80001592:	f852                	sd	s4,48(sp)
    80001594:	f456                	sd	s5,40(sp)
    80001596:	f05a                	sd	s6,32(sp)
    80001598:	ec5e                	sd	s7,24(sp)
    8000159a:	e862                	sd	s8,16(sp)
    8000159c:	e466                	sd	s9,8(sp)
    8000159e:	e06a                	sd	s10,0(sp)
    800015a0:	1080                	addi	s0,sp,96
    800015a2:	8c2a                	mv	s8,a0
    800015a4:	892e                	mv	s2,a1
    800015a6:	8ab2                	mv	s5,a2
    800015a8:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    800015aa:	7cfd                	lui	s9,0xfffff
    if(va0 >= MAXVA)
    800015ac:	5bfd                	li	s7,-1
    800015ae:	01abdb93          	srli	s7,s7,0x1a
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015b2:	4d55                	li	s10,21
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    800015b4:	6b05                	lui	s6,0x1
    800015b6:	a015                	j	800015da <copyout+0x56>
    pa0 = PTE2PA(*pte);
    800015b8:	83a9                	srli	a5,a5,0xa
    800015ba:	07b2                	slli	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015bc:	41390533          	sub	a0,s2,s3
    800015c0:	0004861b          	sext.w	a2,s1
    800015c4:	85d6                	mv	a1,s5
    800015c6:	953e                	add	a0,a0,a5
    800015c8:	f6aff0ef          	jal	80000d32 <memmove>

    len -= n;
    800015cc:	409a0a33          	sub	s4,s4,s1
    src += n;
    800015d0:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    800015d2:	01698933          	add	s2,s3,s6
  while(len > 0){
    800015d6:	020a0863          	beqz	s4,80001606 <copyout+0x82>
    va0 = PGROUNDDOWN(dstva);
    800015da:	019979b3          	and	s3,s2,s9
    if(va0 >= MAXVA)
    800015de:	033be863          	bltu	s7,s3,8000160e <copyout+0x8a>
    pte = walk(pagetable, va0, 0);
    800015e2:	4601                	li	a2,0
    800015e4:	85ce                	mv	a1,s3
    800015e6:	8562                	mv	a0,s8
    800015e8:	97bff0ef          	jal	80000f62 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015ec:	c121                	beqz	a0,8000162c <copyout+0xa8>
    800015ee:	611c                	ld	a5,0(a0)
    800015f0:	0157f713          	andi	a4,a5,21
    800015f4:	03a71e63          	bne	a4,s10,80001630 <copyout+0xac>
    n = PGSIZE - (dstva - va0);
    800015f8:	412984b3          	sub	s1,s3,s2
    800015fc:	94da                	add	s1,s1,s6
    if(n > len)
    800015fe:	fa9a7de3          	bgeu	s4,s1,800015b8 <copyout+0x34>
    80001602:	84d2                	mv	s1,s4
    80001604:	bf55                	j	800015b8 <copyout+0x34>
  }
  return 0;
    80001606:	4501                	li	a0,0
    80001608:	a021                	j	80001610 <copyout+0x8c>
    8000160a:	4501                	li	a0,0
}
    8000160c:	8082                	ret
      return -1;
    8000160e:	557d                	li	a0,-1
}
    80001610:	60e6                	ld	ra,88(sp)
    80001612:	6446                	ld	s0,80(sp)
    80001614:	64a6                	ld	s1,72(sp)
    80001616:	6906                	ld	s2,64(sp)
    80001618:	79e2                	ld	s3,56(sp)
    8000161a:	7a42                	ld	s4,48(sp)
    8000161c:	7aa2                	ld	s5,40(sp)
    8000161e:	7b02                	ld	s6,32(sp)
    80001620:	6be2                	ld	s7,24(sp)
    80001622:	6c42                	ld	s8,16(sp)
    80001624:	6ca2                	ld	s9,8(sp)
    80001626:	6d02                	ld	s10,0(sp)
    80001628:	6125                	addi	sp,sp,96
    8000162a:	8082                	ret
      return -1;
    8000162c:	557d                	li	a0,-1
    8000162e:	b7cd                	j	80001610 <copyout+0x8c>
    80001630:	557d                	li	a0,-1
    80001632:	bff9                	j	80001610 <copyout+0x8c>

0000000080001634 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001634:	c6a5                	beqz	a3,8000169c <copyin+0x68>
{
    80001636:	715d                	addi	sp,sp,-80
    80001638:	e486                	sd	ra,72(sp)
    8000163a:	e0a2                	sd	s0,64(sp)
    8000163c:	fc26                	sd	s1,56(sp)
    8000163e:	f84a                	sd	s2,48(sp)
    80001640:	f44e                	sd	s3,40(sp)
    80001642:	f052                	sd	s4,32(sp)
    80001644:	ec56                	sd	s5,24(sp)
    80001646:	e85a                	sd	s6,16(sp)
    80001648:	e45e                	sd	s7,8(sp)
    8000164a:	e062                	sd	s8,0(sp)
    8000164c:	0880                	addi	s0,sp,80
    8000164e:	8b2a                	mv	s6,a0
    80001650:	8a2e                	mv	s4,a1
    80001652:	8c32                	mv	s8,a2
    80001654:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001656:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001658:	6a85                	lui	s5,0x1
    8000165a:	a00d                	j	8000167c <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000165c:	018505b3          	add	a1,a0,s8
    80001660:	0004861b          	sext.w	a2,s1
    80001664:	412585b3          	sub	a1,a1,s2
    80001668:	8552                	mv	a0,s4
    8000166a:	ec8ff0ef          	jal	80000d32 <memmove>

    len -= n;
    8000166e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001672:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001674:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001678:	02098063          	beqz	s3,80001698 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    8000167c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001680:	85ca                	mv	a1,s2
    80001682:	855a                	mv	a0,s6
    80001684:	979ff0ef          	jal	80000ffc <walkaddr>
    if(pa0 == 0)
    80001688:	cd01                	beqz	a0,800016a0 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000168a:	418904b3          	sub	s1,s2,s8
    8000168e:	94d6                	add	s1,s1,s5
    if(n > len)
    80001690:	fc99f6e3          	bgeu	s3,s1,8000165c <copyin+0x28>
    80001694:	84ce                	mv	s1,s3
    80001696:	b7d9                	j	8000165c <copyin+0x28>
  }
  return 0;
    80001698:	4501                	li	a0,0
    8000169a:	a021                	j	800016a2 <copyin+0x6e>
    8000169c:	4501                	li	a0,0
}
    8000169e:	8082                	ret
      return -1;
    800016a0:	557d                	li	a0,-1
}
    800016a2:	60a6                	ld	ra,72(sp)
    800016a4:	6406                	ld	s0,64(sp)
    800016a6:	74e2                	ld	s1,56(sp)
    800016a8:	7942                	ld	s2,48(sp)
    800016aa:	79a2                	ld	s3,40(sp)
    800016ac:	7a02                	ld	s4,32(sp)
    800016ae:	6ae2                	ld	s5,24(sp)
    800016b0:	6b42                	ld	s6,16(sp)
    800016b2:	6ba2                	ld	s7,8(sp)
    800016b4:	6c02                	ld	s8,0(sp)
    800016b6:	6161                	addi	sp,sp,80
    800016b8:	8082                	ret

00000000800016ba <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    800016ba:	715d                	addi	sp,sp,-80
    800016bc:	e486                	sd	ra,72(sp)
    800016be:	e0a2                	sd	s0,64(sp)
    800016c0:	fc26                	sd	s1,56(sp)
    800016c2:	f84a                	sd	s2,48(sp)
    800016c4:	f44e                	sd	s3,40(sp)
    800016c6:	f052                	sd	s4,32(sp)
    800016c8:	ec56                	sd	s5,24(sp)
    800016ca:	e85a                	sd	s6,16(sp)
    800016cc:	e45e                	sd	s7,8(sp)
    800016ce:	0880                	addi	s0,sp,80
    800016d0:	8aaa                	mv	s5,a0
    800016d2:	89ae                	mv	s3,a1
    800016d4:	8bb2                	mv	s7,a2
    800016d6:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    800016d8:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016da:	6a05                	lui	s4,0x1
    800016dc:	a02d                	j	80001706 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016de:	00078023          	sb	zero,0(a5)
    800016e2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016e4:	0017c793          	xori	a5,a5,1
    800016e8:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016ec:	60a6                	ld	ra,72(sp)
    800016ee:	6406                	ld	s0,64(sp)
    800016f0:	74e2                	ld	s1,56(sp)
    800016f2:	7942                	ld	s2,48(sp)
    800016f4:	79a2                	ld	s3,40(sp)
    800016f6:	7a02                	ld	s4,32(sp)
    800016f8:	6ae2                	ld	s5,24(sp)
    800016fa:	6b42                	ld	s6,16(sp)
    800016fc:	6ba2                	ld	s7,8(sp)
    800016fe:	6161                	addi	sp,sp,80
    80001700:	8082                	ret
    srcva = va0 + PGSIZE;
    80001702:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001706:	c4b1                	beqz	s1,80001752 <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    80001708:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    8000170c:	85ca                	mv	a1,s2
    8000170e:	8556                	mv	a0,s5
    80001710:	8edff0ef          	jal	80000ffc <walkaddr>
    if(pa0 == 0)
    80001714:	c129                	beqz	a0,80001756 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    80001716:	41790633          	sub	a2,s2,s7
    8000171a:	9652                	add	a2,a2,s4
    if(n > max)
    8000171c:	00c4f363          	bgeu	s1,a2,80001722 <copyinstr+0x68>
    80001720:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001722:	412b8bb3          	sub	s7,s7,s2
    80001726:	9baa                	add	s7,s7,a0
    while(n > 0){
    80001728:	de69                	beqz	a2,80001702 <copyinstr+0x48>
    8000172a:	87ce                	mv	a5,s3
      if(*p == '\0'){
    8000172c:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80001730:	964e                	add	a2,a2,s3
    80001732:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001734:	00f68733          	add	a4,a3,a5
    80001738:	00074703          	lbu	a4,0(a4)
    8000173c:	d34d                	beqz	a4,800016de <copyinstr+0x24>
        *dst = *p;
    8000173e:	00e78023          	sb	a4,0(a5)
      dst++;
    80001742:	0785                	addi	a5,a5,1
    while(n > 0){
    80001744:	fec797e3          	bne	a5,a2,80001732 <copyinstr+0x78>
    80001748:	14fd                	addi	s1,s1,-1
    8000174a:	94ce                	add	s1,s1,s3
      --max;
    8000174c:	8c8d                	sub	s1,s1,a1
    8000174e:	89be                	mv	s3,a5
    80001750:	bf4d                	j	80001702 <copyinstr+0x48>
    80001752:	4781                	li	a5,0
    80001754:	bf41                	j	800016e4 <copyinstr+0x2a>
      return -1;
    80001756:	557d                	li	a0,-1
    80001758:	bf51                	j	800016ec <copyinstr+0x32>

000000008000175a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000175a:	715d                	addi	sp,sp,-80
    8000175c:	e486                	sd	ra,72(sp)
    8000175e:	e0a2                	sd	s0,64(sp)
    80001760:	fc26                	sd	s1,56(sp)
    80001762:	f84a                	sd	s2,48(sp)
    80001764:	f44e                	sd	s3,40(sp)
    80001766:	f052                	sd	s4,32(sp)
    80001768:	ec56                	sd	s5,24(sp)
    8000176a:	e85a                	sd	s6,16(sp)
    8000176c:	e45e                	sd	s7,8(sp)
    8000176e:	e062                	sd	s8,0(sp)
    80001770:	0880                	addi	s0,sp,80
    80001772:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001774:	00011497          	auipc	s1,0x11
    80001778:	40c48493          	addi	s1,s1,1036 # 80012b80 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000177c:	8c26                	mv	s8,s1
    8000177e:	1a1f67b7          	lui	a5,0x1a1f6
    80001782:	8d178793          	addi	a5,a5,-1839 # 1a1f58d1 <_entry-0x65e0a72f>
    80001786:	7d634937          	lui	s2,0x7d634
    8000178a:	3eb90913          	addi	s2,s2,1003 # 7d6343eb <_entry-0x29cbc15>
    8000178e:	1902                	slli	s2,s2,0x20
    80001790:	993e                	add	s2,s2,a5
    80001792:	040009b7          	lui	s3,0x4000
    80001796:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001798:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000179a:	4b99                	li	s7,6
    8000179c:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    8000179e:	00017a97          	auipc	s5,0x17
    800017a2:	5e2a8a93          	addi	s5,s5,1506 # 80018d80 <tickslock>
    char *pa = kalloc();
    800017a6:	b84ff0ef          	jal	80000b2a <kalloc>
    800017aa:	862a                	mv	a2,a0
    if(pa == 0)
    800017ac:	c121                	beqz	a0,800017ec <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    800017ae:	418485b3          	sub	a1,s1,s8
    800017b2:	858d                	srai	a1,a1,0x3
    800017b4:	032585b3          	mul	a1,a1,s2
    800017b8:	2585                	addiw	a1,a1,1
    800017ba:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017be:	875e                	mv	a4,s7
    800017c0:	86da                	mv	a3,s6
    800017c2:	40b985b3          	sub	a1,s3,a1
    800017c6:	8552                	mv	a0,s4
    800017c8:	929ff0ef          	jal	800010f0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017cc:	18848493          	addi	s1,s1,392
    800017d0:	fd549be3          	bne	s1,s5,800017a6 <proc_mapstacks+0x4c>
  }
}
    800017d4:	60a6                	ld	ra,72(sp)
    800017d6:	6406                	ld	s0,64(sp)
    800017d8:	74e2                	ld	s1,56(sp)
    800017da:	7942                	ld	s2,48(sp)
    800017dc:	79a2                	ld	s3,40(sp)
    800017de:	7a02                	ld	s4,32(sp)
    800017e0:	6ae2                	ld	s5,24(sp)
    800017e2:	6b42                	ld	s6,16(sp)
    800017e4:	6ba2                	ld	s7,8(sp)
    800017e6:	6c02                	ld	s8,0(sp)
    800017e8:	6161                	addi	sp,sp,80
    800017ea:	8082                	ret
      panic("kalloc");
    800017ec:	00006517          	auipc	a0,0x6
    800017f0:	a0c50513          	addi	a0,a0,-1524 # 800071f8 <etext+0x1f8>
    800017f4:	fabfe0ef          	jal	8000079e <panic>

00000000800017f8 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017f8:	7139                	addi	sp,sp,-64
    800017fa:	fc06                	sd	ra,56(sp)
    800017fc:	f822                	sd	s0,48(sp)
    800017fe:	f426                	sd	s1,40(sp)
    80001800:	f04a                	sd	s2,32(sp)
    80001802:	ec4e                	sd	s3,24(sp)
    80001804:	e852                	sd	s4,16(sp)
    80001806:	e456                	sd	s5,8(sp)
    80001808:	e05a                	sd	s6,0(sp)
    8000180a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000180c:	00006597          	auipc	a1,0x6
    80001810:	9f458593          	addi	a1,a1,-1548 # 80007200 <etext+0x200>
    80001814:	00011517          	auipc	a0,0x11
    80001818:	f3c50513          	addi	a0,a0,-196 # 80012750 <pid_lock>
    8000181c:	b5eff0ef          	jal	80000b7a <initlock>
  initlock(&wait_lock, "wait_lock");
    80001820:	00006597          	auipc	a1,0x6
    80001824:	9e858593          	addi	a1,a1,-1560 # 80007208 <etext+0x208>
    80001828:	00011517          	auipc	a0,0x11
    8000182c:	f4050513          	addi	a0,a0,-192 # 80012768 <wait_lock>
    80001830:	b4aff0ef          	jal	80000b7a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001834:	00011497          	auipc	s1,0x11
    80001838:	34c48493          	addi	s1,s1,844 # 80012b80 <proc>
      initlock(&p->lock, "proc");
    8000183c:	00006b17          	auipc	s6,0x6
    80001840:	9dcb0b13          	addi	s6,s6,-1572 # 80007218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001844:	8aa6                	mv	s5,s1
    80001846:	1a1f67b7          	lui	a5,0x1a1f6
    8000184a:	8d178793          	addi	a5,a5,-1839 # 1a1f58d1 <_entry-0x65e0a72f>
    8000184e:	7d634937          	lui	s2,0x7d634
    80001852:	3eb90913          	addi	s2,s2,1003 # 7d6343eb <_entry-0x29cbc15>
    80001856:	1902                	slli	s2,s2,0x20
    80001858:	993e                	add	s2,s2,a5
    8000185a:	040009b7          	lui	s3,0x4000
    8000185e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001860:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001862:	00017a17          	auipc	s4,0x17
    80001866:	51ea0a13          	addi	s4,s4,1310 # 80018d80 <tickslock>
      initlock(&p->lock, "proc");
    8000186a:	85da                	mv	a1,s6
    8000186c:	8526                	mv	a0,s1
    8000186e:	b0cff0ef          	jal	80000b7a <initlock>
      p->state = UNUSED;
    80001872:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001876:	415487b3          	sub	a5,s1,s5
    8000187a:	878d                	srai	a5,a5,0x3
    8000187c:	032787b3          	mul	a5,a5,s2
    80001880:	2785                	addiw	a5,a5,1
    80001882:	00d7979b          	slliw	a5,a5,0xd
    80001886:	40f987b3          	sub	a5,s3,a5
    8000188a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000188c:	18848493          	addi	s1,s1,392
    80001890:	fd449de3          	bne	s1,s4,8000186a <procinit+0x72>
  }
}
    80001894:	70e2                	ld	ra,56(sp)
    80001896:	7442                	ld	s0,48(sp)
    80001898:	74a2                	ld	s1,40(sp)
    8000189a:	7902                	ld	s2,32(sp)
    8000189c:	69e2                	ld	s3,24(sp)
    8000189e:	6a42                	ld	s4,16(sp)
    800018a0:	6aa2                	ld	s5,8(sp)
    800018a2:	6b02                	ld	s6,0(sp)
    800018a4:	6121                	addi	sp,sp,64
    800018a6:	8082                	ret

00000000800018a8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018a8:	1141                	addi	sp,sp,-16
    800018aa:	e406                	sd	ra,8(sp)
    800018ac:	e022                	sd	s0,0(sp)
    800018ae:	0800                	addi	s0,sp,16
// this core's hartid (core number), the index into cpus[].
static inline uint64
r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    800018b0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018b2:	2501                	sext.w	a0,a0
    800018b4:	60a2                	ld	ra,8(sp)
    800018b6:	6402                	ld	s0,0(sp)
    800018b8:	0141                	addi	sp,sp,16
    800018ba:	8082                	ret

00000000800018bc <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018bc:	1141                	addi	sp,sp,-16
    800018be:	e406                	sd	ra,8(sp)
    800018c0:	e022                	sd	s0,0(sp)
    800018c2:	0800                	addi	s0,sp,16
    800018c4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018c6:	2781                	sext.w	a5,a5
    800018c8:	079e                	slli	a5,a5,0x7
  return c;
}
    800018ca:	00011517          	auipc	a0,0x11
    800018ce:	eb650513          	addi	a0,a0,-330 # 80012780 <cpus>
    800018d2:	953e                	add	a0,a0,a5
    800018d4:	60a2                	ld	ra,8(sp)
    800018d6:	6402                	ld	s0,0(sp)
    800018d8:	0141                	addi	sp,sp,16
    800018da:	8082                	ret

00000000800018dc <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800018dc:	1101                	addi	sp,sp,-32
    800018de:	ec06                	sd	ra,24(sp)
    800018e0:	e822                	sd	s0,16(sp)
    800018e2:	e426                	sd	s1,8(sp)
    800018e4:	1000                	addi	s0,sp,32
  push_off();
    800018e6:	ad8ff0ef          	jal	80000bbe <push_off>
    800018ea:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018ec:	2781                	sext.w	a5,a5
    800018ee:	079e                	slli	a5,a5,0x7
    800018f0:	00011717          	auipc	a4,0x11
    800018f4:	e6070713          	addi	a4,a4,-416 # 80012750 <pid_lock>
    800018f8:	97ba                	add	a5,a5,a4
    800018fa:	7b84                	ld	s1,48(a5)
  pop_off();
    800018fc:	b46ff0ef          	jal	80000c42 <pop_off>
  return p;
}
    80001900:	8526                	mv	a0,s1
    80001902:	60e2                	ld	ra,24(sp)
    80001904:	6442                	ld	s0,16(sp)
    80001906:	64a2                	ld	s1,8(sp)
    80001908:	6105                	addi	sp,sp,32
    8000190a:	8082                	ret

000000008000190c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000190c:	1141                	addi	sp,sp,-16
    8000190e:	e406                	sd	ra,8(sp)
    80001910:	e022                	sd	s0,0(sp)
    80001912:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001914:	fc9ff0ef          	jal	800018dc <myproc>
    80001918:	b7aff0ef          	jal	80000c92 <release>

  if (first) {
    8000191c:	00009797          	auipc	a5,0x9
    80001920:	bc47a783          	lw	a5,-1084(a5) # 8000a4e0 <first.1>
    80001924:	e799                	bnez	a5,80001932 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001926:	3bf000ef          	jal	800024e4 <usertrapret>
}
    8000192a:	60a2                	ld	ra,8(sp)
    8000192c:	6402                	ld	s0,0(sp)
    8000192e:	0141                	addi	sp,sp,16
    80001930:	8082                	ret
    fsinit(ROOTDEV);
    80001932:	4505                	li	a0,1
    80001934:	173010ef          	jal	800032a6 <fsinit>
    first = 0;
    80001938:	00009797          	auipc	a5,0x9
    8000193c:	ba07a423          	sw	zero,-1112(a5) # 8000a4e0 <first.1>
    __sync_synchronize();
    80001940:	0330000f          	fence	rw,rw
    80001944:	b7cd                	j	80001926 <forkret+0x1a>

0000000080001946 <allocpid>:
{
    80001946:	1101                	addi	sp,sp,-32
    80001948:	ec06                	sd	ra,24(sp)
    8000194a:	e822                	sd	s0,16(sp)
    8000194c:	e426                	sd	s1,8(sp)
    8000194e:	e04a                	sd	s2,0(sp)
    80001950:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001952:	00011917          	auipc	s2,0x11
    80001956:	dfe90913          	addi	s2,s2,-514 # 80012750 <pid_lock>
    8000195a:	854a                	mv	a0,s2
    8000195c:	aa2ff0ef          	jal	80000bfe <acquire>
  pid = nextpid;
    80001960:	00009797          	auipc	a5,0x9
    80001964:	b9078793          	addi	a5,a5,-1136 # 8000a4f0 <nextpid>
    80001968:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000196a:	0014871b          	addiw	a4,s1,1
    8000196e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001970:	854a                	mv	a0,s2
    80001972:	b20ff0ef          	jal	80000c92 <release>
}
    80001976:	8526                	mv	a0,s1
    80001978:	60e2                	ld	ra,24(sp)
    8000197a:	6442                	ld	s0,16(sp)
    8000197c:	64a2                	ld	s1,8(sp)
    8000197e:	6902                	ld	s2,0(sp)
    80001980:	6105                	addi	sp,sp,32
    80001982:	8082                	ret

0000000080001984 <proc_pagetable>:
{
    80001984:	1101                	addi	sp,sp,-32
    80001986:	ec06                	sd	ra,24(sp)
    80001988:	e822                	sd	s0,16(sp)
    8000198a:	e426                	sd	s1,8(sp)
    8000198c:	e04a                	sd	s2,0(sp)
    8000198e:	1000                	addi	s0,sp,32
    80001990:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001992:	90bff0ef          	jal	8000129c <uvmcreate>
    80001996:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001998:	cd05                	beqz	a0,800019d0 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000199a:	4729                	li	a4,10
    8000199c:	00004697          	auipc	a3,0x4
    800019a0:	66468693          	addi	a3,a3,1636 # 80006000 <_trampoline>
    800019a4:	6605                	lui	a2,0x1
    800019a6:	040005b7          	lui	a1,0x4000
    800019aa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019ac:	05b2                	slli	a1,a1,0xc
    800019ae:	e8cff0ef          	jal	8000103a <mappages>
    800019b2:	02054663          	bltz	a0,800019de <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019b6:	4719                	li	a4,6
    800019b8:	05893683          	ld	a3,88(s2)
    800019bc:	6605                	lui	a2,0x1
    800019be:	020005b7          	lui	a1,0x2000
    800019c2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019c4:	05b6                	slli	a1,a1,0xd
    800019c6:	8526                	mv	a0,s1
    800019c8:	e72ff0ef          	jal	8000103a <mappages>
    800019cc:	00054f63          	bltz	a0,800019ea <proc_pagetable+0x66>
}
    800019d0:	8526                	mv	a0,s1
    800019d2:	60e2                	ld	ra,24(sp)
    800019d4:	6442                	ld	s0,16(sp)
    800019d6:	64a2                	ld	s1,8(sp)
    800019d8:	6902                	ld	s2,0(sp)
    800019da:	6105                	addi	sp,sp,32
    800019dc:	8082                	ret
    uvmfree(pagetable, 0);
    800019de:	4581                	li	a1,0
    800019e0:	8526                	mv	a0,s1
    800019e2:	a91ff0ef          	jal	80001472 <uvmfree>
    return 0;
    800019e6:	4481                	li	s1,0
    800019e8:	b7e5                	j	800019d0 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800019ea:	4681                	li	a3,0
    800019ec:	4605                	li	a2,1
    800019ee:	040005b7          	lui	a1,0x4000
    800019f2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019f4:	05b2                	slli	a1,a1,0xc
    800019f6:	8526                	mv	a0,s1
    800019f8:	fe8ff0ef          	jal	800011e0 <uvmunmap>
    uvmfree(pagetable, 0);
    800019fc:	4581                	li	a1,0
    800019fe:	8526                	mv	a0,s1
    80001a00:	a73ff0ef          	jal	80001472 <uvmfree>
    return 0;
    80001a04:	4481                	li	s1,0
    80001a06:	b7e9                	j	800019d0 <proc_pagetable+0x4c>

0000000080001a08 <proc_freepagetable>:
{
    80001a08:	1101                	addi	sp,sp,-32
    80001a0a:	ec06                	sd	ra,24(sp)
    80001a0c:	e822                	sd	s0,16(sp)
    80001a0e:	e426                	sd	s1,8(sp)
    80001a10:	e04a                	sd	s2,0(sp)
    80001a12:	1000                	addi	s0,sp,32
    80001a14:	84aa                	mv	s1,a0
    80001a16:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a18:	4681                	li	a3,0
    80001a1a:	4605                	li	a2,1
    80001a1c:	040005b7          	lui	a1,0x4000
    80001a20:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a22:	05b2                	slli	a1,a1,0xc
    80001a24:	fbcff0ef          	jal	800011e0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a28:	4681                	li	a3,0
    80001a2a:	4605                	li	a2,1
    80001a2c:	020005b7          	lui	a1,0x2000
    80001a30:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a32:	05b6                	slli	a1,a1,0xd
    80001a34:	8526                	mv	a0,s1
    80001a36:	faaff0ef          	jal	800011e0 <uvmunmap>
  uvmfree(pagetable, sz);
    80001a3a:	85ca                	mv	a1,s2
    80001a3c:	8526                	mv	a0,s1
    80001a3e:	a35ff0ef          	jal	80001472 <uvmfree>
}
    80001a42:	60e2                	ld	ra,24(sp)
    80001a44:	6442                	ld	s0,16(sp)
    80001a46:	64a2                	ld	s1,8(sp)
    80001a48:	6902                	ld	s2,0(sp)
    80001a4a:	6105                	addi	sp,sp,32
    80001a4c:	8082                	ret

0000000080001a4e <freeproc>:
{
    80001a4e:	1101                	addi	sp,sp,-32
    80001a50:	ec06                	sd	ra,24(sp)
    80001a52:	e822                	sd	s0,16(sp)
    80001a54:	e426                	sd	s1,8(sp)
    80001a56:	1000                	addi	s0,sp,32
    80001a58:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001a5a:	6d28                	ld	a0,88(a0)
    80001a5c:	c119                	beqz	a0,80001a62 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001a5e:	febfe0ef          	jal	80000a48 <kfree>
  p->trapframe = 0;
    80001a62:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a66:	68a8                	ld	a0,80(s1)
    80001a68:	c501                	beqz	a0,80001a70 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001a6a:	64ac                	ld	a1,72(s1)
    80001a6c:	f9dff0ef          	jal	80001a08 <proc_freepagetable>
  p->pagetable = 0;
    80001a70:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a74:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a78:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001a7c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001a80:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001a84:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001a88:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001a8c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001a90:	0004ac23          	sw	zero,24(s1)
  p->trapcount = 0;
    80001a94:	1604a423          	sw	zero,360(s1)
  p->syscallcount = 0;
    80001a98:	1604a623          	sw	zero,364(s1)
  p->devintcount = 0;
    80001a9c:	1604a823          	sw	zero,368(s1)
  p->timerintcount = 0;
    80001aa0:	1604aa23          	sw	zero,372(s1)
  p->nice = 0;
    80001aa4:	1604ac23          	sw	zero,376(s1)
  p->runtime = 0;
    80001aa8:	1604ae23          	sw	zero,380(s1)
  p->vruntime = 0;
    80001aac:	1804a023          	sw	zero,384(s1)
}
    80001ab0:	60e2                	ld	ra,24(sp)
    80001ab2:	6442                	ld	s0,16(sp)
    80001ab4:	64a2                	ld	s1,8(sp)
    80001ab6:	6105                	addi	sp,sp,32
    80001ab8:	8082                	ret

0000000080001aba <allocproc>:
{
    80001aba:	1101                	addi	sp,sp,-32
    80001abc:	ec06                	sd	ra,24(sp)
    80001abe:	e822                	sd	s0,16(sp)
    80001ac0:	e426                	sd	s1,8(sp)
    80001ac2:	e04a                	sd	s2,0(sp)
    80001ac4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ac6:	00011497          	auipc	s1,0x11
    80001aca:	0ba48493          	addi	s1,s1,186 # 80012b80 <proc>
    80001ace:	00017917          	auipc	s2,0x17
    80001ad2:	2b290913          	addi	s2,s2,690 # 80018d80 <tickslock>
    acquire(&p->lock);
    80001ad6:	8526                	mv	a0,s1
    80001ad8:	926ff0ef          	jal	80000bfe <acquire>
    if(p->state == UNUSED) {
    80001adc:	4c9c                	lw	a5,24(s1)
    80001ade:	cb91                	beqz	a5,80001af2 <allocproc+0x38>
      release(&p->lock);
    80001ae0:	8526                	mv	a0,s1
    80001ae2:	9b0ff0ef          	jal	80000c92 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ae6:	18848493          	addi	s1,s1,392
    80001aea:	ff2496e3          	bne	s1,s2,80001ad6 <allocproc+0x1c>
  return 0;
    80001aee:	4481                	li	s1,0
    80001af0:	a089                	j	80001b32 <allocproc+0x78>
  p->pid = allocpid();
    80001af2:	e55ff0ef          	jal	80001946 <allocpid>
    80001af6:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001af8:	4785                	li	a5,1
    80001afa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001afc:	82eff0ef          	jal	80000b2a <kalloc>
    80001b00:	892a                	mv	s2,a0
    80001b02:	eca8                	sd	a0,88(s1)
    80001b04:	cd15                	beqz	a0,80001b40 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b06:	8526                	mv	a0,s1
    80001b08:	e7dff0ef          	jal	80001984 <proc_pagetable>
    80001b0c:	892a                	mv	s2,a0
    80001b0e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001b10:	c121                	beqz	a0,80001b50 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b12:	07000613          	li	a2,112
    80001b16:	4581                	li	a1,0
    80001b18:	06048513          	addi	a0,s1,96
    80001b1c:	9b2ff0ef          	jal	80000cce <memset>
  p->context.ra = (uint64)forkret;
    80001b20:	00000797          	auipc	a5,0x0
    80001b24:	dec78793          	addi	a5,a5,-532 # 8000190c <forkret>
    80001b28:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b2a:	60bc                	ld	a5,64(s1)
    80001b2c:	6705                	lui	a4,0x1
    80001b2e:	97ba                	add	a5,a5,a4
    80001b30:	f4bc                	sd	a5,104(s1)
}
    80001b32:	8526                	mv	a0,s1
    80001b34:	60e2                	ld	ra,24(sp)
    80001b36:	6442                	ld	s0,16(sp)
    80001b38:	64a2                	ld	s1,8(sp)
    80001b3a:	6902                	ld	s2,0(sp)
    80001b3c:	6105                	addi	sp,sp,32
    80001b3e:	8082                	ret
    freeproc(p);
    80001b40:	8526                	mv	a0,s1
    80001b42:	f0dff0ef          	jal	80001a4e <freeproc>
    release(&p->lock);
    80001b46:	8526                	mv	a0,s1
    80001b48:	94aff0ef          	jal	80000c92 <release>
    return 0;
    80001b4c:	84ca                	mv	s1,s2
    80001b4e:	b7d5                	j	80001b32 <allocproc+0x78>
    freeproc(p);
    80001b50:	8526                	mv	a0,s1
    80001b52:	efdff0ef          	jal	80001a4e <freeproc>
    release(&p->lock);
    80001b56:	8526                	mv	a0,s1
    80001b58:	93aff0ef          	jal	80000c92 <release>
    return 0;
    80001b5c:	84ca                	mv	s1,s2
    80001b5e:	bfd1                	j	80001b32 <allocproc+0x78>

0000000080001b60 <userinit>:
{
    80001b60:	1101                	addi	sp,sp,-32
    80001b62:	ec06                	sd	ra,24(sp)
    80001b64:	e822                	sd	s0,16(sp)
    80001b66:	e426                	sd	s1,8(sp)
    80001b68:	1000                	addi	s0,sp,32
  p = allocproc();
    80001b6a:	f51ff0ef          	jal	80001aba <allocproc>
    80001b6e:	84aa                	mv	s1,a0
  initproc = p;
    80001b70:	00009797          	auipc	a5,0x9
    80001b74:	aaa7b823          	sd	a0,-1360(a5) # 8000a620 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001b78:	03400613          	li	a2,52
    80001b7c:	00009597          	auipc	a1,0x9
    80001b80:	98458593          	addi	a1,a1,-1660 # 8000a500 <initcode>
    80001b84:	6928                	ld	a0,80(a0)
    80001b86:	f3cff0ef          	jal	800012c2 <uvmfirst>
  p->sz = PGSIZE;
    80001b8a:	6785                	lui	a5,0x1
    80001b8c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001b8e:	6cb8                	ld	a4,88(s1)
    80001b90:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001b94:	6cb8                	ld	a4,88(s1)
    80001b96:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001b98:	4641                	li	a2,16
    80001b9a:	00005597          	auipc	a1,0x5
    80001b9e:	68658593          	addi	a1,a1,1670 # 80007220 <etext+0x220>
    80001ba2:	15848513          	addi	a0,s1,344
    80001ba6:	a7aff0ef          	jal	80000e20 <safestrcpy>
  p->cwd = namei("/");
    80001baa:	00005517          	auipc	a0,0x5
    80001bae:	68650513          	addi	a0,a0,1670 # 80007230 <etext+0x230>
    80001bb2:	018020ef          	jal	80003bca <namei>
    80001bb6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001bba:	478d                	li	a5,3
    80001bbc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001bbe:	8526                	mv	a0,s1
    80001bc0:	8d2ff0ef          	jal	80000c92 <release>
}
    80001bc4:	60e2                	ld	ra,24(sp)
    80001bc6:	6442                	ld	s0,16(sp)
    80001bc8:	64a2                	ld	s1,8(sp)
    80001bca:	6105                	addi	sp,sp,32
    80001bcc:	8082                	ret

0000000080001bce <growproc>:
{
    80001bce:	1101                	addi	sp,sp,-32
    80001bd0:	ec06                	sd	ra,24(sp)
    80001bd2:	e822                	sd	s0,16(sp)
    80001bd4:	e426                	sd	s1,8(sp)
    80001bd6:	e04a                	sd	s2,0(sp)
    80001bd8:	1000                	addi	s0,sp,32
    80001bda:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001bdc:	d01ff0ef          	jal	800018dc <myproc>
    80001be0:	84aa                	mv	s1,a0
  sz = p->sz;
    80001be2:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001be4:	01204c63          	bgtz	s2,80001bfc <growproc+0x2e>
  } else if(n < 0){
    80001be8:	02094463          	bltz	s2,80001c10 <growproc+0x42>
  p->sz = sz;
    80001bec:	e4ac                	sd	a1,72(s1)
  return 0;
    80001bee:	4501                	li	a0,0
}
    80001bf0:	60e2                	ld	ra,24(sp)
    80001bf2:	6442                	ld	s0,16(sp)
    80001bf4:	64a2                	ld	s1,8(sp)
    80001bf6:	6902                	ld	s2,0(sp)
    80001bf8:	6105                	addi	sp,sp,32
    80001bfa:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001bfc:	4691                	li	a3,4
    80001bfe:	00b90633          	add	a2,s2,a1
    80001c02:	6928                	ld	a0,80(a0)
    80001c04:	f60ff0ef          	jal	80001364 <uvmalloc>
    80001c08:	85aa                	mv	a1,a0
    80001c0a:	f16d                	bnez	a0,80001bec <growproc+0x1e>
      return -1;
    80001c0c:	557d                	li	a0,-1
    80001c0e:	b7cd                	j	80001bf0 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c10:	00b90633          	add	a2,s2,a1
    80001c14:	6928                	ld	a0,80(a0)
    80001c16:	f0aff0ef          	jal	80001320 <uvmdealloc>
    80001c1a:	85aa                	mv	a1,a0
    80001c1c:	bfc1                	j	80001bec <growproc+0x1e>

0000000080001c1e <fork>:
{
    80001c1e:	7139                	addi	sp,sp,-64
    80001c20:	fc06                	sd	ra,56(sp)
    80001c22:	f822                	sd	s0,48(sp)
    80001c24:	f04a                	sd	s2,32(sp)
    80001c26:	e456                	sd	s5,8(sp)
    80001c28:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c2a:	cb3ff0ef          	jal	800018dc <myproc>
    80001c2e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c30:	e8bff0ef          	jal	80001aba <allocproc>
    80001c34:	0e050a63          	beqz	a0,80001d28 <fork+0x10a>
    80001c38:	e852                	sd	s4,16(sp)
    80001c3a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c3c:	048ab603          	ld	a2,72(s5)
    80001c40:	692c                	ld	a1,80(a0)
    80001c42:	050ab503          	ld	a0,80(s5)
    80001c46:	85fff0ef          	jal	800014a4 <uvmcopy>
    80001c4a:	04054a63          	bltz	a0,80001c9e <fork+0x80>
    80001c4e:	f426                	sd	s1,40(sp)
    80001c50:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001c52:	048ab783          	ld	a5,72(s5)
    80001c56:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001c5a:	058ab683          	ld	a3,88(s5)
    80001c5e:	87b6                	mv	a5,a3
    80001c60:	058a3703          	ld	a4,88(s4)
    80001c64:	12068693          	addi	a3,a3,288
    80001c68:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c6c:	6788                	ld	a0,8(a5)
    80001c6e:	6b8c                	ld	a1,16(a5)
    80001c70:	6f90                	ld	a2,24(a5)
    80001c72:	01073023          	sd	a6,0(a4)
    80001c76:	e708                	sd	a0,8(a4)
    80001c78:	eb0c                	sd	a1,16(a4)
    80001c7a:	ef10                	sd	a2,24(a4)
    80001c7c:	02078793          	addi	a5,a5,32
    80001c80:	02070713          	addi	a4,a4,32
    80001c84:	fed792e3          	bne	a5,a3,80001c68 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001c88:	058a3783          	ld	a5,88(s4)
    80001c8c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001c90:	0d0a8493          	addi	s1,s5,208
    80001c94:	0d0a0913          	addi	s2,s4,208
    80001c98:	150a8993          	addi	s3,s5,336
    80001c9c:	a831                	j	80001cb8 <fork+0x9a>
    freeproc(np);
    80001c9e:	8552                	mv	a0,s4
    80001ca0:	dafff0ef          	jal	80001a4e <freeproc>
    release(&np->lock);
    80001ca4:	8552                	mv	a0,s4
    80001ca6:	fedfe0ef          	jal	80000c92 <release>
    return -1;
    80001caa:	597d                	li	s2,-1
    80001cac:	6a42                	ld	s4,16(sp)
    80001cae:	a0b5                	j	80001d1a <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001cb0:	04a1                	addi	s1,s1,8
    80001cb2:	0921                	addi	s2,s2,8
    80001cb4:	01348963          	beq	s1,s3,80001cc6 <fork+0xa8>
    if(p->ofile[i])
    80001cb8:	6088                	ld	a0,0(s1)
    80001cba:	d97d                	beqz	a0,80001cb0 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001cbc:	4aa020ef          	jal	80004166 <filedup>
    80001cc0:	00a93023          	sd	a0,0(s2)
    80001cc4:	b7f5                	j	80001cb0 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001cc6:	150ab503          	ld	a0,336(s5)
    80001cca:	7da010ef          	jal	800034a4 <idup>
    80001cce:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001cd2:	4641                	li	a2,16
    80001cd4:	158a8593          	addi	a1,s5,344
    80001cd8:	158a0513          	addi	a0,s4,344
    80001cdc:	944ff0ef          	jal	80000e20 <safestrcpy>
  pid = np->pid;
    80001ce0:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001ce4:	8552                	mv	a0,s4
    80001ce6:	fadfe0ef          	jal	80000c92 <release>
  acquire(&wait_lock);
    80001cea:	00011497          	auipc	s1,0x11
    80001cee:	a7e48493          	addi	s1,s1,-1410 # 80012768 <wait_lock>
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	f0bfe0ef          	jal	80000bfe <acquire>
  np->parent = p;
    80001cf8:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001cfc:	8526                	mv	a0,s1
    80001cfe:	f95fe0ef          	jal	80000c92 <release>
  acquire(&np->lock);
    80001d02:	8552                	mv	a0,s4
    80001d04:	efbfe0ef          	jal	80000bfe <acquire>
  np->state = RUNNABLE;
    80001d08:	478d                	li	a5,3
    80001d0a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d0e:	8552                	mv	a0,s4
    80001d10:	f83fe0ef          	jal	80000c92 <release>
  return pid;
    80001d14:	74a2                	ld	s1,40(sp)
    80001d16:	69e2                	ld	s3,24(sp)
    80001d18:	6a42                	ld	s4,16(sp)
}
    80001d1a:	854a                	mv	a0,s2
    80001d1c:	70e2                	ld	ra,56(sp)
    80001d1e:	7442                	ld	s0,48(sp)
    80001d20:	7902                	ld	s2,32(sp)
    80001d22:	6aa2                	ld	s5,8(sp)
    80001d24:	6121                	addi	sp,sp,64
    80001d26:	8082                	ret
    return -1;
    80001d28:	597d                	li	s2,-1
    80001d2a:	bfc5                	j	80001d1a <fork+0xfc>

0000000080001d2c <weight_sum>:
int weight_sum(){
    80001d2c:	1141                	addi	sp,sp,-16
    80001d2e:	e406                	sd	ra,8(sp)
    80001d30:	e022                	sd	s0,0(sp)
    80001d32:	0800                	addi	s0,sp,16
}
    80001d34:	4501                	li	a0,0
    80001d36:	60a2                	ld	ra,8(sp)
    80001d38:	6402                	ld	s0,0(sp)
    80001d3a:	0141                	addi	sp,sp,16
    80001d3c:	8082                	ret

0000000080001d3e <shortest_runtime_proc>:
struct proc* shortest_runtime_proc(){
    80001d3e:	1141                	addi	sp,sp,-16
    80001d40:	e406                	sd	ra,8(sp)
    80001d42:	e022                	sd	s0,0(sp)
    80001d44:	0800                	addi	s0,sp,16
}
    80001d46:	4501                	li	a0,0
    80001d48:	60a2                	ld	ra,8(sp)
    80001d4a:	6402                	ld	s0,0(sp)
    80001d4c:	0141                	addi	sp,sp,16
    80001d4e:	8082                	ret

0000000080001d50 <cfs_scheduler>:
  c->proc = 0;
    80001d50:	00053023          	sd	zero,0(a0)
  cfs_proc_timeslice_left = cfs_proc_timeslice_left - 1;
    80001d54:	00009797          	auipc	a5,0x9
    80001d58:	8b478793          	addi	a5,a5,-1868 # 8000a608 <cfs_proc_timeslice_left>
    80001d5c:	4390                	lw	a2,0(a5)
    80001d5e:	367d                	addiw	a2,a2,-1 # fff <_entry-0x7ffff001>
    80001d60:	c390                	sw	a2,0(a5)
  if(cfs_proc_timeslice_left > 0 && cfs_current_proc->state == RUNNABLE){
    80001d62:	02c05563          	blez	a2,80001d8c <cfs_scheduler+0x3c>
    80001d66:	00009797          	auipc	a5,0x9
    80001d6a:	8aa7b783          	ld	a5,-1878(a5) # 8000a610 <cfs_current_proc>
    80001d6e:	4f94                	lw	a3,24(a5)
    80001d70:	470d                	li	a4,3
    80001d72:	00e68b63          	beq	a3,a4,80001d88 <cfs_scheduler+0x38>
  } else if(cfs_proc_timeslice_left == 0 || (cfs_current_proc != 0 && cfs_current_proc->state != RUNNABLE)){
    80001d76:	00009797          	auipc	a5,0x9
    80001d7a:	89a7b783          	ld	a5,-1894(a5) # 8000a610 <cfs_current_proc>
    80001d7e:	4f98                	lw	a4,24(a5)
    80001d80:	478d                	li	a5,3
    80001d82:	00f71663          	bne	a4,a5,80001d8e <cfs_scheduler+0x3e>
    80001d86:	8082                	ret
    c->proc = cfs_current_proc;
    80001d88:	e11c                	sd	a5,0(a0)
    80001d8a:	8082                	ret
  } else if(cfs_proc_timeslice_left == 0 || (cfs_current_proc != 0 && cfs_current_proc->state != RUNNABLE)){
    80001d8c:	e225                	bnez	a2,80001dec <cfs_scheduler+0x9c>
void cfs_scheduler(struct cpu *c) {
    80001d8e:	1141                	addi	sp,sp,-16
    80001d90:	e406                	sd	ra,8(sp)
    80001d92:	e022                	sd	s0,0(sp)
    80001d94:	0800                	addi	s0,sp,16
    int weight = nice_to_weight[cfs_current_proc->nice+20]; //convert nice to weight
    80001d96:	00009717          	auipc	a4,0x9
    80001d9a:	87a73703          	ld	a4,-1926(a4) # 8000a610 <cfs_current_proc>
    int inc = (cfs_proc_timeslice_len - cfs_proc_timeslice_left) * 1024 / weight;
    80001d9e:	00009697          	auipc	a3,0x9
    80001da2:	86e6a683          	lw	a3,-1938(a3) # 8000a60c <cfs_proc_timeslice_len>
    80001da6:	40c6863b          	subw	a2,a3,a2
    80001daa:	00a6159b          	slliw	a1,a2,0xa
    int weight = nice_to_weight[cfs_current_proc->nice+20]; //convert nice to weight
    80001dae:	17872783          	lw	a5,376(a4)
    80001db2:	27d1                	addiw	a5,a5,20
    80001db4:	078a                	slli	a5,a5,0x2
    80001db6:	00008517          	auipc	a0,0x8
    80001dba:	74a50513          	addi	a0,a0,1866 # 8000a500 <initcode>
    80001dbe:	97aa                	add	a5,a5,a0
    int inc = (cfs_proc_timeslice_len - cfs_proc_timeslice_left) * 1024 / weight;
    80001dc0:	5f9c                	lw	a5,56(a5)
    80001dc2:	02f5c7bb          	divw	a5,a1,a5
    80001dc6:	85be                	mv	a1,a5
    if(inc<1) inc=1; //increment should be at least 1
    80001dc8:	02f05863          	blez	a5,80001df8 <cfs_scheduler+0xa8>
    cfs_current_proc->vruntime += inc; //add the increment to vruntime
    80001dcc:	18072783          	lw	a5,384(a4)
    80001dd0:	9dbd                	addw	a1,a1,a5
    80001dd2:	18b72023          	sw	a1,384(a4)
    printf("[DEBUG CFS] Process %d used %d ticks of its assigned timeslice (totally %d ticks) and is swapped out!\n",
    80001dd6:	5b0c                	lw	a1,48(a4)
    80001dd8:	00005517          	auipc	a0,0x5
    80001ddc:	46050513          	addi	a0,a0,1120 # 80007238 <etext+0x238>
    80001de0:	eeefe0ef          	jal	800004ce <printf>
}
    80001de4:	60a2                	ld	ra,8(sp)
    80001de6:	6402                	ld	s0,0(sp)
    80001de8:	0141                	addi	sp,sp,16
    80001dea:	8082                	ret
  } else if(cfs_proc_timeslice_left == 0 || (cfs_current_proc != 0 && cfs_current_proc->state != RUNNABLE)){
    80001dec:	00009797          	auipc	a5,0x9
    80001df0:	8247b783          	ld	a5,-2012(a5) # 8000a610 <cfs_current_proc>
    80001df4:	f7c9                	bnez	a5,80001d7e <cfs_scheduler+0x2e>
    80001df6:	8082                	ret
    if(inc<1) inc=1; //increment should be at least 1
    80001df8:	4585                	li	a1,1
    80001dfa:	bfc9                	j	80001dcc <cfs_scheduler+0x7c>

0000000080001dfc <old_scheduler>:
old_scheduler(struct cpu *c) {
    80001dfc:	7139                	addi	sp,sp,-64
    80001dfe:	fc06                	sd	ra,56(sp)
    80001e00:	f822                	sd	s0,48(sp)
    80001e02:	f426                	sd	s1,40(sp)
    80001e04:	f04a                	sd	s2,32(sp)
    80001e06:	ec4e                	sd	s3,24(sp)
    80001e08:	e852                	sd	s4,16(sp)
    80001e0a:	e456                	sd	s5,8(sp)
    80001e0c:	e05a                	sd	s6,0(sp)
    80001e0e:	0080                	addi	s0,sp,64
    80001e10:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e12:	00011497          	auipc	s1,0x11
    80001e16:	d6e48493          	addi	s1,s1,-658 # 80012b80 <proc>
    if(p->state == RUNNABLE) {
    80001e1a:	498d                	li	s3,3
      p->state = RUNNING;
    80001e1c:	4b11                	li	s6,4
      swtch(&c->context, &p->context);
    80001e1e:	00850a93          	addi	s5,a0,8
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e22:	00017917          	auipc	s2,0x17
    80001e26:	f5e90913          	addi	s2,s2,-162 # 80018d80 <tickslock>
    80001e2a:	a801                	j	80001e3a <old_scheduler+0x3e>
    release(&p->lock);
    80001e2c:	8526                	mv	a0,s1
    80001e2e:	e65fe0ef          	jal	80000c92 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e32:	18848493          	addi	s1,s1,392
    80001e36:	03248463          	beq	s1,s2,80001e5e <old_scheduler+0x62>
    acquire(&p->lock);
    80001e3a:	8526                	mv	a0,s1
    80001e3c:	dc3fe0ef          	jal	80000bfe <acquire>
    if(p->state == RUNNABLE) {
    80001e40:	4c9c                	lw	a5,24(s1)
    80001e42:	ff3795e3          	bne	a5,s3,80001e2c <old_scheduler+0x30>
      p->state = RUNNING;
    80001e46:	0164ac23          	sw	s6,24(s1)
      c->proc = p;
    80001e4a:	009a3023          	sd	s1,0(s4)
      swtch(&c->context, &p->context);
    80001e4e:	06048593          	addi	a1,s1,96
    80001e52:	8556                	mv	a0,s5
    80001e54:	5e6000ef          	jal	8000243a <swtch>
      c->proc = 0;
    80001e58:	000a3023          	sd	zero,0(s4)
    80001e5c:	bfc1                	j	80001e2c <old_scheduler+0x30>
}
    80001e5e:	70e2                	ld	ra,56(sp)
    80001e60:	7442                	ld	s0,48(sp)
    80001e62:	74a2                	ld	s1,40(sp)
    80001e64:	7902                	ld	s2,32(sp)
    80001e66:	69e2                	ld	s3,24(sp)
    80001e68:	6a42                	ld	s4,16(sp)
    80001e6a:	6aa2                	ld	s5,8(sp)
    80001e6c:	6b02                	ld	s6,0(sp)
    80001e6e:	6121                	addi	sp,sp,64
    80001e70:	8082                	ret

0000000080001e72 <scheduler>:
scheduler(void){
    80001e72:	1101                	addi	sp,sp,-32
    80001e74:	ec06                	sd	ra,24(sp)
    80001e76:	e822                	sd	s0,16(sp)
    80001e78:	e426                	sd	s1,8(sp)
    80001e7a:	e04a                	sd	s2,0(sp)
    80001e7c:	1000                	addi	s0,sp,32
    80001e7e:	8792                	mv	a5,tp
  int id = r_tp();
    80001e80:	2781                	sext.w	a5,a5
  struct cpu *c = &cpus[id];
    80001e82:	079e                	slli	a5,a5,0x7
    80001e84:	00011497          	auipc	s1,0x11
    80001e88:	8fc48493          	addi	s1,s1,-1796 # 80012780 <cpus>
    80001e8c:	94be                	add	s1,s1,a5
  c->proc=0;
    80001e8e:	00011717          	auipc	a4,0x11
    80001e92:	8c270713          	addi	a4,a4,-1854 # 80012750 <pid_lock>
    80001e96:	97ba                	add	a5,a5,a4
    80001e98:	0207b823          	sd	zero,48(a5)
    if(cfs){
    80001e9c:	00008917          	auipc	s2,0x8
    80001ea0:	77c90913          	addi	s2,s2,1916 # 8000a618 <cfs>
    80001ea4:	a021                	j	80001eac <scheduler+0x3a>
      cfs_scheduler(c);
    80001ea6:	8526                	mv	a0,s1
    80001ea8:	ea9ff0ef          	jal	80001d50 <cfs_scheduler>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001eb0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eb4:	10079073          	csrw	sstatus,a5
    if(cfs){
    80001eb8:	00092783          	lw	a5,0(s2)
    80001ebc:	f7ed                	bnez	a5,80001ea6 <scheduler+0x34>
      old_scheduler(c);
    80001ebe:	8526                	mv	a0,s1
    80001ec0:	f3dff0ef          	jal	80001dfc <old_scheduler>
    80001ec4:	b7e5                	j	80001eac <scheduler+0x3a>

0000000080001ec6 <sched>:
{
    80001ec6:	7179                	addi	sp,sp,-48
    80001ec8:	f406                	sd	ra,40(sp)
    80001eca:	f022                	sd	s0,32(sp)
    80001ecc:	ec26                	sd	s1,24(sp)
    80001ece:	e84a                	sd	s2,16(sp)
    80001ed0:	e44e                	sd	s3,8(sp)
    80001ed2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001ed4:	a09ff0ef          	jal	800018dc <myproc>
    80001ed8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001eda:	cbbfe0ef          	jal	80000b94 <holding>
    80001ede:	c92d                	beqz	a0,80001f50 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ee0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001ee2:	2781                	sext.w	a5,a5
    80001ee4:	079e                	slli	a5,a5,0x7
    80001ee6:	00011717          	auipc	a4,0x11
    80001eea:	86a70713          	addi	a4,a4,-1942 # 80012750 <pid_lock>
    80001eee:	97ba                	add	a5,a5,a4
    80001ef0:	0a87a703          	lw	a4,168(a5)
    80001ef4:	4785                	li	a5,1
    80001ef6:	06f71363          	bne	a4,a5,80001f5c <sched+0x96>
  if(p->state == RUNNING)
    80001efa:	4c98                	lw	a4,24(s1)
    80001efc:	4791                	li	a5,4
    80001efe:	06f70563          	beq	a4,a5,80001f68 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f02:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f06:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001f08:	e7b5                	bnez	a5,80001f74 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f0a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001f0c:	00011917          	auipc	s2,0x11
    80001f10:	84490913          	addi	s2,s2,-1980 # 80012750 <pid_lock>
    80001f14:	2781                	sext.w	a5,a5
    80001f16:	079e                	slli	a5,a5,0x7
    80001f18:	97ca                	add	a5,a5,s2
    80001f1a:	0ac7a983          	lw	s3,172(a5)
    80001f1e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001f20:	2781                	sext.w	a5,a5
    80001f22:	079e                	slli	a5,a5,0x7
    80001f24:	00011597          	auipc	a1,0x11
    80001f28:	86458593          	addi	a1,a1,-1948 # 80012788 <cpus+0x8>
    80001f2c:	95be                	add	a1,a1,a5
    80001f2e:	06048513          	addi	a0,s1,96
    80001f32:	508000ef          	jal	8000243a <swtch>
    80001f36:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001f38:	2781                	sext.w	a5,a5
    80001f3a:	079e                	slli	a5,a5,0x7
    80001f3c:	993e                	add	s2,s2,a5
    80001f3e:	0b392623          	sw	s3,172(s2)
}
    80001f42:	70a2                	ld	ra,40(sp)
    80001f44:	7402                	ld	s0,32(sp)
    80001f46:	64e2                	ld	s1,24(sp)
    80001f48:	6942                	ld	s2,16(sp)
    80001f4a:	69a2                	ld	s3,8(sp)
    80001f4c:	6145                	addi	sp,sp,48
    80001f4e:	8082                	ret
    panic("sched p->lock");
    80001f50:	00005517          	auipc	a0,0x5
    80001f54:	35050513          	addi	a0,a0,848 # 800072a0 <etext+0x2a0>
    80001f58:	847fe0ef          	jal	8000079e <panic>
    panic("sched locks");
    80001f5c:	00005517          	auipc	a0,0x5
    80001f60:	35450513          	addi	a0,a0,852 # 800072b0 <etext+0x2b0>
    80001f64:	83bfe0ef          	jal	8000079e <panic>
    panic("sched running");
    80001f68:	00005517          	auipc	a0,0x5
    80001f6c:	35850513          	addi	a0,a0,856 # 800072c0 <etext+0x2c0>
    80001f70:	82ffe0ef          	jal	8000079e <panic>
    panic("sched interruptible");
    80001f74:	00005517          	auipc	a0,0x5
    80001f78:	35c50513          	addi	a0,a0,860 # 800072d0 <etext+0x2d0>
    80001f7c:	823fe0ef          	jal	8000079e <panic>

0000000080001f80 <yield>:
{
    80001f80:	1101                	addi	sp,sp,-32
    80001f82:	ec06                	sd	ra,24(sp)
    80001f84:	e822                	sd	s0,16(sp)
    80001f86:	e426                	sd	s1,8(sp)
    80001f88:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f8a:	953ff0ef          	jal	800018dc <myproc>
    80001f8e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f90:	c6ffe0ef          	jal	80000bfe <acquire>
  p->state = RUNNABLE;
    80001f94:	478d                	li	a5,3
    80001f96:	cc9c                	sw	a5,24(s1)
  sched();
    80001f98:	f2fff0ef          	jal	80001ec6 <sched>
  release(&p->lock);
    80001f9c:	8526                	mv	a0,s1
    80001f9e:	cf5fe0ef          	jal	80000c92 <release>
}
    80001fa2:	60e2                	ld	ra,24(sp)
    80001fa4:	6442                	ld	s0,16(sp)
    80001fa6:	64a2                	ld	s1,8(sp)
    80001fa8:	6105                	addi	sp,sp,32
    80001faa:	8082                	ret

0000000080001fac <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001fac:	7179                	addi	sp,sp,-48
    80001fae:	f406                	sd	ra,40(sp)
    80001fb0:	f022                	sd	s0,32(sp)
    80001fb2:	ec26                	sd	s1,24(sp)
    80001fb4:	e84a                	sd	s2,16(sp)
    80001fb6:	e44e                	sd	s3,8(sp)
    80001fb8:	1800                	addi	s0,sp,48
    80001fba:	89aa                	mv	s3,a0
    80001fbc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fbe:	91fff0ef          	jal	800018dc <myproc>
    80001fc2:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001fc4:	c3bfe0ef          	jal	80000bfe <acquire>
  release(lk);
    80001fc8:	854a                	mv	a0,s2
    80001fca:	cc9fe0ef          	jal	80000c92 <release>

  // Go to sleep.
  p->chan = chan;
    80001fce:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001fd2:	4789                	li	a5,2
    80001fd4:	cc9c                	sw	a5,24(s1)

  sched();
    80001fd6:	ef1ff0ef          	jal	80001ec6 <sched>

  // Tidy up.
  p->chan = 0;
    80001fda:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001fde:	8526                	mv	a0,s1
    80001fe0:	cb3fe0ef          	jal	80000c92 <release>
  acquire(lk);
    80001fe4:	854a                	mv	a0,s2
    80001fe6:	c19fe0ef          	jal	80000bfe <acquire>
}
    80001fea:	70a2                	ld	ra,40(sp)
    80001fec:	7402                	ld	s0,32(sp)
    80001fee:	64e2                	ld	s1,24(sp)
    80001ff0:	6942                	ld	s2,16(sp)
    80001ff2:	69a2                	ld	s3,8(sp)
    80001ff4:	6145                	addi	sp,sp,48
    80001ff6:	8082                	ret

0000000080001ff8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001ff8:	7139                	addi	sp,sp,-64
    80001ffa:	fc06                	sd	ra,56(sp)
    80001ffc:	f822                	sd	s0,48(sp)
    80001ffe:	f426                	sd	s1,40(sp)
    80002000:	f04a                	sd	s2,32(sp)
    80002002:	ec4e                	sd	s3,24(sp)
    80002004:	e852                	sd	s4,16(sp)
    80002006:	e456                	sd	s5,8(sp)
    80002008:	0080                	addi	s0,sp,64
    8000200a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000200c:	00011497          	auipc	s1,0x11
    80002010:	b7448493          	addi	s1,s1,-1164 # 80012b80 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002014:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002016:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002018:	00017917          	auipc	s2,0x17
    8000201c:	d6890913          	addi	s2,s2,-664 # 80018d80 <tickslock>
    80002020:	a801                	j	80002030 <wakeup+0x38>
      }
      release(&p->lock);
    80002022:	8526                	mv	a0,s1
    80002024:	c6ffe0ef          	jal	80000c92 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002028:	18848493          	addi	s1,s1,392
    8000202c:	03248263          	beq	s1,s2,80002050 <wakeup+0x58>
    if(p != myproc()){
    80002030:	8adff0ef          	jal	800018dc <myproc>
    80002034:	fea48ae3          	beq	s1,a0,80002028 <wakeup+0x30>
      acquire(&p->lock);
    80002038:	8526                	mv	a0,s1
    8000203a:	bc5fe0ef          	jal	80000bfe <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000203e:	4c9c                	lw	a5,24(s1)
    80002040:	ff3791e3          	bne	a5,s3,80002022 <wakeup+0x2a>
    80002044:	709c                	ld	a5,32(s1)
    80002046:	fd479ee3          	bne	a5,s4,80002022 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000204a:	0154ac23          	sw	s5,24(s1)
    8000204e:	bfd1                	j	80002022 <wakeup+0x2a>
    }
  }
}
    80002050:	70e2                	ld	ra,56(sp)
    80002052:	7442                	ld	s0,48(sp)
    80002054:	74a2                	ld	s1,40(sp)
    80002056:	7902                	ld	s2,32(sp)
    80002058:	69e2                	ld	s3,24(sp)
    8000205a:	6a42                	ld	s4,16(sp)
    8000205c:	6aa2                	ld	s5,8(sp)
    8000205e:	6121                	addi	sp,sp,64
    80002060:	8082                	ret

0000000080002062 <reparent>:
{
    80002062:	7179                	addi	sp,sp,-48
    80002064:	f406                	sd	ra,40(sp)
    80002066:	f022                	sd	s0,32(sp)
    80002068:	ec26                	sd	s1,24(sp)
    8000206a:	e84a                	sd	s2,16(sp)
    8000206c:	e44e                	sd	s3,8(sp)
    8000206e:	e052                	sd	s4,0(sp)
    80002070:	1800                	addi	s0,sp,48
    80002072:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002074:	00011497          	auipc	s1,0x11
    80002078:	b0c48493          	addi	s1,s1,-1268 # 80012b80 <proc>
      pp->parent = initproc;
    8000207c:	00008a17          	auipc	s4,0x8
    80002080:	5a4a0a13          	addi	s4,s4,1444 # 8000a620 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002084:	00017997          	auipc	s3,0x17
    80002088:	cfc98993          	addi	s3,s3,-772 # 80018d80 <tickslock>
    8000208c:	a029                	j	80002096 <reparent+0x34>
    8000208e:	18848493          	addi	s1,s1,392
    80002092:	01348b63          	beq	s1,s3,800020a8 <reparent+0x46>
    if(pp->parent == p){
    80002096:	7c9c                	ld	a5,56(s1)
    80002098:	ff279be3          	bne	a5,s2,8000208e <reparent+0x2c>
      pp->parent = initproc;
    8000209c:	000a3503          	ld	a0,0(s4)
    800020a0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800020a2:	f57ff0ef          	jal	80001ff8 <wakeup>
    800020a6:	b7e5                	j	8000208e <reparent+0x2c>
}
    800020a8:	70a2                	ld	ra,40(sp)
    800020aa:	7402                	ld	s0,32(sp)
    800020ac:	64e2                	ld	s1,24(sp)
    800020ae:	6942                	ld	s2,16(sp)
    800020b0:	69a2                	ld	s3,8(sp)
    800020b2:	6a02                	ld	s4,0(sp)
    800020b4:	6145                	addi	sp,sp,48
    800020b6:	8082                	ret

00000000800020b8 <exit>:
{
    800020b8:	7179                	addi	sp,sp,-48
    800020ba:	f406                	sd	ra,40(sp)
    800020bc:	f022                	sd	s0,32(sp)
    800020be:	ec26                	sd	s1,24(sp)
    800020c0:	e84a                	sd	s2,16(sp)
    800020c2:	e44e                	sd	s3,8(sp)
    800020c4:	e052                	sd	s4,0(sp)
    800020c6:	1800                	addi	s0,sp,48
    800020c8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800020ca:	813ff0ef          	jal	800018dc <myproc>
    800020ce:	89aa                	mv	s3,a0
  if(p == initproc)
    800020d0:	00008797          	auipc	a5,0x8
    800020d4:	5507b783          	ld	a5,1360(a5) # 8000a620 <initproc>
    800020d8:	0d050493          	addi	s1,a0,208
    800020dc:	15050913          	addi	s2,a0,336
    800020e0:	00a79b63          	bne	a5,a0,800020f6 <exit+0x3e>
    panic("init exiting");
    800020e4:	00005517          	auipc	a0,0x5
    800020e8:	20450513          	addi	a0,a0,516 # 800072e8 <etext+0x2e8>
    800020ec:	eb2fe0ef          	jal	8000079e <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800020f0:	04a1                	addi	s1,s1,8
    800020f2:	01248963          	beq	s1,s2,80002104 <exit+0x4c>
    if(p->ofile[fd]){
    800020f6:	6088                	ld	a0,0(s1)
    800020f8:	dd65                	beqz	a0,800020f0 <exit+0x38>
      fileclose(f);
    800020fa:	0b2020ef          	jal	800041ac <fileclose>
      p->ofile[fd] = 0;
    800020fe:	0004b023          	sd	zero,0(s1)
    80002102:	b7fd                	j	800020f0 <exit+0x38>
  begin_op();
    80002104:	489010ef          	jal	80003d8c <begin_op>
  iput(p->cwd);
    80002108:	1509b503          	ld	a0,336(s3)
    8000210c:	550010ef          	jal	8000365c <iput>
  end_op();
    80002110:	4e7010ef          	jal	80003df6 <end_op>
  p->cwd = 0;
    80002114:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002118:	00010497          	auipc	s1,0x10
    8000211c:	65048493          	addi	s1,s1,1616 # 80012768 <wait_lock>
    80002120:	8526                	mv	a0,s1
    80002122:	addfe0ef          	jal	80000bfe <acquire>
  reparent(p);
    80002126:	854e                	mv	a0,s3
    80002128:	f3bff0ef          	jal	80002062 <reparent>
  wakeup(p->parent);
    8000212c:	0389b503          	ld	a0,56(s3)
    80002130:	ec9ff0ef          	jal	80001ff8 <wakeup>
  acquire(&p->lock);
    80002134:	854e                	mv	a0,s3
    80002136:	ac9fe0ef          	jal	80000bfe <acquire>
  p->xstate = status;
    8000213a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000213e:	4795                	li	a5,5
    80002140:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002144:	8526                	mv	a0,s1
    80002146:	b4dfe0ef          	jal	80000c92 <release>
  sched();
    8000214a:	d7dff0ef          	jal	80001ec6 <sched>
  panic("zombie exit");
    8000214e:	00005517          	auipc	a0,0x5
    80002152:	1aa50513          	addi	a0,a0,426 # 800072f8 <etext+0x2f8>
    80002156:	e48fe0ef          	jal	8000079e <panic>

000000008000215a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000215a:	7179                	addi	sp,sp,-48
    8000215c:	f406                	sd	ra,40(sp)
    8000215e:	f022                	sd	s0,32(sp)
    80002160:	ec26                	sd	s1,24(sp)
    80002162:	e84a                	sd	s2,16(sp)
    80002164:	e44e                	sd	s3,8(sp)
    80002166:	1800                	addi	s0,sp,48
    80002168:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000216a:	00011497          	auipc	s1,0x11
    8000216e:	a1648493          	addi	s1,s1,-1514 # 80012b80 <proc>
    80002172:	00017997          	auipc	s3,0x17
    80002176:	c0e98993          	addi	s3,s3,-1010 # 80018d80 <tickslock>
    acquire(&p->lock);
    8000217a:	8526                	mv	a0,s1
    8000217c:	a83fe0ef          	jal	80000bfe <acquire>
    if(p->pid == pid){
    80002180:	589c                	lw	a5,48(s1)
    80002182:	01278b63          	beq	a5,s2,80002198 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002186:	8526                	mv	a0,s1
    80002188:	b0bfe0ef          	jal	80000c92 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000218c:	18848493          	addi	s1,s1,392
    80002190:	ff3495e3          	bne	s1,s3,8000217a <kill+0x20>
  }
  return -1;
    80002194:	557d                	li	a0,-1
    80002196:	a819                	j	800021ac <kill+0x52>
      p->killed = 1;
    80002198:	4785                	li	a5,1
    8000219a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000219c:	4c98                	lw	a4,24(s1)
    8000219e:	4789                	li	a5,2
    800021a0:	00f70d63          	beq	a4,a5,800021ba <kill+0x60>
      release(&p->lock);
    800021a4:	8526                	mv	a0,s1
    800021a6:	aedfe0ef          	jal	80000c92 <release>
      return 0;
    800021aa:	4501                	li	a0,0
}
    800021ac:	70a2                	ld	ra,40(sp)
    800021ae:	7402                	ld	s0,32(sp)
    800021b0:	64e2                	ld	s1,24(sp)
    800021b2:	6942                	ld	s2,16(sp)
    800021b4:	69a2                	ld	s3,8(sp)
    800021b6:	6145                	addi	sp,sp,48
    800021b8:	8082                	ret
        p->state = RUNNABLE;
    800021ba:	478d                	li	a5,3
    800021bc:	cc9c                	sw	a5,24(s1)
    800021be:	b7dd                	j	800021a4 <kill+0x4a>

00000000800021c0 <setkilled>:

void
setkilled(struct proc *p)
{
    800021c0:	1101                	addi	sp,sp,-32
    800021c2:	ec06                	sd	ra,24(sp)
    800021c4:	e822                	sd	s0,16(sp)
    800021c6:	e426                	sd	s1,8(sp)
    800021c8:	1000                	addi	s0,sp,32
    800021ca:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021cc:	a33fe0ef          	jal	80000bfe <acquire>
  p->killed = 1;
    800021d0:	4785                	li	a5,1
    800021d2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800021d4:	8526                	mv	a0,s1
    800021d6:	abdfe0ef          	jal	80000c92 <release>
}
    800021da:	60e2                	ld	ra,24(sp)
    800021dc:	6442                	ld	s0,16(sp)
    800021de:	64a2                	ld	s1,8(sp)
    800021e0:	6105                	addi	sp,sp,32
    800021e2:	8082                	ret

00000000800021e4 <killed>:

int
killed(struct proc *p)
{
    800021e4:	1101                	addi	sp,sp,-32
    800021e6:	ec06                	sd	ra,24(sp)
    800021e8:	e822                	sd	s0,16(sp)
    800021ea:	e426                	sd	s1,8(sp)
    800021ec:	e04a                	sd	s2,0(sp)
    800021ee:	1000                	addi	s0,sp,32
    800021f0:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800021f2:	a0dfe0ef          	jal	80000bfe <acquire>
  k = p->killed;
    800021f6:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800021fa:	8526                	mv	a0,s1
    800021fc:	a97fe0ef          	jal	80000c92 <release>
  return k;
}
    80002200:	854a                	mv	a0,s2
    80002202:	60e2                	ld	ra,24(sp)
    80002204:	6442                	ld	s0,16(sp)
    80002206:	64a2                	ld	s1,8(sp)
    80002208:	6902                	ld	s2,0(sp)
    8000220a:	6105                	addi	sp,sp,32
    8000220c:	8082                	ret

000000008000220e <wait>:
{
    8000220e:	715d                	addi	sp,sp,-80
    80002210:	e486                	sd	ra,72(sp)
    80002212:	e0a2                	sd	s0,64(sp)
    80002214:	fc26                	sd	s1,56(sp)
    80002216:	f84a                	sd	s2,48(sp)
    80002218:	f44e                	sd	s3,40(sp)
    8000221a:	f052                	sd	s4,32(sp)
    8000221c:	ec56                	sd	s5,24(sp)
    8000221e:	e85a                	sd	s6,16(sp)
    80002220:	e45e                	sd	s7,8(sp)
    80002222:	0880                	addi	s0,sp,80
    80002224:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002226:	eb6ff0ef          	jal	800018dc <myproc>
    8000222a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000222c:	00010517          	auipc	a0,0x10
    80002230:	53c50513          	addi	a0,a0,1340 # 80012768 <wait_lock>
    80002234:	9cbfe0ef          	jal	80000bfe <acquire>
        if(pp->state == ZOMBIE){
    80002238:	4a15                	li	s4,5
        havekids = 1;
    8000223a:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000223c:	00017997          	auipc	s3,0x17
    80002240:	b4498993          	addi	s3,s3,-1212 # 80018d80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002244:	00010b97          	auipc	s7,0x10
    80002248:	524b8b93          	addi	s7,s7,1316 # 80012768 <wait_lock>
    8000224c:	a869                	j	800022e6 <wait+0xd8>
          pid = pp->pid;
    8000224e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002252:	000b0c63          	beqz	s6,8000226a <wait+0x5c>
    80002256:	4691                	li	a3,4
    80002258:	02c48613          	addi	a2,s1,44
    8000225c:	85da                	mv	a1,s6
    8000225e:	05093503          	ld	a0,80(s2)
    80002262:	b22ff0ef          	jal	80001584 <copyout>
    80002266:	02054a63          	bltz	a0,8000229a <wait+0x8c>
          freeproc(pp);
    8000226a:	8526                	mv	a0,s1
    8000226c:	fe2ff0ef          	jal	80001a4e <freeproc>
          release(&pp->lock);
    80002270:	8526                	mv	a0,s1
    80002272:	a21fe0ef          	jal	80000c92 <release>
          release(&wait_lock);
    80002276:	00010517          	auipc	a0,0x10
    8000227a:	4f250513          	addi	a0,a0,1266 # 80012768 <wait_lock>
    8000227e:	a15fe0ef          	jal	80000c92 <release>
}
    80002282:	854e                	mv	a0,s3
    80002284:	60a6                	ld	ra,72(sp)
    80002286:	6406                	ld	s0,64(sp)
    80002288:	74e2                	ld	s1,56(sp)
    8000228a:	7942                	ld	s2,48(sp)
    8000228c:	79a2                	ld	s3,40(sp)
    8000228e:	7a02                	ld	s4,32(sp)
    80002290:	6ae2                	ld	s5,24(sp)
    80002292:	6b42                	ld	s6,16(sp)
    80002294:	6ba2                	ld	s7,8(sp)
    80002296:	6161                	addi	sp,sp,80
    80002298:	8082                	ret
            release(&pp->lock);
    8000229a:	8526                	mv	a0,s1
    8000229c:	9f7fe0ef          	jal	80000c92 <release>
            release(&wait_lock);
    800022a0:	00010517          	auipc	a0,0x10
    800022a4:	4c850513          	addi	a0,a0,1224 # 80012768 <wait_lock>
    800022a8:	9ebfe0ef          	jal	80000c92 <release>
            return -1;
    800022ac:	59fd                	li	s3,-1
    800022ae:	bfd1                	j	80002282 <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800022b0:	18848493          	addi	s1,s1,392
    800022b4:	03348063          	beq	s1,s3,800022d4 <wait+0xc6>
      if(pp->parent == p){
    800022b8:	7c9c                	ld	a5,56(s1)
    800022ba:	ff279be3          	bne	a5,s2,800022b0 <wait+0xa2>
        acquire(&pp->lock);
    800022be:	8526                	mv	a0,s1
    800022c0:	93ffe0ef          	jal	80000bfe <acquire>
        if(pp->state == ZOMBIE){
    800022c4:	4c9c                	lw	a5,24(s1)
    800022c6:	f94784e3          	beq	a5,s4,8000224e <wait+0x40>
        release(&pp->lock);
    800022ca:	8526                	mv	a0,s1
    800022cc:	9c7fe0ef          	jal	80000c92 <release>
        havekids = 1;
    800022d0:	8756                	mv	a4,s5
    800022d2:	bff9                	j	800022b0 <wait+0xa2>
    if(!havekids || killed(p)){
    800022d4:	cf19                	beqz	a4,800022f2 <wait+0xe4>
    800022d6:	854a                	mv	a0,s2
    800022d8:	f0dff0ef          	jal	800021e4 <killed>
    800022dc:	e919                	bnez	a0,800022f2 <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800022de:	85de                	mv	a1,s7
    800022e0:	854a                	mv	a0,s2
    800022e2:	ccbff0ef          	jal	80001fac <sleep>
    havekids = 0;
    800022e6:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800022e8:	00011497          	auipc	s1,0x11
    800022ec:	89848493          	addi	s1,s1,-1896 # 80012b80 <proc>
    800022f0:	b7e1                	j	800022b8 <wait+0xaa>
      release(&wait_lock);
    800022f2:	00010517          	auipc	a0,0x10
    800022f6:	47650513          	addi	a0,a0,1142 # 80012768 <wait_lock>
    800022fa:	999fe0ef          	jal	80000c92 <release>
      return -1;
    800022fe:	59fd                	li	s3,-1
    80002300:	b749                	j	80002282 <wait+0x74>

0000000080002302 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002302:	7179                	addi	sp,sp,-48
    80002304:	f406                	sd	ra,40(sp)
    80002306:	f022                	sd	s0,32(sp)
    80002308:	ec26                	sd	s1,24(sp)
    8000230a:	e84a                	sd	s2,16(sp)
    8000230c:	e44e                	sd	s3,8(sp)
    8000230e:	e052                	sd	s4,0(sp)
    80002310:	1800                	addi	s0,sp,48
    80002312:	84aa                	mv	s1,a0
    80002314:	892e                	mv	s2,a1
    80002316:	89b2                	mv	s3,a2
    80002318:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000231a:	dc2ff0ef          	jal	800018dc <myproc>
  if(user_dst){
    8000231e:	cc99                	beqz	s1,8000233c <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002320:	86d2                	mv	a3,s4
    80002322:	864e                	mv	a2,s3
    80002324:	85ca                	mv	a1,s2
    80002326:	6928                	ld	a0,80(a0)
    80002328:	a5cff0ef          	jal	80001584 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000232c:	70a2                	ld	ra,40(sp)
    8000232e:	7402                	ld	s0,32(sp)
    80002330:	64e2                	ld	s1,24(sp)
    80002332:	6942                	ld	s2,16(sp)
    80002334:	69a2                	ld	s3,8(sp)
    80002336:	6a02                	ld	s4,0(sp)
    80002338:	6145                	addi	sp,sp,48
    8000233a:	8082                	ret
    memmove((char *)dst, src, len);
    8000233c:	000a061b          	sext.w	a2,s4
    80002340:	85ce                	mv	a1,s3
    80002342:	854a                	mv	a0,s2
    80002344:	9effe0ef          	jal	80000d32 <memmove>
    return 0;
    80002348:	8526                	mv	a0,s1
    8000234a:	b7cd                	j	8000232c <either_copyout+0x2a>

000000008000234c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000234c:	7179                	addi	sp,sp,-48
    8000234e:	f406                	sd	ra,40(sp)
    80002350:	f022                	sd	s0,32(sp)
    80002352:	ec26                	sd	s1,24(sp)
    80002354:	e84a                	sd	s2,16(sp)
    80002356:	e44e                	sd	s3,8(sp)
    80002358:	e052                	sd	s4,0(sp)
    8000235a:	1800                	addi	s0,sp,48
    8000235c:	892a                	mv	s2,a0
    8000235e:	84ae                	mv	s1,a1
    80002360:	89b2                	mv	s3,a2
    80002362:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002364:	d78ff0ef          	jal	800018dc <myproc>
  if(user_src){
    80002368:	cc99                	beqz	s1,80002386 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000236a:	86d2                	mv	a3,s4
    8000236c:	864e                	mv	a2,s3
    8000236e:	85ca                	mv	a1,s2
    80002370:	6928                	ld	a0,80(a0)
    80002372:	ac2ff0ef          	jal	80001634 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002376:	70a2                	ld	ra,40(sp)
    80002378:	7402                	ld	s0,32(sp)
    8000237a:	64e2                	ld	s1,24(sp)
    8000237c:	6942                	ld	s2,16(sp)
    8000237e:	69a2                	ld	s3,8(sp)
    80002380:	6a02                	ld	s4,0(sp)
    80002382:	6145                	addi	sp,sp,48
    80002384:	8082                	ret
    memmove(dst, (char*)src, len);
    80002386:	000a061b          	sext.w	a2,s4
    8000238a:	85ce                	mv	a1,s3
    8000238c:	854a                	mv	a0,s2
    8000238e:	9a5fe0ef          	jal	80000d32 <memmove>
    return 0;
    80002392:	8526                	mv	a0,s1
    80002394:	b7cd                	j	80002376 <either_copyin+0x2a>

0000000080002396 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002396:	715d                	addi	sp,sp,-80
    80002398:	e486                	sd	ra,72(sp)
    8000239a:	e0a2                	sd	s0,64(sp)
    8000239c:	fc26                	sd	s1,56(sp)
    8000239e:	f84a                	sd	s2,48(sp)
    800023a0:	f44e                	sd	s3,40(sp)
    800023a2:	f052                	sd	s4,32(sp)
    800023a4:	ec56                	sd	s5,24(sp)
    800023a6:	e85a                	sd	s6,16(sp)
    800023a8:	e45e                	sd	s7,8(sp)
    800023aa:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800023ac:	00005517          	auipc	a0,0x5
    800023b0:	ccc50513          	addi	a0,a0,-820 # 80007078 <etext+0x78>
    800023b4:	91afe0ef          	jal	800004ce <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800023b8:	00011497          	auipc	s1,0x11
    800023bc:	92048493          	addi	s1,s1,-1760 # 80012cd8 <proc+0x158>
    800023c0:	00017917          	auipc	s2,0x17
    800023c4:	b1890913          	addi	s2,s2,-1256 # 80018ed8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023c8:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800023ca:	00005997          	auipc	s3,0x5
    800023ce:	f3e98993          	addi	s3,s3,-194 # 80007308 <etext+0x308>
    printf("%d %s %s", p->pid, state, p->name);
    800023d2:	00005a97          	auipc	s5,0x5
    800023d6:	f3ea8a93          	addi	s5,s5,-194 # 80007310 <etext+0x310>
    printf("\n");
    800023da:	00005a17          	auipc	s4,0x5
    800023de:	c9ea0a13          	addi	s4,s4,-866 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023e2:	00005b97          	auipc	s7,0x5
    800023e6:	40eb8b93          	addi	s7,s7,1038 # 800077f0 <states.0>
    800023ea:	a829                	j	80002404 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800023ec:	ed86a583          	lw	a1,-296(a3)
    800023f0:	8556                	mv	a0,s5
    800023f2:	8dcfe0ef          	jal	800004ce <printf>
    printf("\n");
    800023f6:	8552                	mv	a0,s4
    800023f8:	8d6fe0ef          	jal	800004ce <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800023fc:	18848493          	addi	s1,s1,392
    80002400:	03248263          	beq	s1,s2,80002424 <procdump+0x8e>
    if(p->state == UNUSED)
    80002404:	86a6                	mv	a3,s1
    80002406:	ec04a783          	lw	a5,-320(s1)
    8000240a:	dbed                	beqz	a5,800023fc <procdump+0x66>
      state = "???";
    8000240c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000240e:	fcfb6fe3          	bltu	s6,a5,800023ec <procdump+0x56>
    80002412:	02079713          	slli	a4,a5,0x20
    80002416:	01d75793          	srli	a5,a4,0x1d
    8000241a:	97de                	add	a5,a5,s7
    8000241c:	6390                	ld	a2,0(a5)
    8000241e:	f679                	bnez	a2,800023ec <procdump+0x56>
      state = "???";
    80002420:	864e                	mv	a2,s3
    80002422:	b7e9                	j	800023ec <procdump+0x56>
  }
}
    80002424:	60a6                	ld	ra,72(sp)
    80002426:	6406                	ld	s0,64(sp)
    80002428:	74e2                	ld	s1,56(sp)
    8000242a:	7942                	ld	s2,48(sp)
    8000242c:	79a2                	ld	s3,40(sp)
    8000242e:	7a02                	ld	s4,32(sp)
    80002430:	6ae2                	ld	s5,24(sp)
    80002432:	6b42                	ld	s6,16(sp)
    80002434:	6ba2                	ld	s7,8(sp)
    80002436:	6161                	addi	sp,sp,80
    80002438:	8082                	ret

000000008000243a <swtch>:
    8000243a:	00153023          	sd	ra,0(a0)
    8000243e:	00253423          	sd	sp,8(a0)
    80002442:	e900                	sd	s0,16(a0)
    80002444:	ed04                	sd	s1,24(a0)
    80002446:	03253023          	sd	s2,32(a0)
    8000244a:	03353423          	sd	s3,40(a0)
    8000244e:	03453823          	sd	s4,48(a0)
    80002452:	03553c23          	sd	s5,56(a0)
    80002456:	05653023          	sd	s6,64(a0)
    8000245a:	05753423          	sd	s7,72(a0)
    8000245e:	05853823          	sd	s8,80(a0)
    80002462:	05953c23          	sd	s9,88(a0)
    80002466:	07a53023          	sd	s10,96(a0)
    8000246a:	07b53423          	sd	s11,104(a0)
    8000246e:	0005b083          	ld	ra,0(a1)
    80002472:	0085b103          	ld	sp,8(a1)
    80002476:	6980                	ld	s0,16(a1)
    80002478:	6d84                	ld	s1,24(a1)
    8000247a:	0205b903          	ld	s2,32(a1)
    8000247e:	0285b983          	ld	s3,40(a1)
    80002482:	0305ba03          	ld	s4,48(a1)
    80002486:	0385ba83          	ld	s5,56(a1)
    8000248a:	0405bb03          	ld	s6,64(a1)
    8000248e:	0485bb83          	ld	s7,72(a1)
    80002492:	0505bc03          	ld	s8,80(a1)
    80002496:	0585bc83          	ld	s9,88(a1)
    8000249a:	0605bd03          	ld	s10,96(a1)
    8000249e:	0685bd83          	ld	s11,104(a1)
    800024a2:	8082                	ret

00000000800024a4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800024a4:	1141                	addi	sp,sp,-16
    800024a6:	e406                	sd	ra,8(sp)
    800024a8:	e022                	sd	s0,0(sp)
    800024aa:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800024ac:	00005597          	auipc	a1,0x5
    800024b0:	ea458593          	addi	a1,a1,-348 # 80007350 <etext+0x350>
    800024b4:	00017517          	auipc	a0,0x17
    800024b8:	8cc50513          	addi	a0,a0,-1844 # 80018d80 <tickslock>
    800024bc:	ebefe0ef          	jal	80000b7a <initlock>
}
    800024c0:	60a2                	ld	ra,8(sp)
    800024c2:	6402                	ld	s0,0(sp)
    800024c4:	0141                	addi	sp,sp,16
    800024c6:	8082                	ret

00000000800024c8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800024c8:	1141                	addi	sp,sp,-16
    800024ca:	e406                	sd	ra,8(sp)
    800024cc:	e022                	sd	s0,0(sp)
    800024ce:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024d0:	00003797          	auipc	a5,0x3
    800024d4:	09078793          	addi	a5,a5,144 # 80005560 <kernelvec>
    800024d8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800024dc:	60a2                	ld	ra,8(sp)
    800024de:	6402                	ld	s0,0(sp)
    800024e0:	0141                	addi	sp,sp,16
    800024e2:	8082                	ret

00000000800024e4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800024e4:	1141                	addi	sp,sp,-16
    800024e6:	e406                	sd	ra,8(sp)
    800024e8:	e022                	sd	s0,0(sp)
    800024ea:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800024ec:	bf0ff0ef          	jal	800018dc <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024f0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800024f4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024f6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800024fa:	00004697          	auipc	a3,0x4
    800024fe:	b0668693          	addi	a3,a3,-1274 # 80006000 <_trampoline>
    80002502:	00004717          	auipc	a4,0x4
    80002506:	afe70713          	addi	a4,a4,-1282 # 80006000 <_trampoline>
    8000250a:	8f15                	sub	a4,a4,a3
    8000250c:	040007b7          	lui	a5,0x4000
    80002510:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002512:	07b2                	slli	a5,a5,0xc
    80002514:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002516:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000251a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000251c:	18002673          	csrr	a2,satp
    80002520:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002522:	6d30                	ld	a2,88(a0)
    80002524:	6138                	ld	a4,64(a0)
    80002526:	6585                	lui	a1,0x1
    80002528:	972e                	add	a4,a4,a1
    8000252a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000252c:	6d38                	ld	a4,88(a0)
    8000252e:	00000617          	auipc	a2,0x0
    80002532:	11060613          	addi	a2,a2,272 # 8000263e <usertrap>
    80002536:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002538:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000253a:	8612                	mv	a2,tp
    8000253c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000253e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002542:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002546:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000254a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000254e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002550:	6f18                	ld	a4,24(a4)
    80002552:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002556:	6928                	ld	a0,80(a0)
    80002558:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000255a:	00004717          	auipc	a4,0x4
    8000255e:	b4270713          	addi	a4,a4,-1214 # 8000609c <userret>
    80002562:	8f15                	sub	a4,a4,a3
    80002564:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002566:	577d                	li	a4,-1
    80002568:	177e                	slli	a4,a4,0x3f
    8000256a:	8d59                	or	a0,a0,a4
    8000256c:	9782                	jalr	a5
}
    8000256e:	60a2                	ld	ra,8(sp)
    80002570:	6402                	ld	s0,0(sp)
    80002572:	0141                	addi	sp,sp,16
    80002574:	8082                	ret

0000000080002576 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002576:	1101                	addi	sp,sp,-32
    80002578:	ec06                	sd	ra,24(sp)
    8000257a:	e822                	sd	s0,16(sp)
    8000257c:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000257e:	b2aff0ef          	jal	800018a8 <cpuid>
    80002582:	cd11                	beqz	a0,8000259e <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002584:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002588:	000f4737          	lui	a4,0xf4
    8000258c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002590:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002592:	14d79073          	csrw	stimecmp,a5
}
    80002596:	60e2                	ld	ra,24(sp)
    80002598:	6442                	ld	s0,16(sp)
    8000259a:	6105                	addi	sp,sp,32
    8000259c:	8082                	ret
    8000259e:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800025a0:	00016497          	auipc	s1,0x16
    800025a4:	7e048493          	addi	s1,s1,2016 # 80018d80 <tickslock>
    800025a8:	8526                	mv	a0,s1
    800025aa:	e54fe0ef          	jal	80000bfe <acquire>
    ticks++;
    800025ae:	00008517          	auipc	a0,0x8
    800025b2:	07a50513          	addi	a0,a0,122 # 8000a628 <ticks>
    800025b6:	411c                	lw	a5,0(a0)
    800025b8:	2785                	addiw	a5,a5,1
    800025ba:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800025bc:	a3dff0ef          	jal	80001ff8 <wakeup>
    release(&tickslock);
    800025c0:	8526                	mv	a0,s1
    800025c2:	ed0fe0ef          	jal	80000c92 <release>
    800025c6:	64a2                	ld	s1,8(sp)
    800025c8:	bf75                	j	80002584 <clockintr+0xe>

00000000800025ca <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800025ca:	1101                	addi	sp,sp,-32
    800025cc:	ec06                	sd	ra,24(sp)
    800025ce:	e822                	sd	s0,16(sp)
    800025d0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025d2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800025d6:	57fd                	li	a5,-1
    800025d8:	17fe                	slli	a5,a5,0x3f
    800025da:	07a5                	addi	a5,a5,9
    800025dc:	00f70c63          	beq	a4,a5,800025f4 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800025e0:	57fd                	li	a5,-1
    800025e2:	17fe                	slli	a5,a5,0x3f
    800025e4:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800025e6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800025e8:	04f70763          	beq	a4,a5,80002636 <devintr+0x6c>
  }
}
    800025ec:	60e2                	ld	ra,24(sp)
    800025ee:	6442                	ld	s0,16(sp)
    800025f0:	6105                	addi	sp,sp,32
    800025f2:	8082                	ret
    800025f4:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800025f6:	016030ef          	jal	8000560c <plic_claim>
    800025fa:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800025fc:	47a9                	li	a5,10
    800025fe:	00f50963          	beq	a0,a5,80002610 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002602:	4785                	li	a5,1
    80002604:	00f50963          	beq	a0,a5,80002616 <devintr+0x4c>
    return 1;
    80002608:	4505                	li	a0,1
    } else if(irq){
    8000260a:	e889                	bnez	s1,8000261c <devintr+0x52>
    8000260c:	64a2                	ld	s1,8(sp)
    8000260e:	bff9                	j	800025ec <devintr+0x22>
      uartintr();
    80002610:	bfcfe0ef          	jal	80000a0c <uartintr>
    if(irq)
    80002614:	a819                	j	8000262a <devintr+0x60>
      virtio_disk_intr();
    80002616:	486030ef          	jal	80005a9c <virtio_disk_intr>
    if(irq)
    8000261a:	a801                	j	8000262a <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    8000261c:	85a6                	mv	a1,s1
    8000261e:	00005517          	auipc	a0,0x5
    80002622:	d3a50513          	addi	a0,a0,-710 # 80007358 <etext+0x358>
    80002626:	ea9fd0ef          	jal	800004ce <printf>
      plic_complete(irq);
    8000262a:	8526                	mv	a0,s1
    8000262c:	000030ef          	jal	8000562c <plic_complete>
    return 1;
    80002630:	4505                	li	a0,1
    80002632:	64a2                	ld	s1,8(sp)
    80002634:	bf65                	j	800025ec <devintr+0x22>
    clockintr();
    80002636:	f41ff0ef          	jal	80002576 <clockintr>
    return 2;
    8000263a:	4509                	li	a0,2
    8000263c:	bf45                	j	800025ec <devintr+0x22>

000000008000263e <usertrap>:
{
    8000263e:	1101                	addi	sp,sp,-32
    80002640:	ec06                	sd	ra,24(sp)
    80002642:	e822                	sd	s0,16(sp)
    80002644:	e426                	sd	s1,8(sp)
    80002646:	e04a                	sd	s2,0(sp)
    80002648:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000264a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000264e:	1007f793          	andi	a5,a5,256
    80002652:	e7b1                	bnez	a5,8000269e <usertrap+0x60>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002654:	00003797          	auipc	a5,0x3
    80002658:	f0c78793          	addi	a5,a5,-244 # 80005560 <kernelvec>
    8000265c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002660:	a7cff0ef          	jal	800018dc <myproc>
    80002664:	84aa                	mv	s1,a0
  p->trapcount++;
    80002666:	16852783          	lw	a5,360(a0)
    8000266a:	2785                	addiw	a5,a5,1
    8000266c:	16f52423          	sw	a5,360(a0)
  p->trapframe->epc = r_sepc();
    80002670:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002672:	14102773          	csrr	a4,sepc
    80002676:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002678:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000267c:	47a1                	li	a5,8
    8000267e:	02f70663          	beq	a4,a5,800026aa <usertrap+0x6c>
  } else if((which_dev = devintr()) != 0){
    80002682:	f49ff0ef          	jal	800025ca <devintr>
    80002686:	892a                	mv	s2,a0
    80002688:	cd25                	beqz	a0,80002700 <usertrap+0xc2>
    p->devintcount++; // The number of hardware/device interrupts occurrences
    8000268a:	1704a783          	lw	a5,368(s1)
    8000268e:	2785                	addiw	a5,a5,1
    80002690:	16f4a823          	sw	a5,368(s1)
  if(killed(p))
    80002694:	8526                	mv	a0,s1
    80002696:	b4fff0ef          	jal	800021e4 <killed>
    8000269a:	c521                	beqz	a0,800026e2 <usertrap+0xa4>
    8000269c:	a081                	j	800026dc <usertrap+0x9e>
    panic("usertrap: not from user mode");
    8000269e:	00005517          	auipc	a0,0x5
    800026a2:	cda50513          	addi	a0,a0,-806 # 80007378 <etext+0x378>
    800026a6:	8f8fe0ef          	jal	8000079e <panic>
    p->syscallcount++; //count the number of system calls
    800026aa:	16c52783          	lw	a5,364(a0)
    800026ae:	2785                	addiw	a5,a5,1
    800026b0:	16f52623          	sw	a5,364(a0)
    if(killed(p))
    800026b4:	b31ff0ef          	jal	800021e4 <killed>
    800026b8:	e121                	bnez	a0,800026f8 <usertrap+0xba>
    p->trapframe->epc += 4;
    800026ba:	6cb8                	ld	a4,88(s1)
    800026bc:	6f1c                	ld	a5,24(a4)
    800026be:	0791                	addi	a5,a5,4
    800026c0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026c2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800026c6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026ca:	10079073          	csrw	sstatus,a5
    syscall();
    800026ce:	24a000ef          	jal	80002918 <syscall>
  if(killed(p))
    800026d2:	8526                	mv	a0,s1
    800026d4:	b11ff0ef          	jal	800021e4 <killed>
    800026d8:	c901                	beqz	a0,800026e8 <usertrap+0xaa>
    800026da:	4901                	li	s2,0
    exit(-1);
    800026dc:	557d                	li	a0,-1
    800026de:	9dbff0ef          	jal	800020b8 <exit>
  if(which_dev == 2) {
    800026e2:	4789                	li	a5,2
    800026e4:	04f90563          	beq	s2,a5,8000272e <usertrap+0xf0>
  usertrapret();
    800026e8:	dfdff0ef          	jal	800024e4 <usertrapret>
}
    800026ec:	60e2                	ld	ra,24(sp)
    800026ee:	6442                	ld	s0,16(sp)
    800026f0:	64a2                	ld	s1,8(sp)
    800026f2:	6902                	ld	s2,0(sp)
    800026f4:	6105                	addi	sp,sp,32
    800026f6:	8082                	ret
      exit(-1);
    800026f8:	557d                	li	a0,-1
    800026fa:	9bfff0ef          	jal	800020b8 <exit>
    800026fe:	bf75                	j	800026ba <usertrap+0x7c>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002700:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002704:	5890                	lw	a2,48(s1)
    80002706:	00005517          	auipc	a0,0x5
    8000270a:	c9250513          	addi	a0,a0,-878 # 80007398 <etext+0x398>
    8000270e:	dc1fd0ef          	jal	800004ce <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002712:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002716:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000271a:	00005517          	auipc	a0,0x5
    8000271e:	cae50513          	addi	a0,a0,-850 # 800073c8 <etext+0x3c8>
    80002722:	dadfd0ef          	jal	800004ce <printf>
    setkilled(p);
    80002726:	8526                	mv	a0,s1
    80002728:	a99ff0ef          	jal	800021c0 <setkilled>
    8000272c:	b75d                	j	800026d2 <usertrap+0x94>
    p->timerintcount++; // the number of timer interrupts
    8000272e:	1744a783          	lw	a5,372(s1)
    80002732:	2785                	addiw	a5,a5,1
    80002734:	16f4aa23          	sw	a5,372(s1)
    yield();
    80002738:	849ff0ef          	jal	80001f80 <yield>
    8000273c:	b775                	j	800026e8 <usertrap+0xaa>

000000008000273e <kerneltrap>:
{
    8000273e:	7179                	addi	sp,sp,-48
    80002740:	f406                	sd	ra,40(sp)
    80002742:	f022                	sd	s0,32(sp)
    80002744:	ec26                	sd	s1,24(sp)
    80002746:	e84a                	sd	s2,16(sp)
    80002748:	e44e                	sd	s3,8(sp)
    8000274a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000274c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002750:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002754:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002758:	1004f793          	andi	a5,s1,256
    8000275c:	c795                	beqz	a5,80002788 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000275e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002762:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002764:	eb85                	bnez	a5,80002794 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002766:	e65ff0ef          	jal	800025ca <devintr>
    8000276a:	c91d                	beqz	a0,800027a0 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    8000276c:	4789                	li	a5,2
    8000276e:	04f50a63          	beq	a0,a5,800027c2 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002772:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002776:	10049073          	csrw	sstatus,s1
}
    8000277a:	70a2                	ld	ra,40(sp)
    8000277c:	7402                	ld	s0,32(sp)
    8000277e:	64e2                	ld	s1,24(sp)
    80002780:	6942                	ld	s2,16(sp)
    80002782:	69a2                	ld	s3,8(sp)
    80002784:	6145                	addi	sp,sp,48
    80002786:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002788:	00005517          	auipc	a0,0x5
    8000278c:	c6850513          	addi	a0,a0,-920 # 800073f0 <etext+0x3f0>
    80002790:	80efe0ef          	jal	8000079e <panic>
    panic("kerneltrap: interrupts enabled");
    80002794:	00005517          	auipc	a0,0x5
    80002798:	c8450513          	addi	a0,a0,-892 # 80007418 <etext+0x418>
    8000279c:	802fe0ef          	jal	8000079e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027a0:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800027a4:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800027a8:	85ce                	mv	a1,s3
    800027aa:	00005517          	auipc	a0,0x5
    800027ae:	c8e50513          	addi	a0,a0,-882 # 80007438 <etext+0x438>
    800027b2:	d1dfd0ef          	jal	800004ce <printf>
    panic("kerneltrap");
    800027b6:	00005517          	auipc	a0,0x5
    800027ba:	caa50513          	addi	a0,a0,-854 # 80007460 <etext+0x460>
    800027be:	fe1fd0ef          	jal	8000079e <panic>
  if(which_dev == 2 && myproc() != 0)
    800027c2:	91aff0ef          	jal	800018dc <myproc>
    800027c6:	d555                	beqz	a0,80002772 <kerneltrap+0x34>
    yield();
    800027c8:	fb8ff0ef          	jal	80001f80 <yield>
    800027cc:	b75d                	j	80002772 <kerneltrap+0x34>

00000000800027ce <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800027ce:	1101                	addi	sp,sp,-32
    800027d0:	ec06                	sd	ra,24(sp)
    800027d2:	e822                	sd	s0,16(sp)
    800027d4:	e426                	sd	s1,8(sp)
    800027d6:	1000                	addi	s0,sp,32
    800027d8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800027da:	902ff0ef          	jal	800018dc <myproc>
  switch (n) {
    800027de:	4795                	li	a5,5
    800027e0:	0497e163          	bltu	a5,s1,80002822 <argraw+0x54>
    800027e4:	048a                	slli	s1,s1,0x2
    800027e6:	00005717          	auipc	a4,0x5
    800027ea:	03a70713          	addi	a4,a4,58 # 80007820 <states.0+0x30>
    800027ee:	94ba                	add	s1,s1,a4
    800027f0:	409c                	lw	a5,0(s1)
    800027f2:	97ba                	add	a5,a5,a4
    800027f4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800027f6:	6d3c                	ld	a5,88(a0)
    800027f8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800027fa:	60e2                	ld	ra,24(sp)
    800027fc:	6442                	ld	s0,16(sp)
    800027fe:	64a2                	ld	s1,8(sp)
    80002800:	6105                	addi	sp,sp,32
    80002802:	8082                	ret
    return p->trapframe->a1;
    80002804:	6d3c                	ld	a5,88(a0)
    80002806:	7fa8                	ld	a0,120(a5)
    80002808:	bfcd                	j	800027fa <argraw+0x2c>
    return p->trapframe->a2;
    8000280a:	6d3c                	ld	a5,88(a0)
    8000280c:	63c8                	ld	a0,128(a5)
    8000280e:	b7f5                	j	800027fa <argraw+0x2c>
    return p->trapframe->a3;
    80002810:	6d3c                	ld	a5,88(a0)
    80002812:	67c8                	ld	a0,136(a5)
    80002814:	b7dd                	j	800027fa <argraw+0x2c>
    return p->trapframe->a4;
    80002816:	6d3c                	ld	a5,88(a0)
    80002818:	6bc8                	ld	a0,144(a5)
    8000281a:	b7c5                	j	800027fa <argraw+0x2c>
    return p->trapframe->a5;
    8000281c:	6d3c                	ld	a5,88(a0)
    8000281e:	6fc8                	ld	a0,152(a5)
    80002820:	bfe9                	j	800027fa <argraw+0x2c>
  panic("argraw");
    80002822:	00005517          	auipc	a0,0x5
    80002826:	c4e50513          	addi	a0,a0,-946 # 80007470 <etext+0x470>
    8000282a:	f75fd0ef          	jal	8000079e <panic>

000000008000282e <fetchaddr>:
{
    8000282e:	1101                	addi	sp,sp,-32
    80002830:	ec06                	sd	ra,24(sp)
    80002832:	e822                	sd	s0,16(sp)
    80002834:	e426                	sd	s1,8(sp)
    80002836:	e04a                	sd	s2,0(sp)
    80002838:	1000                	addi	s0,sp,32
    8000283a:	84aa                	mv	s1,a0
    8000283c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000283e:	89eff0ef          	jal	800018dc <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002842:	653c                	ld	a5,72(a0)
    80002844:	02f4f663          	bgeu	s1,a5,80002870 <fetchaddr+0x42>
    80002848:	00848713          	addi	a4,s1,8
    8000284c:	02e7e463          	bltu	a5,a4,80002874 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002850:	46a1                	li	a3,8
    80002852:	8626                	mv	a2,s1
    80002854:	85ca                	mv	a1,s2
    80002856:	6928                	ld	a0,80(a0)
    80002858:	dddfe0ef          	jal	80001634 <copyin>
    8000285c:	00a03533          	snez	a0,a0
    80002860:	40a0053b          	negw	a0,a0
}
    80002864:	60e2                	ld	ra,24(sp)
    80002866:	6442                	ld	s0,16(sp)
    80002868:	64a2                	ld	s1,8(sp)
    8000286a:	6902                	ld	s2,0(sp)
    8000286c:	6105                	addi	sp,sp,32
    8000286e:	8082                	ret
    return -1;
    80002870:	557d                	li	a0,-1
    80002872:	bfcd                	j	80002864 <fetchaddr+0x36>
    80002874:	557d                	li	a0,-1
    80002876:	b7fd                	j	80002864 <fetchaddr+0x36>

0000000080002878 <fetchstr>:
{
    80002878:	7179                	addi	sp,sp,-48
    8000287a:	f406                	sd	ra,40(sp)
    8000287c:	f022                	sd	s0,32(sp)
    8000287e:	ec26                	sd	s1,24(sp)
    80002880:	e84a                	sd	s2,16(sp)
    80002882:	e44e                	sd	s3,8(sp)
    80002884:	1800                	addi	s0,sp,48
    80002886:	892a                	mv	s2,a0
    80002888:	84ae                	mv	s1,a1
    8000288a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000288c:	850ff0ef          	jal	800018dc <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002890:	86ce                	mv	a3,s3
    80002892:	864a                	mv	a2,s2
    80002894:	85a6                	mv	a1,s1
    80002896:	6928                	ld	a0,80(a0)
    80002898:	e23fe0ef          	jal	800016ba <copyinstr>
    8000289c:	00054c63          	bltz	a0,800028b4 <fetchstr+0x3c>
  return strlen(buf);
    800028a0:	8526                	mv	a0,s1
    800028a2:	db4fe0ef          	jal	80000e56 <strlen>
}
    800028a6:	70a2                	ld	ra,40(sp)
    800028a8:	7402                	ld	s0,32(sp)
    800028aa:	64e2                	ld	s1,24(sp)
    800028ac:	6942                	ld	s2,16(sp)
    800028ae:	69a2                	ld	s3,8(sp)
    800028b0:	6145                	addi	sp,sp,48
    800028b2:	8082                	ret
    return -1;
    800028b4:	557d                	li	a0,-1
    800028b6:	bfc5                	j	800028a6 <fetchstr+0x2e>

00000000800028b8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800028b8:	1101                	addi	sp,sp,-32
    800028ba:	ec06                	sd	ra,24(sp)
    800028bc:	e822                	sd	s0,16(sp)
    800028be:	e426                	sd	s1,8(sp)
    800028c0:	1000                	addi	s0,sp,32
    800028c2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800028c4:	f0bff0ef          	jal	800027ce <argraw>
    800028c8:	c088                	sw	a0,0(s1)
}
    800028ca:	60e2                	ld	ra,24(sp)
    800028cc:	6442                	ld	s0,16(sp)
    800028ce:	64a2                	ld	s1,8(sp)
    800028d0:	6105                	addi	sp,sp,32
    800028d2:	8082                	ret

00000000800028d4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800028d4:	1101                	addi	sp,sp,-32
    800028d6:	ec06                	sd	ra,24(sp)
    800028d8:	e822                	sd	s0,16(sp)
    800028da:	e426                	sd	s1,8(sp)
    800028dc:	1000                	addi	s0,sp,32
    800028de:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800028e0:	eefff0ef          	jal	800027ce <argraw>
    800028e4:	e088                	sd	a0,0(s1)
}
    800028e6:	60e2                	ld	ra,24(sp)
    800028e8:	6442                	ld	s0,16(sp)
    800028ea:	64a2                	ld	s1,8(sp)
    800028ec:	6105                	addi	sp,sp,32
    800028ee:	8082                	ret

00000000800028f0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800028f0:	1101                	addi	sp,sp,-32
    800028f2:	ec06                	sd	ra,24(sp)
    800028f4:	e822                	sd	s0,16(sp)
    800028f6:	e426                	sd	s1,8(sp)
    800028f8:	e04a                	sd	s2,0(sp)
    800028fa:	1000                	addi	s0,sp,32
    800028fc:	84ae                	mv	s1,a1
    800028fe:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002900:	ecfff0ef          	jal	800027ce <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002904:	864a                	mv	a2,s2
    80002906:	85a6                	mv	a1,s1
    80002908:	f71ff0ef          	jal	80002878 <fetchstr>
}
    8000290c:	60e2                	ld	ra,24(sp)
    8000290e:	6442                	ld	s0,16(sp)
    80002910:	64a2                	ld	s1,8(sp)
    80002912:	6902                	ld	s2,0(sp)
    80002914:	6105                	addi	sp,sp,32
    80002916:	8082                	ret

0000000080002918 <syscall>:
[SYS_stopcfs] sys_stopcfs,
};

void
syscall(void)
{
    80002918:	1101                	addi	sp,sp,-32
    8000291a:	ec06                	sd	ra,24(sp)
    8000291c:	e822                	sd	s0,16(sp)
    8000291e:	e426                	sd	s1,8(sp)
    80002920:	e04a                	sd	s2,0(sp)
    80002922:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002924:	fb9fe0ef          	jal	800018dc <myproc>
    80002928:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000292a:	05853903          	ld	s2,88(a0)
    8000292e:	0a893783          	ld	a5,168(s2)
    80002932:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002936:	37fd                	addiw	a5,a5,-1
    80002938:	4771                	li	a4,28
    8000293a:	00f76f63          	bltu	a4,a5,80002958 <syscall+0x40>
    8000293e:	00369713          	slli	a4,a3,0x3
    80002942:	00005797          	auipc	a5,0x5
    80002946:	ef678793          	addi	a5,a5,-266 # 80007838 <syscalls>
    8000294a:	97ba                	add	a5,a5,a4
    8000294c:	639c                	ld	a5,0(a5)
    8000294e:	c789                	beqz	a5,80002958 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002950:	9782                	jalr	a5
    80002952:	06a93823          	sd	a0,112(s2)
    80002956:	a829                	j	80002970 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002958:	15848613          	addi	a2,s1,344
    8000295c:	588c                	lw	a1,48(s1)
    8000295e:	00005517          	auipc	a0,0x5
    80002962:	b1a50513          	addi	a0,a0,-1254 # 80007478 <etext+0x478>
    80002966:	b69fd0ef          	jal	800004ce <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000296a:	6cbc                	ld	a5,88(s1)
    8000296c:	577d                	li	a4,-1
    8000296e:	fbb8                	sd	a4,112(a5)
  }
}
    80002970:	60e2                	ld	ra,24(sp)
    80002972:	6442                	ld	s0,16(sp)
    80002974:	64a2                	ld	s1,8(sp)
    80002976:	6902                	ld	s2,0(sp)
    80002978:	6105                	addi	sp,sp,32
    8000297a:	8082                	ret

000000008000297c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000297c:	1101                	addi	sp,sp,-32
    8000297e:	ec06                	sd	ra,24(sp)
    80002980:	e822                	sd	s0,16(sp)
    80002982:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002984:	fec40593          	addi	a1,s0,-20
    80002988:	4501                	li	a0,0
    8000298a:	f2fff0ef          	jal	800028b8 <argint>
  exit(n);
    8000298e:	fec42503          	lw	a0,-20(s0)
    80002992:	f26ff0ef          	jal	800020b8 <exit>
  return 0;  // not reached
}
    80002996:	4501                	li	a0,0
    80002998:	60e2                	ld	ra,24(sp)
    8000299a:	6442                	ld	s0,16(sp)
    8000299c:	6105                	addi	sp,sp,32
    8000299e:	8082                	ret

00000000800029a0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800029a0:	1141                	addi	sp,sp,-16
    800029a2:	e406                	sd	ra,8(sp)
    800029a4:	e022                	sd	s0,0(sp)
    800029a6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800029a8:	f35fe0ef          	jal	800018dc <myproc>
}
    800029ac:	5908                	lw	a0,48(a0)
    800029ae:	60a2                	ld	ra,8(sp)
    800029b0:	6402                	ld	s0,0(sp)
    800029b2:	0141                	addi	sp,sp,16
    800029b4:	8082                	ret

00000000800029b6 <sys_fork>:

uint64
sys_fork(void)
{
    800029b6:	1141                	addi	sp,sp,-16
    800029b8:	e406                	sd	ra,8(sp)
    800029ba:	e022                	sd	s0,0(sp)
    800029bc:	0800                	addi	s0,sp,16
  return fork();
    800029be:	a60ff0ef          	jal	80001c1e <fork>
}
    800029c2:	60a2                	ld	ra,8(sp)
    800029c4:	6402                	ld	s0,0(sp)
    800029c6:	0141                	addi	sp,sp,16
    800029c8:	8082                	ret

00000000800029ca <sys_wait>:

uint64
sys_wait(void)
{
    800029ca:	1101                	addi	sp,sp,-32
    800029cc:	ec06                	sd	ra,24(sp)
    800029ce:	e822                	sd	s0,16(sp)
    800029d0:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800029d2:	fe840593          	addi	a1,s0,-24
    800029d6:	4501                	li	a0,0
    800029d8:	efdff0ef          	jal	800028d4 <argaddr>
  return wait(p);
    800029dc:	fe843503          	ld	a0,-24(s0)
    800029e0:	82fff0ef          	jal	8000220e <wait>
}
    800029e4:	60e2                	ld	ra,24(sp)
    800029e6:	6442                	ld	s0,16(sp)
    800029e8:	6105                	addi	sp,sp,32
    800029ea:	8082                	ret

00000000800029ec <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800029ec:	7179                	addi	sp,sp,-48
    800029ee:	f406                	sd	ra,40(sp)
    800029f0:	f022                	sd	s0,32(sp)
    800029f2:	ec26                	sd	s1,24(sp)
    800029f4:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800029f6:	fdc40593          	addi	a1,s0,-36
    800029fa:	4501                	li	a0,0
    800029fc:	ebdff0ef          	jal	800028b8 <argint>
  addr = myproc()->sz;
    80002a00:	eddfe0ef          	jal	800018dc <myproc>
    80002a04:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002a06:	fdc42503          	lw	a0,-36(s0)
    80002a0a:	9c4ff0ef          	jal	80001bce <growproc>
    80002a0e:	00054863          	bltz	a0,80002a1e <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002a12:	8526                	mv	a0,s1
    80002a14:	70a2                	ld	ra,40(sp)
    80002a16:	7402                	ld	s0,32(sp)
    80002a18:	64e2                	ld	s1,24(sp)
    80002a1a:	6145                	addi	sp,sp,48
    80002a1c:	8082                	ret
    return -1;
    80002a1e:	54fd                	li	s1,-1
    80002a20:	bfcd                	j	80002a12 <sys_sbrk+0x26>

0000000080002a22 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002a22:	7139                	addi	sp,sp,-64
    80002a24:	fc06                	sd	ra,56(sp)
    80002a26:	f822                	sd	s0,48(sp)
    80002a28:	f04a                	sd	s2,32(sp)
    80002a2a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002a2c:	fcc40593          	addi	a1,s0,-52
    80002a30:	4501                	li	a0,0
    80002a32:	e87ff0ef          	jal	800028b8 <argint>
  if(n < 0)
    80002a36:	fcc42783          	lw	a5,-52(s0)
    80002a3a:	0607c763          	bltz	a5,80002aa8 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002a3e:	00016517          	auipc	a0,0x16
    80002a42:	34250513          	addi	a0,a0,834 # 80018d80 <tickslock>
    80002a46:	9b8fe0ef          	jal	80000bfe <acquire>
  ticks0 = ticks;
    80002a4a:	00008917          	auipc	s2,0x8
    80002a4e:	bde92903          	lw	s2,-1058(s2) # 8000a628 <ticks>
  while(ticks - ticks0 < n){
    80002a52:	fcc42783          	lw	a5,-52(s0)
    80002a56:	cf8d                	beqz	a5,80002a90 <sys_sleep+0x6e>
    80002a58:	f426                	sd	s1,40(sp)
    80002a5a:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002a5c:	00016997          	auipc	s3,0x16
    80002a60:	32498993          	addi	s3,s3,804 # 80018d80 <tickslock>
    80002a64:	00008497          	auipc	s1,0x8
    80002a68:	bc448493          	addi	s1,s1,-1084 # 8000a628 <ticks>
    if(killed(myproc())){
    80002a6c:	e71fe0ef          	jal	800018dc <myproc>
    80002a70:	f74ff0ef          	jal	800021e4 <killed>
    80002a74:	ed0d                	bnez	a0,80002aae <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002a76:	85ce                	mv	a1,s3
    80002a78:	8526                	mv	a0,s1
    80002a7a:	d32ff0ef          	jal	80001fac <sleep>
  while(ticks - ticks0 < n){
    80002a7e:	409c                	lw	a5,0(s1)
    80002a80:	412787bb          	subw	a5,a5,s2
    80002a84:	fcc42703          	lw	a4,-52(s0)
    80002a88:	fee7e2e3          	bltu	a5,a4,80002a6c <sys_sleep+0x4a>
    80002a8c:	74a2                	ld	s1,40(sp)
    80002a8e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002a90:	00016517          	auipc	a0,0x16
    80002a94:	2f050513          	addi	a0,a0,752 # 80018d80 <tickslock>
    80002a98:	9fafe0ef          	jal	80000c92 <release>
  return 0;
    80002a9c:	4501                	li	a0,0
}
    80002a9e:	70e2                	ld	ra,56(sp)
    80002aa0:	7442                	ld	s0,48(sp)
    80002aa2:	7902                	ld	s2,32(sp)
    80002aa4:	6121                	addi	sp,sp,64
    80002aa6:	8082                	ret
    n = 0;
    80002aa8:	fc042623          	sw	zero,-52(s0)
    80002aac:	bf49                	j	80002a3e <sys_sleep+0x1c>
      release(&tickslock);
    80002aae:	00016517          	auipc	a0,0x16
    80002ab2:	2d250513          	addi	a0,a0,722 # 80018d80 <tickslock>
    80002ab6:	9dcfe0ef          	jal	80000c92 <release>
      return -1;
    80002aba:	557d                	li	a0,-1
    80002abc:	74a2                	ld	s1,40(sp)
    80002abe:	69e2                	ld	s3,24(sp)
    80002ac0:	bff9                	j	80002a9e <sys_sleep+0x7c>

0000000080002ac2 <sys_kill>:

uint64
sys_kill(void)
{
    80002ac2:	1101                	addi	sp,sp,-32
    80002ac4:	ec06                	sd	ra,24(sp)
    80002ac6:	e822                	sd	s0,16(sp)
    80002ac8:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002aca:	fec40593          	addi	a1,s0,-20
    80002ace:	4501                	li	a0,0
    80002ad0:	de9ff0ef          	jal	800028b8 <argint>
  return kill(pid);
    80002ad4:	fec42503          	lw	a0,-20(s0)
    80002ad8:	e82ff0ef          	jal	8000215a <kill>
}
    80002adc:	60e2                	ld	ra,24(sp)
    80002ade:	6442                	ld	s0,16(sp)
    80002ae0:	6105                	addi	sp,sp,32
    80002ae2:	8082                	ret

0000000080002ae4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002ae4:	1101                	addi	sp,sp,-32
    80002ae6:	ec06                	sd	ra,24(sp)
    80002ae8:	e822                	sd	s0,16(sp)
    80002aea:	e426                	sd	s1,8(sp)
    80002aec:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002aee:	00016517          	auipc	a0,0x16
    80002af2:	29250513          	addi	a0,a0,658 # 80018d80 <tickslock>
    80002af6:	908fe0ef          	jal	80000bfe <acquire>
  xticks = ticks;
    80002afa:	00008497          	auipc	s1,0x8
    80002afe:	b2e4a483          	lw	s1,-1234(s1) # 8000a628 <ticks>
  release(&tickslock);
    80002b02:	00016517          	auipc	a0,0x16
    80002b06:	27e50513          	addi	a0,a0,638 # 80018d80 <tickslock>
    80002b0a:	988fe0ef          	jal	80000c92 <release>
  return xticks;
}
    80002b0e:	02049513          	slli	a0,s1,0x20
    80002b12:	9101                	srli	a0,a0,0x20
    80002b14:	60e2                	ld	ra,24(sp)
    80002b16:	6442                	ld	s0,16(sp)
    80002b18:	64a2                	ld	s1,8(sp)
    80002b1a:	6105                	addi	sp,sp,32
    80002b1c:	8082                	ret

0000000080002b1e <sys_getppid>:
// Project 1B >>>
//
// The handler for system call getppid
// Using myproc() function, it can retrieve a currently running process' PCB.
uint64
sys_getppid(void) {
    80002b1e:	1141                	addi	sp,sp,-16
    80002b20:	e406                	sd	ra,8(sp)
    80002b22:	e022                	sd	s0,0(sp)
    80002b24:	0800                	addi	s0,sp,16
  return myproc()->parent->pid;
    80002b26:	db7fe0ef          	jal	800018dc <myproc>
    80002b2a:	7d1c                	ld	a5,56(a0)
}
    80002b2c:	5b88                	lw	a0,48(a5)
    80002b2e:	60a2                	ld	ra,8(sp)
    80002b30:	6402                	ld	s0,0(sp)
    80002b32:	0141                	addi	sp,sp,16
    80002b34:	8082                	ret

0000000080002b36 <sys_getcpids>:

// The handler for system call getcpids
uint64
sys_getcpids(void) {
    80002b36:	715d                	addi	sp,sp,-80
    80002b38:	e486                	sd	ra,72(sp)
    80002b3a:	e0a2                	sd	s0,64(sp)
    80002b3c:	f44e                	sd	s3,40(sp)
    80002b3e:	0880                	addi	s0,sp,80
  // A variable that will hold an address of the given argument (a pointer to int)
  uint64 cparray;
  // nmax will hold the argument address (a pointer to an int)
  // nchild will be the number of all processes and returned at the end.
  int nmax, nchild = -1;
  struct proc *p = myproc();
    80002b40:	d9dfe0ef          	jal	800018dc <myproc>
    80002b44:	89aa                	mv	s3,a0
  
  argaddr(0, &cparray);
    80002b46:	fb840593          	addi	a1,s0,-72
    80002b4a:	4501                	li	a0,0
    80002b4c:	d89ff0ef          	jal	800028d4 <argaddr>
  argint(1, &nmax);
    80002b50:	fb440593          	addi	a1,s0,-76
    80002b54:	4505                	li	a0,1
    80002b56:	d63ff0ef          	jal	800028b8 <argint>
  //if the given max value was greater than the limt NPROC, return -1.
  if(nmax>NPROC||nmax<0) return -1;
    80002b5a:	fb442783          	lw	a5,-76(s0)
    80002b5e:	04000713          	li	a4,64
    80002b62:	557d                	li	a0,-1
    80002b64:	08f76163          	bltu	a4,a5,80002be6 <sys_getcpids+0xb0>

  // A new index, j used for cparray to effectively increment the sizeof(cpid)
  // gets incremented when current pid == processlist.ppid
  int j = 0;
  for(int i=0; i<nmax; i++){
    80002b68:	08f05463          	blez	a5,80002bf0 <sys_getcpids+0xba>
    80002b6c:	fc26                	sd	s1,56(sp)
    80002b6e:	f84a                	sd	s2,48(sp)
    80002b70:	f052                	sd	s4,32(sp)
    80002b72:	ec56                	sd	s5,24(sp)
    80002b74:	e85a                	sd	s6,16(sp)
    80002b76:	00010497          	auipc	s1,0x10
    80002b7a:	03a48493          	addi	s1,s1,58 # 80012bb0 <proc+0x30>
    80002b7e:	4901                	li	s2,0
  int j = 0;
    80002b80:	4a01                	li	s4,0
    if(proc[i].parent != 0) {
      int cpid = proc[i].pid;
      if(p->pid == proc[i].parent->pid) {
        // The j number of children having the common parent
        if(copyout(p->pagetable, cparray+sizeof(cpid)*j, (char*)&cpid, sizeof(cpid)) < 0){
    80002b82:	fb040b13          	addi	s6,s0,-80
    80002b86:	4a91                	li	s5,4
    80002b88:	a839                	j	80002ba6 <sys_getcpids+0x70>
          return -1;
    80002b8a:	557d                	li	a0,-1
    80002b8c:	74e2                	ld	s1,56(sp)
    80002b8e:	7942                	ld	s2,48(sp)
    80002b90:	7a02                	ld	s4,32(sp)
    80002b92:	6ae2                	ld	s5,24(sp)
    80002b94:	6b42                	ld	s6,16(sp)
    80002b96:	a881                	j	80002be6 <sys_getcpids+0xb0>
  for(int i=0; i<nmax; i++){
    80002b98:	2905                	addiw	s2,s2,1
    80002b9a:	18848493          	addi	s1,s1,392
    80002b9e:	fb442783          	lw	a5,-76(s0)
    80002ba2:	02f95d63          	bge	s2,a5,80002bdc <sys_getcpids+0xa6>
    if(proc[i].parent != 0) {
    80002ba6:	649c                	ld	a5,8(s1)
    80002ba8:	dbe5                	beqz	a5,80002b98 <sys_getcpids+0x62>
      int cpid = proc[i].pid;
    80002baa:	4098                	lw	a4,0(s1)
    80002bac:	fae42823          	sw	a4,-80(s0)
      if(p->pid == proc[i].parent->pid) {
    80002bb0:	0309a703          	lw	a4,48(s3)
    80002bb4:	5b9c                	lw	a5,48(a5)
    80002bb6:	fef711e3          	bne	a4,a5,80002b98 <sys_getcpids+0x62>
        if(copyout(p->pagetable, cparray+sizeof(cpid)*j, (char*)&cpid, sizeof(cpid)) < 0){
    80002bba:	002a1593          	slli	a1,s4,0x2
    80002bbe:	86d6                	mv	a3,s5
    80002bc0:	865a                	mv	a2,s6
    80002bc2:	fb843783          	ld	a5,-72(s0)
    80002bc6:	95be                	add	a1,a1,a5
    80002bc8:	0509b503          	ld	a0,80(s3)
    80002bcc:	9b9fe0ef          	jal	80001584 <copyout>
    80002bd0:	fa054de3          	bltz	a0,80002b8a <sys_getcpids+0x54>
        }
        nchild = j+1;
    80002bd4:	001a051b          	addiw	a0,s4,1
    80002bd8:	8a2a                	mv	s4,a0
        j++;
    80002bda:	bf7d                	j	80002b98 <sys_getcpids+0x62>
    80002bdc:	74e2                	ld	s1,56(sp)
    80002bde:	7942                	ld	s2,48(sp)
    80002be0:	7a02                	ld	s4,32(sp)
    80002be2:	6ae2                	ld	s5,24(sp)
    80002be4:	6b42                	ld	s6,16(sp)
      }
    }
  }
  return nchild;
}
    80002be6:	60a6                	ld	ra,72(sp)
    80002be8:	6406                	ld	s0,64(sp)
    80002bea:	79a2                	ld	s3,40(sp)
    80002bec:	6161                	addi	sp,sp,80
    80002bee:	8082                	ret
  int nmax, nchild = -1;
    80002bf0:	557d                	li	a0,-1
  return nchild;
    80002bf2:	bfd5                	j	80002be6 <sys_getcpids+0xb0>

0000000080002bf4 <sys_getpaddr>:

// The handler for system call getaddr
uint64
sys_getpaddr(void) {
    80002bf4:	7179                	addi	sp,sp,-48
    80002bf6:	f406                	sd	ra,40(sp)
    80002bf8:	f022                	sd	s0,32(sp)
    80002bfa:	ec26                	sd	s1,24(sp)
    80002bfc:	1800                	addi	s0,sp,48
  // Src addr -> Dest addr (phys addr)
  uint64 VirtAddr, PhysAddr = 0;
  pte_t *pte;
  struct proc *p = myproc();
    80002bfe:	cdffe0ef          	jal	800018dc <myproc>
    80002c02:	84aa                	mv	s1,a0
  argaddr(0, &VirtAddr);
    80002c04:	fd840593          	addi	a1,s0,-40
    80002c08:	4501                	li	a0,0
    80002c0a:	ccbff0ef          	jal	800028d4 <argaddr>
  pte = walk(p->pagetable, VirtAddr,0);
    80002c0e:	4601                	li	a2,0
    80002c10:	fd843583          	ld	a1,-40(s0)
    80002c14:	68a8                	ld	a0,80(s1)
    80002c16:	b4cfe0ef          	jal	80000f62 <walk>
    80002c1a:	87aa                	mv	a5,a0
  uint64 VirtAddr, PhysAddr = 0;
    80002c1c:	4501                	li	a0,0
  if(pte!=0 && (*pte & PTE_V)){
    80002c1e:	cf81                	beqz	a5,80002c36 <sys_getpaddr+0x42>
    80002c20:	639c                	ld	a5,0(a5)
    80002c22:	0017f513          	andi	a0,a5,1
    80002c26:	c901                	beqz	a0,80002c36 <sys_getpaddr+0x42>
    //the PTE pointed to by pte this is a valid page entry
    PhysAddr = PTE2PA(*pte) | (VirtAddr & 0xFFF);
    80002c28:	83a9                	srli	a5,a5,0xa
    80002c2a:	07b2                	slli	a5,a5,0xc
    80002c2c:	fd843503          	ld	a0,-40(s0)
    80002c30:	1552                	slli	a0,a0,0x34
    80002c32:	9151                	srli	a0,a0,0x34
    80002c34:	8d5d                	or	a0,a0,a5
    //the PTE pointed to by pte is invalid; that is, the virtual address is invalid
    //just return 0.
  }
  
  return PhysAddr;
}
    80002c36:	70a2                	ld	ra,40(sp)
    80002c38:	7402                	ld	s0,32(sp)
    80002c3a:	64e2                	ld	s1,24(sp)
    80002c3c:	6145                	addi	sp,sp,48
    80002c3e:	8082                	ret

0000000080002c40 <sys_gettraphistory>:

// The handler for system call gettraphistory
uint64
sys_gettraphistory(void) {
    80002c40:	715d                	addi	sp,sp,-80
    80002c42:	e486                	sd	ra,72(sp)
    80002c44:	e0a2                	sd	s0,64(sp)
    80002c46:	fc26                	sd	s1,56(sp)
    80002c48:	0880                	addi	s0,sp,80
  //int trapcount=0, syscallcount=0, devintcount=0, timerintcount=0;
  uint64 trapc, sysc, devc, timerc;
  int trap, sys, dev, timer;
  struct proc *p = myproc();
    80002c4a:	c93fe0ef          	jal	800018dc <myproc>
    80002c4e:	84aa                	mv	s1,a0
  argaddr(0, &trapc);
    80002c50:	fd840593          	addi	a1,s0,-40
    80002c54:	4501                	li	a0,0
    80002c56:	c7fff0ef          	jal	800028d4 <argaddr>
  argaddr(1, &sysc);
    80002c5a:	fd040593          	addi	a1,s0,-48
    80002c5e:	4505                	li	a0,1
    80002c60:	c75ff0ef          	jal	800028d4 <argaddr>
  argaddr(2, &devc);
    80002c64:	fc840593          	addi	a1,s0,-56
    80002c68:	4509                	li	a0,2
    80002c6a:	c6bff0ef          	jal	800028d4 <argaddr>
  argaddr(3, &timerc);
    80002c6e:	fc040593          	addi	a1,s0,-64
    80002c72:	450d                	li	a0,3
    80002c74:	c61ff0ef          	jal	800028d4 <argaddr>
  trap = p->trapcount;
    80002c78:	1684a783          	lw	a5,360(s1)
    80002c7c:	faf42e23          	sw	a5,-68(s0)
  sys = p->syscallcount;
    80002c80:	16c4a783          	lw	a5,364(s1)
    80002c84:	faf42c23          	sw	a5,-72(s0)
  dev = p->devintcount;
    80002c88:	1704a783          	lw	a5,368(s1)
    80002c8c:	faf42a23          	sw	a5,-76(s0)
  timer = p->timerintcount;
    80002c90:	1744a783          	lw	a5,372(s1)
    80002c94:	faf42823          	sw	a5,-80(s0)
  if(copyout(p->pagetable, trapc, (char*)&trap, sizeof(trap)) < 0 ||
    80002c98:	4691                	li	a3,4
    80002c9a:	fbc40613          	addi	a2,s0,-68
    80002c9e:	fd843583          	ld	a1,-40(s0)
    80002ca2:	68a8                	ld	a0,80(s1)
    80002ca4:	8e1fe0ef          	jal	80001584 <copyout>
     copyout(p->pagetable, sysc, (char*)&sys, sizeof(sys)) < 0  ||
     copyout(p->pagetable, devc, (char*)&dev, sizeof(dev)) < 0  ||
     copyout(p->pagetable, timerc, (char*)&timer, sizeof(timer)) < 0){
    return -1;
    80002ca8:	57fd                	li	a5,-1
  if(copyout(p->pagetable, trapc, (char*)&trap, sizeof(trap)) < 0 ||
    80002caa:	04054263          	bltz	a0,80002cee <sys_gettraphistory+0xae>
     copyout(p->pagetable, sysc, (char*)&sys, sizeof(sys)) < 0  ||
    80002cae:	4691                	li	a3,4
    80002cb0:	fb840613          	addi	a2,s0,-72
    80002cb4:	fd043583          	ld	a1,-48(s0)
    80002cb8:	68a8                	ld	a0,80(s1)
    80002cba:	8cbfe0ef          	jal	80001584 <copyout>
    return -1;
    80002cbe:	57fd                	li	a5,-1
  if(copyout(p->pagetable, trapc, (char*)&trap, sizeof(trap)) < 0 ||
    80002cc0:	02054763          	bltz	a0,80002cee <sys_gettraphistory+0xae>
     copyout(p->pagetable, devc, (char*)&dev, sizeof(dev)) < 0  ||
    80002cc4:	4691                	li	a3,4
    80002cc6:	fb440613          	addi	a2,s0,-76
    80002cca:	fc843583          	ld	a1,-56(s0)
    80002cce:	68a8                	ld	a0,80(s1)
    80002cd0:	8b5fe0ef          	jal	80001584 <copyout>
    return -1;
    80002cd4:	57fd                	li	a5,-1
     copyout(p->pagetable, sysc, (char*)&sys, sizeof(sys)) < 0  ||
    80002cd6:	00054c63          	bltz	a0,80002cee <sys_gettraphistory+0xae>
     copyout(p->pagetable, timerc, (char*)&timer, sizeof(timer)) < 0){
    80002cda:	4691                	li	a3,4
    80002cdc:	fb040613          	addi	a2,s0,-80
    80002ce0:	fc043583          	ld	a1,-64(s0)
    80002ce4:	68a8                	ld	a0,80(s1)
    80002ce6:	89ffe0ef          	jal	80001584 <copyout>
     copyout(p->pagetable, devc, (char*)&dev, sizeof(dev)) < 0  ||
    80002cea:	43f55793          	srai	a5,a0,0x3f
  }
  return 0;
}
    80002cee:	853e                	mv	a0,a5
    80002cf0:	60a6                	ld	ra,72(sp)
    80002cf2:	6406                	ld	s0,64(sp)
    80002cf4:	74e2                	ld	s1,56(sp)
    80002cf6:	6161                	addi	sp,sp,80
    80002cf8:	8082                	ret

0000000080002cfa <sys_nice>:
// <<< Project 1B

// Project 1C >>>
// The handler for system call nice
uint64
sys_nice(void) {
    80002cfa:	1141                	addi	sp,sp,-16
    80002cfc:	e406                	sd	ra,8(sp)
    80002cfe:	e022                	sd	s0,0(sp)
    80002d00:	0800                	addi	s0,sp,16
  // TO BE ADDED
  return 0;
}
    80002d02:	4501                	li	a0,0
    80002d04:	60a2                	ld	ra,8(sp)
    80002d06:	6402                	ld	s0,0(sp)
    80002d08:	0141                	addi	sp,sp,16
    80002d0a:	8082                	ret

0000000080002d0c <sys_getruntime>:

// The handler for system call getruntime
uint64
sys_getruntime(void) {
    80002d0c:	1141                	addi	sp,sp,-16
    80002d0e:	e406                	sd	ra,8(sp)
    80002d10:	e022                	sd	s0,0(sp)
    80002d12:	0800                	addi	s0,sp,16
  // TO BE ADDED
  return 0;
}
    80002d14:	4501                	li	a0,0
    80002d16:	60a2                	ld	ra,8(sp)
    80002d18:	6402                	ld	s0,0(sp)
    80002d1a:	0141                	addi	sp,sp,16
    80002d1c:	8082                	ret

0000000080002d1e <sys_startcfs>:

// The handler for system call startcfs
uint64
sys_startcfs(void) {
    80002d1e:	1141                	addi	sp,sp,-16
    80002d20:	e406                	sd	ra,8(sp)
    80002d22:	e022                	sd	s0,0(sp)
    80002d24:	0800                	addi	s0,sp,16
  // TO BE ADDED
  return 0;
}
    80002d26:	4501                	li	a0,0
    80002d28:	60a2                	ld	ra,8(sp)
    80002d2a:	6402                	ld	s0,0(sp)
    80002d2c:	0141                	addi	sp,sp,16
    80002d2e:	8082                	ret

0000000080002d30 <sys_stopcfs>:

// The handler for system call stopcfs
uint64
sys_stopcfs(void) {
    80002d30:	1141                	addi	sp,sp,-16
    80002d32:	e406                	sd	ra,8(sp)
    80002d34:	e022                	sd	s0,0(sp)
    80002d36:	0800                	addi	s0,sp,16
  // TO BE ADDED
  return 0;
}
    80002d38:	4501                	li	a0,0
    80002d3a:	60a2                	ld	ra,8(sp)
    80002d3c:	6402                	ld	s0,0(sp)
    80002d3e:	0141                	addi	sp,sp,16
    80002d40:	8082                	ret

0000000080002d42 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d42:	7179                	addi	sp,sp,-48
    80002d44:	f406                	sd	ra,40(sp)
    80002d46:	f022                	sd	s0,32(sp)
    80002d48:	ec26                	sd	s1,24(sp)
    80002d4a:	e84a                	sd	s2,16(sp)
    80002d4c:	e44e                	sd	s3,8(sp)
    80002d4e:	e052                	sd	s4,0(sp)
    80002d50:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d52:	00004597          	auipc	a1,0x4
    80002d56:	74658593          	addi	a1,a1,1862 # 80007498 <etext+0x498>
    80002d5a:	00016517          	auipc	a0,0x16
    80002d5e:	03e50513          	addi	a0,a0,62 # 80018d98 <bcache>
    80002d62:	e19fd0ef          	jal	80000b7a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d66:	0001e797          	auipc	a5,0x1e
    80002d6a:	03278793          	addi	a5,a5,50 # 80020d98 <bcache+0x8000>
    80002d6e:	0001e717          	auipc	a4,0x1e
    80002d72:	29270713          	addi	a4,a4,658 # 80021000 <bcache+0x8268>
    80002d76:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002d7a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002d7e:	00016497          	auipc	s1,0x16
    80002d82:	03248493          	addi	s1,s1,50 # 80018db0 <bcache+0x18>
    b->next = bcache.head.next;
    80002d86:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002d88:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002d8a:	00004a17          	auipc	s4,0x4
    80002d8e:	716a0a13          	addi	s4,s4,1814 # 800074a0 <etext+0x4a0>
    b->next = bcache.head.next;
    80002d92:	2b893783          	ld	a5,696(s2)
    80002d96:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002d98:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002d9c:	85d2                	mv	a1,s4
    80002d9e:	01048513          	addi	a0,s1,16
    80002da2:	244010ef          	jal	80003fe6 <initsleeplock>
    bcache.head.next->prev = b;
    80002da6:	2b893783          	ld	a5,696(s2)
    80002daa:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002dac:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002db0:	45848493          	addi	s1,s1,1112
    80002db4:	fd349fe3          	bne	s1,s3,80002d92 <binit+0x50>
  }
}
    80002db8:	70a2                	ld	ra,40(sp)
    80002dba:	7402                	ld	s0,32(sp)
    80002dbc:	64e2                	ld	s1,24(sp)
    80002dbe:	6942                	ld	s2,16(sp)
    80002dc0:	69a2                	ld	s3,8(sp)
    80002dc2:	6a02                	ld	s4,0(sp)
    80002dc4:	6145                	addi	sp,sp,48
    80002dc6:	8082                	ret

0000000080002dc8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002dc8:	7179                	addi	sp,sp,-48
    80002dca:	f406                	sd	ra,40(sp)
    80002dcc:	f022                	sd	s0,32(sp)
    80002dce:	ec26                	sd	s1,24(sp)
    80002dd0:	e84a                	sd	s2,16(sp)
    80002dd2:	e44e                	sd	s3,8(sp)
    80002dd4:	1800                	addi	s0,sp,48
    80002dd6:	892a                	mv	s2,a0
    80002dd8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002dda:	00016517          	auipc	a0,0x16
    80002dde:	fbe50513          	addi	a0,a0,-66 # 80018d98 <bcache>
    80002de2:	e1dfd0ef          	jal	80000bfe <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002de6:	0001e497          	auipc	s1,0x1e
    80002dea:	26a4b483          	ld	s1,618(s1) # 80021050 <bcache+0x82b8>
    80002dee:	0001e797          	auipc	a5,0x1e
    80002df2:	21278793          	addi	a5,a5,530 # 80021000 <bcache+0x8268>
    80002df6:	02f48b63          	beq	s1,a5,80002e2c <bread+0x64>
    80002dfa:	873e                	mv	a4,a5
    80002dfc:	a021                	j	80002e04 <bread+0x3c>
    80002dfe:	68a4                	ld	s1,80(s1)
    80002e00:	02e48663          	beq	s1,a4,80002e2c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002e04:	449c                	lw	a5,8(s1)
    80002e06:	ff279ce3          	bne	a5,s2,80002dfe <bread+0x36>
    80002e0a:	44dc                	lw	a5,12(s1)
    80002e0c:	ff3799e3          	bne	a5,s3,80002dfe <bread+0x36>
      b->refcnt++;
    80002e10:	40bc                	lw	a5,64(s1)
    80002e12:	2785                	addiw	a5,a5,1
    80002e14:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e16:	00016517          	auipc	a0,0x16
    80002e1a:	f8250513          	addi	a0,a0,-126 # 80018d98 <bcache>
    80002e1e:	e75fd0ef          	jal	80000c92 <release>
      acquiresleep(&b->lock);
    80002e22:	01048513          	addi	a0,s1,16
    80002e26:	1f6010ef          	jal	8000401c <acquiresleep>
      return b;
    80002e2a:	a889                	j	80002e7c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e2c:	0001e497          	auipc	s1,0x1e
    80002e30:	21c4b483          	ld	s1,540(s1) # 80021048 <bcache+0x82b0>
    80002e34:	0001e797          	auipc	a5,0x1e
    80002e38:	1cc78793          	addi	a5,a5,460 # 80021000 <bcache+0x8268>
    80002e3c:	00f48863          	beq	s1,a5,80002e4c <bread+0x84>
    80002e40:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002e42:	40bc                	lw	a5,64(s1)
    80002e44:	cb91                	beqz	a5,80002e58 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e46:	64a4                	ld	s1,72(s1)
    80002e48:	fee49de3          	bne	s1,a4,80002e42 <bread+0x7a>
  panic("bget: no buffers");
    80002e4c:	00004517          	auipc	a0,0x4
    80002e50:	65c50513          	addi	a0,a0,1628 # 800074a8 <etext+0x4a8>
    80002e54:	94bfd0ef          	jal	8000079e <panic>
      b->dev = dev;
    80002e58:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002e5c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002e60:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002e64:	4785                	li	a5,1
    80002e66:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e68:	00016517          	auipc	a0,0x16
    80002e6c:	f3050513          	addi	a0,a0,-208 # 80018d98 <bcache>
    80002e70:	e23fd0ef          	jal	80000c92 <release>
      acquiresleep(&b->lock);
    80002e74:	01048513          	addi	a0,s1,16
    80002e78:	1a4010ef          	jal	8000401c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002e7c:	409c                	lw	a5,0(s1)
    80002e7e:	cb89                	beqz	a5,80002e90 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002e80:	8526                	mv	a0,s1
    80002e82:	70a2                	ld	ra,40(sp)
    80002e84:	7402                	ld	s0,32(sp)
    80002e86:	64e2                	ld	s1,24(sp)
    80002e88:	6942                	ld	s2,16(sp)
    80002e8a:	69a2                	ld	s3,8(sp)
    80002e8c:	6145                	addi	sp,sp,48
    80002e8e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002e90:	4581                	li	a1,0
    80002e92:	8526                	mv	a0,s1
    80002e94:	1fd020ef          	jal	80005890 <virtio_disk_rw>
    b->valid = 1;
    80002e98:	4785                	li	a5,1
    80002e9a:	c09c                	sw	a5,0(s1)
  return b;
    80002e9c:	b7d5                	j	80002e80 <bread+0xb8>

0000000080002e9e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002e9e:	1101                	addi	sp,sp,-32
    80002ea0:	ec06                	sd	ra,24(sp)
    80002ea2:	e822                	sd	s0,16(sp)
    80002ea4:	e426                	sd	s1,8(sp)
    80002ea6:	1000                	addi	s0,sp,32
    80002ea8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002eaa:	0541                	addi	a0,a0,16
    80002eac:	1ee010ef          	jal	8000409a <holdingsleep>
    80002eb0:	c911                	beqz	a0,80002ec4 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002eb2:	4585                	li	a1,1
    80002eb4:	8526                	mv	a0,s1
    80002eb6:	1db020ef          	jal	80005890 <virtio_disk_rw>
}
    80002eba:	60e2                	ld	ra,24(sp)
    80002ebc:	6442                	ld	s0,16(sp)
    80002ebe:	64a2                	ld	s1,8(sp)
    80002ec0:	6105                	addi	sp,sp,32
    80002ec2:	8082                	ret
    panic("bwrite");
    80002ec4:	00004517          	auipc	a0,0x4
    80002ec8:	5fc50513          	addi	a0,a0,1532 # 800074c0 <etext+0x4c0>
    80002ecc:	8d3fd0ef          	jal	8000079e <panic>

0000000080002ed0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002ed0:	1101                	addi	sp,sp,-32
    80002ed2:	ec06                	sd	ra,24(sp)
    80002ed4:	e822                	sd	s0,16(sp)
    80002ed6:	e426                	sd	s1,8(sp)
    80002ed8:	e04a                	sd	s2,0(sp)
    80002eda:	1000                	addi	s0,sp,32
    80002edc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ede:	01050913          	addi	s2,a0,16
    80002ee2:	854a                	mv	a0,s2
    80002ee4:	1b6010ef          	jal	8000409a <holdingsleep>
    80002ee8:	c125                	beqz	a0,80002f48 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002eea:	854a                	mv	a0,s2
    80002eec:	176010ef          	jal	80004062 <releasesleep>

  acquire(&bcache.lock);
    80002ef0:	00016517          	auipc	a0,0x16
    80002ef4:	ea850513          	addi	a0,a0,-344 # 80018d98 <bcache>
    80002ef8:	d07fd0ef          	jal	80000bfe <acquire>
  b->refcnt--;
    80002efc:	40bc                	lw	a5,64(s1)
    80002efe:	37fd                	addiw	a5,a5,-1
    80002f00:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002f02:	e79d                	bnez	a5,80002f30 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002f04:	68b8                	ld	a4,80(s1)
    80002f06:	64bc                	ld	a5,72(s1)
    80002f08:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002f0a:	68b8                	ld	a4,80(s1)
    80002f0c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002f0e:	0001e797          	auipc	a5,0x1e
    80002f12:	e8a78793          	addi	a5,a5,-374 # 80020d98 <bcache+0x8000>
    80002f16:	2b87b703          	ld	a4,696(a5)
    80002f1a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002f1c:	0001e717          	auipc	a4,0x1e
    80002f20:	0e470713          	addi	a4,a4,228 # 80021000 <bcache+0x8268>
    80002f24:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002f26:	2b87b703          	ld	a4,696(a5)
    80002f2a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002f2c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002f30:	00016517          	auipc	a0,0x16
    80002f34:	e6850513          	addi	a0,a0,-408 # 80018d98 <bcache>
    80002f38:	d5bfd0ef          	jal	80000c92 <release>
}
    80002f3c:	60e2                	ld	ra,24(sp)
    80002f3e:	6442                	ld	s0,16(sp)
    80002f40:	64a2                	ld	s1,8(sp)
    80002f42:	6902                	ld	s2,0(sp)
    80002f44:	6105                	addi	sp,sp,32
    80002f46:	8082                	ret
    panic("brelse");
    80002f48:	00004517          	auipc	a0,0x4
    80002f4c:	58050513          	addi	a0,a0,1408 # 800074c8 <etext+0x4c8>
    80002f50:	84ffd0ef          	jal	8000079e <panic>

0000000080002f54 <bpin>:

void
bpin(struct buf *b) {
    80002f54:	1101                	addi	sp,sp,-32
    80002f56:	ec06                	sd	ra,24(sp)
    80002f58:	e822                	sd	s0,16(sp)
    80002f5a:	e426                	sd	s1,8(sp)
    80002f5c:	1000                	addi	s0,sp,32
    80002f5e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002f60:	00016517          	auipc	a0,0x16
    80002f64:	e3850513          	addi	a0,a0,-456 # 80018d98 <bcache>
    80002f68:	c97fd0ef          	jal	80000bfe <acquire>
  b->refcnt++;
    80002f6c:	40bc                	lw	a5,64(s1)
    80002f6e:	2785                	addiw	a5,a5,1
    80002f70:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002f72:	00016517          	auipc	a0,0x16
    80002f76:	e2650513          	addi	a0,a0,-474 # 80018d98 <bcache>
    80002f7a:	d19fd0ef          	jal	80000c92 <release>
}
    80002f7e:	60e2                	ld	ra,24(sp)
    80002f80:	6442                	ld	s0,16(sp)
    80002f82:	64a2                	ld	s1,8(sp)
    80002f84:	6105                	addi	sp,sp,32
    80002f86:	8082                	ret

0000000080002f88 <bunpin>:

void
bunpin(struct buf *b) {
    80002f88:	1101                	addi	sp,sp,-32
    80002f8a:	ec06                	sd	ra,24(sp)
    80002f8c:	e822                	sd	s0,16(sp)
    80002f8e:	e426                	sd	s1,8(sp)
    80002f90:	1000                	addi	s0,sp,32
    80002f92:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002f94:	00016517          	auipc	a0,0x16
    80002f98:	e0450513          	addi	a0,a0,-508 # 80018d98 <bcache>
    80002f9c:	c63fd0ef          	jal	80000bfe <acquire>
  b->refcnt--;
    80002fa0:	40bc                	lw	a5,64(s1)
    80002fa2:	37fd                	addiw	a5,a5,-1
    80002fa4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002fa6:	00016517          	auipc	a0,0x16
    80002faa:	df250513          	addi	a0,a0,-526 # 80018d98 <bcache>
    80002fae:	ce5fd0ef          	jal	80000c92 <release>
}
    80002fb2:	60e2                	ld	ra,24(sp)
    80002fb4:	6442                	ld	s0,16(sp)
    80002fb6:	64a2                	ld	s1,8(sp)
    80002fb8:	6105                	addi	sp,sp,32
    80002fba:	8082                	ret

0000000080002fbc <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002fbc:	1101                	addi	sp,sp,-32
    80002fbe:	ec06                	sd	ra,24(sp)
    80002fc0:	e822                	sd	s0,16(sp)
    80002fc2:	e426                	sd	s1,8(sp)
    80002fc4:	e04a                	sd	s2,0(sp)
    80002fc6:	1000                	addi	s0,sp,32
    80002fc8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002fca:	00d5d79b          	srliw	a5,a1,0xd
    80002fce:	0001e597          	auipc	a1,0x1e
    80002fd2:	4a65a583          	lw	a1,1190(a1) # 80021474 <sb+0x1c>
    80002fd6:	9dbd                	addw	a1,a1,a5
    80002fd8:	df1ff0ef          	jal	80002dc8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002fdc:	0074f713          	andi	a4,s1,7
    80002fe0:	4785                	li	a5,1
    80002fe2:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002fe6:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002fe8:	90d9                	srli	s1,s1,0x36
    80002fea:	00950733          	add	a4,a0,s1
    80002fee:	05874703          	lbu	a4,88(a4)
    80002ff2:	00e7f6b3          	and	a3,a5,a4
    80002ff6:	c29d                	beqz	a3,8000301c <bfree+0x60>
    80002ff8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002ffa:	94aa                	add	s1,s1,a0
    80002ffc:	fff7c793          	not	a5,a5
    80003000:	8f7d                	and	a4,a4,a5
    80003002:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003006:	711000ef          	jal	80003f16 <log_write>
  brelse(bp);
    8000300a:	854a                	mv	a0,s2
    8000300c:	ec5ff0ef          	jal	80002ed0 <brelse>
}
    80003010:	60e2                	ld	ra,24(sp)
    80003012:	6442                	ld	s0,16(sp)
    80003014:	64a2                	ld	s1,8(sp)
    80003016:	6902                	ld	s2,0(sp)
    80003018:	6105                	addi	sp,sp,32
    8000301a:	8082                	ret
    panic("freeing free block");
    8000301c:	00004517          	auipc	a0,0x4
    80003020:	4b450513          	addi	a0,a0,1204 # 800074d0 <etext+0x4d0>
    80003024:	f7afd0ef          	jal	8000079e <panic>

0000000080003028 <balloc>:
{
    80003028:	715d                	addi	sp,sp,-80
    8000302a:	e486                	sd	ra,72(sp)
    8000302c:	e0a2                	sd	s0,64(sp)
    8000302e:	fc26                	sd	s1,56(sp)
    80003030:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003032:	0001e797          	auipc	a5,0x1e
    80003036:	42a7a783          	lw	a5,1066(a5) # 8002145c <sb+0x4>
    8000303a:	0e078863          	beqz	a5,8000312a <balloc+0x102>
    8000303e:	f84a                	sd	s2,48(sp)
    80003040:	f44e                	sd	s3,40(sp)
    80003042:	f052                	sd	s4,32(sp)
    80003044:	ec56                	sd	s5,24(sp)
    80003046:	e85a                	sd	s6,16(sp)
    80003048:	e45e                	sd	s7,8(sp)
    8000304a:	e062                	sd	s8,0(sp)
    8000304c:	8baa                	mv	s7,a0
    8000304e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003050:	0001eb17          	auipc	s6,0x1e
    80003054:	408b0b13          	addi	s6,s6,1032 # 80021458 <sb>
      m = 1 << (bi % 8);
    80003058:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000305a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000305c:	6c09                	lui	s8,0x2
    8000305e:	a09d                	j	800030c4 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003060:	97ca                	add	a5,a5,s2
    80003062:	8e55                	or	a2,a2,a3
    80003064:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003068:	854a                	mv	a0,s2
    8000306a:	6ad000ef          	jal	80003f16 <log_write>
        brelse(bp);
    8000306e:	854a                	mv	a0,s2
    80003070:	e61ff0ef          	jal	80002ed0 <brelse>
  bp = bread(dev, bno);
    80003074:	85a6                	mv	a1,s1
    80003076:	855e                	mv	a0,s7
    80003078:	d51ff0ef          	jal	80002dc8 <bread>
    8000307c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000307e:	40000613          	li	a2,1024
    80003082:	4581                	li	a1,0
    80003084:	05850513          	addi	a0,a0,88
    80003088:	c47fd0ef          	jal	80000cce <memset>
  log_write(bp);
    8000308c:	854a                	mv	a0,s2
    8000308e:	689000ef          	jal	80003f16 <log_write>
  brelse(bp);
    80003092:	854a                	mv	a0,s2
    80003094:	e3dff0ef          	jal	80002ed0 <brelse>
}
    80003098:	7942                	ld	s2,48(sp)
    8000309a:	79a2                	ld	s3,40(sp)
    8000309c:	7a02                	ld	s4,32(sp)
    8000309e:	6ae2                	ld	s5,24(sp)
    800030a0:	6b42                	ld	s6,16(sp)
    800030a2:	6ba2                	ld	s7,8(sp)
    800030a4:	6c02                	ld	s8,0(sp)
}
    800030a6:	8526                	mv	a0,s1
    800030a8:	60a6                	ld	ra,72(sp)
    800030aa:	6406                	ld	s0,64(sp)
    800030ac:	74e2                	ld	s1,56(sp)
    800030ae:	6161                	addi	sp,sp,80
    800030b0:	8082                	ret
    brelse(bp);
    800030b2:	854a                	mv	a0,s2
    800030b4:	e1dff0ef          	jal	80002ed0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800030b8:	015c0abb          	addw	s5,s8,s5
    800030bc:	004b2783          	lw	a5,4(s6)
    800030c0:	04fafe63          	bgeu	s5,a5,8000311c <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    800030c4:	41fad79b          	sraiw	a5,s5,0x1f
    800030c8:	0137d79b          	srliw	a5,a5,0x13
    800030cc:	015787bb          	addw	a5,a5,s5
    800030d0:	40d7d79b          	sraiw	a5,a5,0xd
    800030d4:	01cb2583          	lw	a1,28(s6)
    800030d8:	9dbd                	addw	a1,a1,a5
    800030da:	855e                	mv	a0,s7
    800030dc:	cedff0ef          	jal	80002dc8 <bread>
    800030e0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030e2:	004b2503          	lw	a0,4(s6)
    800030e6:	84d6                	mv	s1,s5
    800030e8:	4701                	li	a4,0
    800030ea:	fca4f4e3          	bgeu	s1,a0,800030b2 <balloc+0x8a>
      m = 1 << (bi % 8);
    800030ee:	00777693          	andi	a3,a4,7
    800030f2:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800030f6:	41f7579b          	sraiw	a5,a4,0x1f
    800030fa:	01d7d79b          	srliw	a5,a5,0x1d
    800030fe:	9fb9                	addw	a5,a5,a4
    80003100:	4037d79b          	sraiw	a5,a5,0x3
    80003104:	00f90633          	add	a2,s2,a5
    80003108:	05864603          	lbu	a2,88(a2)
    8000310c:	00c6f5b3          	and	a1,a3,a2
    80003110:	d9a1                	beqz	a1,80003060 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003112:	2705                	addiw	a4,a4,1
    80003114:	2485                	addiw	s1,s1,1
    80003116:	fd471ae3          	bne	a4,s4,800030ea <balloc+0xc2>
    8000311a:	bf61                	j	800030b2 <balloc+0x8a>
    8000311c:	7942                	ld	s2,48(sp)
    8000311e:	79a2                	ld	s3,40(sp)
    80003120:	7a02                	ld	s4,32(sp)
    80003122:	6ae2                	ld	s5,24(sp)
    80003124:	6b42                	ld	s6,16(sp)
    80003126:	6ba2                	ld	s7,8(sp)
    80003128:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000312a:	00004517          	auipc	a0,0x4
    8000312e:	3be50513          	addi	a0,a0,958 # 800074e8 <etext+0x4e8>
    80003132:	b9cfd0ef          	jal	800004ce <printf>
  return 0;
    80003136:	4481                	li	s1,0
    80003138:	b7bd                	j	800030a6 <balloc+0x7e>

000000008000313a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000313a:	7179                	addi	sp,sp,-48
    8000313c:	f406                	sd	ra,40(sp)
    8000313e:	f022                	sd	s0,32(sp)
    80003140:	ec26                	sd	s1,24(sp)
    80003142:	e84a                	sd	s2,16(sp)
    80003144:	e44e                	sd	s3,8(sp)
    80003146:	1800                	addi	s0,sp,48
    80003148:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000314a:	47ad                	li	a5,11
    8000314c:	02b7e363          	bltu	a5,a1,80003172 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80003150:	02059793          	slli	a5,a1,0x20
    80003154:	01e7d593          	srli	a1,a5,0x1e
    80003158:	00b504b3          	add	s1,a0,a1
    8000315c:	0504a903          	lw	s2,80(s1)
    80003160:	06091363          	bnez	s2,800031c6 <bmap+0x8c>
      addr = balloc(ip->dev);
    80003164:	4108                	lw	a0,0(a0)
    80003166:	ec3ff0ef          	jal	80003028 <balloc>
    8000316a:	892a                	mv	s2,a0
      if(addr == 0)
    8000316c:	cd29                	beqz	a0,800031c6 <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    8000316e:	c8a8                	sw	a0,80(s1)
    80003170:	a899                	j	800031c6 <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003172:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80003176:	0ff00793          	li	a5,255
    8000317a:	0697e963          	bltu	a5,s1,800031ec <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000317e:	08052903          	lw	s2,128(a0)
    80003182:	00091b63          	bnez	s2,80003198 <bmap+0x5e>
      addr = balloc(ip->dev);
    80003186:	4108                	lw	a0,0(a0)
    80003188:	ea1ff0ef          	jal	80003028 <balloc>
    8000318c:	892a                	mv	s2,a0
      if(addr == 0)
    8000318e:	cd05                	beqz	a0,800031c6 <bmap+0x8c>
    80003190:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003192:	08a9a023          	sw	a0,128(s3)
    80003196:	a011                	j	8000319a <bmap+0x60>
    80003198:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000319a:	85ca                	mv	a1,s2
    8000319c:	0009a503          	lw	a0,0(s3)
    800031a0:	c29ff0ef          	jal	80002dc8 <bread>
    800031a4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800031a6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800031aa:	02049713          	slli	a4,s1,0x20
    800031ae:	01e75593          	srli	a1,a4,0x1e
    800031b2:	00b784b3          	add	s1,a5,a1
    800031b6:	0004a903          	lw	s2,0(s1)
    800031ba:	00090e63          	beqz	s2,800031d6 <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800031be:	8552                	mv	a0,s4
    800031c0:	d11ff0ef          	jal	80002ed0 <brelse>
    return addr;
    800031c4:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800031c6:	854a                	mv	a0,s2
    800031c8:	70a2                	ld	ra,40(sp)
    800031ca:	7402                	ld	s0,32(sp)
    800031cc:	64e2                	ld	s1,24(sp)
    800031ce:	6942                	ld	s2,16(sp)
    800031d0:	69a2                	ld	s3,8(sp)
    800031d2:	6145                	addi	sp,sp,48
    800031d4:	8082                	ret
      addr = balloc(ip->dev);
    800031d6:	0009a503          	lw	a0,0(s3)
    800031da:	e4fff0ef          	jal	80003028 <balloc>
    800031de:	892a                	mv	s2,a0
      if(addr){
    800031e0:	dd79                	beqz	a0,800031be <bmap+0x84>
        a[bn] = addr;
    800031e2:	c088                	sw	a0,0(s1)
        log_write(bp);
    800031e4:	8552                	mv	a0,s4
    800031e6:	531000ef          	jal	80003f16 <log_write>
    800031ea:	bfd1                	j	800031be <bmap+0x84>
    800031ec:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800031ee:	00004517          	auipc	a0,0x4
    800031f2:	31250513          	addi	a0,a0,786 # 80007500 <etext+0x500>
    800031f6:	da8fd0ef          	jal	8000079e <panic>

00000000800031fa <iget>:
{
    800031fa:	7179                	addi	sp,sp,-48
    800031fc:	f406                	sd	ra,40(sp)
    800031fe:	f022                	sd	s0,32(sp)
    80003200:	ec26                	sd	s1,24(sp)
    80003202:	e84a                	sd	s2,16(sp)
    80003204:	e44e                	sd	s3,8(sp)
    80003206:	e052                	sd	s4,0(sp)
    80003208:	1800                	addi	s0,sp,48
    8000320a:	89aa                	mv	s3,a0
    8000320c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000320e:	0001e517          	auipc	a0,0x1e
    80003212:	26a50513          	addi	a0,a0,618 # 80021478 <itable>
    80003216:	9e9fd0ef          	jal	80000bfe <acquire>
  empty = 0;
    8000321a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000321c:	0001e497          	auipc	s1,0x1e
    80003220:	27448493          	addi	s1,s1,628 # 80021490 <itable+0x18>
    80003224:	00020697          	auipc	a3,0x20
    80003228:	cfc68693          	addi	a3,a3,-772 # 80022f20 <log>
    8000322c:	a039                	j	8000323a <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000322e:	02090963          	beqz	s2,80003260 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003232:	08848493          	addi	s1,s1,136
    80003236:	02d48863          	beq	s1,a3,80003266 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000323a:	449c                	lw	a5,8(s1)
    8000323c:	fef059e3          	blez	a5,8000322e <iget+0x34>
    80003240:	4098                	lw	a4,0(s1)
    80003242:	ff3716e3          	bne	a4,s3,8000322e <iget+0x34>
    80003246:	40d8                	lw	a4,4(s1)
    80003248:	ff4713e3          	bne	a4,s4,8000322e <iget+0x34>
      ip->ref++;
    8000324c:	2785                	addiw	a5,a5,1
    8000324e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003250:	0001e517          	auipc	a0,0x1e
    80003254:	22850513          	addi	a0,a0,552 # 80021478 <itable>
    80003258:	a3bfd0ef          	jal	80000c92 <release>
      return ip;
    8000325c:	8926                	mv	s2,s1
    8000325e:	a02d                	j	80003288 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003260:	fbe9                	bnez	a5,80003232 <iget+0x38>
      empty = ip;
    80003262:	8926                	mv	s2,s1
    80003264:	b7f9                	j	80003232 <iget+0x38>
  if(empty == 0)
    80003266:	02090a63          	beqz	s2,8000329a <iget+0xa0>
  ip->dev = dev;
    8000326a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000326e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003272:	4785                	li	a5,1
    80003274:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003278:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000327c:	0001e517          	auipc	a0,0x1e
    80003280:	1fc50513          	addi	a0,a0,508 # 80021478 <itable>
    80003284:	a0ffd0ef          	jal	80000c92 <release>
}
    80003288:	854a                	mv	a0,s2
    8000328a:	70a2                	ld	ra,40(sp)
    8000328c:	7402                	ld	s0,32(sp)
    8000328e:	64e2                	ld	s1,24(sp)
    80003290:	6942                	ld	s2,16(sp)
    80003292:	69a2                	ld	s3,8(sp)
    80003294:	6a02                	ld	s4,0(sp)
    80003296:	6145                	addi	sp,sp,48
    80003298:	8082                	ret
    panic("iget: no inodes");
    8000329a:	00004517          	auipc	a0,0x4
    8000329e:	27e50513          	addi	a0,a0,638 # 80007518 <etext+0x518>
    800032a2:	cfcfd0ef          	jal	8000079e <panic>

00000000800032a6 <fsinit>:
fsinit(int dev) {
    800032a6:	7179                	addi	sp,sp,-48
    800032a8:	f406                	sd	ra,40(sp)
    800032aa:	f022                	sd	s0,32(sp)
    800032ac:	ec26                	sd	s1,24(sp)
    800032ae:	e84a                	sd	s2,16(sp)
    800032b0:	e44e                	sd	s3,8(sp)
    800032b2:	1800                	addi	s0,sp,48
    800032b4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800032b6:	4585                	li	a1,1
    800032b8:	b11ff0ef          	jal	80002dc8 <bread>
    800032bc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800032be:	0001e997          	auipc	s3,0x1e
    800032c2:	19a98993          	addi	s3,s3,410 # 80021458 <sb>
    800032c6:	02000613          	li	a2,32
    800032ca:	05850593          	addi	a1,a0,88
    800032ce:	854e                	mv	a0,s3
    800032d0:	a63fd0ef          	jal	80000d32 <memmove>
  brelse(bp);
    800032d4:	8526                	mv	a0,s1
    800032d6:	bfbff0ef          	jal	80002ed0 <brelse>
  if(sb.magic != FSMAGIC)
    800032da:	0009a703          	lw	a4,0(s3)
    800032de:	102037b7          	lui	a5,0x10203
    800032e2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800032e6:	02f71063          	bne	a4,a5,80003306 <fsinit+0x60>
  initlog(dev, &sb);
    800032ea:	0001e597          	auipc	a1,0x1e
    800032ee:	16e58593          	addi	a1,a1,366 # 80021458 <sb>
    800032f2:	854a                	mv	a0,s2
    800032f4:	215000ef          	jal	80003d08 <initlog>
}
    800032f8:	70a2                	ld	ra,40(sp)
    800032fa:	7402                	ld	s0,32(sp)
    800032fc:	64e2                	ld	s1,24(sp)
    800032fe:	6942                	ld	s2,16(sp)
    80003300:	69a2                	ld	s3,8(sp)
    80003302:	6145                	addi	sp,sp,48
    80003304:	8082                	ret
    panic("invalid file system");
    80003306:	00004517          	auipc	a0,0x4
    8000330a:	22250513          	addi	a0,a0,546 # 80007528 <etext+0x528>
    8000330e:	c90fd0ef          	jal	8000079e <panic>

0000000080003312 <iinit>:
{
    80003312:	7179                	addi	sp,sp,-48
    80003314:	f406                	sd	ra,40(sp)
    80003316:	f022                	sd	s0,32(sp)
    80003318:	ec26                	sd	s1,24(sp)
    8000331a:	e84a                	sd	s2,16(sp)
    8000331c:	e44e                	sd	s3,8(sp)
    8000331e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003320:	00004597          	auipc	a1,0x4
    80003324:	22058593          	addi	a1,a1,544 # 80007540 <etext+0x540>
    80003328:	0001e517          	auipc	a0,0x1e
    8000332c:	15050513          	addi	a0,a0,336 # 80021478 <itable>
    80003330:	84bfd0ef          	jal	80000b7a <initlock>
  for(i = 0; i < NINODE; i++) {
    80003334:	0001e497          	auipc	s1,0x1e
    80003338:	16c48493          	addi	s1,s1,364 # 800214a0 <itable+0x28>
    8000333c:	00020997          	auipc	s3,0x20
    80003340:	bf498993          	addi	s3,s3,-1036 # 80022f30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003344:	00004917          	auipc	s2,0x4
    80003348:	20490913          	addi	s2,s2,516 # 80007548 <etext+0x548>
    8000334c:	85ca                	mv	a1,s2
    8000334e:	8526                	mv	a0,s1
    80003350:	497000ef          	jal	80003fe6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003354:	08848493          	addi	s1,s1,136
    80003358:	ff349ae3          	bne	s1,s3,8000334c <iinit+0x3a>
}
    8000335c:	70a2                	ld	ra,40(sp)
    8000335e:	7402                	ld	s0,32(sp)
    80003360:	64e2                	ld	s1,24(sp)
    80003362:	6942                	ld	s2,16(sp)
    80003364:	69a2                	ld	s3,8(sp)
    80003366:	6145                	addi	sp,sp,48
    80003368:	8082                	ret

000000008000336a <ialloc>:
{
    8000336a:	7139                	addi	sp,sp,-64
    8000336c:	fc06                	sd	ra,56(sp)
    8000336e:	f822                	sd	s0,48(sp)
    80003370:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003372:	0001e717          	auipc	a4,0x1e
    80003376:	0f272703          	lw	a4,242(a4) # 80021464 <sb+0xc>
    8000337a:	4785                	li	a5,1
    8000337c:	06e7f063          	bgeu	a5,a4,800033dc <ialloc+0x72>
    80003380:	f426                	sd	s1,40(sp)
    80003382:	f04a                	sd	s2,32(sp)
    80003384:	ec4e                	sd	s3,24(sp)
    80003386:	e852                	sd	s4,16(sp)
    80003388:	e456                	sd	s5,8(sp)
    8000338a:	e05a                	sd	s6,0(sp)
    8000338c:	8aaa                	mv	s5,a0
    8000338e:	8b2e                	mv	s6,a1
    80003390:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003392:	0001ea17          	auipc	s4,0x1e
    80003396:	0c6a0a13          	addi	s4,s4,198 # 80021458 <sb>
    8000339a:	00495593          	srli	a1,s2,0x4
    8000339e:	018a2783          	lw	a5,24(s4)
    800033a2:	9dbd                	addw	a1,a1,a5
    800033a4:	8556                	mv	a0,s5
    800033a6:	a23ff0ef          	jal	80002dc8 <bread>
    800033aa:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800033ac:	05850993          	addi	s3,a0,88
    800033b0:	00f97793          	andi	a5,s2,15
    800033b4:	079a                	slli	a5,a5,0x6
    800033b6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800033b8:	00099783          	lh	a5,0(s3)
    800033bc:	cb9d                	beqz	a5,800033f2 <ialloc+0x88>
    brelse(bp);
    800033be:	b13ff0ef          	jal	80002ed0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800033c2:	0905                	addi	s2,s2,1
    800033c4:	00ca2703          	lw	a4,12(s4)
    800033c8:	0009079b          	sext.w	a5,s2
    800033cc:	fce7e7e3          	bltu	a5,a4,8000339a <ialloc+0x30>
    800033d0:	74a2                	ld	s1,40(sp)
    800033d2:	7902                	ld	s2,32(sp)
    800033d4:	69e2                	ld	s3,24(sp)
    800033d6:	6a42                	ld	s4,16(sp)
    800033d8:	6aa2                	ld	s5,8(sp)
    800033da:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800033dc:	00004517          	auipc	a0,0x4
    800033e0:	17450513          	addi	a0,a0,372 # 80007550 <etext+0x550>
    800033e4:	8eafd0ef          	jal	800004ce <printf>
  return 0;
    800033e8:	4501                	li	a0,0
}
    800033ea:	70e2                	ld	ra,56(sp)
    800033ec:	7442                	ld	s0,48(sp)
    800033ee:	6121                	addi	sp,sp,64
    800033f0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800033f2:	04000613          	li	a2,64
    800033f6:	4581                	li	a1,0
    800033f8:	854e                	mv	a0,s3
    800033fa:	8d5fd0ef          	jal	80000cce <memset>
      dip->type = type;
    800033fe:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003402:	8526                	mv	a0,s1
    80003404:	313000ef          	jal	80003f16 <log_write>
      brelse(bp);
    80003408:	8526                	mv	a0,s1
    8000340a:	ac7ff0ef          	jal	80002ed0 <brelse>
      return iget(dev, inum);
    8000340e:	0009059b          	sext.w	a1,s2
    80003412:	8556                	mv	a0,s5
    80003414:	de7ff0ef          	jal	800031fa <iget>
    80003418:	74a2                	ld	s1,40(sp)
    8000341a:	7902                	ld	s2,32(sp)
    8000341c:	69e2                	ld	s3,24(sp)
    8000341e:	6a42                	ld	s4,16(sp)
    80003420:	6aa2                	ld	s5,8(sp)
    80003422:	6b02                	ld	s6,0(sp)
    80003424:	b7d9                	j	800033ea <ialloc+0x80>

0000000080003426 <iupdate>:
{
    80003426:	1101                	addi	sp,sp,-32
    80003428:	ec06                	sd	ra,24(sp)
    8000342a:	e822                	sd	s0,16(sp)
    8000342c:	e426                	sd	s1,8(sp)
    8000342e:	e04a                	sd	s2,0(sp)
    80003430:	1000                	addi	s0,sp,32
    80003432:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003434:	415c                	lw	a5,4(a0)
    80003436:	0047d79b          	srliw	a5,a5,0x4
    8000343a:	0001e597          	auipc	a1,0x1e
    8000343e:	0365a583          	lw	a1,54(a1) # 80021470 <sb+0x18>
    80003442:	9dbd                	addw	a1,a1,a5
    80003444:	4108                	lw	a0,0(a0)
    80003446:	983ff0ef          	jal	80002dc8 <bread>
    8000344a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000344c:	05850793          	addi	a5,a0,88
    80003450:	40d8                	lw	a4,4(s1)
    80003452:	8b3d                	andi	a4,a4,15
    80003454:	071a                	slli	a4,a4,0x6
    80003456:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003458:	04449703          	lh	a4,68(s1)
    8000345c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003460:	04649703          	lh	a4,70(s1)
    80003464:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003468:	04849703          	lh	a4,72(s1)
    8000346c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003470:	04a49703          	lh	a4,74(s1)
    80003474:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003478:	44f8                	lw	a4,76(s1)
    8000347a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000347c:	03400613          	li	a2,52
    80003480:	05048593          	addi	a1,s1,80
    80003484:	00c78513          	addi	a0,a5,12
    80003488:	8abfd0ef          	jal	80000d32 <memmove>
  log_write(bp);
    8000348c:	854a                	mv	a0,s2
    8000348e:	289000ef          	jal	80003f16 <log_write>
  brelse(bp);
    80003492:	854a                	mv	a0,s2
    80003494:	a3dff0ef          	jal	80002ed0 <brelse>
}
    80003498:	60e2                	ld	ra,24(sp)
    8000349a:	6442                	ld	s0,16(sp)
    8000349c:	64a2                	ld	s1,8(sp)
    8000349e:	6902                	ld	s2,0(sp)
    800034a0:	6105                	addi	sp,sp,32
    800034a2:	8082                	ret

00000000800034a4 <idup>:
{
    800034a4:	1101                	addi	sp,sp,-32
    800034a6:	ec06                	sd	ra,24(sp)
    800034a8:	e822                	sd	s0,16(sp)
    800034aa:	e426                	sd	s1,8(sp)
    800034ac:	1000                	addi	s0,sp,32
    800034ae:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800034b0:	0001e517          	auipc	a0,0x1e
    800034b4:	fc850513          	addi	a0,a0,-56 # 80021478 <itable>
    800034b8:	f46fd0ef          	jal	80000bfe <acquire>
  ip->ref++;
    800034bc:	449c                	lw	a5,8(s1)
    800034be:	2785                	addiw	a5,a5,1
    800034c0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800034c2:	0001e517          	auipc	a0,0x1e
    800034c6:	fb650513          	addi	a0,a0,-74 # 80021478 <itable>
    800034ca:	fc8fd0ef          	jal	80000c92 <release>
}
    800034ce:	8526                	mv	a0,s1
    800034d0:	60e2                	ld	ra,24(sp)
    800034d2:	6442                	ld	s0,16(sp)
    800034d4:	64a2                	ld	s1,8(sp)
    800034d6:	6105                	addi	sp,sp,32
    800034d8:	8082                	ret

00000000800034da <ilock>:
{
    800034da:	1101                	addi	sp,sp,-32
    800034dc:	ec06                	sd	ra,24(sp)
    800034de:	e822                	sd	s0,16(sp)
    800034e0:	e426                	sd	s1,8(sp)
    800034e2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800034e4:	cd19                	beqz	a0,80003502 <ilock+0x28>
    800034e6:	84aa                	mv	s1,a0
    800034e8:	451c                	lw	a5,8(a0)
    800034ea:	00f05c63          	blez	a5,80003502 <ilock+0x28>
  acquiresleep(&ip->lock);
    800034ee:	0541                	addi	a0,a0,16
    800034f0:	32d000ef          	jal	8000401c <acquiresleep>
  if(ip->valid == 0){
    800034f4:	40bc                	lw	a5,64(s1)
    800034f6:	cf89                	beqz	a5,80003510 <ilock+0x36>
}
    800034f8:	60e2                	ld	ra,24(sp)
    800034fa:	6442                	ld	s0,16(sp)
    800034fc:	64a2                	ld	s1,8(sp)
    800034fe:	6105                	addi	sp,sp,32
    80003500:	8082                	ret
    80003502:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003504:	00004517          	auipc	a0,0x4
    80003508:	06450513          	addi	a0,a0,100 # 80007568 <etext+0x568>
    8000350c:	a92fd0ef          	jal	8000079e <panic>
    80003510:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003512:	40dc                	lw	a5,4(s1)
    80003514:	0047d79b          	srliw	a5,a5,0x4
    80003518:	0001e597          	auipc	a1,0x1e
    8000351c:	f585a583          	lw	a1,-168(a1) # 80021470 <sb+0x18>
    80003520:	9dbd                	addw	a1,a1,a5
    80003522:	4088                	lw	a0,0(s1)
    80003524:	8a5ff0ef          	jal	80002dc8 <bread>
    80003528:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000352a:	05850593          	addi	a1,a0,88
    8000352e:	40dc                	lw	a5,4(s1)
    80003530:	8bbd                	andi	a5,a5,15
    80003532:	079a                	slli	a5,a5,0x6
    80003534:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003536:	00059783          	lh	a5,0(a1)
    8000353a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000353e:	00259783          	lh	a5,2(a1)
    80003542:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003546:	00459783          	lh	a5,4(a1)
    8000354a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000354e:	00659783          	lh	a5,6(a1)
    80003552:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003556:	459c                	lw	a5,8(a1)
    80003558:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000355a:	03400613          	li	a2,52
    8000355e:	05b1                	addi	a1,a1,12
    80003560:	05048513          	addi	a0,s1,80
    80003564:	fcefd0ef          	jal	80000d32 <memmove>
    brelse(bp);
    80003568:	854a                	mv	a0,s2
    8000356a:	967ff0ef          	jal	80002ed0 <brelse>
    ip->valid = 1;
    8000356e:	4785                	li	a5,1
    80003570:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003572:	04449783          	lh	a5,68(s1)
    80003576:	c399                	beqz	a5,8000357c <ilock+0xa2>
    80003578:	6902                	ld	s2,0(sp)
    8000357a:	bfbd                	j	800034f8 <ilock+0x1e>
      panic("ilock: no type");
    8000357c:	00004517          	auipc	a0,0x4
    80003580:	ff450513          	addi	a0,a0,-12 # 80007570 <etext+0x570>
    80003584:	a1afd0ef          	jal	8000079e <panic>

0000000080003588 <iunlock>:
{
    80003588:	1101                	addi	sp,sp,-32
    8000358a:	ec06                	sd	ra,24(sp)
    8000358c:	e822                	sd	s0,16(sp)
    8000358e:	e426                	sd	s1,8(sp)
    80003590:	e04a                	sd	s2,0(sp)
    80003592:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003594:	c505                	beqz	a0,800035bc <iunlock+0x34>
    80003596:	84aa                	mv	s1,a0
    80003598:	01050913          	addi	s2,a0,16
    8000359c:	854a                	mv	a0,s2
    8000359e:	2fd000ef          	jal	8000409a <holdingsleep>
    800035a2:	cd09                	beqz	a0,800035bc <iunlock+0x34>
    800035a4:	449c                	lw	a5,8(s1)
    800035a6:	00f05b63          	blez	a5,800035bc <iunlock+0x34>
  releasesleep(&ip->lock);
    800035aa:	854a                	mv	a0,s2
    800035ac:	2b7000ef          	jal	80004062 <releasesleep>
}
    800035b0:	60e2                	ld	ra,24(sp)
    800035b2:	6442                	ld	s0,16(sp)
    800035b4:	64a2                	ld	s1,8(sp)
    800035b6:	6902                	ld	s2,0(sp)
    800035b8:	6105                	addi	sp,sp,32
    800035ba:	8082                	ret
    panic("iunlock");
    800035bc:	00004517          	auipc	a0,0x4
    800035c0:	fc450513          	addi	a0,a0,-60 # 80007580 <etext+0x580>
    800035c4:	9dafd0ef          	jal	8000079e <panic>

00000000800035c8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800035c8:	7179                	addi	sp,sp,-48
    800035ca:	f406                	sd	ra,40(sp)
    800035cc:	f022                	sd	s0,32(sp)
    800035ce:	ec26                	sd	s1,24(sp)
    800035d0:	e84a                	sd	s2,16(sp)
    800035d2:	e44e                	sd	s3,8(sp)
    800035d4:	1800                	addi	s0,sp,48
    800035d6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800035d8:	05050493          	addi	s1,a0,80
    800035dc:	08050913          	addi	s2,a0,128
    800035e0:	a021                	j	800035e8 <itrunc+0x20>
    800035e2:	0491                	addi	s1,s1,4
    800035e4:	01248b63          	beq	s1,s2,800035fa <itrunc+0x32>
    if(ip->addrs[i]){
    800035e8:	408c                	lw	a1,0(s1)
    800035ea:	dde5                	beqz	a1,800035e2 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800035ec:	0009a503          	lw	a0,0(s3)
    800035f0:	9cdff0ef          	jal	80002fbc <bfree>
      ip->addrs[i] = 0;
    800035f4:	0004a023          	sw	zero,0(s1)
    800035f8:	b7ed                	j	800035e2 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800035fa:	0809a583          	lw	a1,128(s3)
    800035fe:	ed89                	bnez	a1,80003618 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003600:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003604:	854e                	mv	a0,s3
    80003606:	e21ff0ef          	jal	80003426 <iupdate>
}
    8000360a:	70a2                	ld	ra,40(sp)
    8000360c:	7402                	ld	s0,32(sp)
    8000360e:	64e2                	ld	s1,24(sp)
    80003610:	6942                	ld	s2,16(sp)
    80003612:	69a2                	ld	s3,8(sp)
    80003614:	6145                	addi	sp,sp,48
    80003616:	8082                	ret
    80003618:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000361a:	0009a503          	lw	a0,0(s3)
    8000361e:	faaff0ef          	jal	80002dc8 <bread>
    80003622:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003624:	05850493          	addi	s1,a0,88
    80003628:	45850913          	addi	s2,a0,1112
    8000362c:	a021                	j	80003634 <itrunc+0x6c>
    8000362e:	0491                	addi	s1,s1,4
    80003630:	01248963          	beq	s1,s2,80003642 <itrunc+0x7a>
      if(a[j])
    80003634:	408c                	lw	a1,0(s1)
    80003636:	dde5                	beqz	a1,8000362e <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003638:	0009a503          	lw	a0,0(s3)
    8000363c:	981ff0ef          	jal	80002fbc <bfree>
    80003640:	b7fd                	j	8000362e <itrunc+0x66>
    brelse(bp);
    80003642:	8552                	mv	a0,s4
    80003644:	88dff0ef          	jal	80002ed0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003648:	0809a583          	lw	a1,128(s3)
    8000364c:	0009a503          	lw	a0,0(s3)
    80003650:	96dff0ef          	jal	80002fbc <bfree>
    ip->addrs[NDIRECT] = 0;
    80003654:	0809a023          	sw	zero,128(s3)
    80003658:	6a02                	ld	s4,0(sp)
    8000365a:	b75d                	j	80003600 <itrunc+0x38>

000000008000365c <iput>:
{
    8000365c:	1101                	addi	sp,sp,-32
    8000365e:	ec06                	sd	ra,24(sp)
    80003660:	e822                	sd	s0,16(sp)
    80003662:	e426                	sd	s1,8(sp)
    80003664:	1000                	addi	s0,sp,32
    80003666:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003668:	0001e517          	auipc	a0,0x1e
    8000366c:	e1050513          	addi	a0,a0,-496 # 80021478 <itable>
    80003670:	d8efd0ef          	jal	80000bfe <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003674:	4498                	lw	a4,8(s1)
    80003676:	4785                	li	a5,1
    80003678:	02f70063          	beq	a4,a5,80003698 <iput+0x3c>
  ip->ref--;
    8000367c:	449c                	lw	a5,8(s1)
    8000367e:	37fd                	addiw	a5,a5,-1
    80003680:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003682:	0001e517          	auipc	a0,0x1e
    80003686:	df650513          	addi	a0,a0,-522 # 80021478 <itable>
    8000368a:	e08fd0ef          	jal	80000c92 <release>
}
    8000368e:	60e2                	ld	ra,24(sp)
    80003690:	6442                	ld	s0,16(sp)
    80003692:	64a2                	ld	s1,8(sp)
    80003694:	6105                	addi	sp,sp,32
    80003696:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003698:	40bc                	lw	a5,64(s1)
    8000369a:	d3ed                	beqz	a5,8000367c <iput+0x20>
    8000369c:	04a49783          	lh	a5,74(s1)
    800036a0:	fff1                	bnez	a5,8000367c <iput+0x20>
    800036a2:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800036a4:	01048913          	addi	s2,s1,16
    800036a8:	854a                	mv	a0,s2
    800036aa:	173000ef          	jal	8000401c <acquiresleep>
    release(&itable.lock);
    800036ae:	0001e517          	auipc	a0,0x1e
    800036b2:	dca50513          	addi	a0,a0,-566 # 80021478 <itable>
    800036b6:	ddcfd0ef          	jal	80000c92 <release>
    itrunc(ip);
    800036ba:	8526                	mv	a0,s1
    800036bc:	f0dff0ef          	jal	800035c8 <itrunc>
    ip->type = 0;
    800036c0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800036c4:	8526                	mv	a0,s1
    800036c6:	d61ff0ef          	jal	80003426 <iupdate>
    ip->valid = 0;
    800036ca:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800036ce:	854a                	mv	a0,s2
    800036d0:	193000ef          	jal	80004062 <releasesleep>
    acquire(&itable.lock);
    800036d4:	0001e517          	auipc	a0,0x1e
    800036d8:	da450513          	addi	a0,a0,-604 # 80021478 <itable>
    800036dc:	d22fd0ef          	jal	80000bfe <acquire>
    800036e0:	6902                	ld	s2,0(sp)
    800036e2:	bf69                	j	8000367c <iput+0x20>

00000000800036e4 <iunlockput>:
{
    800036e4:	1101                	addi	sp,sp,-32
    800036e6:	ec06                	sd	ra,24(sp)
    800036e8:	e822                	sd	s0,16(sp)
    800036ea:	e426                	sd	s1,8(sp)
    800036ec:	1000                	addi	s0,sp,32
    800036ee:	84aa                	mv	s1,a0
  iunlock(ip);
    800036f0:	e99ff0ef          	jal	80003588 <iunlock>
  iput(ip);
    800036f4:	8526                	mv	a0,s1
    800036f6:	f67ff0ef          	jal	8000365c <iput>
}
    800036fa:	60e2                	ld	ra,24(sp)
    800036fc:	6442                	ld	s0,16(sp)
    800036fe:	64a2                	ld	s1,8(sp)
    80003700:	6105                	addi	sp,sp,32
    80003702:	8082                	ret

0000000080003704 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003704:	1141                	addi	sp,sp,-16
    80003706:	e406                	sd	ra,8(sp)
    80003708:	e022                	sd	s0,0(sp)
    8000370a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000370c:	411c                	lw	a5,0(a0)
    8000370e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003710:	415c                	lw	a5,4(a0)
    80003712:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003714:	04451783          	lh	a5,68(a0)
    80003718:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000371c:	04a51783          	lh	a5,74(a0)
    80003720:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003724:	04c56783          	lwu	a5,76(a0)
    80003728:	e99c                	sd	a5,16(a1)
}
    8000372a:	60a2                	ld	ra,8(sp)
    8000372c:	6402                	ld	s0,0(sp)
    8000372e:	0141                	addi	sp,sp,16
    80003730:	8082                	ret

0000000080003732 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003732:	457c                	lw	a5,76(a0)
    80003734:	0ed7e663          	bltu	a5,a3,80003820 <readi+0xee>
{
    80003738:	7159                	addi	sp,sp,-112
    8000373a:	f486                	sd	ra,104(sp)
    8000373c:	f0a2                	sd	s0,96(sp)
    8000373e:	eca6                	sd	s1,88(sp)
    80003740:	e0d2                	sd	s4,64(sp)
    80003742:	fc56                	sd	s5,56(sp)
    80003744:	f85a                	sd	s6,48(sp)
    80003746:	f45e                	sd	s7,40(sp)
    80003748:	1880                	addi	s0,sp,112
    8000374a:	8b2a                	mv	s6,a0
    8000374c:	8bae                	mv	s7,a1
    8000374e:	8a32                	mv	s4,a2
    80003750:	84b6                	mv	s1,a3
    80003752:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003754:	9f35                	addw	a4,a4,a3
    return 0;
    80003756:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003758:	0ad76b63          	bltu	a4,a3,8000380e <readi+0xdc>
    8000375c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000375e:	00e7f463          	bgeu	a5,a4,80003766 <readi+0x34>
    n = ip->size - off;
    80003762:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003766:	080a8b63          	beqz	s5,800037fc <readi+0xca>
    8000376a:	e8ca                	sd	s2,80(sp)
    8000376c:	f062                	sd	s8,32(sp)
    8000376e:	ec66                	sd	s9,24(sp)
    80003770:	e86a                	sd	s10,16(sp)
    80003772:	e46e                	sd	s11,8(sp)
    80003774:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003776:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000377a:	5c7d                	li	s8,-1
    8000377c:	a80d                	j	800037ae <readi+0x7c>
    8000377e:	020d1d93          	slli	s11,s10,0x20
    80003782:	020ddd93          	srli	s11,s11,0x20
    80003786:	05890613          	addi	a2,s2,88
    8000378a:	86ee                	mv	a3,s11
    8000378c:	963e                	add	a2,a2,a5
    8000378e:	85d2                	mv	a1,s4
    80003790:	855e                	mv	a0,s7
    80003792:	b71fe0ef          	jal	80002302 <either_copyout>
    80003796:	05850363          	beq	a0,s8,800037dc <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000379a:	854a                	mv	a0,s2
    8000379c:	f34ff0ef          	jal	80002ed0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800037a0:	013d09bb          	addw	s3,s10,s3
    800037a4:	009d04bb          	addw	s1,s10,s1
    800037a8:	9a6e                	add	s4,s4,s11
    800037aa:	0559f363          	bgeu	s3,s5,800037f0 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800037ae:	00a4d59b          	srliw	a1,s1,0xa
    800037b2:	855a                	mv	a0,s6
    800037b4:	987ff0ef          	jal	8000313a <bmap>
    800037b8:	85aa                	mv	a1,a0
    if(addr == 0)
    800037ba:	c139                	beqz	a0,80003800 <readi+0xce>
    bp = bread(ip->dev, addr);
    800037bc:	000b2503          	lw	a0,0(s6)
    800037c0:	e08ff0ef          	jal	80002dc8 <bread>
    800037c4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800037c6:	3ff4f793          	andi	a5,s1,1023
    800037ca:	40fc873b          	subw	a4,s9,a5
    800037ce:	413a86bb          	subw	a3,s5,s3
    800037d2:	8d3a                	mv	s10,a4
    800037d4:	fae6f5e3          	bgeu	a3,a4,8000377e <readi+0x4c>
    800037d8:	8d36                	mv	s10,a3
    800037da:	b755                	j	8000377e <readi+0x4c>
      brelse(bp);
    800037dc:	854a                	mv	a0,s2
    800037de:	ef2ff0ef          	jal	80002ed0 <brelse>
      tot = -1;
    800037e2:	59fd                	li	s3,-1
      break;
    800037e4:	6946                	ld	s2,80(sp)
    800037e6:	7c02                	ld	s8,32(sp)
    800037e8:	6ce2                	ld	s9,24(sp)
    800037ea:	6d42                	ld	s10,16(sp)
    800037ec:	6da2                	ld	s11,8(sp)
    800037ee:	a831                	j	8000380a <readi+0xd8>
    800037f0:	6946                	ld	s2,80(sp)
    800037f2:	7c02                	ld	s8,32(sp)
    800037f4:	6ce2                	ld	s9,24(sp)
    800037f6:	6d42                	ld	s10,16(sp)
    800037f8:	6da2                	ld	s11,8(sp)
    800037fa:	a801                	j	8000380a <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800037fc:	89d6                	mv	s3,s5
    800037fe:	a031                	j	8000380a <readi+0xd8>
    80003800:	6946                	ld	s2,80(sp)
    80003802:	7c02                	ld	s8,32(sp)
    80003804:	6ce2                	ld	s9,24(sp)
    80003806:	6d42                	ld	s10,16(sp)
    80003808:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000380a:	854e                	mv	a0,s3
    8000380c:	69a6                	ld	s3,72(sp)
}
    8000380e:	70a6                	ld	ra,104(sp)
    80003810:	7406                	ld	s0,96(sp)
    80003812:	64e6                	ld	s1,88(sp)
    80003814:	6a06                	ld	s4,64(sp)
    80003816:	7ae2                	ld	s5,56(sp)
    80003818:	7b42                	ld	s6,48(sp)
    8000381a:	7ba2                	ld	s7,40(sp)
    8000381c:	6165                	addi	sp,sp,112
    8000381e:	8082                	ret
    return 0;
    80003820:	4501                	li	a0,0
}
    80003822:	8082                	ret

0000000080003824 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003824:	457c                	lw	a5,76(a0)
    80003826:	0ed7eb63          	bltu	a5,a3,8000391c <writei+0xf8>
{
    8000382a:	7159                	addi	sp,sp,-112
    8000382c:	f486                	sd	ra,104(sp)
    8000382e:	f0a2                	sd	s0,96(sp)
    80003830:	e8ca                	sd	s2,80(sp)
    80003832:	e0d2                	sd	s4,64(sp)
    80003834:	fc56                	sd	s5,56(sp)
    80003836:	f85a                	sd	s6,48(sp)
    80003838:	f45e                	sd	s7,40(sp)
    8000383a:	1880                	addi	s0,sp,112
    8000383c:	8aaa                	mv	s5,a0
    8000383e:	8bae                	mv	s7,a1
    80003840:	8a32                	mv	s4,a2
    80003842:	8936                	mv	s2,a3
    80003844:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003846:	00e687bb          	addw	a5,a3,a4
    8000384a:	0cd7eb63          	bltu	a5,a3,80003920 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000384e:	00043737          	lui	a4,0x43
    80003852:	0cf76963          	bltu	a4,a5,80003924 <writei+0x100>
    80003856:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003858:	0a0b0a63          	beqz	s6,8000390c <writei+0xe8>
    8000385c:	eca6                	sd	s1,88(sp)
    8000385e:	f062                	sd	s8,32(sp)
    80003860:	ec66                	sd	s9,24(sp)
    80003862:	e86a                	sd	s10,16(sp)
    80003864:	e46e                	sd	s11,8(sp)
    80003866:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003868:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000386c:	5c7d                	li	s8,-1
    8000386e:	a825                	j	800038a6 <writei+0x82>
    80003870:	020d1d93          	slli	s11,s10,0x20
    80003874:	020ddd93          	srli	s11,s11,0x20
    80003878:	05848513          	addi	a0,s1,88
    8000387c:	86ee                	mv	a3,s11
    8000387e:	8652                	mv	a2,s4
    80003880:	85de                	mv	a1,s7
    80003882:	953e                	add	a0,a0,a5
    80003884:	ac9fe0ef          	jal	8000234c <either_copyin>
    80003888:	05850663          	beq	a0,s8,800038d4 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000388c:	8526                	mv	a0,s1
    8000388e:	688000ef          	jal	80003f16 <log_write>
    brelse(bp);
    80003892:	8526                	mv	a0,s1
    80003894:	e3cff0ef          	jal	80002ed0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003898:	013d09bb          	addw	s3,s10,s3
    8000389c:	012d093b          	addw	s2,s10,s2
    800038a0:	9a6e                	add	s4,s4,s11
    800038a2:	0369fc63          	bgeu	s3,s6,800038da <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    800038a6:	00a9559b          	srliw	a1,s2,0xa
    800038aa:	8556                	mv	a0,s5
    800038ac:	88fff0ef          	jal	8000313a <bmap>
    800038b0:	85aa                	mv	a1,a0
    if(addr == 0)
    800038b2:	c505                	beqz	a0,800038da <writei+0xb6>
    bp = bread(ip->dev, addr);
    800038b4:	000aa503          	lw	a0,0(s5)
    800038b8:	d10ff0ef          	jal	80002dc8 <bread>
    800038bc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800038be:	3ff97793          	andi	a5,s2,1023
    800038c2:	40fc873b          	subw	a4,s9,a5
    800038c6:	413b06bb          	subw	a3,s6,s3
    800038ca:	8d3a                	mv	s10,a4
    800038cc:	fae6f2e3          	bgeu	a3,a4,80003870 <writei+0x4c>
    800038d0:	8d36                	mv	s10,a3
    800038d2:	bf79                	j	80003870 <writei+0x4c>
      brelse(bp);
    800038d4:	8526                	mv	a0,s1
    800038d6:	dfaff0ef          	jal	80002ed0 <brelse>
  }

  if(off > ip->size)
    800038da:	04caa783          	lw	a5,76(s5)
    800038de:	0327f963          	bgeu	a5,s2,80003910 <writei+0xec>
    ip->size = off;
    800038e2:	052aa623          	sw	s2,76(s5)
    800038e6:	64e6                	ld	s1,88(sp)
    800038e8:	7c02                	ld	s8,32(sp)
    800038ea:	6ce2                	ld	s9,24(sp)
    800038ec:	6d42                	ld	s10,16(sp)
    800038ee:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800038f0:	8556                	mv	a0,s5
    800038f2:	b35ff0ef          	jal	80003426 <iupdate>

  return tot;
    800038f6:	854e                	mv	a0,s3
    800038f8:	69a6                	ld	s3,72(sp)
}
    800038fa:	70a6                	ld	ra,104(sp)
    800038fc:	7406                	ld	s0,96(sp)
    800038fe:	6946                	ld	s2,80(sp)
    80003900:	6a06                	ld	s4,64(sp)
    80003902:	7ae2                	ld	s5,56(sp)
    80003904:	7b42                	ld	s6,48(sp)
    80003906:	7ba2                	ld	s7,40(sp)
    80003908:	6165                	addi	sp,sp,112
    8000390a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000390c:	89da                	mv	s3,s6
    8000390e:	b7cd                	j	800038f0 <writei+0xcc>
    80003910:	64e6                	ld	s1,88(sp)
    80003912:	7c02                	ld	s8,32(sp)
    80003914:	6ce2                	ld	s9,24(sp)
    80003916:	6d42                	ld	s10,16(sp)
    80003918:	6da2                	ld	s11,8(sp)
    8000391a:	bfd9                	j	800038f0 <writei+0xcc>
    return -1;
    8000391c:	557d                	li	a0,-1
}
    8000391e:	8082                	ret
    return -1;
    80003920:	557d                	li	a0,-1
    80003922:	bfe1                	j	800038fa <writei+0xd6>
    return -1;
    80003924:	557d                	li	a0,-1
    80003926:	bfd1                	j	800038fa <writei+0xd6>

0000000080003928 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003928:	1141                	addi	sp,sp,-16
    8000392a:	e406                	sd	ra,8(sp)
    8000392c:	e022                	sd	s0,0(sp)
    8000392e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003930:	4639                	li	a2,14
    80003932:	c74fd0ef          	jal	80000da6 <strncmp>
}
    80003936:	60a2                	ld	ra,8(sp)
    80003938:	6402                	ld	s0,0(sp)
    8000393a:	0141                	addi	sp,sp,16
    8000393c:	8082                	ret

000000008000393e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000393e:	711d                	addi	sp,sp,-96
    80003940:	ec86                	sd	ra,88(sp)
    80003942:	e8a2                	sd	s0,80(sp)
    80003944:	e4a6                	sd	s1,72(sp)
    80003946:	e0ca                	sd	s2,64(sp)
    80003948:	fc4e                	sd	s3,56(sp)
    8000394a:	f852                	sd	s4,48(sp)
    8000394c:	f456                	sd	s5,40(sp)
    8000394e:	f05a                	sd	s6,32(sp)
    80003950:	ec5e                	sd	s7,24(sp)
    80003952:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003954:	04451703          	lh	a4,68(a0)
    80003958:	4785                	li	a5,1
    8000395a:	00f71f63          	bne	a4,a5,80003978 <dirlookup+0x3a>
    8000395e:	892a                	mv	s2,a0
    80003960:	8aae                	mv	s5,a1
    80003962:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003964:	457c                	lw	a5,76(a0)
    80003966:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003968:	fa040a13          	addi	s4,s0,-96
    8000396c:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    8000396e:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003972:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003974:	e39d                	bnez	a5,8000399a <dirlookup+0x5c>
    80003976:	a8b9                	j	800039d4 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003978:	00004517          	auipc	a0,0x4
    8000397c:	c1050513          	addi	a0,a0,-1008 # 80007588 <etext+0x588>
    80003980:	e1ffc0ef          	jal	8000079e <panic>
      panic("dirlookup read");
    80003984:	00004517          	auipc	a0,0x4
    80003988:	c1c50513          	addi	a0,a0,-996 # 800075a0 <etext+0x5a0>
    8000398c:	e13fc0ef          	jal	8000079e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003990:	24c1                	addiw	s1,s1,16
    80003992:	04c92783          	lw	a5,76(s2)
    80003996:	02f4fe63          	bgeu	s1,a5,800039d2 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000399a:	874e                	mv	a4,s3
    8000399c:	86a6                	mv	a3,s1
    8000399e:	8652                	mv	a2,s4
    800039a0:	4581                	li	a1,0
    800039a2:	854a                	mv	a0,s2
    800039a4:	d8fff0ef          	jal	80003732 <readi>
    800039a8:	fd351ee3          	bne	a0,s3,80003984 <dirlookup+0x46>
    if(de.inum == 0)
    800039ac:	fa045783          	lhu	a5,-96(s0)
    800039b0:	d3e5                	beqz	a5,80003990 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    800039b2:	85da                	mv	a1,s6
    800039b4:	8556                	mv	a0,s5
    800039b6:	f73ff0ef          	jal	80003928 <namecmp>
    800039ba:	f979                	bnez	a0,80003990 <dirlookup+0x52>
      if(poff)
    800039bc:	000b8463          	beqz	s7,800039c4 <dirlookup+0x86>
        *poff = off;
    800039c0:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800039c4:	fa045583          	lhu	a1,-96(s0)
    800039c8:	00092503          	lw	a0,0(s2)
    800039cc:	82fff0ef          	jal	800031fa <iget>
    800039d0:	a011                	j	800039d4 <dirlookup+0x96>
  return 0;
    800039d2:	4501                	li	a0,0
}
    800039d4:	60e6                	ld	ra,88(sp)
    800039d6:	6446                	ld	s0,80(sp)
    800039d8:	64a6                	ld	s1,72(sp)
    800039da:	6906                	ld	s2,64(sp)
    800039dc:	79e2                	ld	s3,56(sp)
    800039de:	7a42                	ld	s4,48(sp)
    800039e0:	7aa2                	ld	s5,40(sp)
    800039e2:	7b02                	ld	s6,32(sp)
    800039e4:	6be2                	ld	s7,24(sp)
    800039e6:	6125                	addi	sp,sp,96
    800039e8:	8082                	ret

00000000800039ea <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800039ea:	711d                	addi	sp,sp,-96
    800039ec:	ec86                	sd	ra,88(sp)
    800039ee:	e8a2                	sd	s0,80(sp)
    800039f0:	e4a6                	sd	s1,72(sp)
    800039f2:	e0ca                	sd	s2,64(sp)
    800039f4:	fc4e                	sd	s3,56(sp)
    800039f6:	f852                	sd	s4,48(sp)
    800039f8:	f456                	sd	s5,40(sp)
    800039fa:	f05a                	sd	s6,32(sp)
    800039fc:	ec5e                	sd	s7,24(sp)
    800039fe:	e862                	sd	s8,16(sp)
    80003a00:	e466                	sd	s9,8(sp)
    80003a02:	e06a                	sd	s10,0(sp)
    80003a04:	1080                	addi	s0,sp,96
    80003a06:	84aa                	mv	s1,a0
    80003a08:	8b2e                	mv	s6,a1
    80003a0a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003a0c:	00054703          	lbu	a4,0(a0)
    80003a10:	02f00793          	li	a5,47
    80003a14:	00f70f63          	beq	a4,a5,80003a32 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003a18:	ec5fd0ef          	jal	800018dc <myproc>
    80003a1c:	15053503          	ld	a0,336(a0)
    80003a20:	a85ff0ef          	jal	800034a4 <idup>
    80003a24:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003a26:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003a2a:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003a2c:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003a2e:	4b85                	li	s7,1
    80003a30:	a879                	j	80003ace <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003a32:	4585                	li	a1,1
    80003a34:	852e                	mv	a0,a1
    80003a36:	fc4ff0ef          	jal	800031fa <iget>
    80003a3a:	8a2a                	mv	s4,a0
    80003a3c:	b7ed                	j	80003a26 <namex+0x3c>
      iunlockput(ip);
    80003a3e:	8552                	mv	a0,s4
    80003a40:	ca5ff0ef          	jal	800036e4 <iunlockput>
      return 0;
    80003a44:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003a46:	8552                	mv	a0,s4
    80003a48:	60e6                	ld	ra,88(sp)
    80003a4a:	6446                	ld	s0,80(sp)
    80003a4c:	64a6                	ld	s1,72(sp)
    80003a4e:	6906                	ld	s2,64(sp)
    80003a50:	79e2                	ld	s3,56(sp)
    80003a52:	7a42                	ld	s4,48(sp)
    80003a54:	7aa2                	ld	s5,40(sp)
    80003a56:	7b02                	ld	s6,32(sp)
    80003a58:	6be2                	ld	s7,24(sp)
    80003a5a:	6c42                	ld	s8,16(sp)
    80003a5c:	6ca2                	ld	s9,8(sp)
    80003a5e:	6d02                	ld	s10,0(sp)
    80003a60:	6125                	addi	sp,sp,96
    80003a62:	8082                	ret
      iunlock(ip);
    80003a64:	8552                	mv	a0,s4
    80003a66:	b23ff0ef          	jal	80003588 <iunlock>
      return ip;
    80003a6a:	bff1                	j	80003a46 <namex+0x5c>
      iunlockput(ip);
    80003a6c:	8552                	mv	a0,s4
    80003a6e:	c77ff0ef          	jal	800036e4 <iunlockput>
      return 0;
    80003a72:	8a4e                	mv	s4,s3
    80003a74:	bfc9                	j	80003a46 <namex+0x5c>
  len = path - s;
    80003a76:	40998633          	sub	a2,s3,s1
    80003a7a:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003a7e:	09ac5063          	bge	s8,s10,80003afe <namex+0x114>
    memmove(name, s, DIRSIZ);
    80003a82:	8666                	mv	a2,s9
    80003a84:	85a6                	mv	a1,s1
    80003a86:	8556                	mv	a0,s5
    80003a88:	aaafd0ef          	jal	80000d32 <memmove>
    80003a8c:	84ce                	mv	s1,s3
  while(*path == '/')
    80003a8e:	0004c783          	lbu	a5,0(s1)
    80003a92:	01279763          	bne	a5,s2,80003aa0 <namex+0xb6>
    path++;
    80003a96:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a98:	0004c783          	lbu	a5,0(s1)
    80003a9c:	ff278de3          	beq	a5,s2,80003a96 <namex+0xac>
    ilock(ip);
    80003aa0:	8552                	mv	a0,s4
    80003aa2:	a39ff0ef          	jal	800034da <ilock>
    if(ip->type != T_DIR){
    80003aa6:	044a1783          	lh	a5,68(s4)
    80003aaa:	f9779ae3          	bne	a5,s7,80003a3e <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003aae:	000b0563          	beqz	s6,80003ab8 <namex+0xce>
    80003ab2:	0004c783          	lbu	a5,0(s1)
    80003ab6:	d7dd                	beqz	a5,80003a64 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003ab8:	4601                	li	a2,0
    80003aba:	85d6                	mv	a1,s5
    80003abc:	8552                	mv	a0,s4
    80003abe:	e81ff0ef          	jal	8000393e <dirlookup>
    80003ac2:	89aa                	mv	s3,a0
    80003ac4:	d545                	beqz	a0,80003a6c <namex+0x82>
    iunlockput(ip);
    80003ac6:	8552                	mv	a0,s4
    80003ac8:	c1dff0ef          	jal	800036e4 <iunlockput>
    ip = next;
    80003acc:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003ace:	0004c783          	lbu	a5,0(s1)
    80003ad2:	01279763          	bne	a5,s2,80003ae0 <namex+0xf6>
    path++;
    80003ad6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003ad8:	0004c783          	lbu	a5,0(s1)
    80003adc:	ff278de3          	beq	a5,s2,80003ad6 <namex+0xec>
  if(*path == 0)
    80003ae0:	cb8d                	beqz	a5,80003b12 <namex+0x128>
  while(*path != '/' && *path != 0)
    80003ae2:	0004c783          	lbu	a5,0(s1)
    80003ae6:	89a6                	mv	s3,s1
  len = path - s;
    80003ae8:	4d01                	li	s10,0
    80003aea:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003aec:	01278963          	beq	a5,s2,80003afe <namex+0x114>
    80003af0:	d3d9                	beqz	a5,80003a76 <namex+0x8c>
    path++;
    80003af2:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003af4:	0009c783          	lbu	a5,0(s3)
    80003af8:	ff279ce3          	bne	a5,s2,80003af0 <namex+0x106>
    80003afc:	bfad                	j	80003a76 <namex+0x8c>
    memmove(name, s, len);
    80003afe:	2601                	sext.w	a2,a2
    80003b00:	85a6                	mv	a1,s1
    80003b02:	8556                	mv	a0,s5
    80003b04:	a2efd0ef          	jal	80000d32 <memmove>
    name[len] = 0;
    80003b08:	9d56                	add	s10,s10,s5
    80003b0a:	000d0023          	sb	zero,0(s10)
    80003b0e:	84ce                	mv	s1,s3
    80003b10:	bfbd                	j	80003a8e <namex+0xa4>
  if(nameiparent){
    80003b12:	f20b0ae3          	beqz	s6,80003a46 <namex+0x5c>
    iput(ip);
    80003b16:	8552                	mv	a0,s4
    80003b18:	b45ff0ef          	jal	8000365c <iput>
    return 0;
    80003b1c:	4a01                	li	s4,0
    80003b1e:	b725                	j	80003a46 <namex+0x5c>

0000000080003b20 <dirlink>:
{
    80003b20:	715d                	addi	sp,sp,-80
    80003b22:	e486                	sd	ra,72(sp)
    80003b24:	e0a2                	sd	s0,64(sp)
    80003b26:	f84a                	sd	s2,48(sp)
    80003b28:	ec56                	sd	s5,24(sp)
    80003b2a:	e85a                	sd	s6,16(sp)
    80003b2c:	0880                	addi	s0,sp,80
    80003b2e:	892a                	mv	s2,a0
    80003b30:	8aae                	mv	s5,a1
    80003b32:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003b34:	4601                	li	a2,0
    80003b36:	e09ff0ef          	jal	8000393e <dirlookup>
    80003b3a:	ed1d                	bnez	a0,80003b78 <dirlink+0x58>
    80003b3c:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b3e:	04c92483          	lw	s1,76(s2)
    80003b42:	c4b9                	beqz	s1,80003b90 <dirlink+0x70>
    80003b44:	f44e                	sd	s3,40(sp)
    80003b46:	f052                	sd	s4,32(sp)
    80003b48:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b4a:	fb040a13          	addi	s4,s0,-80
    80003b4e:	49c1                	li	s3,16
    80003b50:	874e                	mv	a4,s3
    80003b52:	86a6                	mv	a3,s1
    80003b54:	8652                	mv	a2,s4
    80003b56:	4581                	li	a1,0
    80003b58:	854a                	mv	a0,s2
    80003b5a:	bd9ff0ef          	jal	80003732 <readi>
    80003b5e:	03351163          	bne	a0,s3,80003b80 <dirlink+0x60>
    if(de.inum == 0)
    80003b62:	fb045783          	lhu	a5,-80(s0)
    80003b66:	c39d                	beqz	a5,80003b8c <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b68:	24c1                	addiw	s1,s1,16
    80003b6a:	04c92783          	lw	a5,76(s2)
    80003b6e:	fef4e1e3          	bltu	s1,a5,80003b50 <dirlink+0x30>
    80003b72:	79a2                	ld	s3,40(sp)
    80003b74:	7a02                	ld	s4,32(sp)
    80003b76:	a829                	j	80003b90 <dirlink+0x70>
    iput(ip);
    80003b78:	ae5ff0ef          	jal	8000365c <iput>
    return -1;
    80003b7c:	557d                	li	a0,-1
    80003b7e:	a83d                	j	80003bbc <dirlink+0x9c>
      panic("dirlink read");
    80003b80:	00004517          	auipc	a0,0x4
    80003b84:	a3050513          	addi	a0,a0,-1488 # 800075b0 <etext+0x5b0>
    80003b88:	c17fc0ef          	jal	8000079e <panic>
    80003b8c:	79a2                	ld	s3,40(sp)
    80003b8e:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003b90:	4639                	li	a2,14
    80003b92:	85d6                	mv	a1,s5
    80003b94:	fb240513          	addi	a0,s0,-78
    80003b98:	a48fd0ef          	jal	80000de0 <strncpy>
  de.inum = inum;
    80003b9c:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ba0:	4741                	li	a4,16
    80003ba2:	86a6                	mv	a3,s1
    80003ba4:	fb040613          	addi	a2,s0,-80
    80003ba8:	4581                	li	a1,0
    80003baa:	854a                	mv	a0,s2
    80003bac:	c79ff0ef          	jal	80003824 <writei>
    80003bb0:	1541                	addi	a0,a0,-16
    80003bb2:	00a03533          	snez	a0,a0
    80003bb6:	40a0053b          	negw	a0,a0
    80003bba:	74e2                	ld	s1,56(sp)
}
    80003bbc:	60a6                	ld	ra,72(sp)
    80003bbe:	6406                	ld	s0,64(sp)
    80003bc0:	7942                	ld	s2,48(sp)
    80003bc2:	6ae2                	ld	s5,24(sp)
    80003bc4:	6b42                	ld	s6,16(sp)
    80003bc6:	6161                	addi	sp,sp,80
    80003bc8:	8082                	ret

0000000080003bca <namei>:

struct inode*
namei(char *path)
{
    80003bca:	1101                	addi	sp,sp,-32
    80003bcc:	ec06                	sd	ra,24(sp)
    80003bce:	e822                	sd	s0,16(sp)
    80003bd0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003bd2:	fe040613          	addi	a2,s0,-32
    80003bd6:	4581                	li	a1,0
    80003bd8:	e13ff0ef          	jal	800039ea <namex>
}
    80003bdc:	60e2                	ld	ra,24(sp)
    80003bde:	6442                	ld	s0,16(sp)
    80003be0:	6105                	addi	sp,sp,32
    80003be2:	8082                	ret

0000000080003be4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003be4:	1141                	addi	sp,sp,-16
    80003be6:	e406                	sd	ra,8(sp)
    80003be8:	e022                	sd	s0,0(sp)
    80003bea:	0800                	addi	s0,sp,16
    80003bec:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003bee:	4585                	li	a1,1
    80003bf0:	dfbff0ef          	jal	800039ea <namex>
}
    80003bf4:	60a2                	ld	ra,8(sp)
    80003bf6:	6402                	ld	s0,0(sp)
    80003bf8:	0141                	addi	sp,sp,16
    80003bfa:	8082                	ret

0000000080003bfc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003bfc:	1101                	addi	sp,sp,-32
    80003bfe:	ec06                	sd	ra,24(sp)
    80003c00:	e822                	sd	s0,16(sp)
    80003c02:	e426                	sd	s1,8(sp)
    80003c04:	e04a                	sd	s2,0(sp)
    80003c06:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003c08:	0001f917          	auipc	s2,0x1f
    80003c0c:	31890913          	addi	s2,s2,792 # 80022f20 <log>
    80003c10:	01892583          	lw	a1,24(s2)
    80003c14:	02892503          	lw	a0,40(s2)
    80003c18:	9b0ff0ef          	jal	80002dc8 <bread>
    80003c1c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003c1e:	02c92603          	lw	a2,44(s2)
    80003c22:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003c24:	00c05f63          	blez	a2,80003c42 <write_head+0x46>
    80003c28:	0001f717          	auipc	a4,0x1f
    80003c2c:	32870713          	addi	a4,a4,808 # 80022f50 <log+0x30>
    80003c30:	87aa                	mv	a5,a0
    80003c32:	060a                	slli	a2,a2,0x2
    80003c34:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003c36:	4314                	lw	a3,0(a4)
    80003c38:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003c3a:	0711                	addi	a4,a4,4
    80003c3c:	0791                	addi	a5,a5,4
    80003c3e:	fec79ce3          	bne	a5,a2,80003c36 <write_head+0x3a>
  }
  bwrite(buf);
    80003c42:	8526                	mv	a0,s1
    80003c44:	a5aff0ef          	jal	80002e9e <bwrite>
  brelse(buf);
    80003c48:	8526                	mv	a0,s1
    80003c4a:	a86ff0ef          	jal	80002ed0 <brelse>
}
    80003c4e:	60e2                	ld	ra,24(sp)
    80003c50:	6442                	ld	s0,16(sp)
    80003c52:	64a2                	ld	s1,8(sp)
    80003c54:	6902                	ld	s2,0(sp)
    80003c56:	6105                	addi	sp,sp,32
    80003c58:	8082                	ret

0000000080003c5a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c5a:	0001f797          	auipc	a5,0x1f
    80003c5e:	2f27a783          	lw	a5,754(a5) # 80022f4c <log+0x2c>
    80003c62:	0af05263          	blez	a5,80003d06 <install_trans+0xac>
{
    80003c66:	715d                	addi	sp,sp,-80
    80003c68:	e486                	sd	ra,72(sp)
    80003c6a:	e0a2                	sd	s0,64(sp)
    80003c6c:	fc26                	sd	s1,56(sp)
    80003c6e:	f84a                	sd	s2,48(sp)
    80003c70:	f44e                	sd	s3,40(sp)
    80003c72:	f052                	sd	s4,32(sp)
    80003c74:	ec56                	sd	s5,24(sp)
    80003c76:	e85a                	sd	s6,16(sp)
    80003c78:	e45e                	sd	s7,8(sp)
    80003c7a:	0880                	addi	s0,sp,80
    80003c7c:	8b2a                	mv	s6,a0
    80003c7e:	0001fa97          	auipc	s5,0x1f
    80003c82:	2d2a8a93          	addi	s5,s5,722 # 80022f50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c86:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003c88:	0001f997          	auipc	s3,0x1f
    80003c8c:	29898993          	addi	s3,s3,664 # 80022f20 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003c90:	40000b93          	li	s7,1024
    80003c94:	a829                	j	80003cae <install_trans+0x54>
    brelse(lbuf);
    80003c96:	854a                	mv	a0,s2
    80003c98:	a38ff0ef          	jal	80002ed0 <brelse>
    brelse(dbuf);
    80003c9c:	8526                	mv	a0,s1
    80003c9e:	a32ff0ef          	jal	80002ed0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ca2:	2a05                	addiw	s4,s4,1
    80003ca4:	0a91                	addi	s5,s5,4
    80003ca6:	02c9a783          	lw	a5,44(s3)
    80003caa:	04fa5363          	bge	s4,a5,80003cf0 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003cae:	0189a583          	lw	a1,24(s3)
    80003cb2:	014585bb          	addw	a1,a1,s4
    80003cb6:	2585                	addiw	a1,a1,1
    80003cb8:	0289a503          	lw	a0,40(s3)
    80003cbc:	90cff0ef          	jal	80002dc8 <bread>
    80003cc0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003cc2:	000aa583          	lw	a1,0(s5)
    80003cc6:	0289a503          	lw	a0,40(s3)
    80003cca:	8feff0ef          	jal	80002dc8 <bread>
    80003cce:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003cd0:	865e                	mv	a2,s7
    80003cd2:	05890593          	addi	a1,s2,88
    80003cd6:	05850513          	addi	a0,a0,88
    80003cda:	858fd0ef          	jal	80000d32 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003cde:	8526                	mv	a0,s1
    80003ce0:	9beff0ef          	jal	80002e9e <bwrite>
    if(recovering == 0)
    80003ce4:	fa0b19e3          	bnez	s6,80003c96 <install_trans+0x3c>
      bunpin(dbuf);
    80003ce8:	8526                	mv	a0,s1
    80003cea:	a9eff0ef          	jal	80002f88 <bunpin>
    80003cee:	b765                	j	80003c96 <install_trans+0x3c>
}
    80003cf0:	60a6                	ld	ra,72(sp)
    80003cf2:	6406                	ld	s0,64(sp)
    80003cf4:	74e2                	ld	s1,56(sp)
    80003cf6:	7942                	ld	s2,48(sp)
    80003cf8:	79a2                	ld	s3,40(sp)
    80003cfa:	7a02                	ld	s4,32(sp)
    80003cfc:	6ae2                	ld	s5,24(sp)
    80003cfe:	6b42                	ld	s6,16(sp)
    80003d00:	6ba2                	ld	s7,8(sp)
    80003d02:	6161                	addi	sp,sp,80
    80003d04:	8082                	ret
    80003d06:	8082                	ret

0000000080003d08 <initlog>:
{
    80003d08:	7179                	addi	sp,sp,-48
    80003d0a:	f406                	sd	ra,40(sp)
    80003d0c:	f022                	sd	s0,32(sp)
    80003d0e:	ec26                	sd	s1,24(sp)
    80003d10:	e84a                	sd	s2,16(sp)
    80003d12:	e44e                	sd	s3,8(sp)
    80003d14:	1800                	addi	s0,sp,48
    80003d16:	892a                	mv	s2,a0
    80003d18:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003d1a:	0001f497          	auipc	s1,0x1f
    80003d1e:	20648493          	addi	s1,s1,518 # 80022f20 <log>
    80003d22:	00004597          	auipc	a1,0x4
    80003d26:	89e58593          	addi	a1,a1,-1890 # 800075c0 <etext+0x5c0>
    80003d2a:	8526                	mv	a0,s1
    80003d2c:	e4ffc0ef          	jal	80000b7a <initlock>
  log.start = sb->logstart;
    80003d30:	0149a583          	lw	a1,20(s3)
    80003d34:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003d36:	0109a783          	lw	a5,16(s3)
    80003d3a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003d3c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003d40:	854a                	mv	a0,s2
    80003d42:	886ff0ef          	jal	80002dc8 <bread>
  log.lh.n = lh->n;
    80003d46:	4d30                	lw	a2,88(a0)
    80003d48:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003d4a:	00c05f63          	blez	a2,80003d68 <initlog+0x60>
    80003d4e:	87aa                	mv	a5,a0
    80003d50:	0001f717          	auipc	a4,0x1f
    80003d54:	20070713          	addi	a4,a4,512 # 80022f50 <log+0x30>
    80003d58:	060a                	slli	a2,a2,0x2
    80003d5a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003d5c:	4ff4                	lw	a3,92(a5)
    80003d5e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003d60:	0791                	addi	a5,a5,4
    80003d62:	0711                	addi	a4,a4,4
    80003d64:	fec79ce3          	bne	a5,a2,80003d5c <initlog+0x54>
  brelse(buf);
    80003d68:	968ff0ef          	jal	80002ed0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003d6c:	4505                	li	a0,1
    80003d6e:	eedff0ef          	jal	80003c5a <install_trans>
  log.lh.n = 0;
    80003d72:	0001f797          	auipc	a5,0x1f
    80003d76:	1c07ad23          	sw	zero,474(a5) # 80022f4c <log+0x2c>
  write_head(); // clear the log
    80003d7a:	e83ff0ef          	jal	80003bfc <write_head>
}
    80003d7e:	70a2                	ld	ra,40(sp)
    80003d80:	7402                	ld	s0,32(sp)
    80003d82:	64e2                	ld	s1,24(sp)
    80003d84:	6942                	ld	s2,16(sp)
    80003d86:	69a2                	ld	s3,8(sp)
    80003d88:	6145                	addi	sp,sp,48
    80003d8a:	8082                	ret

0000000080003d8c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003d8c:	1101                	addi	sp,sp,-32
    80003d8e:	ec06                	sd	ra,24(sp)
    80003d90:	e822                	sd	s0,16(sp)
    80003d92:	e426                	sd	s1,8(sp)
    80003d94:	e04a                	sd	s2,0(sp)
    80003d96:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003d98:	0001f517          	auipc	a0,0x1f
    80003d9c:	18850513          	addi	a0,a0,392 # 80022f20 <log>
    80003da0:	e5ffc0ef          	jal	80000bfe <acquire>
  while(1){
    if(log.committing){
    80003da4:	0001f497          	auipc	s1,0x1f
    80003da8:	17c48493          	addi	s1,s1,380 # 80022f20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003dac:	4979                	li	s2,30
    80003dae:	a029                	j	80003db8 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003db0:	85a6                	mv	a1,s1
    80003db2:	8526                	mv	a0,s1
    80003db4:	9f8fe0ef          	jal	80001fac <sleep>
    if(log.committing){
    80003db8:	50dc                	lw	a5,36(s1)
    80003dba:	fbfd                	bnez	a5,80003db0 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003dbc:	5098                	lw	a4,32(s1)
    80003dbe:	2705                	addiw	a4,a4,1
    80003dc0:	0027179b          	slliw	a5,a4,0x2
    80003dc4:	9fb9                	addw	a5,a5,a4
    80003dc6:	0017979b          	slliw	a5,a5,0x1
    80003dca:	54d4                	lw	a3,44(s1)
    80003dcc:	9fb5                	addw	a5,a5,a3
    80003dce:	00f95763          	bge	s2,a5,80003ddc <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003dd2:	85a6                	mv	a1,s1
    80003dd4:	8526                	mv	a0,s1
    80003dd6:	9d6fe0ef          	jal	80001fac <sleep>
    80003dda:	bff9                	j	80003db8 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003ddc:	0001f517          	auipc	a0,0x1f
    80003de0:	14450513          	addi	a0,a0,324 # 80022f20 <log>
    80003de4:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003de6:	eadfc0ef          	jal	80000c92 <release>
      break;
    }
  }
}
    80003dea:	60e2                	ld	ra,24(sp)
    80003dec:	6442                	ld	s0,16(sp)
    80003dee:	64a2                	ld	s1,8(sp)
    80003df0:	6902                	ld	s2,0(sp)
    80003df2:	6105                	addi	sp,sp,32
    80003df4:	8082                	ret

0000000080003df6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003df6:	7139                	addi	sp,sp,-64
    80003df8:	fc06                	sd	ra,56(sp)
    80003dfa:	f822                	sd	s0,48(sp)
    80003dfc:	f426                	sd	s1,40(sp)
    80003dfe:	f04a                	sd	s2,32(sp)
    80003e00:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003e02:	0001f497          	auipc	s1,0x1f
    80003e06:	11e48493          	addi	s1,s1,286 # 80022f20 <log>
    80003e0a:	8526                	mv	a0,s1
    80003e0c:	df3fc0ef          	jal	80000bfe <acquire>
  log.outstanding -= 1;
    80003e10:	509c                	lw	a5,32(s1)
    80003e12:	37fd                	addiw	a5,a5,-1
    80003e14:	893e                	mv	s2,a5
    80003e16:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003e18:	50dc                	lw	a5,36(s1)
    80003e1a:	ef9d                	bnez	a5,80003e58 <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    80003e1c:	04091863          	bnez	s2,80003e6c <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003e20:	0001f497          	auipc	s1,0x1f
    80003e24:	10048493          	addi	s1,s1,256 # 80022f20 <log>
    80003e28:	4785                	li	a5,1
    80003e2a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003e2c:	8526                	mv	a0,s1
    80003e2e:	e65fc0ef          	jal	80000c92 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003e32:	54dc                	lw	a5,44(s1)
    80003e34:	04f04c63          	bgtz	a5,80003e8c <end_op+0x96>
    acquire(&log.lock);
    80003e38:	0001f497          	auipc	s1,0x1f
    80003e3c:	0e848493          	addi	s1,s1,232 # 80022f20 <log>
    80003e40:	8526                	mv	a0,s1
    80003e42:	dbdfc0ef          	jal	80000bfe <acquire>
    log.committing = 0;
    80003e46:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003e4a:	8526                	mv	a0,s1
    80003e4c:	9acfe0ef          	jal	80001ff8 <wakeup>
    release(&log.lock);
    80003e50:	8526                	mv	a0,s1
    80003e52:	e41fc0ef          	jal	80000c92 <release>
}
    80003e56:	a02d                	j	80003e80 <end_op+0x8a>
    80003e58:	ec4e                	sd	s3,24(sp)
    80003e5a:	e852                	sd	s4,16(sp)
    80003e5c:	e456                	sd	s5,8(sp)
    80003e5e:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80003e60:	00003517          	auipc	a0,0x3
    80003e64:	76850513          	addi	a0,a0,1896 # 800075c8 <etext+0x5c8>
    80003e68:	937fc0ef          	jal	8000079e <panic>
    wakeup(&log);
    80003e6c:	0001f497          	auipc	s1,0x1f
    80003e70:	0b448493          	addi	s1,s1,180 # 80022f20 <log>
    80003e74:	8526                	mv	a0,s1
    80003e76:	982fe0ef          	jal	80001ff8 <wakeup>
  release(&log.lock);
    80003e7a:	8526                	mv	a0,s1
    80003e7c:	e17fc0ef          	jal	80000c92 <release>
}
    80003e80:	70e2                	ld	ra,56(sp)
    80003e82:	7442                	ld	s0,48(sp)
    80003e84:	74a2                	ld	s1,40(sp)
    80003e86:	7902                	ld	s2,32(sp)
    80003e88:	6121                	addi	sp,sp,64
    80003e8a:	8082                	ret
    80003e8c:	ec4e                	sd	s3,24(sp)
    80003e8e:	e852                	sd	s4,16(sp)
    80003e90:	e456                	sd	s5,8(sp)
    80003e92:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e94:	0001fa97          	auipc	s5,0x1f
    80003e98:	0bca8a93          	addi	s5,s5,188 # 80022f50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003e9c:	0001fa17          	auipc	s4,0x1f
    80003ea0:	084a0a13          	addi	s4,s4,132 # 80022f20 <log>
    memmove(to->data, from->data, BSIZE);
    80003ea4:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003ea8:	018a2583          	lw	a1,24(s4)
    80003eac:	012585bb          	addw	a1,a1,s2
    80003eb0:	2585                	addiw	a1,a1,1
    80003eb2:	028a2503          	lw	a0,40(s4)
    80003eb6:	f13fe0ef          	jal	80002dc8 <bread>
    80003eba:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003ebc:	000aa583          	lw	a1,0(s5)
    80003ec0:	028a2503          	lw	a0,40(s4)
    80003ec4:	f05fe0ef          	jal	80002dc8 <bread>
    80003ec8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003eca:	865a                	mv	a2,s6
    80003ecc:	05850593          	addi	a1,a0,88
    80003ed0:	05848513          	addi	a0,s1,88
    80003ed4:	e5ffc0ef          	jal	80000d32 <memmove>
    bwrite(to);  // write the log
    80003ed8:	8526                	mv	a0,s1
    80003eda:	fc5fe0ef          	jal	80002e9e <bwrite>
    brelse(from);
    80003ede:	854e                	mv	a0,s3
    80003ee0:	ff1fe0ef          	jal	80002ed0 <brelse>
    brelse(to);
    80003ee4:	8526                	mv	a0,s1
    80003ee6:	febfe0ef          	jal	80002ed0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003eea:	2905                	addiw	s2,s2,1
    80003eec:	0a91                	addi	s5,s5,4
    80003eee:	02ca2783          	lw	a5,44(s4)
    80003ef2:	faf94be3          	blt	s2,a5,80003ea8 <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003ef6:	d07ff0ef          	jal	80003bfc <write_head>
    install_trans(0); // Now install writes to home locations
    80003efa:	4501                	li	a0,0
    80003efc:	d5fff0ef          	jal	80003c5a <install_trans>
    log.lh.n = 0;
    80003f00:	0001f797          	auipc	a5,0x1f
    80003f04:	0407a623          	sw	zero,76(a5) # 80022f4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003f08:	cf5ff0ef          	jal	80003bfc <write_head>
    80003f0c:	69e2                	ld	s3,24(sp)
    80003f0e:	6a42                	ld	s4,16(sp)
    80003f10:	6aa2                	ld	s5,8(sp)
    80003f12:	6b02                	ld	s6,0(sp)
    80003f14:	b715                	j	80003e38 <end_op+0x42>

0000000080003f16 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003f16:	1101                	addi	sp,sp,-32
    80003f18:	ec06                	sd	ra,24(sp)
    80003f1a:	e822                	sd	s0,16(sp)
    80003f1c:	e426                	sd	s1,8(sp)
    80003f1e:	e04a                	sd	s2,0(sp)
    80003f20:	1000                	addi	s0,sp,32
    80003f22:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003f24:	0001f917          	auipc	s2,0x1f
    80003f28:	ffc90913          	addi	s2,s2,-4 # 80022f20 <log>
    80003f2c:	854a                	mv	a0,s2
    80003f2e:	cd1fc0ef          	jal	80000bfe <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003f32:	02c92603          	lw	a2,44(s2)
    80003f36:	47f5                	li	a5,29
    80003f38:	06c7c363          	blt	a5,a2,80003f9e <log_write+0x88>
    80003f3c:	0001f797          	auipc	a5,0x1f
    80003f40:	0007a783          	lw	a5,0(a5) # 80022f3c <log+0x1c>
    80003f44:	37fd                	addiw	a5,a5,-1
    80003f46:	04f65c63          	bge	a2,a5,80003f9e <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003f4a:	0001f797          	auipc	a5,0x1f
    80003f4e:	ff67a783          	lw	a5,-10(a5) # 80022f40 <log+0x20>
    80003f52:	04f05c63          	blez	a5,80003faa <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003f56:	4781                	li	a5,0
    80003f58:	04c05f63          	blez	a2,80003fb6 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003f5c:	44cc                	lw	a1,12(s1)
    80003f5e:	0001f717          	auipc	a4,0x1f
    80003f62:	ff270713          	addi	a4,a4,-14 # 80022f50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003f66:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003f68:	4314                	lw	a3,0(a4)
    80003f6a:	04b68663          	beq	a3,a1,80003fb6 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003f6e:	2785                	addiw	a5,a5,1
    80003f70:	0711                	addi	a4,a4,4
    80003f72:	fef61be3          	bne	a2,a5,80003f68 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003f76:	0621                	addi	a2,a2,8
    80003f78:	060a                	slli	a2,a2,0x2
    80003f7a:	0001f797          	auipc	a5,0x1f
    80003f7e:	fa678793          	addi	a5,a5,-90 # 80022f20 <log>
    80003f82:	97b2                	add	a5,a5,a2
    80003f84:	44d8                	lw	a4,12(s1)
    80003f86:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003f88:	8526                	mv	a0,s1
    80003f8a:	fcbfe0ef          	jal	80002f54 <bpin>
    log.lh.n++;
    80003f8e:	0001f717          	auipc	a4,0x1f
    80003f92:	f9270713          	addi	a4,a4,-110 # 80022f20 <log>
    80003f96:	575c                	lw	a5,44(a4)
    80003f98:	2785                	addiw	a5,a5,1
    80003f9a:	d75c                	sw	a5,44(a4)
    80003f9c:	a80d                	j	80003fce <log_write+0xb8>
    panic("too big a transaction");
    80003f9e:	00003517          	auipc	a0,0x3
    80003fa2:	63a50513          	addi	a0,a0,1594 # 800075d8 <etext+0x5d8>
    80003fa6:	ff8fc0ef          	jal	8000079e <panic>
    panic("log_write outside of trans");
    80003faa:	00003517          	auipc	a0,0x3
    80003fae:	64650513          	addi	a0,a0,1606 # 800075f0 <etext+0x5f0>
    80003fb2:	fecfc0ef          	jal	8000079e <panic>
  log.lh.block[i] = b->blockno;
    80003fb6:	00878693          	addi	a3,a5,8
    80003fba:	068a                	slli	a3,a3,0x2
    80003fbc:	0001f717          	auipc	a4,0x1f
    80003fc0:	f6470713          	addi	a4,a4,-156 # 80022f20 <log>
    80003fc4:	9736                	add	a4,a4,a3
    80003fc6:	44d4                	lw	a3,12(s1)
    80003fc8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003fca:	faf60fe3          	beq	a2,a5,80003f88 <log_write+0x72>
  }
  release(&log.lock);
    80003fce:	0001f517          	auipc	a0,0x1f
    80003fd2:	f5250513          	addi	a0,a0,-174 # 80022f20 <log>
    80003fd6:	cbdfc0ef          	jal	80000c92 <release>
}
    80003fda:	60e2                	ld	ra,24(sp)
    80003fdc:	6442                	ld	s0,16(sp)
    80003fde:	64a2                	ld	s1,8(sp)
    80003fe0:	6902                	ld	s2,0(sp)
    80003fe2:	6105                	addi	sp,sp,32
    80003fe4:	8082                	ret

0000000080003fe6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003fe6:	1101                	addi	sp,sp,-32
    80003fe8:	ec06                	sd	ra,24(sp)
    80003fea:	e822                	sd	s0,16(sp)
    80003fec:	e426                	sd	s1,8(sp)
    80003fee:	e04a                	sd	s2,0(sp)
    80003ff0:	1000                	addi	s0,sp,32
    80003ff2:	84aa                	mv	s1,a0
    80003ff4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003ff6:	00003597          	auipc	a1,0x3
    80003ffa:	61a58593          	addi	a1,a1,1562 # 80007610 <etext+0x610>
    80003ffe:	0521                	addi	a0,a0,8
    80004000:	b7bfc0ef          	jal	80000b7a <initlock>
  lk->name = name;
    80004004:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004008:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000400c:	0204a423          	sw	zero,40(s1)
}
    80004010:	60e2                	ld	ra,24(sp)
    80004012:	6442                	ld	s0,16(sp)
    80004014:	64a2                	ld	s1,8(sp)
    80004016:	6902                	ld	s2,0(sp)
    80004018:	6105                	addi	sp,sp,32
    8000401a:	8082                	ret

000000008000401c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000401c:	1101                	addi	sp,sp,-32
    8000401e:	ec06                	sd	ra,24(sp)
    80004020:	e822                	sd	s0,16(sp)
    80004022:	e426                	sd	s1,8(sp)
    80004024:	e04a                	sd	s2,0(sp)
    80004026:	1000                	addi	s0,sp,32
    80004028:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000402a:	00850913          	addi	s2,a0,8
    8000402e:	854a                	mv	a0,s2
    80004030:	bcffc0ef          	jal	80000bfe <acquire>
  while (lk->locked) {
    80004034:	409c                	lw	a5,0(s1)
    80004036:	c799                	beqz	a5,80004044 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004038:	85ca                	mv	a1,s2
    8000403a:	8526                	mv	a0,s1
    8000403c:	f71fd0ef          	jal	80001fac <sleep>
  while (lk->locked) {
    80004040:	409c                	lw	a5,0(s1)
    80004042:	fbfd                	bnez	a5,80004038 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004044:	4785                	li	a5,1
    80004046:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004048:	895fd0ef          	jal	800018dc <myproc>
    8000404c:	591c                	lw	a5,48(a0)
    8000404e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004050:	854a                	mv	a0,s2
    80004052:	c41fc0ef          	jal	80000c92 <release>
}
    80004056:	60e2                	ld	ra,24(sp)
    80004058:	6442                	ld	s0,16(sp)
    8000405a:	64a2                	ld	s1,8(sp)
    8000405c:	6902                	ld	s2,0(sp)
    8000405e:	6105                	addi	sp,sp,32
    80004060:	8082                	ret

0000000080004062 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004062:	1101                	addi	sp,sp,-32
    80004064:	ec06                	sd	ra,24(sp)
    80004066:	e822                	sd	s0,16(sp)
    80004068:	e426                	sd	s1,8(sp)
    8000406a:	e04a                	sd	s2,0(sp)
    8000406c:	1000                	addi	s0,sp,32
    8000406e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004070:	00850913          	addi	s2,a0,8
    80004074:	854a                	mv	a0,s2
    80004076:	b89fc0ef          	jal	80000bfe <acquire>
  lk->locked = 0;
    8000407a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000407e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004082:	8526                	mv	a0,s1
    80004084:	f75fd0ef          	jal	80001ff8 <wakeup>
  release(&lk->lk);
    80004088:	854a                	mv	a0,s2
    8000408a:	c09fc0ef          	jal	80000c92 <release>
}
    8000408e:	60e2                	ld	ra,24(sp)
    80004090:	6442                	ld	s0,16(sp)
    80004092:	64a2                	ld	s1,8(sp)
    80004094:	6902                	ld	s2,0(sp)
    80004096:	6105                	addi	sp,sp,32
    80004098:	8082                	ret

000000008000409a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000409a:	7179                	addi	sp,sp,-48
    8000409c:	f406                	sd	ra,40(sp)
    8000409e:	f022                	sd	s0,32(sp)
    800040a0:	ec26                	sd	s1,24(sp)
    800040a2:	e84a                	sd	s2,16(sp)
    800040a4:	1800                	addi	s0,sp,48
    800040a6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800040a8:	00850913          	addi	s2,a0,8
    800040ac:	854a                	mv	a0,s2
    800040ae:	b51fc0ef          	jal	80000bfe <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800040b2:	409c                	lw	a5,0(s1)
    800040b4:	ef81                	bnez	a5,800040cc <holdingsleep+0x32>
    800040b6:	4481                	li	s1,0
  release(&lk->lk);
    800040b8:	854a                	mv	a0,s2
    800040ba:	bd9fc0ef          	jal	80000c92 <release>
  return r;
}
    800040be:	8526                	mv	a0,s1
    800040c0:	70a2                	ld	ra,40(sp)
    800040c2:	7402                	ld	s0,32(sp)
    800040c4:	64e2                	ld	s1,24(sp)
    800040c6:	6942                	ld	s2,16(sp)
    800040c8:	6145                	addi	sp,sp,48
    800040ca:	8082                	ret
    800040cc:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800040ce:	0284a983          	lw	s3,40(s1)
    800040d2:	80bfd0ef          	jal	800018dc <myproc>
    800040d6:	5904                	lw	s1,48(a0)
    800040d8:	413484b3          	sub	s1,s1,s3
    800040dc:	0014b493          	seqz	s1,s1
    800040e0:	69a2                	ld	s3,8(sp)
    800040e2:	bfd9                	j	800040b8 <holdingsleep+0x1e>

00000000800040e4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800040e4:	1141                	addi	sp,sp,-16
    800040e6:	e406                	sd	ra,8(sp)
    800040e8:	e022                	sd	s0,0(sp)
    800040ea:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800040ec:	00003597          	auipc	a1,0x3
    800040f0:	53458593          	addi	a1,a1,1332 # 80007620 <etext+0x620>
    800040f4:	0001f517          	auipc	a0,0x1f
    800040f8:	f7450513          	addi	a0,a0,-140 # 80023068 <ftable>
    800040fc:	a7ffc0ef          	jal	80000b7a <initlock>
}
    80004100:	60a2                	ld	ra,8(sp)
    80004102:	6402                	ld	s0,0(sp)
    80004104:	0141                	addi	sp,sp,16
    80004106:	8082                	ret

0000000080004108 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004108:	1101                	addi	sp,sp,-32
    8000410a:	ec06                	sd	ra,24(sp)
    8000410c:	e822                	sd	s0,16(sp)
    8000410e:	e426                	sd	s1,8(sp)
    80004110:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004112:	0001f517          	auipc	a0,0x1f
    80004116:	f5650513          	addi	a0,a0,-170 # 80023068 <ftable>
    8000411a:	ae5fc0ef          	jal	80000bfe <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000411e:	0001f497          	auipc	s1,0x1f
    80004122:	f6248493          	addi	s1,s1,-158 # 80023080 <ftable+0x18>
    80004126:	00020717          	auipc	a4,0x20
    8000412a:	efa70713          	addi	a4,a4,-262 # 80024020 <disk>
    if(f->ref == 0){
    8000412e:	40dc                	lw	a5,4(s1)
    80004130:	cf89                	beqz	a5,8000414a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004132:	02848493          	addi	s1,s1,40
    80004136:	fee49ce3          	bne	s1,a4,8000412e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000413a:	0001f517          	auipc	a0,0x1f
    8000413e:	f2e50513          	addi	a0,a0,-210 # 80023068 <ftable>
    80004142:	b51fc0ef          	jal	80000c92 <release>
  return 0;
    80004146:	4481                	li	s1,0
    80004148:	a809                	j	8000415a <filealloc+0x52>
      f->ref = 1;
    8000414a:	4785                	li	a5,1
    8000414c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000414e:	0001f517          	auipc	a0,0x1f
    80004152:	f1a50513          	addi	a0,a0,-230 # 80023068 <ftable>
    80004156:	b3dfc0ef          	jal	80000c92 <release>
}
    8000415a:	8526                	mv	a0,s1
    8000415c:	60e2                	ld	ra,24(sp)
    8000415e:	6442                	ld	s0,16(sp)
    80004160:	64a2                	ld	s1,8(sp)
    80004162:	6105                	addi	sp,sp,32
    80004164:	8082                	ret

0000000080004166 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004166:	1101                	addi	sp,sp,-32
    80004168:	ec06                	sd	ra,24(sp)
    8000416a:	e822                	sd	s0,16(sp)
    8000416c:	e426                	sd	s1,8(sp)
    8000416e:	1000                	addi	s0,sp,32
    80004170:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004172:	0001f517          	auipc	a0,0x1f
    80004176:	ef650513          	addi	a0,a0,-266 # 80023068 <ftable>
    8000417a:	a85fc0ef          	jal	80000bfe <acquire>
  if(f->ref < 1)
    8000417e:	40dc                	lw	a5,4(s1)
    80004180:	02f05063          	blez	a5,800041a0 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004184:	2785                	addiw	a5,a5,1
    80004186:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004188:	0001f517          	auipc	a0,0x1f
    8000418c:	ee050513          	addi	a0,a0,-288 # 80023068 <ftable>
    80004190:	b03fc0ef          	jal	80000c92 <release>
  return f;
}
    80004194:	8526                	mv	a0,s1
    80004196:	60e2                	ld	ra,24(sp)
    80004198:	6442                	ld	s0,16(sp)
    8000419a:	64a2                	ld	s1,8(sp)
    8000419c:	6105                	addi	sp,sp,32
    8000419e:	8082                	ret
    panic("filedup");
    800041a0:	00003517          	auipc	a0,0x3
    800041a4:	48850513          	addi	a0,a0,1160 # 80007628 <etext+0x628>
    800041a8:	df6fc0ef          	jal	8000079e <panic>

00000000800041ac <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800041ac:	7139                	addi	sp,sp,-64
    800041ae:	fc06                	sd	ra,56(sp)
    800041b0:	f822                	sd	s0,48(sp)
    800041b2:	f426                	sd	s1,40(sp)
    800041b4:	0080                	addi	s0,sp,64
    800041b6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800041b8:	0001f517          	auipc	a0,0x1f
    800041bc:	eb050513          	addi	a0,a0,-336 # 80023068 <ftable>
    800041c0:	a3ffc0ef          	jal	80000bfe <acquire>
  if(f->ref < 1)
    800041c4:	40dc                	lw	a5,4(s1)
    800041c6:	04f05863          	blez	a5,80004216 <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    800041ca:	37fd                	addiw	a5,a5,-1
    800041cc:	c0dc                	sw	a5,4(s1)
    800041ce:	04f04e63          	bgtz	a5,8000422a <fileclose+0x7e>
    800041d2:	f04a                	sd	s2,32(sp)
    800041d4:	ec4e                	sd	s3,24(sp)
    800041d6:	e852                	sd	s4,16(sp)
    800041d8:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800041da:	0004a903          	lw	s2,0(s1)
    800041de:	0094ca83          	lbu	s5,9(s1)
    800041e2:	0104ba03          	ld	s4,16(s1)
    800041e6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800041ea:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800041ee:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800041f2:	0001f517          	auipc	a0,0x1f
    800041f6:	e7650513          	addi	a0,a0,-394 # 80023068 <ftable>
    800041fa:	a99fc0ef          	jal	80000c92 <release>

  if(ff.type == FD_PIPE){
    800041fe:	4785                	li	a5,1
    80004200:	04f90063          	beq	s2,a5,80004240 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004204:	3979                	addiw	s2,s2,-2
    80004206:	4785                	li	a5,1
    80004208:	0527f563          	bgeu	a5,s2,80004252 <fileclose+0xa6>
    8000420c:	7902                	ld	s2,32(sp)
    8000420e:	69e2                	ld	s3,24(sp)
    80004210:	6a42                	ld	s4,16(sp)
    80004212:	6aa2                	ld	s5,8(sp)
    80004214:	a00d                	j	80004236 <fileclose+0x8a>
    80004216:	f04a                	sd	s2,32(sp)
    80004218:	ec4e                	sd	s3,24(sp)
    8000421a:	e852                	sd	s4,16(sp)
    8000421c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000421e:	00003517          	auipc	a0,0x3
    80004222:	41250513          	addi	a0,a0,1042 # 80007630 <etext+0x630>
    80004226:	d78fc0ef          	jal	8000079e <panic>
    release(&ftable.lock);
    8000422a:	0001f517          	auipc	a0,0x1f
    8000422e:	e3e50513          	addi	a0,a0,-450 # 80023068 <ftable>
    80004232:	a61fc0ef          	jal	80000c92 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004236:	70e2                	ld	ra,56(sp)
    80004238:	7442                	ld	s0,48(sp)
    8000423a:	74a2                	ld	s1,40(sp)
    8000423c:	6121                	addi	sp,sp,64
    8000423e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004240:	85d6                	mv	a1,s5
    80004242:	8552                	mv	a0,s4
    80004244:	340000ef          	jal	80004584 <pipeclose>
    80004248:	7902                	ld	s2,32(sp)
    8000424a:	69e2                	ld	s3,24(sp)
    8000424c:	6a42                	ld	s4,16(sp)
    8000424e:	6aa2                	ld	s5,8(sp)
    80004250:	b7dd                	j	80004236 <fileclose+0x8a>
    begin_op();
    80004252:	b3bff0ef          	jal	80003d8c <begin_op>
    iput(ff.ip);
    80004256:	854e                	mv	a0,s3
    80004258:	c04ff0ef          	jal	8000365c <iput>
    end_op();
    8000425c:	b9bff0ef          	jal	80003df6 <end_op>
    80004260:	7902                	ld	s2,32(sp)
    80004262:	69e2                	ld	s3,24(sp)
    80004264:	6a42                	ld	s4,16(sp)
    80004266:	6aa2                	ld	s5,8(sp)
    80004268:	b7f9                	j	80004236 <fileclose+0x8a>

000000008000426a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000426a:	715d                	addi	sp,sp,-80
    8000426c:	e486                	sd	ra,72(sp)
    8000426e:	e0a2                	sd	s0,64(sp)
    80004270:	fc26                	sd	s1,56(sp)
    80004272:	f44e                	sd	s3,40(sp)
    80004274:	0880                	addi	s0,sp,80
    80004276:	84aa                	mv	s1,a0
    80004278:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000427a:	e62fd0ef          	jal	800018dc <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000427e:	409c                	lw	a5,0(s1)
    80004280:	37f9                	addiw	a5,a5,-2
    80004282:	4705                	li	a4,1
    80004284:	04f76263          	bltu	a4,a5,800042c8 <filestat+0x5e>
    80004288:	f84a                	sd	s2,48(sp)
    8000428a:	f052                	sd	s4,32(sp)
    8000428c:	892a                	mv	s2,a0
    ilock(f->ip);
    8000428e:	6c88                	ld	a0,24(s1)
    80004290:	a4aff0ef          	jal	800034da <ilock>
    stati(f->ip, &st);
    80004294:	fb840a13          	addi	s4,s0,-72
    80004298:	85d2                	mv	a1,s4
    8000429a:	6c88                	ld	a0,24(s1)
    8000429c:	c68ff0ef          	jal	80003704 <stati>
    iunlock(f->ip);
    800042a0:	6c88                	ld	a0,24(s1)
    800042a2:	ae6ff0ef          	jal	80003588 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800042a6:	46e1                	li	a3,24
    800042a8:	8652                	mv	a2,s4
    800042aa:	85ce                	mv	a1,s3
    800042ac:	05093503          	ld	a0,80(s2)
    800042b0:	ad4fd0ef          	jal	80001584 <copyout>
    800042b4:	41f5551b          	sraiw	a0,a0,0x1f
    800042b8:	7942                	ld	s2,48(sp)
    800042ba:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800042bc:	60a6                	ld	ra,72(sp)
    800042be:	6406                	ld	s0,64(sp)
    800042c0:	74e2                	ld	s1,56(sp)
    800042c2:	79a2                	ld	s3,40(sp)
    800042c4:	6161                	addi	sp,sp,80
    800042c6:	8082                	ret
  return -1;
    800042c8:	557d                	li	a0,-1
    800042ca:	bfcd                	j	800042bc <filestat+0x52>

00000000800042cc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800042cc:	7179                	addi	sp,sp,-48
    800042ce:	f406                	sd	ra,40(sp)
    800042d0:	f022                	sd	s0,32(sp)
    800042d2:	e84a                	sd	s2,16(sp)
    800042d4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800042d6:	00854783          	lbu	a5,8(a0)
    800042da:	cfd1                	beqz	a5,80004376 <fileread+0xaa>
    800042dc:	ec26                	sd	s1,24(sp)
    800042de:	e44e                	sd	s3,8(sp)
    800042e0:	84aa                	mv	s1,a0
    800042e2:	89ae                	mv	s3,a1
    800042e4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800042e6:	411c                	lw	a5,0(a0)
    800042e8:	4705                	li	a4,1
    800042ea:	04e78363          	beq	a5,a4,80004330 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800042ee:	470d                	li	a4,3
    800042f0:	04e78763          	beq	a5,a4,8000433e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800042f4:	4709                	li	a4,2
    800042f6:	06e79a63          	bne	a5,a4,8000436a <fileread+0x9e>
    ilock(f->ip);
    800042fa:	6d08                	ld	a0,24(a0)
    800042fc:	9deff0ef          	jal	800034da <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004300:	874a                	mv	a4,s2
    80004302:	5094                	lw	a3,32(s1)
    80004304:	864e                	mv	a2,s3
    80004306:	4585                	li	a1,1
    80004308:	6c88                	ld	a0,24(s1)
    8000430a:	c28ff0ef          	jal	80003732 <readi>
    8000430e:	892a                	mv	s2,a0
    80004310:	00a05563          	blez	a0,8000431a <fileread+0x4e>
      f->off += r;
    80004314:	509c                	lw	a5,32(s1)
    80004316:	9fa9                	addw	a5,a5,a0
    80004318:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000431a:	6c88                	ld	a0,24(s1)
    8000431c:	a6cff0ef          	jal	80003588 <iunlock>
    80004320:	64e2                	ld	s1,24(sp)
    80004322:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004324:	854a                	mv	a0,s2
    80004326:	70a2                	ld	ra,40(sp)
    80004328:	7402                	ld	s0,32(sp)
    8000432a:	6942                	ld	s2,16(sp)
    8000432c:	6145                	addi	sp,sp,48
    8000432e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004330:	6908                	ld	a0,16(a0)
    80004332:	3a2000ef          	jal	800046d4 <piperead>
    80004336:	892a                	mv	s2,a0
    80004338:	64e2                	ld	s1,24(sp)
    8000433a:	69a2                	ld	s3,8(sp)
    8000433c:	b7e5                	j	80004324 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000433e:	02451783          	lh	a5,36(a0)
    80004342:	03079693          	slli	a3,a5,0x30
    80004346:	92c1                	srli	a3,a3,0x30
    80004348:	4725                	li	a4,9
    8000434a:	02d76863          	bltu	a4,a3,8000437a <fileread+0xae>
    8000434e:	0792                	slli	a5,a5,0x4
    80004350:	0001f717          	auipc	a4,0x1f
    80004354:	c7870713          	addi	a4,a4,-904 # 80022fc8 <devsw>
    80004358:	97ba                	add	a5,a5,a4
    8000435a:	639c                	ld	a5,0(a5)
    8000435c:	c39d                	beqz	a5,80004382 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000435e:	4505                	li	a0,1
    80004360:	9782                	jalr	a5
    80004362:	892a                	mv	s2,a0
    80004364:	64e2                	ld	s1,24(sp)
    80004366:	69a2                	ld	s3,8(sp)
    80004368:	bf75                	j	80004324 <fileread+0x58>
    panic("fileread");
    8000436a:	00003517          	auipc	a0,0x3
    8000436e:	2d650513          	addi	a0,a0,726 # 80007640 <etext+0x640>
    80004372:	c2cfc0ef          	jal	8000079e <panic>
    return -1;
    80004376:	597d                	li	s2,-1
    80004378:	b775                	j	80004324 <fileread+0x58>
      return -1;
    8000437a:	597d                	li	s2,-1
    8000437c:	64e2                	ld	s1,24(sp)
    8000437e:	69a2                	ld	s3,8(sp)
    80004380:	b755                	j	80004324 <fileread+0x58>
    80004382:	597d                	li	s2,-1
    80004384:	64e2                	ld	s1,24(sp)
    80004386:	69a2                	ld	s3,8(sp)
    80004388:	bf71                	j	80004324 <fileread+0x58>

000000008000438a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000438a:	00954783          	lbu	a5,9(a0)
    8000438e:	10078e63          	beqz	a5,800044aa <filewrite+0x120>
{
    80004392:	711d                	addi	sp,sp,-96
    80004394:	ec86                	sd	ra,88(sp)
    80004396:	e8a2                	sd	s0,80(sp)
    80004398:	e0ca                	sd	s2,64(sp)
    8000439a:	f456                	sd	s5,40(sp)
    8000439c:	f05a                	sd	s6,32(sp)
    8000439e:	1080                	addi	s0,sp,96
    800043a0:	892a                	mv	s2,a0
    800043a2:	8b2e                	mv	s6,a1
    800043a4:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800043a6:	411c                	lw	a5,0(a0)
    800043a8:	4705                	li	a4,1
    800043aa:	02e78963          	beq	a5,a4,800043dc <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800043ae:	470d                	li	a4,3
    800043b0:	02e78a63          	beq	a5,a4,800043e4 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800043b4:	4709                	li	a4,2
    800043b6:	0ce79e63          	bne	a5,a4,80004492 <filewrite+0x108>
    800043ba:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800043bc:	0ac05963          	blez	a2,8000446e <filewrite+0xe4>
    800043c0:	e4a6                	sd	s1,72(sp)
    800043c2:	fc4e                	sd	s3,56(sp)
    800043c4:	ec5e                	sd	s7,24(sp)
    800043c6:	e862                	sd	s8,16(sp)
    800043c8:	e466                	sd	s9,8(sp)
    int i = 0;
    800043ca:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800043cc:	6b85                	lui	s7,0x1
    800043ce:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800043d2:	6c85                	lui	s9,0x1
    800043d4:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800043d8:	4c05                	li	s8,1
    800043da:	a8ad                	j	80004454 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    800043dc:	6908                	ld	a0,16(a0)
    800043de:	1fe000ef          	jal	800045dc <pipewrite>
    800043e2:	a04d                	j	80004484 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800043e4:	02451783          	lh	a5,36(a0)
    800043e8:	03079693          	slli	a3,a5,0x30
    800043ec:	92c1                	srli	a3,a3,0x30
    800043ee:	4725                	li	a4,9
    800043f0:	0ad76f63          	bltu	a4,a3,800044ae <filewrite+0x124>
    800043f4:	0792                	slli	a5,a5,0x4
    800043f6:	0001f717          	auipc	a4,0x1f
    800043fa:	bd270713          	addi	a4,a4,-1070 # 80022fc8 <devsw>
    800043fe:	97ba                	add	a5,a5,a4
    80004400:	679c                	ld	a5,8(a5)
    80004402:	cbc5                	beqz	a5,800044b2 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80004404:	4505                	li	a0,1
    80004406:	9782                	jalr	a5
    80004408:	a8b5                	j	80004484 <filewrite+0xfa>
      if(n1 > max)
    8000440a:	2981                	sext.w	s3,s3
      begin_op();
    8000440c:	981ff0ef          	jal	80003d8c <begin_op>
      ilock(f->ip);
    80004410:	01893503          	ld	a0,24(s2)
    80004414:	8c6ff0ef          	jal	800034da <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004418:	874e                	mv	a4,s3
    8000441a:	02092683          	lw	a3,32(s2)
    8000441e:	016a0633          	add	a2,s4,s6
    80004422:	85e2                	mv	a1,s8
    80004424:	01893503          	ld	a0,24(s2)
    80004428:	bfcff0ef          	jal	80003824 <writei>
    8000442c:	84aa                	mv	s1,a0
    8000442e:	00a05763          	blez	a0,8000443c <filewrite+0xb2>
        f->off += r;
    80004432:	02092783          	lw	a5,32(s2)
    80004436:	9fa9                	addw	a5,a5,a0
    80004438:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000443c:	01893503          	ld	a0,24(s2)
    80004440:	948ff0ef          	jal	80003588 <iunlock>
      end_op();
    80004444:	9b3ff0ef          	jal	80003df6 <end_op>

      if(r != n1){
    80004448:	02999563          	bne	s3,s1,80004472 <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    8000444c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004450:	015a5963          	bge	s4,s5,80004462 <filewrite+0xd8>
      int n1 = n - i;
    80004454:	414a87bb          	subw	a5,s5,s4
    80004458:	89be                	mv	s3,a5
      if(n1 > max)
    8000445a:	fafbd8e3          	bge	s7,a5,8000440a <filewrite+0x80>
    8000445e:	89e6                	mv	s3,s9
    80004460:	b76d                	j	8000440a <filewrite+0x80>
    80004462:	64a6                	ld	s1,72(sp)
    80004464:	79e2                	ld	s3,56(sp)
    80004466:	6be2                	ld	s7,24(sp)
    80004468:	6c42                	ld	s8,16(sp)
    8000446a:	6ca2                	ld	s9,8(sp)
    8000446c:	a801                	j	8000447c <filewrite+0xf2>
    int i = 0;
    8000446e:	4a01                	li	s4,0
    80004470:	a031                	j	8000447c <filewrite+0xf2>
    80004472:	64a6                	ld	s1,72(sp)
    80004474:	79e2                	ld	s3,56(sp)
    80004476:	6be2                	ld	s7,24(sp)
    80004478:	6c42                	ld	s8,16(sp)
    8000447a:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000447c:	034a9d63          	bne	s5,s4,800044b6 <filewrite+0x12c>
    80004480:	8556                	mv	a0,s5
    80004482:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004484:	60e6                	ld	ra,88(sp)
    80004486:	6446                	ld	s0,80(sp)
    80004488:	6906                	ld	s2,64(sp)
    8000448a:	7aa2                	ld	s5,40(sp)
    8000448c:	7b02                	ld	s6,32(sp)
    8000448e:	6125                	addi	sp,sp,96
    80004490:	8082                	ret
    80004492:	e4a6                	sd	s1,72(sp)
    80004494:	fc4e                	sd	s3,56(sp)
    80004496:	f852                	sd	s4,48(sp)
    80004498:	ec5e                	sd	s7,24(sp)
    8000449a:	e862                	sd	s8,16(sp)
    8000449c:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000449e:	00003517          	auipc	a0,0x3
    800044a2:	1b250513          	addi	a0,a0,434 # 80007650 <etext+0x650>
    800044a6:	af8fc0ef          	jal	8000079e <panic>
    return -1;
    800044aa:	557d                	li	a0,-1
}
    800044ac:	8082                	ret
      return -1;
    800044ae:	557d                	li	a0,-1
    800044b0:	bfd1                	j	80004484 <filewrite+0xfa>
    800044b2:	557d                	li	a0,-1
    800044b4:	bfc1                	j	80004484 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    800044b6:	557d                	li	a0,-1
    800044b8:	7a42                	ld	s4,48(sp)
    800044ba:	b7e9                	j	80004484 <filewrite+0xfa>

00000000800044bc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800044bc:	7179                	addi	sp,sp,-48
    800044be:	f406                	sd	ra,40(sp)
    800044c0:	f022                	sd	s0,32(sp)
    800044c2:	ec26                	sd	s1,24(sp)
    800044c4:	e052                	sd	s4,0(sp)
    800044c6:	1800                	addi	s0,sp,48
    800044c8:	84aa                	mv	s1,a0
    800044ca:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800044cc:	0005b023          	sd	zero,0(a1)
    800044d0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800044d4:	c35ff0ef          	jal	80004108 <filealloc>
    800044d8:	e088                	sd	a0,0(s1)
    800044da:	c549                	beqz	a0,80004564 <pipealloc+0xa8>
    800044dc:	c2dff0ef          	jal	80004108 <filealloc>
    800044e0:	00aa3023          	sd	a0,0(s4)
    800044e4:	cd25                	beqz	a0,8000455c <pipealloc+0xa0>
    800044e6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800044e8:	e42fc0ef          	jal	80000b2a <kalloc>
    800044ec:	892a                	mv	s2,a0
    800044ee:	c12d                	beqz	a0,80004550 <pipealloc+0x94>
    800044f0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800044f2:	4985                	li	s3,1
    800044f4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800044f8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800044fc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004500:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004504:	00003597          	auipc	a1,0x3
    80004508:	15c58593          	addi	a1,a1,348 # 80007660 <etext+0x660>
    8000450c:	e6efc0ef          	jal	80000b7a <initlock>
  (*f0)->type = FD_PIPE;
    80004510:	609c                	ld	a5,0(s1)
    80004512:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004516:	609c                	ld	a5,0(s1)
    80004518:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000451c:	609c                	ld	a5,0(s1)
    8000451e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004522:	609c                	ld	a5,0(s1)
    80004524:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004528:	000a3783          	ld	a5,0(s4)
    8000452c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004530:	000a3783          	ld	a5,0(s4)
    80004534:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004538:	000a3783          	ld	a5,0(s4)
    8000453c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004540:	000a3783          	ld	a5,0(s4)
    80004544:	0127b823          	sd	s2,16(a5)
  return 0;
    80004548:	4501                	li	a0,0
    8000454a:	6942                	ld	s2,16(sp)
    8000454c:	69a2                	ld	s3,8(sp)
    8000454e:	a01d                	j	80004574 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004550:	6088                	ld	a0,0(s1)
    80004552:	c119                	beqz	a0,80004558 <pipealloc+0x9c>
    80004554:	6942                	ld	s2,16(sp)
    80004556:	a029                	j	80004560 <pipealloc+0xa4>
    80004558:	6942                	ld	s2,16(sp)
    8000455a:	a029                	j	80004564 <pipealloc+0xa8>
    8000455c:	6088                	ld	a0,0(s1)
    8000455e:	c10d                	beqz	a0,80004580 <pipealloc+0xc4>
    fileclose(*f0);
    80004560:	c4dff0ef          	jal	800041ac <fileclose>
  if(*f1)
    80004564:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004568:	557d                	li	a0,-1
  if(*f1)
    8000456a:	c789                	beqz	a5,80004574 <pipealloc+0xb8>
    fileclose(*f1);
    8000456c:	853e                	mv	a0,a5
    8000456e:	c3fff0ef          	jal	800041ac <fileclose>
  return -1;
    80004572:	557d                	li	a0,-1
}
    80004574:	70a2                	ld	ra,40(sp)
    80004576:	7402                	ld	s0,32(sp)
    80004578:	64e2                	ld	s1,24(sp)
    8000457a:	6a02                	ld	s4,0(sp)
    8000457c:	6145                	addi	sp,sp,48
    8000457e:	8082                	ret
  return -1;
    80004580:	557d                	li	a0,-1
    80004582:	bfcd                	j	80004574 <pipealloc+0xb8>

0000000080004584 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004584:	1101                	addi	sp,sp,-32
    80004586:	ec06                	sd	ra,24(sp)
    80004588:	e822                	sd	s0,16(sp)
    8000458a:	e426                	sd	s1,8(sp)
    8000458c:	e04a                	sd	s2,0(sp)
    8000458e:	1000                	addi	s0,sp,32
    80004590:	84aa                	mv	s1,a0
    80004592:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004594:	e6afc0ef          	jal	80000bfe <acquire>
  if(writable){
    80004598:	02090763          	beqz	s2,800045c6 <pipeclose+0x42>
    pi->writeopen = 0;
    8000459c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800045a0:	21848513          	addi	a0,s1,536
    800045a4:	a55fd0ef          	jal	80001ff8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800045a8:	2204b783          	ld	a5,544(s1)
    800045ac:	e785                	bnez	a5,800045d4 <pipeclose+0x50>
    release(&pi->lock);
    800045ae:	8526                	mv	a0,s1
    800045b0:	ee2fc0ef          	jal	80000c92 <release>
    kfree((char*)pi);
    800045b4:	8526                	mv	a0,s1
    800045b6:	c92fc0ef          	jal	80000a48 <kfree>
  } else
    release(&pi->lock);
}
    800045ba:	60e2                	ld	ra,24(sp)
    800045bc:	6442                	ld	s0,16(sp)
    800045be:	64a2                	ld	s1,8(sp)
    800045c0:	6902                	ld	s2,0(sp)
    800045c2:	6105                	addi	sp,sp,32
    800045c4:	8082                	ret
    pi->readopen = 0;
    800045c6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800045ca:	21c48513          	addi	a0,s1,540
    800045ce:	a2bfd0ef          	jal	80001ff8 <wakeup>
    800045d2:	bfd9                	j	800045a8 <pipeclose+0x24>
    release(&pi->lock);
    800045d4:	8526                	mv	a0,s1
    800045d6:	ebcfc0ef          	jal	80000c92 <release>
}
    800045da:	b7c5                	j	800045ba <pipeclose+0x36>

00000000800045dc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800045dc:	7159                	addi	sp,sp,-112
    800045de:	f486                	sd	ra,104(sp)
    800045e0:	f0a2                	sd	s0,96(sp)
    800045e2:	eca6                	sd	s1,88(sp)
    800045e4:	e8ca                	sd	s2,80(sp)
    800045e6:	e4ce                	sd	s3,72(sp)
    800045e8:	e0d2                	sd	s4,64(sp)
    800045ea:	fc56                	sd	s5,56(sp)
    800045ec:	1880                	addi	s0,sp,112
    800045ee:	84aa                	mv	s1,a0
    800045f0:	8aae                	mv	s5,a1
    800045f2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800045f4:	ae8fd0ef          	jal	800018dc <myproc>
    800045f8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800045fa:	8526                	mv	a0,s1
    800045fc:	e02fc0ef          	jal	80000bfe <acquire>
  while(i < n){
    80004600:	0d405263          	blez	s4,800046c4 <pipewrite+0xe8>
    80004604:	f85a                	sd	s6,48(sp)
    80004606:	f45e                	sd	s7,40(sp)
    80004608:	f062                	sd	s8,32(sp)
    8000460a:	ec66                	sd	s9,24(sp)
    8000460c:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000460e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004610:	f9f40c13          	addi	s8,s0,-97
    80004614:	4b85                	li	s7,1
    80004616:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004618:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000461c:	21c48c93          	addi	s9,s1,540
    80004620:	a82d                	j	8000465a <pipewrite+0x7e>
      release(&pi->lock);
    80004622:	8526                	mv	a0,s1
    80004624:	e6efc0ef          	jal	80000c92 <release>
      return -1;
    80004628:	597d                	li	s2,-1
    8000462a:	7b42                	ld	s6,48(sp)
    8000462c:	7ba2                	ld	s7,40(sp)
    8000462e:	7c02                	ld	s8,32(sp)
    80004630:	6ce2                	ld	s9,24(sp)
    80004632:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004634:	854a                	mv	a0,s2
    80004636:	70a6                	ld	ra,104(sp)
    80004638:	7406                	ld	s0,96(sp)
    8000463a:	64e6                	ld	s1,88(sp)
    8000463c:	6946                	ld	s2,80(sp)
    8000463e:	69a6                	ld	s3,72(sp)
    80004640:	6a06                	ld	s4,64(sp)
    80004642:	7ae2                	ld	s5,56(sp)
    80004644:	6165                	addi	sp,sp,112
    80004646:	8082                	ret
      wakeup(&pi->nread);
    80004648:	856a                	mv	a0,s10
    8000464a:	9affd0ef          	jal	80001ff8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000464e:	85a6                	mv	a1,s1
    80004650:	8566                	mv	a0,s9
    80004652:	95bfd0ef          	jal	80001fac <sleep>
  while(i < n){
    80004656:	05495a63          	bge	s2,s4,800046aa <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    8000465a:	2204a783          	lw	a5,544(s1)
    8000465e:	d3f1                	beqz	a5,80004622 <pipewrite+0x46>
    80004660:	854e                	mv	a0,s3
    80004662:	b83fd0ef          	jal	800021e4 <killed>
    80004666:	fd55                	bnez	a0,80004622 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004668:	2184a783          	lw	a5,536(s1)
    8000466c:	21c4a703          	lw	a4,540(s1)
    80004670:	2007879b          	addiw	a5,a5,512
    80004674:	fcf70ae3          	beq	a4,a5,80004648 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004678:	86de                	mv	a3,s7
    8000467a:	01590633          	add	a2,s2,s5
    8000467e:	85e2                	mv	a1,s8
    80004680:	0509b503          	ld	a0,80(s3)
    80004684:	fb1fc0ef          	jal	80001634 <copyin>
    80004688:	05650063          	beq	a0,s6,800046c8 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000468c:	21c4a783          	lw	a5,540(s1)
    80004690:	0017871b          	addiw	a4,a5,1
    80004694:	20e4ae23          	sw	a4,540(s1)
    80004698:	1ff7f793          	andi	a5,a5,511
    8000469c:	97a6                	add	a5,a5,s1
    8000469e:	f9f44703          	lbu	a4,-97(s0)
    800046a2:	00e78c23          	sb	a4,24(a5)
      i++;
    800046a6:	2905                	addiw	s2,s2,1
    800046a8:	b77d                	j	80004656 <pipewrite+0x7a>
    800046aa:	7b42                	ld	s6,48(sp)
    800046ac:	7ba2                	ld	s7,40(sp)
    800046ae:	7c02                	ld	s8,32(sp)
    800046b0:	6ce2                	ld	s9,24(sp)
    800046b2:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800046b4:	21848513          	addi	a0,s1,536
    800046b8:	941fd0ef          	jal	80001ff8 <wakeup>
  release(&pi->lock);
    800046bc:	8526                	mv	a0,s1
    800046be:	dd4fc0ef          	jal	80000c92 <release>
  return i;
    800046c2:	bf8d                	j	80004634 <pipewrite+0x58>
  int i = 0;
    800046c4:	4901                	li	s2,0
    800046c6:	b7fd                	j	800046b4 <pipewrite+0xd8>
    800046c8:	7b42                	ld	s6,48(sp)
    800046ca:	7ba2                	ld	s7,40(sp)
    800046cc:	7c02                	ld	s8,32(sp)
    800046ce:	6ce2                	ld	s9,24(sp)
    800046d0:	6d42                	ld	s10,16(sp)
    800046d2:	b7cd                	j	800046b4 <pipewrite+0xd8>

00000000800046d4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800046d4:	711d                	addi	sp,sp,-96
    800046d6:	ec86                	sd	ra,88(sp)
    800046d8:	e8a2                	sd	s0,80(sp)
    800046da:	e4a6                	sd	s1,72(sp)
    800046dc:	e0ca                	sd	s2,64(sp)
    800046de:	fc4e                	sd	s3,56(sp)
    800046e0:	f852                	sd	s4,48(sp)
    800046e2:	f456                	sd	s5,40(sp)
    800046e4:	1080                	addi	s0,sp,96
    800046e6:	84aa                	mv	s1,a0
    800046e8:	892e                	mv	s2,a1
    800046ea:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800046ec:	9f0fd0ef          	jal	800018dc <myproc>
    800046f0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800046f2:	8526                	mv	a0,s1
    800046f4:	d0afc0ef          	jal	80000bfe <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800046f8:	2184a703          	lw	a4,536(s1)
    800046fc:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004700:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004704:	02f71763          	bne	a4,a5,80004732 <piperead+0x5e>
    80004708:	2244a783          	lw	a5,548(s1)
    8000470c:	cf85                	beqz	a5,80004744 <piperead+0x70>
    if(killed(pr)){
    8000470e:	8552                	mv	a0,s4
    80004710:	ad5fd0ef          	jal	800021e4 <killed>
    80004714:	e11d                	bnez	a0,8000473a <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004716:	85a6                	mv	a1,s1
    80004718:	854e                	mv	a0,s3
    8000471a:	893fd0ef          	jal	80001fac <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000471e:	2184a703          	lw	a4,536(s1)
    80004722:	21c4a783          	lw	a5,540(s1)
    80004726:	fef701e3          	beq	a4,a5,80004708 <piperead+0x34>
    8000472a:	f05a                	sd	s6,32(sp)
    8000472c:	ec5e                	sd	s7,24(sp)
    8000472e:	e862                	sd	s8,16(sp)
    80004730:	a829                	j	8000474a <piperead+0x76>
    80004732:	f05a                	sd	s6,32(sp)
    80004734:	ec5e                	sd	s7,24(sp)
    80004736:	e862                	sd	s8,16(sp)
    80004738:	a809                	j	8000474a <piperead+0x76>
      release(&pi->lock);
    8000473a:	8526                	mv	a0,s1
    8000473c:	d56fc0ef          	jal	80000c92 <release>
      return -1;
    80004740:	59fd                	li	s3,-1
    80004742:	a0a5                	j	800047aa <piperead+0xd6>
    80004744:	f05a                	sd	s6,32(sp)
    80004746:	ec5e                	sd	s7,24(sp)
    80004748:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000474a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000474c:	faf40c13          	addi	s8,s0,-81
    80004750:	4b85                	li	s7,1
    80004752:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004754:	05505163          	blez	s5,80004796 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    80004758:	2184a783          	lw	a5,536(s1)
    8000475c:	21c4a703          	lw	a4,540(s1)
    80004760:	02f70b63          	beq	a4,a5,80004796 <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004764:	0017871b          	addiw	a4,a5,1
    80004768:	20e4ac23          	sw	a4,536(s1)
    8000476c:	1ff7f793          	andi	a5,a5,511
    80004770:	97a6                	add	a5,a5,s1
    80004772:	0187c783          	lbu	a5,24(a5)
    80004776:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000477a:	86de                	mv	a3,s7
    8000477c:	8662                	mv	a2,s8
    8000477e:	85ca                	mv	a1,s2
    80004780:	050a3503          	ld	a0,80(s4)
    80004784:	e01fc0ef          	jal	80001584 <copyout>
    80004788:	01650763          	beq	a0,s6,80004796 <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000478c:	2985                	addiw	s3,s3,1
    8000478e:	0905                	addi	s2,s2,1
    80004790:	fd3a94e3          	bne	s5,s3,80004758 <piperead+0x84>
    80004794:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004796:	21c48513          	addi	a0,s1,540
    8000479a:	85ffd0ef          	jal	80001ff8 <wakeup>
  release(&pi->lock);
    8000479e:	8526                	mv	a0,s1
    800047a0:	cf2fc0ef          	jal	80000c92 <release>
    800047a4:	7b02                	ld	s6,32(sp)
    800047a6:	6be2                	ld	s7,24(sp)
    800047a8:	6c42                	ld	s8,16(sp)
  return i;
}
    800047aa:	854e                	mv	a0,s3
    800047ac:	60e6                	ld	ra,88(sp)
    800047ae:	6446                	ld	s0,80(sp)
    800047b0:	64a6                	ld	s1,72(sp)
    800047b2:	6906                	ld	s2,64(sp)
    800047b4:	79e2                	ld	s3,56(sp)
    800047b6:	7a42                	ld	s4,48(sp)
    800047b8:	7aa2                	ld	s5,40(sp)
    800047ba:	6125                	addi	sp,sp,96
    800047bc:	8082                	ret

00000000800047be <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800047be:	1141                	addi	sp,sp,-16
    800047c0:	e406                	sd	ra,8(sp)
    800047c2:	e022                	sd	s0,0(sp)
    800047c4:	0800                	addi	s0,sp,16
    800047c6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800047c8:	0035151b          	slliw	a0,a0,0x3
    800047cc:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800047ce:	8b89                	andi	a5,a5,2
    800047d0:	c399                	beqz	a5,800047d6 <flags2perm+0x18>
      perm |= PTE_W;
    800047d2:	00456513          	ori	a0,a0,4
    return perm;
}
    800047d6:	60a2                	ld	ra,8(sp)
    800047d8:	6402                	ld	s0,0(sp)
    800047da:	0141                	addi	sp,sp,16
    800047dc:	8082                	ret

00000000800047de <exec>:

int
exec(char *path, char **argv)
{
    800047de:	de010113          	addi	sp,sp,-544
    800047e2:	20113c23          	sd	ra,536(sp)
    800047e6:	20813823          	sd	s0,528(sp)
    800047ea:	20913423          	sd	s1,520(sp)
    800047ee:	21213023          	sd	s2,512(sp)
    800047f2:	1400                	addi	s0,sp,544
    800047f4:	892a                	mv	s2,a0
    800047f6:	dea43823          	sd	a0,-528(s0)
    800047fa:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800047fe:	8defd0ef          	jal	800018dc <myproc>
    80004802:	84aa                	mv	s1,a0

  begin_op();
    80004804:	d88ff0ef          	jal	80003d8c <begin_op>

  if((ip = namei(path)) == 0){
    80004808:	854a                	mv	a0,s2
    8000480a:	bc0ff0ef          	jal	80003bca <namei>
    8000480e:	cd21                	beqz	a0,80004866 <exec+0x88>
    80004810:	fbd2                	sd	s4,496(sp)
    80004812:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004814:	cc7fe0ef          	jal	800034da <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004818:	04000713          	li	a4,64
    8000481c:	4681                	li	a3,0
    8000481e:	e5040613          	addi	a2,s0,-432
    80004822:	4581                	li	a1,0
    80004824:	8552                	mv	a0,s4
    80004826:	f0dfe0ef          	jal	80003732 <readi>
    8000482a:	04000793          	li	a5,64
    8000482e:	00f51a63          	bne	a0,a5,80004842 <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004832:	e5042703          	lw	a4,-432(s0)
    80004836:	464c47b7          	lui	a5,0x464c4
    8000483a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000483e:	02f70863          	beq	a4,a5,8000486e <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004842:	8552                	mv	a0,s4
    80004844:	ea1fe0ef          	jal	800036e4 <iunlockput>
    end_op();
    80004848:	daeff0ef          	jal	80003df6 <end_op>
  }
  return -1;
    8000484c:	557d                	li	a0,-1
    8000484e:	7a5e                	ld	s4,496(sp)
}
    80004850:	21813083          	ld	ra,536(sp)
    80004854:	21013403          	ld	s0,528(sp)
    80004858:	20813483          	ld	s1,520(sp)
    8000485c:	20013903          	ld	s2,512(sp)
    80004860:	22010113          	addi	sp,sp,544
    80004864:	8082                	ret
    end_op();
    80004866:	d90ff0ef          	jal	80003df6 <end_op>
    return -1;
    8000486a:	557d                	li	a0,-1
    8000486c:	b7d5                	j	80004850 <exec+0x72>
    8000486e:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004870:	8526                	mv	a0,s1
    80004872:	912fd0ef          	jal	80001984 <proc_pagetable>
    80004876:	8b2a                	mv	s6,a0
    80004878:	26050d63          	beqz	a0,80004af2 <exec+0x314>
    8000487c:	ffce                	sd	s3,504(sp)
    8000487e:	f7d6                	sd	s5,488(sp)
    80004880:	efde                	sd	s7,472(sp)
    80004882:	ebe2                	sd	s8,464(sp)
    80004884:	e7e6                	sd	s9,456(sp)
    80004886:	e3ea                	sd	s10,448(sp)
    80004888:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000488a:	e7042683          	lw	a3,-400(s0)
    8000488e:	e8845783          	lhu	a5,-376(s0)
    80004892:	0e078763          	beqz	a5,80004980 <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004896:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004898:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000489a:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    8000489e:	6c85                	lui	s9,0x1
    800048a0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800048a4:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800048a8:	6a85                	lui	s5,0x1
    800048aa:	a085                	j	8000490a <exec+0x12c>
      panic("loadseg: address should exist");
    800048ac:	00003517          	auipc	a0,0x3
    800048b0:	dbc50513          	addi	a0,a0,-580 # 80007668 <etext+0x668>
    800048b4:	eebfb0ef          	jal	8000079e <panic>
    if(sz - i < PGSIZE)
    800048b8:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800048ba:	874a                	mv	a4,s2
    800048bc:	009c06bb          	addw	a3,s8,s1
    800048c0:	4581                	li	a1,0
    800048c2:	8552                	mv	a0,s4
    800048c4:	e6ffe0ef          	jal	80003732 <readi>
    800048c8:	22a91963          	bne	s2,a0,80004afa <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    800048cc:	009a84bb          	addw	s1,s5,s1
    800048d0:	0334f263          	bgeu	s1,s3,800048f4 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    800048d4:	02049593          	slli	a1,s1,0x20
    800048d8:	9181                	srli	a1,a1,0x20
    800048da:	95de                	add	a1,a1,s7
    800048dc:	855a                	mv	a0,s6
    800048de:	f1efc0ef          	jal	80000ffc <walkaddr>
    800048e2:	862a                	mv	a2,a0
    if(pa == 0)
    800048e4:	d561                	beqz	a0,800048ac <exec+0xce>
    if(sz - i < PGSIZE)
    800048e6:	409987bb          	subw	a5,s3,s1
    800048ea:	893e                	mv	s2,a5
    800048ec:	fcfcf6e3          	bgeu	s9,a5,800048b8 <exec+0xda>
    800048f0:	8956                	mv	s2,s5
    800048f2:	b7d9                	j	800048b8 <exec+0xda>
    sz = sz1;
    800048f4:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800048f8:	2d05                	addiw	s10,s10,1
    800048fa:	e0843783          	ld	a5,-504(s0)
    800048fe:	0387869b          	addiw	a3,a5,56
    80004902:	e8845783          	lhu	a5,-376(s0)
    80004906:	06fd5e63          	bge	s10,a5,80004982 <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000490a:	e0d43423          	sd	a3,-504(s0)
    8000490e:	876e                	mv	a4,s11
    80004910:	e1840613          	addi	a2,s0,-488
    80004914:	4581                	li	a1,0
    80004916:	8552                	mv	a0,s4
    80004918:	e1bfe0ef          	jal	80003732 <readi>
    8000491c:	1db51d63          	bne	a0,s11,80004af6 <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80004920:	e1842783          	lw	a5,-488(s0)
    80004924:	4705                	li	a4,1
    80004926:	fce799e3          	bne	a5,a4,800048f8 <exec+0x11a>
    if(ph.memsz < ph.filesz)
    8000492a:	e4043483          	ld	s1,-448(s0)
    8000492e:	e3843783          	ld	a5,-456(s0)
    80004932:	1ef4e263          	bltu	s1,a5,80004b16 <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004936:	e2843783          	ld	a5,-472(s0)
    8000493a:	94be                	add	s1,s1,a5
    8000493c:	1ef4e063          	bltu	s1,a5,80004b1c <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80004940:	de843703          	ld	a4,-536(s0)
    80004944:	8ff9                	and	a5,a5,a4
    80004946:	1c079e63          	bnez	a5,80004b22 <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000494a:	e1c42503          	lw	a0,-484(s0)
    8000494e:	e71ff0ef          	jal	800047be <flags2perm>
    80004952:	86aa                	mv	a3,a0
    80004954:	8626                	mv	a2,s1
    80004956:	85ca                	mv	a1,s2
    80004958:	855a                	mv	a0,s6
    8000495a:	a0bfc0ef          	jal	80001364 <uvmalloc>
    8000495e:	dea43c23          	sd	a0,-520(s0)
    80004962:	1c050363          	beqz	a0,80004b28 <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004966:	e2843b83          	ld	s7,-472(s0)
    8000496a:	e2042c03          	lw	s8,-480(s0)
    8000496e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004972:	00098463          	beqz	s3,8000497a <exec+0x19c>
    80004976:	4481                	li	s1,0
    80004978:	bfb1                	j	800048d4 <exec+0xf6>
    sz = sz1;
    8000497a:	df843903          	ld	s2,-520(s0)
    8000497e:	bfad                	j	800048f8 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004980:	4901                	li	s2,0
  iunlockput(ip);
    80004982:	8552                	mv	a0,s4
    80004984:	d61fe0ef          	jal	800036e4 <iunlockput>
  end_op();
    80004988:	c6eff0ef          	jal	80003df6 <end_op>
  p = myproc();
    8000498c:	f51fc0ef          	jal	800018dc <myproc>
    80004990:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004992:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004996:	6985                	lui	s3,0x1
    80004998:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000499a:	99ca                	add	s3,s3,s2
    8000499c:	77fd                	lui	a5,0xfffff
    8000499e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800049a2:	4691                	li	a3,4
    800049a4:	6609                	lui	a2,0x2
    800049a6:	964e                	add	a2,a2,s3
    800049a8:	85ce                	mv	a1,s3
    800049aa:	855a                	mv	a0,s6
    800049ac:	9b9fc0ef          	jal	80001364 <uvmalloc>
    800049b0:	8a2a                	mv	s4,a0
    800049b2:	e105                	bnez	a0,800049d2 <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    800049b4:	85ce                	mv	a1,s3
    800049b6:	855a                	mv	a0,s6
    800049b8:	850fd0ef          	jal	80001a08 <proc_freepagetable>
  return -1;
    800049bc:	557d                	li	a0,-1
    800049be:	79fe                	ld	s3,504(sp)
    800049c0:	7a5e                	ld	s4,496(sp)
    800049c2:	7abe                	ld	s5,488(sp)
    800049c4:	7b1e                	ld	s6,480(sp)
    800049c6:	6bfe                	ld	s7,472(sp)
    800049c8:	6c5e                	ld	s8,464(sp)
    800049ca:	6cbe                	ld	s9,456(sp)
    800049cc:	6d1e                	ld	s10,448(sp)
    800049ce:	7dfa                	ld	s11,440(sp)
    800049d0:	b541                	j	80004850 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800049d2:	75f9                	lui	a1,0xffffe
    800049d4:	95aa                	add	a1,a1,a0
    800049d6:	855a                	mv	a0,s6
    800049d8:	b83fc0ef          	jal	8000155a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800049dc:	7bfd                	lui	s7,0xfffff
    800049de:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    800049e0:	e0043783          	ld	a5,-512(s0)
    800049e4:	6388                	ld	a0,0(a5)
  sp = sz;
    800049e6:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800049e8:	4481                	li	s1,0
    ustack[argc] = sp;
    800049ea:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800049ee:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800049f2:	cd21                	beqz	a0,80004a4a <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    800049f4:	c62fc0ef          	jal	80000e56 <strlen>
    800049f8:	0015079b          	addiw	a5,a0,1
    800049fc:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004a00:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004a04:	13796563          	bltu	s2,s7,80004b2e <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004a08:	e0043d83          	ld	s11,-512(s0)
    80004a0c:	000db983          	ld	s3,0(s11)
    80004a10:	854e                	mv	a0,s3
    80004a12:	c44fc0ef          	jal	80000e56 <strlen>
    80004a16:	0015069b          	addiw	a3,a0,1
    80004a1a:	864e                	mv	a2,s3
    80004a1c:	85ca                	mv	a1,s2
    80004a1e:	855a                	mv	a0,s6
    80004a20:	b65fc0ef          	jal	80001584 <copyout>
    80004a24:	10054763          	bltz	a0,80004b32 <exec+0x354>
    ustack[argc] = sp;
    80004a28:	00349793          	slli	a5,s1,0x3
    80004a2c:	97e6                	add	a5,a5,s9
    80004a2e:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdaea0>
  for(argc = 0; argv[argc]; argc++) {
    80004a32:	0485                	addi	s1,s1,1
    80004a34:	008d8793          	addi	a5,s11,8
    80004a38:	e0f43023          	sd	a5,-512(s0)
    80004a3c:	008db503          	ld	a0,8(s11)
    80004a40:	c509                	beqz	a0,80004a4a <exec+0x26c>
    if(argc >= MAXARG)
    80004a42:	fb8499e3          	bne	s1,s8,800049f4 <exec+0x216>
  sz = sz1;
    80004a46:	89d2                	mv	s3,s4
    80004a48:	b7b5                	j	800049b4 <exec+0x1d6>
  ustack[argc] = 0;
    80004a4a:	00349793          	slli	a5,s1,0x3
    80004a4e:	f9078793          	addi	a5,a5,-112
    80004a52:	97a2                	add	a5,a5,s0
    80004a54:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004a58:	00148693          	addi	a3,s1,1
    80004a5c:	068e                	slli	a3,a3,0x3
    80004a5e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004a62:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004a66:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80004a68:	f57966e3          	bltu	s2,s7,800049b4 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004a6c:	e9040613          	addi	a2,s0,-368
    80004a70:	85ca                	mv	a1,s2
    80004a72:	855a                	mv	a0,s6
    80004a74:	b11fc0ef          	jal	80001584 <copyout>
    80004a78:	f2054ee3          	bltz	a0,800049b4 <exec+0x1d6>
  p->trapframe->a1 = sp;
    80004a7c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004a80:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004a84:	df043783          	ld	a5,-528(s0)
    80004a88:	0007c703          	lbu	a4,0(a5)
    80004a8c:	cf11                	beqz	a4,80004aa8 <exec+0x2ca>
    80004a8e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004a90:	02f00693          	li	a3,47
    80004a94:	a029                	j	80004a9e <exec+0x2c0>
  for(last=s=path; *s; s++)
    80004a96:	0785                	addi	a5,a5,1
    80004a98:	fff7c703          	lbu	a4,-1(a5)
    80004a9c:	c711                	beqz	a4,80004aa8 <exec+0x2ca>
    if(*s == '/')
    80004a9e:	fed71ce3          	bne	a4,a3,80004a96 <exec+0x2b8>
      last = s+1;
    80004aa2:	def43823          	sd	a5,-528(s0)
    80004aa6:	bfc5                	j	80004a96 <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80004aa8:	4641                	li	a2,16
    80004aaa:	df043583          	ld	a1,-528(s0)
    80004aae:	158a8513          	addi	a0,s5,344
    80004ab2:	b6efc0ef          	jal	80000e20 <safestrcpy>
  oldpagetable = p->pagetable;
    80004ab6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004aba:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004abe:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004ac2:	058ab783          	ld	a5,88(s5)
    80004ac6:	e6843703          	ld	a4,-408(s0)
    80004aca:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004acc:	058ab783          	ld	a5,88(s5)
    80004ad0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004ad4:	85ea                	mv	a1,s10
    80004ad6:	f33fc0ef          	jal	80001a08 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004ada:	0004851b          	sext.w	a0,s1
    80004ade:	79fe                	ld	s3,504(sp)
    80004ae0:	7a5e                	ld	s4,496(sp)
    80004ae2:	7abe                	ld	s5,488(sp)
    80004ae4:	7b1e                	ld	s6,480(sp)
    80004ae6:	6bfe                	ld	s7,472(sp)
    80004ae8:	6c5e                	ld	s8,464(sp)
    80004aea:	6cbe                	ld	s9,456(sp)
    80004aec:	6d1e                	ld	s10,448(sp)
    80004aee:	7dfa                	ld	s11,440(sp)
    80004af0:	b385                	j	80004850 <exec+0x72>
    80004af2:	7b1e                	ld	s6,480(sp)
    80004af4:	b3b9                	j	80004842 <exec+0x64>
    80004af6:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004afa:	df843583          	ld	a1,-520(s0)
    80004afe:	855a                	mv	a0,s6
    80004b00:	f09fc0ef          	jal	80001a08 <proc_freepagetable>
  if(ip){
    80004b04:	79fe                	ld	s3,504(sp)
    80004b06:	7abe                	ld	s5,488(sp)
    80004b08:	7b1e                	ld	s6,480(sp)
    80004b0a:	6bfe                	ld	s7,472(sp)
    80004b0c:	6c5e                	ld	s8,464(sp)
    80004b0e:	6cbe                	ld	s9,456(sp)
    80004b10:	6d1e                	ld	s10,448(sp)
    80004b12:	7dfa                	ld	s11,440(sp)
    80004b14:	b33d                	j	80004842 <exec+0x64>
    80004b16:	df243c23          	sd	s2,-520(s0)
    80004b1a:	b7c5                	j	80004afa <exec+0x31c>
    80004b1c:	df243c23          	sd	s2,-520(s0)
    80004b20:	bfe9                	j	80004afa <exec+0x31c>
    80004b22:	df243c23          	sd	s2,-520(s0)
    80004b26:	bfd1                	j	80004afa <exec+0x31c>
    80004b28:	df243c23          	sd	s2,-520(s0)
    80004b2c:	b7f9                	j	80004afa <exec+0x31c>
  sz = sz1;
    80004b2e:	89d2                	mv	s3,s4
    80004b30:	b551                	j	800049b4 <exec+0x1d6>
    80004b32:	89d2                	mv	s3,s4
    80004b34:	b541                	j	800049b4 <exec+0x1d6>

0000000080004b36 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004b36:	7179                	addi	sp,sp,-48
    80004b38:	f406                	sd	ra,40(sp)
    80004b3a:	f022                	sd	s0,32(sp)
    80004b3c:	ec26                	sd	s1,24(sp)
    80004b3e:	e84a                	sd	s2,16(sp)
    80004b40:	1800                	addi	s0,sp,48
    80004b42:	892e                	mv	s2,a1
    80004b44:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004b46:	fdc40593          	addi	a1,s0,-36
    80004b4a:	d6ffd0ef          	jal	800028b8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004b4e:	fdc42703          	lw	a4,-36(s0)
    80004b52:	47bd                	li	a5,15
    80004b54:	02e7e963          	bltu	a5,a4,80004b86 <argfd+0x50>
    80004b58:	d85fc0ef          	jal	800018dc <myproc>
    80004b5c:	fdc42703          	lw	a4,-36(s0)
    80004b60:	01a70793          	addi	a5,a4,26
    80004b64:	078e                	slli	a5,a5,0x3
    80004b66:	953e                	add	a0,a0,a5
    80004b68:	611c                	ld	a5,0(a0)
    80004b6a:	c385                	beqz	a5,80004b8a <argfd+0x54>
    return -1;
  if(pfd)
    80004b6c:	00090463          	beqz	s2,80004b74 <argfd+0x3e>
    *pfd = fd;
    80004b70:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004b74:	4501                	li	a0,0
  if(pf)
    80004b76:	c091                	beqz	s1,80004b7a <argfd+0x44>
    *pf = f;
    80004b78:	e09c                	sd	a5,0(s1)
}
    80004b7a:	70a2                	ld	ra,40(sp)
    80004b7c:	7402                	ld	s0,32(sp)
    80004b7e:	64e2                	ld	s1,24(sp)
    80004b80:	6942                	ld	s2,16(sp)
    80004b82:	6145                	addi	sp,sp,48
    80004b84:	8082                	ret
    return -1;
    80004b86:	557d                	li	a0,-1
    80004b88:	bfcd                	j	80004b7a <argfd+0x44>
    80004b8a:	557d                	li	a0,-1
    80004b8c:	b7fd                	j	80004b7a <argfd+0x44>

0000000080004b8e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004b8e:	1101                	addi	sp,sp,-32
    80004b90:	ec06                	sd	ra,24(sp)
    80004b92:	e822                	sd	s0,16(sp)
    80004b94:	e426                	sd	s1,8(sp)
    80004b96:	1000                	addi	s0,sp,32
    80004b98:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004b9a:	d43fc0ef          	jal	800018dc <myproc>
    80004b9e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004ba0:	0d050793          	addi	a5,a0,208
    80004ba4:	4501                	li	a0,0
    80004ba6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004ba8:	6398                	ld	a4,0(a5)
    80004baa:	cb19                	beqz	a4,80004bc0 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004bac:	2505                	addiw	a0,a0,1
    80004bae:	07a1                	addi	a5,a5,8
    80004bb0:	fed51ce3          	bne	a0,a3,80004ba8 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004bb4:	557d                	li	a0,-1
}
    80004bb6:	60e2                	ld	ra,24(sp)
    80004bb8:	6442                	ld	s0,16(sp)
    80004bba:	64a2                	ld	s1,8(sp)
    80004bbc:	6105                	addi	sp,sp,32
    80004bbe:	8082                	ret
      p->ofile[fd] = f;
    80004bc0:	01a50793          	addi	a5,a0,26
    80004bc4:	078e                	slli	a5,a5,0x3
    80004bc6:	963e                	add	a2,a2,a5
    80004bc8:	e204                	sd	s1,0(a2)
      return fd;
    80004bca:	b7f5                	j	80004bb6 <fdalloc+0x28>

0000000080004bcc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004bcc:	715d                	addi	sp,sp,-80
    80004bce:	e486                	sd	ra,72(sp)
    80004bd0:	e0a2                	sd	s0,64(sp)
    80004bd2:	fc26                	sd	s1,56(sp)
    80004bd4:	f84a                	sd	s2,48(sp)
    80004bd6:	f44e                	sd	s3,40(sp)
    80004bd8:	ec56                	sd	s5,24(sp)
    80004bda:	e85a                	sd	s6,16(sp)
    80004bdc:	0880                	addi	s0,sp,80
    80004bde:	8b2e                	mv	s6,a1
    80004be0:	89b2                	mv	s3,a2
    80004be2:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004be4:	fb040593          	addi	a1,s0,-80
    80004be8:	ffdfe0ef          	jal	80003be4 <nameiparent>
    80004bec:	84aa                	mv	s1,a0
    80004bee:	10050a63          	beqz	a0,80004d02 <create+0x136>
    return 0;

  ilock(dp);
    80004bf2:	8e9fe0ef          	jal	800034da <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004bf6:	4601                	li	a2,0
    80004bf8:	fb040593          	addi	a1,s0,-80
    80004bfc:	8526                	mv	a0,s1
    80004bfe:	d41fe0ef          	jal	8000393e <dirlookup>
    80004c02:	8aaa                	mv	s5,a0
    80004c04:	c129                	beqz	a0,80004c46 <create+0x7a>
    iunlockput(dp);
    80004c06:	8526                	mv	a0,s1
    80004c08:	addfe0ef          	jal	800036e4 <iunlockput>
    ilock(ip);
    80004c0c:	8556                	mv	a0,s5
    80004c0e:	8cdfe0ef          	jal	800034da <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004c12:	4789                	li	a5,2
    80004c14:	02fb1463          	bne	s6,a5,80004c3c <create+0x70>
    80004c18:	044ad783          	lhu	a5,68(s5)
    80004c1c:	37f9                	addiw	a5,a5,-2
    80004c1e:	17c2                	slli	a5,a5,0x30
    80004c20:	93c1                	srli	a5,a5,0x30
    80004c22:	4705                	li	a4,1
    80004c24:	00f76c63          	bltu	a4,a5,80004c3c <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004c28:	8556                	mv	a0,s5
    80004c2a:	60a6                	ld	ra,72(sp)
    80004c2c:	6406                	ld	s0,64(sp)
    80004c2e:	74e2                	ld	s1,56(sp)
    80004c30:	7942                	ld	s2,48(sp)
    80004c32:	79a2                	ld	s3,40(sp)
    80004c34:	6ae2                	ld	s5,24(sp)
    80004c36:	6b42                	ld	s6,16(sp)
    80004c38:	6161                	addi	sp,sp,80
    80004c3a:	8082                	ret
    iunlockput(ip);
    80004c3c:	8556                	mv	a0,s5
    80004c3e:	aa7fe0ef          	jal	800036e4 <iunlockput>
    return 0;
    80004c42:	4a81                	li	s5,0
    80004c44:	b7d5                	j	80004c28 <create+0x5c>
    80004c46:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004c48:	85da                	mv	a1,s6
    80004c4a:	4088                	lw	a0,0(s1)
    80004c4c:	f1efe0ef          	jal	8000336a <ialloc>
    80004c50:	8a2a                	mv	s4,a0
    80004c52:	cd15                	beqz	a0,80004c8e <create+0xc2>
  ilock(ip);
    80004c54:	887fe0ef          	jal	800034da <ilock>
  ip->major = major;
    80004c58:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004c5c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004c60:	4905                	li	s2,1
    80004c62:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004c66:	8552                	mv	a0,s4
    80004c68:	fbefe0ef          	jal	80003426 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004c6c:	032b0763          	beq	s6,s2,80004c9a <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004c70:	004a2603          	lw	a2,4(s4)
    80004c74:	fb040593          	addi	a1,s0,-80
    80004c78:	8526                	mv	a0,s1
    80004c7a:	ea7fe0ef          	jal	80003b20 <dirlink>
    80004c7e:	06054563          	bltz	a0,80004ce8 <create+0x11c>
  iunlockput(dp);
    80004c82:	8526                	mv	a0,s1
    80004c84:	a61fe0ef          	jal	800036e4 <iunlockput>
  return ip;
    80004c88:	8ad2                	mv	s5,s4
    80004c8a:	7a02                	ld	s4,32(sp)
    80004c8c:	bf71                	j	80004c28 <create+0x5c>
    iunlockput(dp);
    80004c8e:	8526                	mv	a0,s1
    80004c90:	a55fe0ef          	jal	800036e4 <iunlockput>
    return 0;
    80004c94:	8ad2                	mv	s5,s4
    80004c96:	7a02                	ld	s4,32(sp)
    80004c98:	bf41                	j	80004c28 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004c9a:	004a2603          	lw	a2,4(s4)
    80004c9e:	00003597          	auipc	a1,0x3
    80004ca2:	9ea58593          	addi	a1,a1,-1558 # 80007688 <etext+0x688>
    80004ca6:	8552                	mv	a0,s4
    80004ca8:	e79fe0ef          	jal	80003b20 <dirlink>
    80004cac:	02054e63          	bltz	a0,80004ce8 <create+0x11c>
    80004cb0:	40d0                	lw	a2,4(s1)
    80004cb2:	00003597          	auipc	a1,0x3
    80004cb6:	9de58593          	addi	a1,a1,-1570 # 80007690 <etext+0x690>
    80004cba:	8552                	mv	a0,s4
    80004cbc:	e65fe0ef          	jal	80003b20 <dirlink>
    80004cc0:	02054463          	bltz	a0,80004ce8 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004cc4:	004a2603          	lw	a2,4(s4)
    80004cc8:	fb040593          	addi	a1,s0,-80
    80004ccc:	8526                	mv	a0,s1
    80004cce:	e53fe0ef          	jal	80003b20 <dirlink>
    80004cd2:	00054b63          	bltz	a0,80004ce8 <create+0x11c>
    dp->nlink++;  // for ".."
    80004cd6:	04a4d783          	lhu	a5,74(s1)
    80004cda:	2785                	addiw	a5,a5,1
    80004cdc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ce0:	8526                	mv	a0,s1
    80004ce2:	f44fe0ef          	jal	80003426 <iupdate>
    80004ce6:	bf71                	j	80004c82 <create+0xb6>
  ip->nlink = 0;
    80004ce8:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004cec:	8552                	mv	a0,s4
    80004cee:	f38fe0ef          	jal	80003426 <iupdate>
  iunlockput(ip);
    80004cf2:	8552                	mv	a0,s4
    80004cf4:	9f1fe0ef          	jal	800036e4 <iunlockput>
  iunlockput(dp);
    80004cf8:	8526                	mv	a0,s1
    80004cfa:	9ebfe0ef          	jal	800036e4 <iunlockput>
  return 0;
    80004cfe:	7a02                	ld	s4,32(sp)
    80004d00:	b725                	j	80004c28 <create+0x5c>
    return 0;
    80004d02:	8aaa                	mv	s5,a0
    80004d04:	b715                	j	80004c28 <create+0x5c>

0000000080004d06 <sys_dup>:
{
    80004d06:	7179                	addi	sp,sp,-48
    80004d08:	f406                	sd	ra,40(sp)
    80004d0a:	f022                	sd	s0,32(sp)
    80004d0c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004d0e:	fd840613          	addi	a2,s0,-40
    80004d12:	4581                	li	a1,0
    80004d14:	4501                	li	a0,0
    80004d16:	e21ff0ef          	jal	80004b36 <argfd>
    return -1;
    80004d1a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004d1c:	02054363          	bltz	a0,80004d42 <sys_dup+0x3c>
    80004d20:	ec26                	sd	s1,24(sp)
    80004d22:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004d24:	fd843903          	ld	s2,-40(s0)
    80004d28:	854a                	mv	a0,s2
    80004d2a:	e65ff0ef          	jal	80004b8e <fdalloc>
    80004d2e:	84aa                	mv	s1,a0
    return -1;
    80004d30:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004d32:	00054d63          	bltz	a0,80004d4c <sys_dup+0x46>
  filedup(f);
    80004d36:	854a                	mv	a0,s2
    80004d38:	c2eff0ef          	jal	80004166 <filedup>
  return fd;
    80004d3c:	87a6                	mv	a5,s1
    80004d3e:	64e2                	ld	s1,24(sp)
    80004d40:	6942                	ld	s2,16(sp)
}
    80004d42:	853e                	mv	a0,a5
    80004d44:	70a2                	ld	ra,40(sp)
    80004d46:	7402                	ld	s0,32(sp)
    80004d48:	6145                	addi	sp,sp,48
    80004d4a:	8082                	ret
    80004d4c:	64e2                	ld	s1,24(sp)
    80004d4e:	6942                	ld	s2,16(sp)
    80004d50:	bfcd                	j	80004d42 <sys_dup+0x3c>

0000000080004d52 <sys_read>:
{
    80004d52:	7179                	addi	sp,sp,-48
    80004d54:	f406                	sd	ra,40(sp)
    80004d56:	f022                	sd	s0,32(sp)
    80004d58:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004d5a:	fd840593          	addi	a1,s0,-40
    80004d5e:	4505                	li	a0,1
    80004d60:	b75fd0ef          	jal	800028d4 <argaddr>
  argint(2, &n);
    80004d64:	fe440593          	addi	a1,s0,-28
    80004d68:	4509                	li	a0,2
    80004d6a:	b4ffd0ef          	jal	800028b8 <argint>
  if(argfd(0, 0, &f) < 0)
    80004d6e:	fe840613          	addi	a2,s0,-24
    80004d72:	4581                	li	a1,0
    80004d74:	4501                	li	a0,0
    80004d76:	dc1ff0ef          	jal	80004b36 <argfd>
    80004d7a:	87aa                	mv	a5,a0
    return -1;
    80004d7c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004d7e:	0007ca63          	bltz	a5,80004d92 <sys_read+0x40>
  return fileread(f, p, n);
    80004d82:	fe442603          	lw	a2,-28(s0)
    80004d86:	fd843583          	ld	a1,-40(s0)
    80004d8a:	fe843503          	ld	a0,-24(s0)
    80004d8e:	d3eff0ef          	jal	800042cc <fileread>
}
    80004d92:	70a2                	ld	ra,40(sp)
    80004d94:	7402                	ld	s0,32(sp)
    80004d96:	6145                	addi	sp,sp,48
    80004d98:	8082                	ret

0000000080004d9a <sys_write>:
{
    80004d9a:	7179                	addi	sp,sp,-48
    80004d9c:	f406                	sd	ra,40(sp)
    80004d9e:	f022                	sd	s0,32(sp)
    80004da0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004da2:	fd840593          	addi	a1,s0,-40
    80004da6:	4505                	li	a0,1
    80004da8:	b2dfd0ef          	jal	800028d4 <argaddr>
  argint(2, &n);
    80004dac:	fe440593          	addi	a1,s0,-28
    80004db0:	4509                	li	a0,2
    80004db2:	b07fd0ef          	jal	800028b8 <argint>
  if(argfd(0, 0, &f) < 0)
    80004db6:	fe840613          	addi	a2,s0,-24
    80004dba:	4581                	li	a1,0
    80004dbc:	4501                	li	a0,0
    80004dbe:	d79ff0ef          	jal	80004b36 <argfd>
    80004dc2:	87aa                	mv	a5,a0
    return -1;
    80004dc4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004dc6:	0007ca63          	bltz	a5,80004dda <sys_write+0x40>
  return filewrite(f, p, n);
    80004dca:	fe442603          	lw	a2,-28(s0)
    80004dce:	fd843583          	ld	a1,-40(s0)
    80004dd2:	fe843503          	ld	a0,-24(s0)
    80004dd6:	db4ff0ef          	jal	8000438a <filewrite>
}
    80004dda:	70a2                	ld	ra,40(sp)
    80004ddc:	7402                	ld	s0,32(sp)
    80004dde:	6145                	addi	sp,sp,48
    80004de0:	8082                	ret

0000000080004de2 <sys_close>:
{
    80004de2:	1101                	addi	sp,sp,-32
    80004de4:	ec06                	sd	ra,24(sp)
    80004de6:	e822                	sd	s0,16(sp)
    80004de8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004dea:	fe040613          	addi	a2,s0,-32
    80004dee:	fec40593          	addi	a1,s0,-20
    80004df2:	4501                	li	a0,0
    80004df4:	d43ff0ef          	jal	80004b36 <argfd>
    return -1;
    80004df8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004dfa:	02054063          	bltz	a0,80004e1a <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004dfe:	adffc0ef          	jal	800018dc <myproc>
    80004e02:	fec42783          	lw	a5,-20(s0)
    80004e06:	07e9                	addi	a5,a5,26
    80004e08:	078e                	slli	a5,a5,0x3
    80004e0a:	953e                	add	a0,a0,a5
    80004e0c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004e10:	fe043503          	ld	a0,-32(s0)
    80004e14:	b98ff0ef          	jal	800041ac <fileclose>
  return 0;
    80004e18:	4781                	li	a5,0
}
    80004e1a:	853e                	mv	a0,a5
    80004e1c:	60e2                	ld	ra,24(sp)
    80004e1e:	6442                	ld	s0,16(sp)
    80004e20:	6105                	addi	sp,sp,32
    80004e22:	8082                	ret

0000000080004e24 <sys_fstat>:
{
    80004e24:	1101                	addi	sp,sp,-32
    80004e26:	ec06                	sd	ra,24(sp)
    80004e28:	e822                	sd	s0,16(sp)
    80004e2a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004e2c:	fe040593          	addi	a1,s0,-32
    80004e30:	4505                	li	a0,1
    80004e32:	aa3fd0ef          	jal	800028d4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004e36:	fe840613          	addi	a2,s0,-24
    80004e3a:	4581                	li	a1,0
    80004e3c:	4501                	li	a0,0
    80004e3e:	cf9ff0ef          	jal	80004b36 <argfd>
    80004e42:	87aa                	mv	a5,a0
    return -1;
    80004e44:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e46:	0007c863          	bltz	a5,80004e56 <sys_fstat+0x32>
  return filestat(f, st);
    80004e4a:	fe043583          	ld	a1,-32(s0)
    80004e4e:	fe843503          	ld	a0,-24(s0)
    80004e52:	c18ff0ef          	jal	8000426a <filestat>
}
    80004e56:	60e2                	ld	ra,24(sp)
    80004e58:	6442                	ld	s0,16(sp)
    80004e5a:	6105                	addi	sp,sp,32
    80004e5c:	8082                	ret

0000000080004e5e <sys_link>:
{
    80004e5e:	7169                	addi	sp,sp,-304
    80004e60:	f606                	sd	ra,296(sp)
    80004e62:	f222                	sd	s0,288(sp)
    80004e64:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e66:	08000613          	li	a2,128
    80004e6a:	ed040593          	addi	a1,s0,-304
    80004e6e:	4501                	li	a0,0
    80004e70:	a81fd0ef          	jal	800028f0 <argstr>
    return -1;
    80004e74:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e76:	0c054e63          	bltz	a0,80004f52 <sys_link+0xf4>
    80004e7a:	08000613          	li	a2,128
    80004e7e:	f5040593          	addi	a1,s0,-176
    80004e82:	4505                	li	a0,1
    80004e84:	a6dfd0ef          	jal	800028f0 <argstr>
    return -1;
    80004e88:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e8a:	0c054463          	bltz	a0,80004f52 <sys_link+0xf4>
    80004e8e:	ee26                	sd	s1,280(sp)
  begin_op();
    80004e90:	efdfe0ef          	jal	80003d8c <begin_op>
  if((ip = namei(old)) == 0){
    80004e94:	ed040513          	addi	a0,s0,-304
    80004e98:	d33fe0ef          	jal	80003bca <namei>
    80004e9c:	84aa                	mv	s1,a0
    80004e9e:	c53d                	beqz	a0,80004f0c <sys_link+0xae>
  ilock(ip);
    80004ea0:	e3afe0ef          	jal	800034da <ilock>
  if(ip->type == T_DIR){
    80004ea4:	04449703          	lh	a4,68(s1)
    80004ea8:	4785                	li	a5,1
    80004eaa:	06f70663          	beq	a4,a5,80004f16 <sys_link+0xb8>
    80004eae:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004eb0:	04a4d783          	lhu	a5,74(s1)
    80004eb4:	2785                	addiw	a5,a5,1
    80004eb6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004eba:	8526                	mv	a0,s1
    80004ebc:	d6afe0ef          	jal	80003426 <iupdate>
  iunlock(ip);
    80004ec0:	8526                	mv	a0,s1
    80004ec2:	ec6fe0ef          	jal	80003588 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ec6:	fd040593          	addi	a1,s0,-48
    80004eca:	f5040513          	addi	a0,s0,-176
    80004ece:	d17fe0ef          	jal	80003be4 <nameiparent>
    80004ed2:	892a                	mv	s2,a0
    80004ed4:	cd21                	beqz	a0,80004f2c <sys_link+0xce>
  ilock(dp);
    80004ed6:	e04fe0ef          	jal	800034da <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004eda:	00092703          	lw	a4,0(s2)
    80004ede:	409c                	lw	a5,0(s1)
    80004ee0:	04f71363          	bne	a4,a5,80004f26 <sys_link+0xc8>
    80004ee4:	40d0                	lw	a2,4(s1)
    80004ee6:	fd040593          	addi	a1,s0,-48
    80004eea:	854a                	mv	a0,s2
    80004eec:	c35fe0ef          	jal	80003b20 <dirlink>
    80004ef0:	02054b63          	bltz	a0,80004f26 <sys_link+0xc8>
  iunlockput(dp);
    80004ef4:	854a                	mv	a0,s2
    80004ef6:	feefe0ef          	jal	800036e4 <iunlockput>
  iput(ip);
    80004efa:	8526                	mv	a0,s1
    80004efc:	f60fe0ef          	jal	8000365c <iput>
  end_op();
    80004f00:	ef7fe0ef          	jal	80003df6 <end_op>
  return 0;
    80004f04:	4781                	li	a5,0
    80004f06:	64f2                	ld	s1,280(sp)
    80004f08:	6952                	ld	s2,272(sp)
    80004f0a:	a0a1                	j	80004f52 <sys_link+0xf4>
    end_op();
    80004f0c:	eebfe0ef          	jal	80003df6 <end_op>
    return -1;
    80004f10:	57fd                	li	a5,-1
    80004f12:	64f2                	ld	s1,280(sp)
    80004f14:	a83d                	j	80004f52 <sys_link+0xf4>
    iunlockput(ip);
    80004f16:	8526                	mv	a0,s1
    80004f18:	fccfe0ef          	jal	800036e4 <iunlockput>
    end_op();
    80004f1c:	edbfe0ef          	jal	80003df6 <end_op>
    return -1;
    80004f20:	57fd                	li	a5,-1
    80004f22:	64f2                	ld	s1,280(sp)
    80004f24:	a03d                	j	80004f52 <sys_link+0xf4>
    iunlockput(dp);
    80004f26:	854a                	mv	a0,s2
    80004f28:	fbcfe0ef          	jal	800036e4 <iunlockput>
  ilock(ip);
    80004f2c:	8526                	mv	a0,s1
    80004f2e:	dacfe0ef          	jal	800034da <ilock>
  ip->nlink--;
    80004f32:	04a4d783          	lhu	a5,74(s1)
    80004f36:	37fd                	addiw	a5,a5,-1
    80004f38:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f3c:	8526                	mv	a0,s1
    80004f3e:	ce8fe0ef          	jal	80003426 <iupdate>
  iunlockput(ip);
    80004f42:	8526                	mv	a0,s1
    80004f44:	fa0fe0ef          	jal	800036e4 <iunlockput>
  end_op();
    80004f48:	eaffe0ef          	jal	80003df6 <end_op>
  return -1;
    80004f4c:	57fd                	li	a5,-1
    80004f4e:	64f2                	ld	s1,280(sp)
    80004f50:	6952                	ld	s2,272(sp)
}
    80004f52:	853e                	mv	a0,a5
    80004f54:	70b2                	ld	ra,296(sp)
    80004f56:	7412                	ld	s0,288(sp)
    80004f58:	6155                	addi	sp,sp,304
    80004f5a:	8082                	ret

0000000080004f5c <sys_unlink>:
{
    80004f5c:	7111                	addi	sp,sp,-256
    80004f5e:	fd86                	sd	ra,248(sp)
    80004f60:	f9a2                	sd	s0,240(sp)
    80004f62:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80004f64:	08000613          	li	a2,128
    80004f68:	f2040593          	addi	a1,s0,-224
    80004f6c:	4501                	li	a0,0
    80004f6e:	983fd0ef          	jal	800028f0 <argstr>
    80004f72:	16054663          	bltz	a0,800050de <sys_unlink+0x182>
    80004f76:	f5a6                	sd	s1,232(sp)
  begin_op();
    80004f78:	e15fe0ef          	jal	80003d8c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004f7c:	fa040593          	addi	a1,s0,-96
    80004f80:	f2040513          	addi	a0,s0,-224
    80004f84:	c61fe0ef          	jal	80003be4 <nameiparent>
    80004f88:	84aa                	mv	s1,a0
    80004f8a:	c955                	beqz	a0,8000503e <sys_unlink+0xe2>
  ilock(dp);
    80004f8c:	d4efe0ef          	jal	800034da <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004f90:	00002597          	auipc	a1,0x2
    80004f94:	6f858593          	addi	a1,a1,1784 # 80007688 <etext+0x688>
    80004f98:	fa040513          	addi	a0,s0,-96
    80004f9c:	98dfe0ef          	jal	80003928 <namecmp>
    80004fa0:	12050463          	beqz	a0,800050c8 <sys_unlink+0x16c>
    80004fa4:	00002597          	auipc	a1,0x2
    80004fa8:	6ec58593          	addi	a1,a1,1772 # 80007690 <etext+0x690>
    80004fac:	fa040513          	addi	a0,s0,-96
    80004fb0:	979fe0ef          	jal	80003928 <namecmp>
    80004fb4:	10050a63          	beqz	a0,800050c8 <sys_unlink+0x16c>
    80004fb8:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004fba:	f1c40613          	addi	a2,s0,-228
    80004fbe:	fa040593          	addi	a1,s0,-96
    80004fc2:	8526                	mv	a0,s1
    80004fc4:	97bfe0ef          	jal	8000393e <dirlookup>
    80004fc8:	892a                	mv	s2,a0
    80004fca:	0e050e63          	beqz	a0,800050c6 <sys_unlink+0x16a>
    80004fce:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004fd0:	d0afe0ef          	jal	800034da <ilock>
  if(ip->nlink < 1)
    80004fd4:	04a91783          	lh	a5,74(s2)
    80004fd8:	06f05863          	blez	a5,80005048 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004fdc:	04491703          	lh	a4,68(s2)
    80004fe0:	4785                	li	a5,1
    80004fe2:	06f70b63          	beq	a4,a5,80005058 <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    80004fe6:	fb040993          	addi	s3,s0,-80
    80004fea:	4641                	li	a2,16
    80004fec:	4581                	li	a1,0
    80004fee:	854e                	mv	a0,s3
    80004ff0:	cdffb0ef          	jal	80000cce <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ff4:	4741                	li	a4,16
    80004ff6:	f1c42683          	lw	a3,-228(s0)
    80004ffa:	864e                	mv	a2,s3
    80004ffc:	4581                	li	a1,0
    80004ffe:	8526                	mv	a0,s1
    80005000:	825fe0ef          	jal	80003824 <writei>
    80005004:	47c1                	li	a5,16
    80005006:	08f51f63          	bne	a0,a5,800050a4 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    8000500a:	04491703          	lh	a4,68(s2)
    8000500e:	4785                	li	a5,1
    80005010:	0af70263          	beq	a4,a5,800050b4 <sys_unlink+0x158>
  iunlockput(dp);
    80005014:	8526                	mv	a0,s1
    80005016:	ecefe0ef          	jal	800036e4 <iunlockput>
  ip->nlink--;
    8000501a:	04a95783          	lhu	a5,74(s2)
    8000501e:	37fd                	addiw	a5,a5,-1
    80005020:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005024:	854a                	mv	a0,s2
    80005026:	c00fe0ef          	jal	80003426 <iupdate>
  iunlockput(ip);
    8000502a:	854a                	mv	a0,s2
    8000502c:	eb8fe0ef          	jal	800036e4 <iunlockput>
  end_op();
    80005030:	dc7fe0ef          	jal	80003df6 <end_op>
  return 0;
    80005034:	4501                	li	a0,0
    80005036:	74ae                	ld	s1,232(sp)
    80005038:	790e                	ld	s2,224(sp)
    8000503a:	69ee                	ld	s3,216(sp)
    8000503c:	a869                	j	800050d6 <sys_unlink+0x17a>
    end_op();
    8000503e:	db9fe0ef          	jal	80003df6 <end_op>
    return -1;
    80005042:	557d                	li	a0,-1
    80005044:	74ae                	ld	s1,232(sp)
    80005046:	a841                	j	800050d6 <sys_unlink+0x17a>
    80005048:	e9d2                	sd	s4,208(sp)
    8000504a:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    8000504c:	00002517          	auipc	a0,0x2
    80005050:	64c50513          	addi	a0,a0,1612 # 80007698 <etext+0x698>
    80005054:	f4afb0ef          	jal	8000079e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005058:	04c92703          	lw	a4,76(s2)
    8000505c:	02000793          	li	a5,32
    80005060:	f8e7f3e3          	bgeu	a5,a4,80004fe6 <sys_unlink+0x8a>
    80005064:	e9d2                	sd	s4,208(sp)
    80005066:	e5d6                	sd	s5,200(sp)
    80005068:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000506a:	f0840a93          	addi	s5,s0,-248
    8000506e:	4a41                	li	s4,16
    80005070:	8752                	mv	a4,s4
    80005072:	86ce                	mv	a3,s3
    80005074:	8656                	mv	a2,s5
    80005076:	4581                	li	a1,0
    80005078:	854a                	mv	a0,s2
    8000507a:	eb8fe0ef          	jal	80003732 <readi>
    8000507e:	01451d63          	bne	a0,s4,80005098 <sys_unlink+0x13c>
    if(de.inum != 0)
    80005082:	f0845783          	lhu	a5,-248(s0)
    80005086:	efb1                	bnez	a5,800050e2 <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005088:	29c1                	addiw	s3,s3,16
    8000508a:	04c92783          	lw	a5,76(s2)
    8000508e:	fef9e1e3          	bltu	s3,a5,80005070 <sys_unlink+0x114>
    80005092:	6a4e                	ld	s4,208(sp)
    80005094:	6aae                	ld	s5,200(sp)
    80005096:	bf81                	j	80004fe6 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80005098:	00002517          	auipc	a0,0x2
    8000509c:	61850513          	addi	a0,a0,1560 # 800076b0 <etext+0x6b0>
    800050a0:	efefb0ef          	jal	8000079e <panic>
    800050a4:	e9d2                	sd	s4,208(sp)
    800050a6:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    800050a8:	00002517          	auipc	a0,0x2
    800050ac:	62050513          	addi	a0,a0,1568 # 800076c8 <etext+0x6c8>
    800050b0:	eeefb0ef          	jal	8000079e <panic>
    dp->nlink--;
    800050b4:	04a4d783          	lhu	a5,74(s1)
    800050b8:	37fd                	addiw	a5,a5,-1
    800050ba:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800050be:	8526                	mv	a0,s1
    800050c0:	b66fe0ef          	jal	80003426 <iupdate>
    800050c4:	bf81                	j	80005014 <sys_unlink+0xb8>
    800050c6:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    800050c8:	8526                	mv	a0,s1
    800050ca:	e1afe0ef          	jal	800036e4 <iunlockput>
  end_op();
    800050ce:	d29fe0ef          	jal	80003df6 <end_op>
  return -1;
    800050d2:	557d                	li	a0,-1
    800050d4:	74ae                	ld	s1,232(sp)
}
    800050d6:	70ee                	ld	ra,248(sp)
    800050d8:	744e                	ld	s0,240(sp)
    800050da:	6111                	addi	sp,sp,256
    800050dc:	8082                	ret
    return -1;
    800050de:	557d                	li	a0,-1
    800050e0:	bfdd                	j	800050d6 <sys_unlink+0x17a>
    iunlockput(ip);
    800050e2:	854a                	mv	a0,s2
    800050e4:	e00fe0ef          	jal	800036e4 <iunlockput>
    goto bad;
    800050e8:	790e                	ld	s2,224(sp)
    800050ea:	69ee                	ld	s3,216(sp)
    800050ec:	6a4e                	ld	s4,208(sp)
    800050ee:	6aae                	ld	s5,200(sp)
    800050f0:	bfe1                	j	800050c8 <sys_unlink+0x16c>

00000000800050f2 <sys_open>:

uint64
sys_open(void)
{
    800050f2:	7131                	addi	sp,sp,-192
    800050f4:	fd06                	sd	ra,184(sp)
    800050f6:	f922                	sd	s0,176(sp)
    800050f8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800050fa:	f4c40593          	addi	a1,s0,-180
    800050fe:	4505                	li	a0,1
    80005100:	fb8fd0ef          	jal	800028b8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005104:	08000613          	li	a2,128
    80005108:	f5040593          	addi	a1,s0,-176
    8000510c:	4501                	li	a0,0
    8000510e:	fe2fd0ef          	jal	800028f0 <argstr>
    80005112:	87aa                	mv	a5,a0
    return -1;
    80005114:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005116:	0a07c363          	bltz	a5,800051bc <sys_open+0xca>
    8000511a:	f526                	sd	s1,168(sp)

  begin_op();
    8000511c:	c71fe0ef          	jal	80003d8c <begin_op>

  if(omode & O_CREATE){
    80005120:	f4c42783          	lw	a5,-180(s0)
    80005124:	2007f793          	andi	a5,a5,512
    80005128:	c3dd                	beqz	a5,800051ce <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000512a:	4681                	li	a3,0
    8000512c:	4601                	li	a2,0
    8000512e:	4589                	li	a1,2
    80005130:	f5040513          	addi	a0,s0,-176
    80005134:	a99ff0ef          	jal	80004bcc <create>
    80005138:	84aa                	mv	s1,a0
    if(ip == 0){
    8000513a:	c549                	beqz	a0,800051c4 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000513c:	04449703          	lh	a4,68(s1)
    80005140:	478d                	li	a5,3
    80005142:	00f71763          	bne	a4,a5,80005150 <sys_open+0x5e>
    80005146:	0464d703          	lhu	a4,70(s1)
    8000514a:	47a5                	li	a5,9
    8000514c:	0ae7ee63          	bltu	a5,a4,80005208 <sys_open+0x116>
    80005150:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005152:	fb7fe0ef          	jal	80004108 <filealloc>
    80005156:	892a                	mv	s2,a0
    80005158:	c561                	beqz	a0,80005220 <sys_open+0x12e>
    8000515a:	ed4e                	sd	s3,152(sp)
    8000515c:	a33ff0ef          	jal	80004b8e <fdalloc>
    80005160:	89aa                	mv	s3,a0
    80005162:	0a054b63          	bltz	a0,80005218 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005166:	04449703          	lh	a4,68(s1)
    8000516a:	478d                	li	a5,3
    8000516c:	0cf70363          	beq	a4,a5,80005232 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005170:	4789                	li	a5,2
    80005172:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005176:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000517a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000517e:	f4c42783          	lw	a5,-180(s0)
    80005182:	0017f713          	andi	a4,a5,1
    80005186:	00174713          	xori	a4,a4,1
    8000518a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000518e:	0037f713          	andi	a4,a5,3
    80005192:	00e03733          	snez	a4,a4
    80005196:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000519a:	4007f793          	andi	a5,a5,1024
    8000519e:	c791                	beqz	a5,800051aa <sys_open+0xb8>
    800051a0:	04449703          	lh	a4,68(s1)
    800051a4:	4789                	li	a5,2
    800051a6:	08f70d63          	beq	a4,a5,80005240 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800051aa:	8526                	mv	a0,s1
    800051ac:	bdcfe0ef          	jal	80003588 <iunlock>
  end_op();
    800051b0:	c47fe0ef          	jal	80003df6 <end_op>

  return fd;
    800051b4:	854e                	mv	a0,s3
    800051b6:	74aa                	ld	s1,168(sp)
    800051b8:	790a                	ld	s2,160(sp)
    800051ba:	69ea                	ld	s3,152(sp)
}
    800051bc:	70ea                	ld	ra,184(sp)
    800051be:	744a                	ld	s0,176(sp)
    800051c0:	6129                	addi	sp,sp,192
    800051c2:	8082                	ret
      end_op();
    800051c4:	c33fe0ef          	jal	80003df6 <end_op>
      return -1;
    800051c8:	557d                	li	a0,-1
    800051ca:	74aa                	ld	s1,168(sp)
    800051cc:	bfc5                	j	800051bc <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800051ce:	f5040513          	addi	a0,s0,-176
    800051d2:	9f9fe0ef          	jal	80003bca <namei>
    800051d6:	84aa                	mv	s1,a0
    800051d8:	c11d                	beqz	a0,800051fe <sys_open+0x10c>
    ilock(ip);
    800051da:	b00fe0ef          	jal	800034da <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800051de:	04449703          	lh	a4,68(s1)
    800051e2:	4785                	li	a5,1
    800051e4:	f4f71ce3          	bne	a4,a5,8000513c <sys_open+0x4a>
    800051e8:	f4c42783          	lw	a5,-180(s0)
    800051ec:	d3b5                	beqz	a5,80005150 <sys_open+0x5e>
      iunlockput(ip);
    800051ee:	8526                	mv	a0,s1
    800051f0:	cf4fe0ef          	jal	800036e4 <iunlockput>
      end_op();
    800051f4:	c03fe0ef          	jal	80003df6 <end_op>
      return -1;
    800051f8:	557d                	li	a0,-1
    800051fa:	74aa                	ld	s1,168(sp)
    800051fc:	b7c1                	j	800051bc <sys_open+0xca>
      end_op();
    800051fe:	bf9fe0ef          	jal	80003df6 <end_op>
      return -1;
    80005202:	557d                	li	a0,-1
    80005204:	74aa                	ld	s1,168(sp)
    80005206:	bf5d                	j	800051bc <sys_open+0xca>
    iunlockput(ip);
    80005208:	8526                	mv	a0,s1
    8000520a:	cdafe0ef          	jal	800036e4 <iunlockput>
    end_op();
    8000520e:	be9fe0ef          	jal	80003df6 <end_op>
    return -1;
    80005212:	557d                	li	a0,-1
    80005214:	74aa                	ld	s1,168(sp)
    80005216:	b75d                	j	800051bc <sys_open+0xca>
      fileclose(f);
    80005218:	854a                	mv	a0,s2
    8000521a:	f93fe0ef          	jal	800041ac <fileclose>
    8000521e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005220:	8526                	mv	a0,s1
    80005222:	cc2fe0ef          	jal	800036e4 <iunlockput>
    end_op();
    80005226:	bd1fe0ef          	jal	80003df6 <end_op>
    return -1;
    8000522a:	557d                	li	a0,-1
    8000522c:	74aa                	ld	s1,168(sp)
    8000522e:	790a                	ld	s2,160(sp)
    80005230:	b771                	j	800051bc <sys_open+0xca>
    f->type = FD_DEVICE;
    80005232:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005236:	04649783          	lh	a5,70(s1)
    8000523a:	02f91223          	sh	a5,36(s2)
    8000523e:	bf35                	j	8000517a <sys_open+0x88>
    itrunc(ip);
    80005240:	8526                	mv	a0,s1
    80005242:	b86fe0ef          	jal	800035c8 <itrunc>
    80005246:	b795                	j	800051aa <sys_open+0xb8>

0000000080005248 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005248:	7175                	addi	sp,sp,-144
    8000524a:	e506                	sd	ra,136(sp)
    8000524c:	e122                	sd	s0,128(sp)
    8000524e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005250:	b3dfe0ef          	jal	80003d8c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005254:	08000613          	li	a2,128
    80005258:	f7040593          	addi	a1,s0,-144
    8000525c:	4501                	li	a0,0
    8000525e:	e92fd0ef          	jal	800028f0 <argstr>
    80005262:	02054363          	bltz	a0,80005288 <sys_mkdir+0x40>
    80005266:	4681                	li	a3,0
    80005268:	4601                	li	a2,0
    8000526a:	4585                	li	a1,1
    8000526c:	f7040513          	addi	a0,s0,-144
    80005270:	95dff0ef          	jal	80004bcc <create>
    80005274:	c911                	beqz	a0,80005288 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005276:	c6efe0ef          	jal	800036e4 <iunlockput>
  end_op();
    8000527a:	b7dfe0ef          	jal	80003df6 <end_op>
  return 0;
    8000527e:	4501                	li	a0,0
}
    80005280:	60aa                	ld	ra,136(sp)
    80005282:	640a                	ld	s0,128(sp)
    80005284:	6149                	addi	sp,sp,144
    80005286:	8082                	ret
    end_op();
    80005288:	b6ffe0ef          	jal	80003df6 <end_op>
    return -1;
    8000528c:	557d                	li	a0,-1
    8000528e:	bfcd                	j	80005280 <sys_mkdir+0x38>

0000000080005290 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005290:	7135                	addi	sp,sp,-160
    80005292:	ed06                	sd	ra,152(sp)
    80005294:	e922                	sd	s0,144(sp)
    80005296:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005298:	af5fe0ef          	jal	80003d8c <begin_op>
  argint(1, &major);
    8000529c:	f6c40593          	addi	a1,s0,-148
    800052a0:	4505                	li	a0,1
    800052a2:	e16fd0ef          	jal	800028b8 <argint>
  argint(2, &minor);
    800052a6:	f6840593          	addi	a1,s0,-152
    800052aa:	4509                	li	a0,2
    800052ac:	e0cfd0ef          	jal	800028b8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800052b0:	08000613          	li	a2,128
    800052b4:	f7040593          	addi	a1,s0,-144
    800052b8:	4501                	li	a0,0
    800052ba:	e36fd0ef          	jal	800028f0 <argstr>
    800052be:	02054563          	bltz	a0,800052e8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800052c2:	f6841683          	lh	a3,-152(s0)
    800052c6:	f6c41603          	lh	a2,-148(s0)
    800052ca:	458d                	li	a1,3
    800052cc:	f7040513          	addi	a0,s0,-144
    800052d0:	8fdff0ef          	jal	80004bcc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800052d4:	c911                	beqz	a0,800052e8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800052d6:	c0efe0ef          	jal	800036e4 <iunlockput>
  end_op();
    800052da:	b1dfe0ef          	jal	80003df6 <end_op>
  return 0;
    800052de:	4501                	li	a0,0
}
    800052e0:	60ea                	ld	ra,152(sp)
    800052e2:	644a                	ld	s0,144(sp)
    800052e4:	610d                	addi	sp,sp,160
    800052e6:	8082                	ret
    end_op();
    800052e8:	b0ffe0ef          	jal	80003df6 <end_op>
    return -1;
    800052ec:	557d                	li	a0,-1
    800052ee:	bfcd                	j	800052e0 <sys_mknod+0x50>

00000000800052f0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800052f0:	7135                	addi	sp,sp,-160
    800052f2:	ed06                	sd	ra,152(sp)
    800052f4:	e922                	sd	s0,144(sp)
    800052f6:	e14a                	sd	s2,128(sp)
    800052f8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800052fa:	de2fc0ef          	jal	800018dc <myproc>
    800052fe:	892a                	mv	s2,a0
  
  begin_op();
    80005300:	a8dfe0ef          	jal	80003d8c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005304:	08000613          	li	a2,128
    80005308:	f6040593          	addi	a1,s0,-160
    8000530c:	4501                	li	a0,0
    8000530e:	de2fd0ef          	jal	800028f0 <argstr>
    80005312:	04054363          	bltz	a0,80005358 <sys_chdir+0x68>
    80005316:	e526                	sd	s1,136(sp)
    80005318:	f6040513          	addi	a0,s0,-160
    8000531c:	8affe0ef          	jal	80003bca <namei>
    80005320:	84aa                	mv	s1,a0
    80005322:	c915                	beqz	a0,80005356 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005324:	9b6fe0ef          	jal	800034da <ilock>
  if(ip->type != T_DIR){
    80005328:	04449703          	lh	a4,68(s1)
    8000532c:	4785                	li	a5,1
    8000532e:	02f71963          	bne	a4,a5,80005360 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005332:	8526                	mv	a0,s1
    80005334:	a54fe0ef          	jal	80003588 <iunlock>
  iput(p->cwd);
    80005338:	15093503          	ld	a0,336(s2)
    8000533c:	b20fe0ef          	jal	8000365c <iput>
  end_op();
    80005340:	ab7fe0ef          	jal	80003df6 <end_op>
  p->cwd = ip;
    80005344:	14993823          	sd	s1,336(s2)
  return 0;
    80005348:	4501                	li	a0,0
    8000534a:	64aa                	ld	s1,136(sp)
}
    8000534c:	60ea                	ld	ra,152(sp)
    8000534e:	644a                	ld	s0,144(sp)
    80005350:	690a                	ld	s2,128(sp)
    80005352:	610d                	addi	sp,sp,160
    80005354:	8082                	ret
    80005356:	64aa                	ld	s1,136(sp)
    end_op();
    80005358:	a9ffe0ef          	jal	80003df6 <end_op>
    return -1;
    8000535c:	557d                	li	a0,-1
    8000535e:	b7fd                	j	8000534c <sys_chdir+0x5c>
    iunlockput(ip);
    80005360:	8526                	mv	a0,s1
    80005362:	b82fe0ef          	jal	800036e4 <iunlockput>
    end_op();
    80005366:	a91fe0ef          	jal	80003df6 <end_op>
    return -1;
    8000536a:	557d                	li	a0,-1
    8000536c:	64aa                	ld	s1,136(sp)
    8000536e:	bff9                	j	8000534c <sys_chdir+0x5c>

0000000080005370 <sys_exec>:

uint64
sys_exec(void)
{
    80005370:	7105                	addi	sp,sp,-480
    80005372:	ef86                	sd	ra,472(sp)
    80005374:	eba2                	sd	s0,464(sp)
    80005376:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005378:	e2840593          	addi	a1,s0,-472
    8000537c:	4505                	li	a0,1
    8000537e:	d56fd0ef          	jal	800028d4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005382:	08000613          	li	a2,128
    80005386:	f3040593          	addi	a1,s0,-208
    8000538a:	4501                	li	a0,0
    8000538c:	d64fd0ef          	jal	800028f0 <argstr>
    80005390:	87aa                	mv	a5,a0
    return -1;
    80005392:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005394:	0e07c063          	bltz	a5,80005474 <sys_exec+0x104>
    80005398:	e7a6                	sd	s1,456(sp)
    8000539a:	e3ca                	sd	s2,448(sp)
    8000539c:	ff4e                	sd	s3,440(sp)
    8000539e:	fb52                	sd	s4,432(sp)
    800053a0:	f756                	sd	s5,424(sp)
    800053a2:	f35a                	sd	s6,416(sp)
    800053a4:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800053a6:	e3040a13          	addi	s4,s0,-464
    800053aa:	10000613          	li	a2,256
    800053ae:	4581                	li	a1,0
    800053b0:	8552                	mv	a0,s4
    800053b2:	91dfb0ef          	jal	80000cce <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800053b6:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800053b8:	89d2                	mv	s3,s4
    800053ba:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800053bc:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800053c0:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800053c2:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800053c6:	00391513          	slli	a0,s2,0x3
    800053ca:	85d6                	mv	a1,s5
    800053cc:	e2843783          	ld	a5,-472(s0)
    800053d0:	953e                	add	a0,a0,a5
    800053d2:	c5cfd0ef          	jal	8000282e <fetchaddr>
    800053d6:	02054663          	bltz	a0,80005402 <sys_exec+0x92>
    if(uarg == 0){
    800053da:	e2043783          	ld	a5,-480(s0)
    800053de:	c7a1                	beqz	a5,80005426 <sys_exec+0xb6>
    argv[i] = kalloc();
    800053e0:	f4afb0ef          	jal	80000b2a <kalloc>
    800053e4:	85aa                	mv	a1,a0
    800053e6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800053ea:	cd01                	beqz	a0,80005402 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800053ec:	865a                	mv	a2,s6
    800053ee:	e2043503          	ld	a0,-480(s0)
    800053f2:	c86fd0ef          	jal	80002878 <fetchstr>
    800053f6:	00054663          	bltz	a0,80005402 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800053fa:	0905                	addi	s2,s2,1
    800053fc:	09a1                	addi	s3,s3,8
    800053fe:	fd7914e3          	bne	s2,s7,800053c6 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005402:	100a0a13          	addi	s4,s4,256
    80005406:	6088                	ld	a0,0(s1)
    80005408:	cd31                	beqz	a0,80005464 <sys_exec+0xf4>
    kfree(argv[i]);
    8000540a:	e3efb0ef          	jal	80000a48 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000540e:	04a1                	addi	s1,s1,8
    80005410:	ff449be3          	bne	s1,s4,80005406 <sys_exec+0x96>
  return -1;
    80005414:	557d                	li	a0,-1
    80005416:	64be                	ld	s1,456(sp)
    80005418:	691e                	ld	s2,448(sp)
    8000541a:	79fa                	ld	s3,440(sp)
    8000541c:	7a5a                	ld	s4,432(sp)
    8000541e:	7aba                	ld	s5,424(sp)
    80005420:	7b1a                	ld	s6,416(sp)
    80005422:	6bfa                	ld	s7,408(sp)
    80005424:	a881                	j	80005474 <sys_exec+0x104>
      argv[i] = 0;
    80005426:	0009079b          	sext.w	a5,s2
    8000542a:	e3040593          	addi	a1,s0,-464
    8000542e:	078e                	slli	a5,a5,0x3
    80005430:	97ae                	add	a5,a5,a1
    80005432:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80005436:	f3040513          	addi	a0,s0,-208
    8000543a:	ba4ff0ef          	jal	800047de <exec>
    8000543e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005440:	100a0a13          	addi	s4,s4,256
    80005444:	6088                	ld	a0,0(s1)
    80005446:	c511                	beqz	a0,80005452 <sys_exec+0xe2>
    kfree(argv[i]);
    80005448:	e00fb0ef          	jal	80000a48 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000544c:	04a1                	addi	s1,s1,8
    8000544e:	ff449be3          	bne	s1,s4,80005444 <sys_exec+0xd4>
  return ret;
    80005452:	854a                	mv	a0,s2
    80005454:	64be                	ld	s1,456(sp)
    80005456:	691e                	ld	s2,448(sp)
    80005458:	79fa                	ld	s3,440(sp)
    8000545a:	7a5a                	ld	s4,432(sp)
    8000545c:	7aba                	ld	s5,424(sp)
    8000545e:	7b1a                	ld	s6,416(sp)
    80005460:	6bfa                	ld	s7,408(sp)
    80005462:	a809                	j	80005474 <sys_exec+0x104>
  return -1;
    80005464:	557d                	li	a0,-1
    80005466:	64be                	ld	s1,456(sp)
    80005468:	691e                	ld	s2,448(sp)
    8000546a:	79fa                	ld	s3,440(sp)
    8000546c:	7a5a                	ld	s4,432(sp)
    8000546e:	7aba                	ld	s5,424(sp)
    80005470:	7b1a                	ld	s6,416(sp)
    80005472:	6bfa                	ld	s7,408(sp)
}
    80005474:	60fe                	ld	ra,472(sp)
    80005476:	645e                	ld	s0,464(sp)
    80005478:	613d                	addi	sp,sp,480
    8000547a:	8082                	ret

000000008000547c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000547c:	7139                	addi	sp,sp,-64
    8000547e:	fc06                	sd	ra,56(sp)
    80005480:	f822                	sd	s0,48(sp)
    80005482:	f426                	sd	s1,40(sp)
    80005484:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005486:	c56fc0ef          	jal	800018dc <myproc>
    8000548a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000548c:	fd840593          	addi	a1,s0,-40
    80005490:	4501                	li	a0,0
    80005492:	c42fd0ef          	jal	800028d4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005496:	fc840593          	addi	a1,s0,-56
    8000549a:	fd040513          	addi	a0,s0,-48
    8000549e:	81eff0ef          	jal	800044bc <pipealloc>
    return -1;
    800054a2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800054a4:	0a054463          	bltz	a0,8000554c <sys_pipe+0xd0>
  fd0 = -1;
    800054a8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800054ac:	fd043503          	ld	a0,-48(s0)
    800054b0:	edeff0ef          	jal	80004b8e <fdalloc>
    800054b4:	fca42223          	sw	a0,-60(s0)
    800054b8:	08054163          	bltz	a0,8000553a <sys_pipe+0xbe>
    800054bc:	fc843503          	ld	a0,-56(s0)
    800054c0:	eceff0ef          	jal	80004b8e <fdalloc>
    800054c4:	fca42023          	sw	a0,-64(s0)
    800054c8:	06054063          	bltz	a0,80005528 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800054cc:	4691                	li	a3,4
    800054ce:	fc440613          	addi	a2,s0,-60
    800054d2:	fd843583          	ld	a1,-40(s0)
    800054d6:	68a8                	ld	a0,80(s1)
    800054d8:	8acfc0ef          	jal	80001584 <copyout>
    800054dc:	00054e63          	bltz	a0,800054f8 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800054e0:	4691                	li	a3,4
    800054e2:	fc040613          	addi	a2,s0,-64
    800054e6:	fd843583          	ld	a1,-40(s0)
    800054ea:	95b6                	add	a1,a1,a3
    800054ec:	68a8                	ld	a0,80(s1)
    800054ee:	896fc0ef          	jal	80001584 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800054f2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800054f4:	04055c63          	bgez	a0,8000554c <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800054f8:	fc442783          	lw	a5,-60(s0)
    800054fc:	07e9                	addi	a5,a5,26
    800054fe:	078e                	slli	a5,a5,0x3
    80005500:	97a6                	add	a5,a5,s1
    80005502:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005506:	fc042783          	lw	a5,-64(s0)
    8000550a:	07e9                	addi	a5,a5,26
    8000550c:	078e                	slli	a5,a5,0x3
    8000550e:	94be                	add	s1,s1,a5
    80005510:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005514:	fd043503          	ld	a0,-48(s0)
    80005518:	c95fe0ef          	jal	800041ac <fileclose>
    fileclose(wf);
    8000551c:	fc843503          	ld	a0,-56(s0)
    80005520:	c8dfe0ef          	jal	800041ac <fileclose>
    return -1;
    80005524:	57fd                	li	a5,-1
    80005526:	a01d                	j	8000554c <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005528:	fc442783          	lw	a5,-60(s0)
    8000552c:	0007c763          	bltz	a5,8000553a <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005530:	07e9                	addi	a5,a5,26
    80005532:	078e                	slli	a5,a5,0x3
    80005534:	97a6                	add	a5,a5,s1
    80005536:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000553a:	fd043503          	ld	a0,-48(s0)
    8000553e:	c6ffe0ef          	jal	800041ac <fileclose>
    fileclose(wf);
    80005542:	fc843503          	ld	a0,-56(s0)
    80005546:	c67fe0ef          	jal	800041ac <fileclose>
    return -1;
    8000554a:	57fd                	li	a5,-1
}
    8000554c:	853e                	mv	a0,a5
    8000554e:	70e2                	ld	ra,56(sp)
    80005550:	7442                	ld	s0,48(sp)
    80005552:	74a2                	ld	s1,40(sp)
    80005554:	6121                	addi	sp,sp,64
    80005556:	8082                	ret
	...

0000000080005560 <kernelvec>:
    80005560:	7111                	addi	sp,sp,-256
    80005562:	e006                	sd	ra,0(sp)
    80005564:	e40a                	sd	sp,8(sp)
    80005566:	e80e                	sd	gp,16(sp)
    80005568:	ec12                	sd	tp,24(sp)
    8000556a:	f016                	sd	t0,32(sp)
    8000556c:	f41a                	sd	t1,40(sp)
    8000556e:	f81e                	sd	t2,48(sp)
    80005570:	e4aa                	sd	a0,72(sp)
    80005572:	e8ae                	sd	a1,80(sp)
    80005574:	ecb2                	sd	a2,88(sp)
    80005576:	f0b6                	sd	a3,96(sp)
    80005578:	f4ba                	sd	a4,104(sp)
    8000557a:	f8be                	sd	a5,112(sp)
    8000557c:	fcc2                	sd	a6,120(sp)
    8000557e:	e146                	sd	a7,128(sp)
    80005580:	edf2                	sd	t3,216(sp)
    80005582:	f1f6                	sd	t4,224(sp)
    80005584:	f5fa                	sd	t5,232(sp)
    80005586:	f9fe                	sd	t6,240(sp)
    80005588:	9b6fd0ef          	jal	8000273e <kerneltrap>
    8000558c:	6082                	ld	ra,0(sp)
    8000558e:	6122                	ld	sp,8(sp)
    80005590:	61c2                	ld	gp,16(sp)
    80005592:	7282                	ld	t0,32(sp)
    80005594:	7322                	ld	t1,40(sp)
    80005596:	73c2                	ld	t2,48(sp)
    80005598:	6526                	ld	a0,72(sp)
    8000559a:	65c6                	ld	a1,80(sp)
    8000559c:	6666                	ld	a2,88(sp)
    8000559e:	7686                	ld	a3,96(sp)
    800055a0:	7726                	ld	a4,104(sp)
    800055a2:	77c6                	ld	a5,112(sp)
    800055a4:	7866                	ld	a6,120(sp)
    800055a6:	688a                	ld	a7,128(sp)
    800055a8:	6e6e                	ld	t3,216(sp)
    800055aa:	7e8e                	ld	t4,224(sp)
    800055ac:	7f2e                	ld	t5,232(sp)
    800055ae:	7fce                	ld	t6,240(sp)
    800055b0:	6111                	addi	sp,sp,256
    800055b2:	10200073          	sret
	...

00000000800055be <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800055be:	1141                	addi	sp,sp,-16
    800055c0:	e406                	sd	ra,8(sp)
    800055c2:	e022                	sd	s0,0(sp)
    800055c4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800055c6:	0c000737          	lui	a4,0xc000
    800055ca:	4785                	li	a5,1
    800055cc:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800055ce:	c35c                	sw	a5,4(a4)
}
    800055d0:	60a2                	ld	ra,8(sp)
    800055d2:	6402                	ld	s0,0(sp)
    800055d4:	0141                	addi	sp,sp,16
    800055d6:	8082                	ret

00000000800055d8 <plicinithart>:

void
plicinithart(void)
{
    800055d8:	1141                	addi	sp,sp,-16
    800055da:	e406                	sd	ra,8(sp)
    800055dc:	e022                	sd	s0,0(sp)
    800055de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800055e0:	ac8fc0ef          	jal	800018a8 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800055e4:	0085171b          	slliw	a4,a0,0x8
    800055e8:	0c0027b7          	lui	a5,0xc002
    800055ec:	97ba                	add	a5,a5,a4
    800055ee:	40200713          	li	a4,1026
    800055f2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800055f6:	00d5151b          	slliw	a0,a0,0xd
    800055fa:	0c2017b7          	lui	a5,0xc201
    800055fe:	97aa                	add	a5,a5,a0
    80005600:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005604:	60a2                	ld	ra,8(sp)
    80005606:	6402                	ld	s0,0(sp)
    80005608:	0141                	addi	sp,sp,16
    8000560a:	8082                	ret

000000008000560c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000560c:	1141                	addi	sp,sp,-16
    8000560e:	e406                	sd	ra,8(sp)
    80005610:	e022                	sd	s0,0(sp)
    80005612:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005614:	a94fc0ef          	jal	800018a8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005618:	00d5151b          	slliw	a0,a0,0xd
    8000561c:	0c2017b7          	lui	a5,0xc201
    80005620:	97aa                	add	a5,a5,a0
  return irq;
}
    80005622:	43c8                	lw	a0,4(a5)
    80005624:	60a2                	ld	ra,8(sp)
    80005626:	6402                	ld	s0,0(sp)
    80005628:	0141                	addi	sp,sp,16
    8000562a:	8082                	ret

000000008000562c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000562c:	1101                	addi	sp,sp,-32
    8000562e:	ec06                	sd	ra,24(sp)
    80005630:	e822                	sd	s0,16(sp)
    80005632:	e426                	sd	s1,8(sp)
    80005634:	1000                	addi	s0,sp,32
    80005636:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005638:	a70fc0ef          	jal	800018a8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000563c:	00d5179b          	slliw	a5,a0,0xd
    80005640:	0c201737          	lui	a4,0xc201
    80005644:	97ba                	add	a5,a5,a4
    80005646:	c3c4                	sw	s1,4(a5)
}
    80005648:	60e2                	ld	ra,24(sp)
    8000564a:	6442                	ld	s0,16(sp)
    8000564c:	64a2                	ld	s1,8(sp)
    8000564e:	6105                	addi	sp,sp,32
    80005650:	8082                	ret

0000000080005652 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005652:	1141                	addi	sp,sp,-16
    80005654:	e406                	sd	ra,8(sp)
    80005656:	e022                	sd	s0,0(sp)
    80005658:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000565a:	479d                	li	a5,7
    8000565c:	04a7ca63          	blt	a5,a0,800056b0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005660:	0001f797          	auipc	a5,0x1f
    80005664:	9c078793          	addi	a5,a5,-1600 # 80024020 <disk>
    80005668:	97aa                	add	a5,a5,a0
    8000566a:	0187c783          	lbu	a5,24(a5)
    8000566e:	e7b9                	bnez	a5,800056bc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005670:	00451693          	slli	a3,a0,0x4
    80005674:	0001f797          	auipc	a5,0x1f
    80005678:	9ac78793          	addi	a5,a5,-1620 # 80024020 <disk>
    8000567c:	6398                	ld	a4,0(a5)
    8000567e:	9736                	add	a4,a4,a3
    80005680:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005684:	6398                	ld	a4,0(a5)
    80005686:	9736                	add	a4,a4,a3
    80005688:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000568c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005690:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005694:	97aa                	add	a5,a5,a0
    80005696:	4705                	li	a4,1
    80005698:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000569c:	0001f517          	auipc	a0,0x1f
    800056a0:	99c50513          	addi	a0,a0,-1636 # 80024038 <disk+0x18>
    800056a4:	955fc0ef          	jal	80001ff8 <wakeup>
}
    800056a8:	60a2                	ld	ra,8(sp)
    800056aa:	6402                	ld	s0,0(sp)
    800056ac:	0141                	addi	sp,sp,16
    800056ae:	8082                	ret
    panic("free_desc 1");
    800056b0:	00002517          	auipc	a0,0x2
    800056b4:	02850513          	addi	a0,a0,40 # 800076d8 <etext+0x6d8>
    800056b8:	8e6fb0ef          	jal	8000079e <panic>
    panic("free_desc 2");
    800056bc:	00002517          	auipc	a0,0x2
    800056c0:	02c50513          	addi	a0,a0,44 # 800076e8 <etext+0x6e8>
    800056c4:	8dafb0ef          	jal	8000079e <panic>

00000000800056c8 <virtio_disk_init>:
{
    800056c8:	1101                	addi	sp,sp,-32
    800056ca:	ec06                	sd	ra,24(sp)
    800056cc:	e822                	sd	s0,16(sp)
    800056ce:	e426                	sd	s1,8(sp)
    800056d0:	e04a                	sd	s2,0(sp)
    800056d2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800056d4:	00002597          	auipc	a1,0x2
    800056d8:	02458593          	addi	a1,a1,36 # 800076f8 <etext+0x6f8>
    800056dc:	0001f517          	auipc	a0,0x1f
    800056e0:	a6c50513          	addi	a0,a0,-1428 # 80024148 <disk+0x128>
    800056e4:	c96fb0ef          	jal	80000b7a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800056e8:	100017b7          	lui	a5,0x10001
    800056ec:	4398                	lw	a4,0(a5)
    800056ee:	2701                	sext.w	a4,a4
    800056f0:	747277b7          	lui	a5,0x74727
    800056f4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800056f8:	14f71863          	bne	a4,a5,80005848 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800056fc:	100017b7          	lui	a5,0x10001
    80005700:	43dc                	lw	a5,4(a5)
    80005702:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005704:	4709                	li	a4,2
    80005706:	14e79163          	bne	a5,a4,80005848 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000570a:	100017b7          	lui	a5,0x10001
    8000570e:	479c                	lw	a5,8(a5)
    80005710:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005712:	12e79b63          	bne	a5,a4,80005848 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005716:	100017b7          	lui	a5,0x10001
    8000571a:	47d8                	lw	a4,12(a5)
    8000571c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000571e:	554d47b7          	lui	a5,0x554d4
    80005722:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005726:	12f71163          	bne	a4,a5,80005848 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000572a:	100017b7          	lui	a5,0x10001
    8000572e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005732:	4705                	li	a4,1
    80005734:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005736:	470d                	li	a4,3
    80005738:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000573a:	10001737          	lui	a4,0x10001
    8000573e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005740:	c7ffe6b7          	lui	a3,0xc7ffe
    80005744:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fda5ff>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005748:	8f75                	and	a4,a4,a3
    8000574a:	100016b7          	lui	a3,0x10001
    8000574e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005750:	472d                	li	a4,11
    80005752:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005754:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005758:	439c                	lw	a5,0(a5)
    8000575a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000575e:	8ba1                	andi	a5,a5,8
    80005760:	0e078a63          	beqz	a5,80005854 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005764:	100017b7          	lui	a5,0x10001
    80005768:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000576c:	43fc                	lw	a5,68(a5)
    8000576e:	2781                	sext.w	a5,a5
    80005770:	0e079863          	bnez	a5,80005860 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005774:	100017b7          	lui	a5,0x10001
    80005778:	5bdc                	lw	a5,52(a5)
    8000577a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000577c:	0e078863          	beqz	a5,8000586c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005780:	471d                	li	a4,7
    80005782:	0ef77b63          	bgeu	a4,a5,80005878 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005786:	ba4fb0ef          	jal	80000b2a <kalloc>
    8000578a:	0001f497          	auipc	s1,0x1f
    8000578e:	89648493          	addi	s1,s1,-1898 # 80024020 <disk>
    80005792:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005794:	b96fb0ef          	jal	80000b2a <kalloc>
    80005798:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000579a:	b90fb0ef          	jal	80000b2a <kalloc>
    8000579e:	87aa                	mv	a5,a0
    800057a0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800057a2:	6088                	ld	a0,0(s1)
    800057a4:	0e050063          	beqz	a0,80005884 <virtio_disk_init+0x1bc>
    800057a8:	0001f717          	auipc	a4,0x1f
    800057ac:	88073703          	ld	a4,-1920(a4) # 80024028 <disk+0x8>
    800057b0:	cb71                	beqz	a4,80005884 <virtio_disk_init+0x1bc>
    800057b2:	cbe9                	beqz	a5,80005884 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    800057b4:	6605                	lui	a2,0x1
    800057b6:	4581                	li	a1,0
    800057b8:	d16fb0ef          	jal	80000cce <memset>
  memset(disk.avail, 0, PGSIZE);
    800057bc:	0001f497          	auipc	s1,0x1f
    800057c0:	86448493          	addi	s1,s1,-1948 # 80024020 <disk>
    800057c4:	6605                	lui	a2,0x1
    800057c6:	4581                	li	a1,0
    800057c8:	6488                	ld	a0,8(s1)
    800057ca:	d04fb0ef          	jal	80000cce <memset>
  memset(disk.used, 0, PGSIZE);
    800057ce:	6605                	lui	a2,0x1
    800057d0:	4581                	li	a1,0
    800057d2:	6888                	ld	a0,16(s1)
    800057d4:	cfafb0ef          	jal	80000cce <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800057d8:	100017b7          	lui	a5,0x10001
    800057dc:	4721                	li	a4,8
    800057de:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800057e0:	4098                	lw	a4,0(s1)
    800057e2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800057e6:	40d8                	lw	a4,4(s1)
    800057e8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800057ec:	649c                	ld	a5,8(s1)
    800057ee:	0007869b          	sext.w	a3,a5
    800057f2:	10001737          	lui	a4,0x10001
    800057f6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800057fa:	9781                	srai	a5,a5,0x20
    800057fc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005800:	689c                	ld	a5,16(s1)
    80005802:	0007869b          	sext.w	a3,a5
    80005806:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000580a:	9781                	srai	a5,a5,0x20
    8000580c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005810:	4785                	li	a5,1
    80005812:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005814:	00f48c23          	sb	a5,24(s1)
    80005818:	00f48ca3          	sb	a5,25(s1)
    8000581c:	00f48d23          	sb	a5,26(s1)
    80005820:	00f48da3          	sb	a5,27(s1)
    80005824:	00f48e23          	sb	a5,28(s1)
    80005828:	00f48ea3          	sb	a5,29(s1)
    8000582c:	00f48f23          	sb	a5,30(s1)
    80005830:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005834:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005838:	07272823          	sw	s2,112(a4)
}
    8000583c:	60e2                	ld	ra,24(sp)
    8000583e:	6442                	ld	s0,16(sp)
    80005840:	64a2                	ld	s1,8(sp)
    80005842:	6902                	ld	s2,0(sp)
    80005844:	6105                	addi	sp,sp,32
    80005846:	8082                	ret
    panic("could not find virtio disk");
    80005848:	00002517          	auipc	a0,0x2
    8000584c:	ec050513          	addi	a0,a0,-320 # 80007708 <etext+0x708>
    80005850:	f4ffa0ef          	jal	8000079e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005854:	00002517          	auipc	a0,0x2
    80005858:	ed450513          	addi	a0,a0,-300 # 80007728 <etext+0x728>
    8000585c:	f43fa0ef          	jal	8000079e <panic>
    panic("virtio disk should not be ready");
    80005860:	00002517          	auipc	a0,0x2
    80005864:	ee850513          	addi	a0,a0,-280 # 80007748 <etext+0x748>
    80005868:	f37fa0ef          	jal	8000079e <panic>
    panic("virtio disk has no queue 0");
    8000586c:	00002517          	auipc	a0,0x2
    80005870:	efc50513          	addi	a0,a0,-260 # 80007768 <etext+0x768>
    80005874:	f2bfa0ef          	jal	8000079e <panic>
    panic("virtio disk max queue too short");
    80005878:	00002517          	auipc	a0,0x2
    8000587c:	f1050513          	addi	a0,a0,-240 # 80007788 <etext+0x788>
    80005880:	f1ffa0ef          	jal	8000079e <panic>
    panic("virtio disk kalloc");
    80005884:	00002517          	auipc	a0,0x2
    80005888:	f2450513          	addi	a0,a0,-220 # 800077a8 <etext+0x7a8>
    8000588c:	f13fa0ef          	jal	8000079e <panic>

0000000080005890 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005890:	711d                	addi	sp,sp,-96
    80005892:	ec86                	sd	ra,88(sp)
    80005894:	e8a2                	sd	s0,80(sp)
    80005896:	e4a6                	sd	s1,72(sp)
    80005898:	e0ca                	sd	s2,64(sp)
    8000589a:	fc4e                	sd	s3,56(sp)
    8000589c:	f852                	sd	s4,48(sp)
    8000589e:	f456                	sd	s5,40(sp)
    800058a0:	f05a                	sd	s6,32(sp)
    800058a2:	ec5e                	sd	s7,24(sp)
    800058a4:	e862                	sd	s8,16(sp)
    800058a6:	1080                	addi	s0,sp,96
    800058a8:	89aa                	mv	s3,a0
    800058aa:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800058ac:	00c52b83          	lw	s7,12(a0)
    800058b0:	001b9b9b          	slliw	s7,s7,0x1
    800058b4:	1b82                	slli	s7,s7,0x20
    800058b6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800058ba:	0001f517          	auipc	a0,0x1f
    800058be:	88e50513          	addi	a0,a0,-1906 # 80024148 <disk+0x128>
    800058c2:	b3cfb0ef          	jal	80000bfe <acquire>
  for(int i = 0; i < NUM; i++){
    800058c6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800058c8:	0001ea97          	auipc	s5,0x1e
    800058cc:	758a8a93          	addi	s5,s5,1880 # 80024020 <disk>
  for(int i = 0; i < 3; i++){
    800058d0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800058d2:	5c7d                	li	s8,-1
    800058d4:	a095                	j	80005938 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    800058d6:	00fa8733          	add	a4,s5,a5
    800058da:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800058de:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800058e0:	0207c563          	bltz	a5,8000590a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    800058e4:	2905                	addiw	s2,s2,1
    800058e6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800058e8:	05490c63          	beq	s2,s4,80005940 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    800058ec:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800058ee:	0001e717          	auipc	a4,0x1e
    800058f2:	73270713          	addi	a4,a4,1842 # 80024020 <disk>
    800058f6:	4781                	li	a5,0
    if(disk.free[i]){
    800058f8:	01874683          	lbu	a3,24(a4)
    800058fc:	fee9                	bnez	a3,800058d6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    800058fe:	2785                	addiw	a5,a5,1
    80005900:	0705                	addi	a4,a4,1
    80005902:	fe979be3          	bne	a5,s1,800058f8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005906:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    8000590a:	01205d63          	blez	s2,80005924 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000590e:	fa042503          	lw	a0,-96(s0)
    80005912:	d41ff0ef          	jal	80005652 <free_desc>
      for(int j = 0; j < i; j++)
    80005916:	4785                	li	a5,1
    80005918:	0127d663          	bge	a5,s2,80005924 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000591c:	fa442503          	lw	a0,-92(s0)
    80005920:	d33ff0ef          	jal	80005652 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005924:	0001f597          	auipc	a1,0x1f
    80005928:	82458593          	addi	a1,a1,-2012 # 80024148 <disk+0x128>
    8000592c:	0001e517          	auipc	a0,0x1e
    80005930:	70c50513          	addi	a0,a0,1804 # 80024038 <disk+0x18>
    80005934:	e78fc0ef          	jal	80001fac <sleep>
  for(int i = 0; i < 3; i++){
    80005938:	fa040613          	addi	a2,s0,-96
    8000593c:	4901                	li	s2,0
    8000593e:	b77d                	j	800058ec <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005940:	fa042503          	lw	a0,-96(s0)
    80005944:	00451693          	slli	a3,a0,0x4

  if(write)
    80005948:	0001e797          	auipc	a5,0x1e
    8000594c:	6d878793          	addi	a5,a5,1752 # 80024020 <disk>
    80005950:	00a50713          	addi	a4,a0,10
    80005954:	0712                	slli	a4,a4,0x4
    80005956:	973e                	add	a4,a4,a5
    80005958:	01603633          	snez	a2,s6
    8000595c:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000595e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005962:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005966:	6398                	ld	a4,0(a5)
    80005968:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000596a:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    8000596e:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005970:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005972:	6390                	ld	a2,0(a5)
    80005974:	00d605b3          	add	a1,a2,a3
    80005978:	4741                	li	a4,16
    8000597a:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000597c:	4805                	li	a6,1
    8000597e:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005982:	fa442703          	lw	a4,-92(s0)
    80005986:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000598a:	0712                	slli	a4,a4,0x4
    8000598c:	963a                	add	a2,a2,a4
    8000598e:	05898593          	addi	a1,s3,88
    80005992:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005994:	0007b883          	ld	a7,0(a5)
    80005998:	9746                	add	a4,a4,a7
    8000599a:	40000613          	li	a2,1024
    8000599e:	c710                	sw	a2,8(a4)
  if(write)
    800059a0:	001b3613          	seqz	a2,s6
    800059a4:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800059a8:	01066633          	or	a2,a2,a6
    800059ac:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800059b0:	fa842583          	lw	a1,-88(s0)
    800059b4:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800059b8:	00250613          	addi	a2,a0,2
    800059bc:	0612                	slli	a2,a2,0x4
    800059be:	963e                	add	a2,a2,a5
    800059c0:	577d                	li	a4,-1
    800059c2:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800059c6:	0592                	slli	a1,a1,0x4
    800059c8:	98ae                	add	a7,a7,a1
    800059ca:	03068713          	addi	a4,a3,48
    800059ce:	973e                	add	a4,a4,a5
    800059d0:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800059d4:	6398                	ld	a4,0(a5)
    800059d6:	972e                	add	a4,a4,a1
    800059d8:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800059dc:	4689                	li	a3,2
    800059de:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800059e2:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800059e6:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    800059ea:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800059ee:	6794                	ld	a3,8(a5)
    800059f0:	0026d703          	lhu	a4,2(a3)
    800059f4:	8b1d                	andi	a4,a4,7
    800059f6:	0706                	slli	a4,a4,0x1
    800059f8:	96ba                	add	a3,a3,a4
    800059fa:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800059fe:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005a02:	6798                	ld	a4,8(a5)
    80005a04:	00275783          	lhu	a5,2(a4)
    80005a08:	2785                	addiw	a5,a5,1
    80005a0a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005a0e:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005a12:	100017b7          	lui	a5,0x10001
    80005a16:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005a1a:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80005a1e:	0001e917          	auipc	s2,0x1e
    80005a22:	72a90913          	addi	s2,s2,1834 # 80024148 <disk+0x128>
  while(b->disk == 1) {
    80005a26:	84c2                	mv	s1,a6
    80005a28:	01079a63          	bne	a5,a6,80005a3c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80005a2c:	85ca                	mv	a1,s2
    80005a2e:	854e                	mv	a0,s3
    80005a30:	d7cfc0ef          	jal	80001fac <sleep>
  while(b->disk == 1) {
    80005a34:	0049a783          	lw	a5,4(s3)
    80005a38:	fe978ae3          	beq	a5,s1,80005a2c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80005a3c:	fa042903          	lw	s2,-96(s0)
    80005a40:	00290713          	addi	a4,s2,2
    80005a44:	0712                	slli	a4,a4,0x4
    80005a46:	0001e797          	auipc	a5,0x1e
    80005a4a:	5da78793          	addi	a5,a5,1498 # 80024020 <disk>
    80005a4e:	97ba                	add	a5,a5,a4
    80005a50:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005a54:	0001e997          	auipc	s3,0x1e
    80005a58:	5cc98993          	addi	s3,s3,1484 # 80024020 <disk>
    80005a5c:	00491713          	slli	a4,s2,0x4
    80005a60:	0009b783          	ld	a5,0(s3)
    80005a64:	97ba                	add	a5,a5,a4
    80005a66:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005a6a:	854a                	mv	a0,s2
    80005a6c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005a70:	be3ff0ef          	jal	80005652 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005a74:	8885                	andi	s1,s1,1
    80005a76:	f0fd                	bnez	s1,80005a5c <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005a78:	0001e517          	auipc	a0,0x1e
    80005a7c:	6d050513          	addi	a0,a0,1744 # 80024148 <disk+0x128>
    80005a80:	a12fb0ef          	jal	80000c92 <release>
}
    80005a84:	60e6                	ld	ra,88(sp)
    80005a86:	6446                	ld	s0,80(sp)
    80005a88:	64a6                	ld	s1,72(sp)
    80005a8a:	6906                	ld	s2,64(sp)
    80005a8c:	79e2                	ld	s3,56(sp)
    80005a8e:	7a42                	ld	s4,48(sp)
    80005a90:	7aa2                	ld	s5,40(sp)
    80005a92:	7b02                	ld	s6,32(sp)
    80005a94:	6be2                	ld	s7,24(sp)
    80005a96:	6c42                	ld	s8,16(sp)
    80005a98:	6125                	addi	sp,sp,96
    80005a9a:	8082                	ret

0000000080005a9c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a9c:	1101                	addi	sp,sp,-32
    80005a9e:	ec06                	sd	ra,24(sp)
    80005aa0:	e822                	sd	s0,16(sp)
    80005aa2:	e426                	sd	s1,8(sp)
    80005aa4:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005aa6:	0001e497          	auipc	s1,0x1e
    80005aaa:	57a48493          	addi	s1,s1,1402 # 80024020 <disk>
    80005aae:	0001e517          	auipc	a0,0x1e
    80005ab2:	69a50513          	addi	a0,a0,1690 # 80024148 <disk+0x128>
    80005ab6:	948fb0ef          	jal	80000bfe <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005aba:	100017b7          	lui	a5,0x10001
    80005abe:	53bc                	lw	a5,96(a5)
    80005ac0:	8b8d                	andi	a5,a5,3
    80005ac2:	10001737          	lui	a4,0x10001
    80005ac6:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005ac8:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005acc:	689c                	ld	a5,16(s1)
    80005ace:	0204d703          	lhu	a4,32(s1)
    80005ad2:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005ad6:	04f70663          	beq	a4,a5,80005b22 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005ada:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005ade:	6898                	ld	a4,16(s1)
    80005ae0:	0204d783          	lhu	a5,32(s1)
    80005ae4:	8b9d                	andi	a5,a5,7
    80005ae6:	078e                	slli	a5,a5,0x3
    80005ae8:	97ba                	add	a5,a5,a4
    80005aea:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005aec:	00278713          	addi	a4,a5,2
    80005af0:	0712                	slli	a4,a4,0x4
    80005af2:	9726                	add	a4,a4,s1
    80005af4:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005af8:	e321                	bnez	a4,80005b38 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005afa:	0789                	addi	a5,a5,2
    80005afc:	0792                	slli	a5,a5,0x4
    80005afe:	97a6                	add	a5,a5,s1
    80005b00:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005b02:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005b06:	cf2fc0ef          	jal	80001ff8 <wakeup>

    disk.used_idx += 1;
    80005b0a:	0204d783          	lhu	a5,32(s1)
    80005b0e:	2785                	addiw	a5,a5,1
    80005b10:	17c2                	slli	a5,a5,0x30
    80005b12:	93c1                	srli	a5,a5,0x30
    80005b14:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005b18:	6898                	ld	a4,16(s1)
    80005b1a:	00275703          	lhu	a4,2(a4)
    80005b1e:	faf71ee3          	bne	a4,a5,80005ada <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005b22:	0001e517          	auipc	a0,0x1e
    80005b26:	62650513          	addi	a0,a0,1574 # 80024148 <disk+0x128>
    80005b2a:	968fb0ef          	jal	80000c92 <release>
}
    80005b2e:	60e2                	ld	ra,24(sp)
    80005b30:	6442                	ld	s0,16(sp)
    80005b32:	64a2                	ld	s1,8(sp)
    80005b34:	6105                	addi	sp,sp,32
    80005b36:	8082                	ret
      panic("virtio_disk_intr status");
    80005b38:	00002517          	auipc	a0,0x2
    80005b3c:	c8850513          	addi	a0,a0,-888 # 800077c0 <etext+0x7c0>
    80005b40:	c5ffa0ef          	jal	8000079e <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
