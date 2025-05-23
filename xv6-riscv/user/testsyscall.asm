
user/_testsyscall:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <panic>:
#include "kernel/stat.h"
#include "user/user.h"

void
panic(char *s)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
   a:	00001597          	auipc	a1,0x1
   e:	a5658593          	addi	a1,a1,-1450 # a60 <malloc+0xfe>
  12:	4509                	li	a0,2
  14:	06d000ef          	jal	880 <fprintf>
  exit(1);
  18:	4505                	li	a0,1
  1a:	44e000ef          	jal	468 <exit>

000000000000001e <fork1>:
}

int
fork1(void)
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  int pid;
  pid = fork();
  26:	43a000ef          	jal	460 <fork>
  if(pid == -1)
  2a:	57fd                	li	a5,-1
  2c:	00f50663          	beq	a0,a5,38 <fork1+0x1a>
    panic("fork");
  return pid;
}
  30:	60a2                	ld	ra,8(sp)
  32:	6402                	ld	s0,0(sp)
  34:	0141                	addi	sp,sp,16
  36:	8082                	ret
    panic("fork");
  38:	00001517          	auipc	a0,0x1
  3c:	a3050513          	addi	a0,a0,-1488 # a68 <malloc+0x106>
  40:	fc1ff0ef          	jal	0 <panic>

0000000000000044 <main>:


int
main(int argc, char* argv[])
{
  44:	7131                	addi	sp,sp,-192
  46:	fd06                	sd	ra,184(sp)
  48:	f922                	sd	s0,176(sp)
  4a:	f526                	sd	s1,168(sp)
  4c:	f14a                	sd	s2,160(sp)
  4e:	ed4e                	sd	s3,152(sp)
  50:	0180                	addi	s0,sp,192

	//set a pipe to make processes output mutually exclusive 
	int fd[2];
	if (pipe(fd) == -1) panic("pipe");
  52:	fc840513          	addi	a0,s0,-56
  56:	422000ef          	jal	478 <pipe>
  5a:	57fd                	li	a5,-1
  5c:	10f50663          	beq	a0,a5,168 <main+0x124>
	char msg[128]="Hi";
  60:	679d                	lui	a5,0x7
  62:	94878793          	addi	a5,a5,-1720 # 6948 <base+0x4938>
  66:	f4f43423          	sd	a5,-184(s0)
  6a:	f4043823          	sd	zero,-176(s0)
  6e:	f4043c23          	sd	zero,-168(s0)
  72:	f6043023          	sd	zero,-160(s0)
  76:	f6043423          	sd	zero,-152(s0)
  7a:	f6043823          	sd	zero,-144(s0)
  7e:	f6043c23          	sd	zero,-136(s0)
  82:	f8043023          	sd	zero,-128(s0)
  86:	f8043423          	sd	zero,-120(s0)
  8a:	f8043823          	sd	zero,-112(s0)
  8e:	f8043c23          	sd	zero,-104(s0)
  92:	fa043023          	sd	zero,-96(s0)
  96:	fa043423          	sd	zero,-88(s0)
  9a:	fa043823          	sd	zero,-80(s0)
  9e:	fa043c23          	sd	zero,-72(s0)
  a2:	fc043023          	sd	zero,-64(s0)

	//set up parent process and start cfs
	nice(3);
  a6:	450d                	li	a0,3
  a8:	480000ef          	jal	528 <nice>
	startcfs(100,20,2);
  ac:	4609                	li	a2,2
  ae:	45d1                	li	a1,20
  b0:	06400513          	li	a0,100
  b4:	484000ef          	jal	538 <startcfs>
	printf("\n[START] Process (pid:%d) has started cfs!\n\n", getpid());
  b8:	430000ef          	jal	4e8 <getpid>
  bc:	85aa                	mv	a1,a0
  be:	00001517          	auipc	a0,0x1
  c2:	9ba50513          	addi	a0,a0,-1606 # a78 <malloc+0x116>
  c6:	7e4000ef          	jal	8aa <printf>

	//create 10 child processes: first 5 have lower priority than the last 5
        int ret=0;
        for(int i=0; i<10; i++){
  ca:	4901                	li	s2,0
  cc:	49a9                	li	s3,10
                ret=fork1();
  ce:	f51ff0ef          	jal	1e <fork1>
  d2:	84aa                	mv	s1,a0
                if(ret==0){
  d4:	c145                	beqz	a0,174 <main+0x130>
        for(int i=0; i<10; i++){
  d6:	2905                	addiw	s2,s2,1
  d8:	ff391be3          	bne	s2,s3,ce <main+0x8a>
                        if(i<5) nice(10);
			else nice(5);
                        break;
                }
        }
	int mypid = getpid();
  dc:	40c000ef          	jal	4e8 <getpid>
  e0:	892a                	mv	s2,a0
        printf("[PRIORITY] process (pid=%d): has nice = %d\n", mypid,nice(-30));
  e2:	5509                	li	a0,-30
  e4:	444000ef          	jal	528 <nice>
  e8:	862a                	mv	a2,a0
  ea:	85ca                	mv	a1,s2
  ec:	00001517          	auipc	a0,0x1
  f0:	9bc50513          	addi	a0,a0,-1604 # aa8 <malloc+0x146>
  f4:	7b6000ef          	jal	8aa <printf>
  f8:	05f5e7b7          	lui	a5,0x5f5e
  fc:	10078793          	addi	a5,a5,256 # 5f5e100 <base+0x5f5c0f0>

	//do intensive computation
        int t=0;
        while(t++<2){
                double x=987654321.9;
                for(int i=0; i<100000000; i++){
 100:	37fd                	addiw	a5,a5,-1
 102:	fffd                	bnez	a5,100 <main+0xbc>
 104:	05f5e7b7          	lui	a5,0x5f5e
 108:	10078793          	addi	a5,a5,256 # 5f5e100 <base+0x5f5c0f0>
 10c:	37fd                	addiw	a5,a5,-1
 10e:	fffd                	bnez	a5,10c <main+0xc8>
                }
        }


	//when parent is done (which should be earlier than children due to its high priority), it stop CFS and then every one summarize their actual and virtual runtime during CFS
	if(ret>0){
 110:	06904d63          	bgtz	s1,18a <main+0x146>
		for(int i=0; i<10; i++) wait(0);
	}


	//every one summarizies its actual and virtual runtime during CFS; note: pipe is used for mutual exclusion
	read(fd[0],msg,128);
 114:	08000613          	li	a2,128
 118:	f4840593          	addi	a1,s0,-184
 11c:	fc842503          	lw	a0,-56(s0)
 120:	360000ef          	jal	480 <read>
	int runtime[2];
        if(getruntime(&runtime[0], &runtime[1])==0)
 124:	f4440593          	addi	a1,s0,-188
 128:	f4040513          	addi	a0,s0,-192
 12c:	404000ef          	jal	530 <getruntime>
 130:	e549                	bnez	a0,1ba <main+0x176>
            printf("[SUMMARY] process (pid=%d): finishes comutation. During CFS: actual runtime = %d; virtual runtime = %d\n", mypid, runtime[0], runtime[1]);
 132:	f4442683          	lw	a3,-188(s0)
 136:	f4042603          	lw	a2,-192(s0)
 13a:	85ca                	mv	a1,s2
 13c:	00001517          	auipc	a0,0x1
 140:	9cc50513          	addi	a0,a0,-1588 # b08 <malloc+0x1a6>
 144:	766000ef          	jal	8aa <printf>
        else
            printf("\n [ERROR] Process (pid=%d): something wrong with getruntime!\n\n", mypid);
	write(fd[1],msg,128);
 148:	08000613          	li	a2,128
 14c:	f4840593          	addi	a1,s0,-184
 150:	fcc42503          	lw	a0,-52(s0)
 154:	334000ef          	jal	488 <write>

        return 0;
}
 158:	4501                	li	a0,0
 15a:	70ea                	ld	ra,184(sp)
 15c:	744a                	ld	s0,176(sp)
 15e:	74aa                	ld	s1,168(sp)
 160:	790a                	ld	s2,160(sp)
 162:	69ea                	ld	s3,152(sp)
 164:	6129                	addi	sp,sp,192
 166:	8082                	ret
	if (pipe(fd) == -1) panic("pipe");
 168:	00001517          	auipc	a0,0x1
 16c:	90850513          	addi	a0,a0,-1784 # a70 <malloc+0x10e>
 170:	e91ff0ef          	jal	0 <panic>
                        if(i<5) nice(10);
 174:	4791                	li	a5,4
 176:	0127c663          	blt	a5,s2,182 <main+0x13e>
 17a:	4529                	li	a0,10
 17c:	3ac000ef          	jal	528 <nice>
 180:	bfb1                	j	dc <main+0x98>
			else nice(5);
 182:	4515                	li	a0,5
 184:	3a4000ef          	jal	528 <nice>
 188:	bf91                	j	dc <main+0x98>
		stopcfs();
 18a:	3b6000ef          	jal	540 <stopcfs>
		printf("\n[STOP] Process (pid=%d): has stopped cfs\n\n", mypid);
 18e:	85ca                	mv	a1,s2
 190:	00001517          	auipc	a0,0x1
 194:	94850513          	addi	a0,a0,-1720 # ad8 <malloc+0x176>
 198:	712000ef          	jal	8aa <printf>
		write(fd[1],msg,128);
 19c:	08000613          	li	a2,128
 1a0:	f4840593          	addi	a1,s0,-184
 1a4:	fcc42503          	lw	a0,-52(s0)
 1a8:	2e0000ef          	jal	488 <write>
 1ac:	44a9                	li	s1,10
		for(int i=0; i<10; i++) wait(0);
 1ae:	4501                	li	a0,0
 1b0:	2c0000ef          	jal	470 <wait>
 1b4:	34fd                	addiw	s1,s1,-1
 1b6:	fce5                	bnez	s1,1ae <main+0x16a>
 1b8:	bfb1                	j	114 <main+0xd0>
            printf("\n [ERROR] Process (pid=%d): something wrong with getruntime!\n\n", mypid);
 1ba:	85ca                	mv	a1,s2
 1bc:	00001517          	auipc	a0,0x1
 1c0:	9b450513          	addi	a0,a0,-1612 # b70 <malloc+0x20e>
 1c4:	6e6000ef          	jal	8aa <printf>
 1c8:	b741                	j	148 <main+0x104>

00000000000001ca <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e406                	sd	ra,8(sp)
 1ce:	e022                	sd	s0,0(sp)
 1d0:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1d2:	e73ff0ef          	jal	44 <main>
  exit(0);
 1d6:	4501                	li	a0,0
 1d8:	290000ef          	jal	468 <exit>

00000000000001dc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e406                	sd	ra,8(sp)
 1e0:	e022                	sd	s0,0(sp)
 1e2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1e4:	87aa                	mv	a5,a0
 1e6:	0585                	addi	a1,a1,1
 1e8:	0785                	addi	a5,a5,1
 1ea:	fff5c703          	lbu	a4,-1(a1)
 1ee:	fee78fa3          	sb	a4,-1(a5)
 1f2:	fb75                	bnez	a4,1e6 <strcpy+0xa>
    ;
  return os;
}
 1f4:	60a2                	ld	ra,8(sp)
 1f6:	6402                	ld	s0,0(sp)
 1f8:	0141                	addi	sp,sp,16
 1fa:	8082                	ret

00000000000001fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e406                	sd	ra,8(sp)
 200:	e022                	sd	s0,0(sp)
 202:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 204:	00054783          	lbu	a5,0(a0)
 208:	cb91                	beqz	a5,21c <strcmp+0x20>
 20a:	0005c703          	lbu	a4,0(a1)
 20e:	00f71763          	bne	a4,a5,21c <strcmp+0x20>
    p++, q++;
 212:	0505                	addi	a0,a0,1
 214:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 216:	00054783          	lbu	a5,0(a0)
 21a:	fbe5                	bnez	a5,20a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 21c:	0005c503          	lbu	a0,0(a1)
}
 220:	40a7853b          	subw	a0,a5,a0
 224:	60a2                	ld	ra,8(sp)
 226:	6402                	ld	s0,0(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret

000000000000022c <strlen>:

uint
strlen(const char *s)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e406                	sd	ra,8(sp)
 230:	e022                	sd	s0,0(sp)
 232:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 234:	00054783          	lbu	a5,0(a0)
 238:	cf99                	beqz	a5,256 <strlen+0x2a>
 23a:	0505                	addi	a0,a0,1
 23c:	87aa                	mv	a5,a0
 23e:	86be                	mv	a3,a5
 240:	0785                	addi	a5,a5,1
 242:	fff7c703          	lbu	a4,-1(a5)
 246:	ff65                	bnez	a4,23e <strlen+0x12>
 248:	40a6853b          	subw	a0,a3,a0
 24c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 24e:	60a2                	ld	ra,8(sp)
 250:	6402                	ld	s0,0(sp)
 252:	0141                	addi	sp,sp,16
 254:	8082                	ret
  for(n = 0; s[n]; n++)
 256:	4501                	li	a0,0
 258:	bfdd                	j	24e <strlen+0x22>

000000000000025a <memset>:

void*
memset(void *dst, int c, uint n)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 262:	ca19                	beqz	a2,278 <memset+0x1e>
 264:	87aa                	mv	a5,a0
 266:	1602                	slli	a2,a2,0x20
 268:	9201                	srli	a2,a2,0x20
 26a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 26e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 272:	0785                	addi	a5,a5,1
 274:	fee79de3          	bne	a5,a4,26e <memset+0x14>
  }
  return dst;
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret

0000000000000280 <strchr>:

char*
strchr(const char *s, char c)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  for(; *s; s++)
 288:	00054783          	lbu	a5,0(a0)
 28c:	cf81                	beqz	a5,2a4 <strchr+0x24>
    if(*s == c)
 28e:	00f58763          	beq	a1,a5,29c <strchr+0x1c>
  for(; *s; s++)
 292:	0505                	addi	a0,a0,1
 294:	00054783          	lbu	a5,0(a0)
 298:	fbfd                	bnez	a5,28e <strchr+0xe>
      return (char*)s;
  return 0;
 29a:	4501                	li	a0,0
}
 29c:	60a2                	ld	ra,8(sp)
 29e:	6402                	ld	s0,0(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  return 0;
 2a4:	4501                	li	a0,0
 2a6:	bfdd                	j	29c <strchr+0x1c>

00000000000002a8 <gets>:

char*
gets(char *buf, int max)
{
 2a8:	7159                	addi	sp,sp,-112
 2aa:	f486                	sd	ra,104(sp)
 2ac:	f0a2                	sd	s0,96(sp)
 2ae:	eca6                	sd	s1,88(sp)
 2b0:	e8ca                	sd	s2,80(sp)
 2b2:	e4ce                	sd	s3,72(sp)
 2b4:	e0d2                	sd	s4,64(sp)
 2b6:	fc56                	sd	s5,56(sp)
 2b8:	f85a                	sd	s6,48(sp)
 2ba:	f45e                	sd	s7,40(sp)
 2bc:	f062                	sd	s8,32(sp)
 2be:	ec66                	sd	s9,24(sp)
 2c0:	e86a                	sd	s10,16(sp)
 2c2:	1880                	addi	s0,sp,112
 2c4:	8caa                	mv	s9,a0
 2c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c8:	892a                	mv	s2,a0
 2ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
 2cc:	f9f40b13          	addi	s6,s0,-97
 2d0:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d2:	4ba9                	li	s7,10
 2d4:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 2d6:	8d26                	mv	s10,s1
 2d8:	0014899b          	addiw	s3,s1,1
 2dc:	84ce                	mv	s1,s3
 2de:	0349d563          	bge	s3,s4,308 <gets+0x60>
    cc = read(0, &c, 1);
 2e2:	8656                	mv	a2,s5
 2e4:	85da                	mv	a1,s6
 2e6:	4501                	li	a0,0
 2e8:	198000ef          	jal	480 <read>
    if(cc < 1)
 2ec:	00a05e63          	blez	a0,308 <gets+0x60>
    buf[i++] = c;
 2f0:	f9f44783          	lbu	a5,-97(s0)
 2f4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2f8:	01778763          	beq	a5,s7,306 <gets+0x5e>
 2fc:	0905                	addi	s2,s2,1
 2fe:	fd879ce3          	bne	a5,s8,2d6 <gets+0x2e>
    buf[i++] = c;
 302:	8d4e                	mv	s10,s3
 304:	a011                	j	308 <gets+0x60>
 306:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 308:	9d66                	add	s10,s10,s9
 30a:	000d0023          	sb	zero,0(s10)
  return buf;
}
 30e:	8566                	mv	a0,s9
 310:	70a6                	ld	ra,104(sp)
 312:	7406                	ld	s0,96(sp)
 314:	64e6                	ld	s1,88(sp)
 316:	6946                	ld	s2,80(sp)
 318:	69a6                	ld	s3,72(sp)
 31a:	6a06                	ld	s4,64(sp)
 31c:	7ae2                	ld	s5,56(sp)
 31e:	7b42                	ld	s6,48(sp)
 320:	7ba2                	ld	s7,40(sp)
 322:	7c02                	ld	s8,32(sp)
 324:	6ce2                	ld	s9,24(sp)
 326:	6d42                	ld	s10,16(sp)
 328:	6165                	addi	sp,sp,112
 32a:	8082                	ret

000000000000032c <stat>:

int
stat(const char *n, struct stat *st)
{
 32c:	1101                	addi	sp,sp,-32
 32e:	ec06                	sd	ra,24(sp)
 330:	e822                	sd	s0,16(sp)
 332:	e04a                	sd	s2,0(sp)
 334:	1000                	addi	s0,sp,32
 336:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 338:	4581                	li	a1,0
 33a:	16e000ef          	jal	4a8 <open>
  if(fd < 0)
 33e:	02054263          	bltz	a0,362 <stat+0x36>
 342:	e426                	sd	s1,8(sp)
 344:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 346:	85ca                	mv	a1,s2
 348:	178000ef          	jal	4c0 <fstat>
 34c:	892a                	mv	s2,a0
  close(fd);
 34e:	8526                	mv	a0,s1
 350:	140000ef          	jal	490 <close>
  return r;
 354:	64a2                	ld	s1,8(sp)
}
 356:	854a                	mv	a0,s2
 358:	60e2                	ld	ra,24(sp)
 35a:	6442                	ld	s0,16(sp)
 35c:	6902                	ld	s2,0(sp)
 35e:	6105                	addi	sp,sp,32
 360:	8082                	ret
    return -1;
 362:	597d                	li	s2,-1
 364:	bfcd                	j	356 <stat+0x2a>

0000000000000366 <atoi>:

int
atoi(const char *s)
{
 366:	1141                	addi	sp,sp,-16
 368:	e406                	sd	ra,8(sp)
 36a:	e022                	sd	s0,0(sp)
 36c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 36e:	00054683          	lbu	a3,0(a0)
 372:	fd06879b          	addiw	a5,a3,-48
 376:	0ff7f793          	zext.b	a5,a5
 37a:	4625                	li	a2,9
 37c:	02f66963          	bltu	a2,a5,3ae <atoi+0x48>
 380:	872a                	mv	a4,a0
  n = 0;
 382:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 384:	0705                	addi	a4,a4,1
 386:	0025179b          	slliw	a5,a0,0x2
 38a:	9fa9                	addw	a5,a5,a0
 38c:	0017979b          	slliw	a5,a5,0x1
 390:	9fb5                	addw	a5,a5,a3
 392:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 396:	00074683          	lbu	a3,0(a4)
 39a:	fd06879b          	addiw	a5,a3,-48
 39e:	0ff7f793          	zext.b	a5,a5
 3a2:	fef671e3          	bgeu	a2,a5,384 <atoi+0x1e>
  return n;
}
 3a6:	60a2                	ld	ra,8(sp)
 3a8:	6402                	ld	s0,0(sp)
 3aa:	0141                	addi	sp,sp,16
 3ac:	8082                	ret
  n = 0;
 3ae:	4501                	li	a0,0
 3b0:	bfdd                	j	3a6 <atoi+0x40>

00000000000003b2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e406                	sd	ra,8(sp)
 3b6:	e022                	sd	s0,0(sp)
 3b8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3ba:	02b57563          	bgeu	a0,a1,3e4 <memmove+0x32>
    while(n-- > 0)
 3be:	00c05f63          	blez	a2,3dc <memmove+0x2a>
 3c2:	1602                	slli	a2,a2,0x20
 3c4:	9201                	srli	a2,a2,0x20
 3c6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 3cc:	0585                	addi	a1,a1,1
 3ce:	0705                	addi	a4,a4,1
 3d0:	fff5c683          	lbu	a3,-1(a1)
 3d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3d8:	fee79ae3          	bne	a5,a4,3cc <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3dc:	60a2                	ld	ra,8(sp)
 3de:	6402                	ld	s0,0(sp)
 3e0:	0141                	addi	sp,sp,16
 3e2:	8082                	ret
    dst += n;
 3e4:	00c50733          	add	a4,a0,a2
    src += n;
 3e8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ea:	fec059e3          	blez	a2,3dc <memmove+0x2a>
 3ee:	fff6079b          	addiw	a5,a2,-1
 3f2:	1782                	slli	a5,a5,0x20
 3f4:	9381                	srli	a5,a5,0x20
 3f6:	fff7c793          	not	a5,a5
 3fa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3fc:	15fd                	addi	a1,a1,-1
 3fe:	177d                	addi	a4,a4,-1
 400:	0005c683          	lbu	a3,0(a1)
 404:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 408:	fef71ae3          	bne	a4,a5,3fc <memmove+0x4a>
 40c:	bfc1                	j	3dc <memmove+0x2a>

000000000000040e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 40e:	1141                	addi	sp,sp,-16
 410:	e406                	sd	ra,8(sp)
 412:	e022                	sd	s0,0(sp)
 414:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 416:	ca0d                	beqz	a2,448 <memcmp+0x3a>
 418:	fff6069b          	addiw	a3,a2,-1
 41c:	1682                	slli	a3,a3,0x20
 41e:	9281                	srli	a3,a3,0x20
 420:	0685                	addi	a3,a3,1
 422:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 424:	00054783          	lbu	a5,0(a0)
 428:	0005c703          	lbu	a4,0(a1)
 42c:	00e79863          	bne	a5,a4,43c <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 430:	0505                	addi	a0,a0,1
    p2++;
 432:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 434:	fed518e3          	bne	a0,a3,424 <memcmp+0x16>
  }
  return 0;
 438:	4501                	li	a0,0
 43a:	a019                	j	440 <memcmp+0x32>
      return *p1 - *p2;
 43c:	40e7853b          	subw	a0,a5,a4
}
 440:	60a2                	ld	ra,8(sp)
 442:	6402                	ld	s0,0(sp)
 444:	0141                	addi	sp,sp,16
 446:	8082                	ret
  return 0;
 448:	4501                	li	a0,0
 44a:	bfdd                	j	440 <memcmp+0x32>

000000000000044c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 44c:	1141                	addi	sp,sp,-16
 44e:	e406                	sd	ra,8(sp)
 450:	e022                	sd	s0,0(sp)
 452:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 454:	f5fff0ef          	jal	3b2 <memmove>
}
 458:	60a2                	ld	ra,8(sp)
 45a:	6402                	ld	s0,0(sp)
 45c:	0141                	addi	sp,sp,16
 45e:	8082                	ret

0000000000000460 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 460:	4885                	li	a7,1
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <exit>:
.global exit
exit:
 li a7, SYS_exit
 468:	4889                	li	a7,2
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <wait>:
.global wait
wait:
 li a7, SYS_wait
 470:	488d                	li	a7,3
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 478:	4891                	li	a7,4
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <read>:
.global read
read:
 li a7, SYS_read
 480:	4895                	li	a7,5
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <write>:
.global write
write:
 li a7, SYS_write
 488:	48c1                	li	a7,16
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <close>:
.global close
close:
 li a7, SYS_close
 490:	48d5                	li	a7,21
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <kill>:
.global kill
kill:
 li a7, SYS_kill
 498:	4899                	li	a7,6
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a0:	489d                	li	a7,7
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <open>:
.global open
open:
 li a7, SYS_open
 4a8:	48bd                	li	a7,15
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b0:	48c5                	li	a7,17
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4b8:	48c9                	li	a7,18
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c0:	48a1                	li	a7,8
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <link>:
.global link
link:
 li a7, SYS_link
 4c8:	48cd                	li	a7,19
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d0:	48d1                	li	a7,20
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4d8:	48a5                	li	a7,9
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e0:	48a9                	li	a7,10
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4e8:	48ad                	li	a7,11
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f0:	48b1                	li	a7,12
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4f8:	48b5                	li	a7,13
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 500:	48b9                	li	a7,14
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 508:	48d9                	li	a7,22
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <getcpids>:
.global getcpids
getcpids:
 li a7, SYS_getcpids
 510:	48dd                	li	a7,23
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <getpaddr>:
.global getpaddr
getpaddr:
 li a7, SYS_getpaddr
 518:	48e1                	li	a7,24
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <gettraphistory>:
.global gettraphistory
gettraphistory:
 li a7, SYS_gettraphistory
 520:	48e5                	li	a7,25
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <nice>:
.global nice
nice:
 li a7, SYS_nice
 528:	48e9                	li	a7,26
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <getruntime>:
.global getruntime
getruntime:
 li a7, SYS_getruntime
 530:	48ed                	li	a7,27
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <startcfs>:
.global startcfs
startcfs:
 li a7, SYS_startcfs
 538:	48f1                	li	a7,28
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <stopcfs>:
.global stopcfs
stopcfs:
 li a7, SYS_stopcfs
 540:	48f5                	li	a7,29
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 548:	1101                	addi	sp,sp,-32
 54a:	ec06                	sd	ra,24(sp)
 54c:	e822                	sd	s0,16(sp)
 54e:	1000                	addi	s0,sp,32
 550:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 554:	4605                	li	a2,1
 556:	fef40593          	addi	a1,s0,-17
 55a:	f2fff0ef          	jal	488 <write>
}
 55e:	60e2                	ld	ra,24(sp)
 560:	6442                	ld	s0,16(sp)
 562:	6105                	addi	sp,sp,32
 564:	8082                	ret

0000000000000566 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 566:	7139                	addi	sp,sp,-64
 568:	fc06                	sd	ra,56(sp)
 56a:	f822                	sd	s0,48(sp)
 56c:	f426                	sd	s1,40(sp)
 56e:	f04a                	sd	s2,32(sp)
 570:	ec4e                	sd	s3,24(sp)
 572:	0080                	addi	s0,sp,64
 574:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 576:	c299                	beqz	a3,57c <printint+0x16>
 578:	0605ce63          	bltz	a1,5f4 <printint+0x8e>
  neg = 0;
 57c:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 57e:	fc040313          	addi	t1,s0,-64
  neg = 0;
 582:	869a                	mv	a3,t1
  i = 0;
 584:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 586:	00000817          	auipc	a6,0x0
 58a:	63280813          	addi	a6,a6,1586 # bb8 <digits>
 58e:	88be                	mv	a7,a5
 590:	0017851b          	addiw	a0,a5,1
 594:	87aa                	mv	a5,a0
 596:	02c5f73b          	remuw	a4,a1,a2
 59a:	1702                	slli	a4,a4,0x20
 59c:	9301                	srli	a4,a4,0x20
 59e:	9742                	add	a4,a4,a6
 5a0:	00074703          	lbu	a4,0(a4)
 5a4:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5a8:	872e                	mv	a4,a1
 5aa:	02c5d5bb          	divuw	a1,a1,a2
 5ae:	0685                	addi	a3,a3,1
 5b0:	fcc77fe3          	bgeu	a4,a2,58e <printint+0x28>
  if(neg)
 5b4:	000e0c63          	beqz	t3,5cc <printint+0x66>
    buf[i++] = '-';
 5b8:	fd050793          	addi	a5,a0,-48
 5bc:	00878533          	add	a0,a5,s0
 5c0:	02d00793          	li	a5,45
 5c4:	fef50823          	sb	a5,-16(a0)
 5c8:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 5cc:	fff7899b          	addiw	s3,a5,-1
 5d0:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 5d4:	fff4c583          	lbu	a1,-1(s1)
 5d8:	854a                	mv	a0,s2
 5da:	f6fff0ef          	jal	548 <putc>
  while(--i >= 0)
 5de:	39fd                	addiw	s3,s3,-1
 5e0:	14fd                	addi	s1,s1,-1
 5e2:	fe09d9e3          	bgez	s3,5d4 <printint+0x6e>
}
 5e6:	70e2                	ld	ra,56(sp)
 5e8:	7442                	ld	s0,48(sp)
 5ea:	74a2                	ld	s1,40(sp)
 5ec:	7902                	ld	s2,32(sp)
 5ee:	69e2                	ld	s3,24(sp)
 5f0:	6121                	addi	sp,sp,64
 5f2:	8082                	ret
    x = -xx;
 5f4:	40b005bb          	negw	a1,a1
    neg = 1;
 5f8:	4e05                	li	t3,1
    x = -xx;
 5fa:	b751                	j	57e <printint+0x18>

00000000000005fc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5fc:	711d                	addi	sp,sp,-96
 5fe:	ec86                	sd	ra,88(sp)
 600:	e8a2                	sd	s0,80(sp)
 602:	e4a6                	sd	s1,72(sp)
 604:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 606:	0005c483          	lbu	s1,0(a1)
 60a:	26048663          	beqz	s1,876 <vprintf+0x27a>
 60e:	e0ca                	sd	s2,64(sp)
 610:	fc4e                	sd	s3,56(sp)
 612:	f852                	sd	s4,48(sp)
 614:	f456                	sd	s5,40(sp)
 616:	f05a                	sd	s6,32(sp)
 618:	ec5e                	sd	s7,24(sp)
 61a:	e862                	sd	s8,16(sp)
 61c:	e466                	sd	s9,8(sp)
 61e:	8b2a                	mv	s6,a0
 620:	8a2e                	mv	s4,a1
 622:	8bb2                	mv	s7,a2
  state = 0;
 624:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 626:	4901                	li	s2,0
 628:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 62a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 62e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 632:	06c00c93          	li	s9,108
 636:	a00d                	j	658 <vprintf+0x5c>
        putc(fd, c0);
 638:	85a6                	mv	a1,s1
 63a:	855a                	mv	a0,s6
 63c:	f0dff0ef          	jal	548 <putc>
 640:	a019                	j	646 <vprintf+0x4a>
    } else if(state == '%'){
 642:	03598363          	beq	s3,s5,668 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 646:	0019079b          	addiw	a5,s2,1
 64a:	893e                	mv	s2,a5
 64c:	873e                	mv	a4,a5
 64e:	97d2                	add	a5,a5,s4
 650:	0007c483          	lbu	s1,0(a5)
 654:	20048963          	beqz	s1,866 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 658:	0004879b          	sext.w	a5,s1
    if(state == 0){
 65c:	fe0993e3          	bnez	s3,642 <vprintf+0x46>
      if(c0 == '%'){
 660:	fd579ce3          	bne	a5,s5,638 <vprintf+0x3c>
        state = '%';
 664:	89be                	mv	s3,a5
 666:	b7c5                	j	646 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 668:	00ea06b3          	add	a3,s4,a4
 66c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 670:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 672:	c681                	beqz	a3,67a <vprintf+0x7e>
 674:	9752                	add	a4,a4,s4
 676:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 67a:	03878e63          	beq	a5,s8,6b6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 67e:	05978863          	beq	a5,s9,6ce <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 682:	07500713          	li	a4,117
 686:	0ee78263          	beq	a5,a4,76a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 68a:	07800713          	li	a4,120
 68e:	12e78463          	beq	a5,a4,7b6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 692:	07000713          	li	a4,112
 696:	14e78963          	beq	a5,a4,7e8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 69a:	07300713          	li	a4,115
 69e:	18e78863          	beq	a5,a4,82e <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6a2:	02500713          	li	a4,37
 6a6:	04e79463          	bne	a5,a4,6ee <vprintf+0xf2>
        putc(fd, '%');
 6aa:	85ba                	mv	a1,a4
 6ac:	855a                	mv	a0,s6
 6ae:	e9bff0ef          	jal	548 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	bf49                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6b6:	008b8493          	addi	s1,s7,8
 6ba:	4685                	li	a3,1
 6bc:	4629                	li	a2,10
 6be:	000ba583          	lw	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	ea3ff0ef          	jal	566 <printint>
 6c8:	8ba6                	mv	s7,s1
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bfad                	j	646 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6ce:	06400793          	li	a5,100
 6d2:	02f68963          	beq	a3,a5,704 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d6:	06c00793          	li	a5,108
 6da:	04f68263          	beq	a3,a5,71e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6de:	07500793          	li	a5,117
 6e2:	0af68063          	beq	a3,a5,782 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6e6:	07800793          	li	a5,120
 6ea:	0ef68263          	beq	a3,a5,7ce <vprintf+0x1d2>
        putc(fd, '%');
 6ee:	02500593          	li	a1,37
 6f2:	855a                	mv	a0,s6
 6f4:	e55ff0ef          	jal	548 <putc>
        putc(fd, c0);
 6f8:	85a6                	mv	a1,s1
 6fa:	855a                	mv	a0,s6
 6fc:	e4dff0ef          	jal	548 <putc>
      state = 0;
 700:	4981                	li	s3,0
 702:	b791                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 704:	008b8493          	addi	s1,s7,8
 708:	4685                	li	a3,1
 70a:	4629                	li	a2,10
 70c:	000ba583          	lw	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	e55ff0ef          	jal	566 <printint>
        i += 1;
 716:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 718:	8ba6                	mv	s7,s1
      state = 0;
 71a:	4981                	li	s3,0
        i += 1;
 71c:	b72d                	j	646 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 71e:	06400793          	li	a5,100
 722:	02f60763          	beq	a2,a5,750 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 726:	07500793          	li	a5,117
 72a:	06f60963          	beq	a2,a5,79c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 72e:	07800793          	li	a5,120
 732:	faf61ee3          	bne	a2,a5,6ee <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 736:	008b8493          	addi	s1,s7,8
 73a:	4681                	li	a3,0
 73c:	4641                	li	a2,16
 73e:	000ba583          	lw	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	e23ff0ef          	jal	566 <printint>
        i += 2;
 748:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 74a:	8ba6                	mv	s7,s1
      state = 0;
 74c:	4981                	li	s3,0
        i += 2;
 74e:	bde5                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 750:	008b8493          	addi	s1,s7,8
 754:	4685                	li	a3,1
 756:	4629                	li	a2,10
 758:	000ba583          	lw	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	e09ff0ef          	jal	566 <printint>
        i += 2;
 762:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 764:	8ba6                	mv	s7,s1
      state = 0;
 766:	4981                	li	s3,0
        i += 2;
 768:	bdf9                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 76a:	008b8493          	addi	s1,s7,8
 76e:	4681                	li	a3,0
 770:	4629                	li	a2,10
 772:	000ba583          	lw	a1,0(s7)
 776:	855a                	mv	a0,s6
 778:	defff0ef          	jal	566 <printint>
 77c:	8ba6                	mv	s7,s1
      state = 0;
 77e:	4981                	li	s3,0
 780:	b5d9                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 782:	008b8493          	addi	s1,s7,8
 786:	4681                	li	a3,0
 788:	4629                	li	a2,10
 78a:	000ba583          	lw	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	dd7ff0ef          	jal	566 <printint>
        i += 1;
 794:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 796:	8ba6                	mv	s7,s1
      state = 0;
 798:	4981                	li	s3,0
        i += 1;
 79a:	b575                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 79c:	008b8493          	addi	s1,s7,8
 7a0:	4681                	li	a3,0
 7a2:	4629                	li	a2,10
 7a4:	000ba583          	lw	a1,0(s7)
 7a8:	855a                	mv	a0,s6
 7aa:	dbdff0ef          	jal	566 <printint>
        i += 2;
 7ae:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b0:	8ba6                	mv	s7,s1
      state = 0;
 7b2:	4981                	li	s3,0
        i += 2;
 7b4:	bd49                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7b6:	008b8493          	addi	s1,s7,8
 7ba:	4681                	li	a3,0
 7bc:	4641                	li	a2,16
 7be:	000ba583          	lw	a1,0(s7)
 7c2:	855a                	mv	a0,s6
 7c4:	da3ff0ef          	jal	566 <printint>
 7c8:	8ba6                	mv	s7,s1
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	bdad                	j	646 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ce:	008b8493          	addi	s1,s7,8
 7d2:	4681                	li	a3,0
 7d4:	4641                	li	a2,16
 7d6:	000ba583          	lw	a1,0(s7)
 7da:	855a                	mv	a0,s6
 7dc:	d8bff0ef          	jal	566 <printint>
        i += 1;
 7e0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e2:	8ba6                	mv	s7,s1
      state = 0;
 7e4:	4981                	li	s3,0
        i += 1;
 7e6:	b585                	j	646 <vprintf+0x4a>
 7e8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7ea:	008b8d13          	addi	s10,s7,8
 7ee:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7f2:	03000593          	li	a1,48
 7f6:	855a                	mv	a0,s6
 7f8:	d51ff0ef          	jal	548 <putc>
  putc(fd, 'x');
 7fc:	07800593          	li	a1,120
 800:	855a                	mv	a0,s6
 802:	d47ff0ef          	jal	548 <putc>
 806:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 808:	00000b97          	auipc	s7,0x0
 80c:	3b0b8b93          	addi	s7,s7,944 # bb8 <digits>
 810:	03c9d793          	srli	a5,s3,0x3c
 814:	97de                	add	a5,a5,s7
 816:	0007c583          	lbu	a1,0(a5)
 81a:	855a                	mv	a0,s6
 81c:	d2dff0ef          	jal	548 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 820:	0992                	slli	s3,s3,0x4
 822:	34fd                	addiw	s1,s1,-1
 824:	f4f5                	bnez	s1,810 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 826:	8bea                	mv	s7,s10
      state = 0;
 828:	4981                	li	s3,0
 82a:	6d02                	ld	s10,0(sp)
 82c:	bd29                	j	646 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 82e:	008b8993          	addi	s3,s7,8
 832:	000bb483          	ld	s1,0(s7)
 836:	cc91                	beqz	s1,852 <vprintf+0x256>
        for(; *s; s++)
 838:	0004c583          	lbu	a1,0(s1)
 83c:	c195                	beqz	a1,860 <vprintf+0x264>
          putc(fd, *s);
 83e:	855a                	mv	a0,s6
 840:	d09ff0ef          	jal	548 <putc>
        for(; *s; s++)
 844:	0485                	addi	s1,s1,1
 846:	0004c583          	lbu	a1,0(s1)
 84a:	f9f5                	bnez	a1,83e <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 84c:	8bce                	mv	s7,s3
      state = 0;
 84e:	4981                	li	s3,0
 850:	bbdd                	j	646 <vprintf+0x4a>
          s = "(null)";
 852:	00000497          	auipc	s1,0x0
 856:	35e48493          	addi	s1,s1,862 # bb0 <malloc+0x24e>
        for(; *s; s++)
 85a:	02800593          	li	a1,40
 85e:	b7c5                	j	83e <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 860:	8bce                	mv	s7,s3
      state = 0;
 862:	4981                	li	s3,0
 864:	b3cd                	j	646 <vprintf+0x4a>
 866:	6906                	ld	s2,64(sp)
 868:	79e2                	ld	s3,56(sp)
 86a:	7a42                	ld	s4,48(sp)
 86c:	7aa2                	ld	s5,40(sp)
 86e:	7b02                	ld	s6,32(sp)
 870:	6be2                	ld	s7,24(sp)
 872:	6c42                	ld	s8,16(sp)
 874:	6ca2                	ld	s9,8(sp)
    }
  }
}
 876:	60e6                	ld	ra,88(sp)
 878:	6446                	ld	s0,80(sp)
 87a:	64a6                	ld	s1,72(sp)
 87c:	6125                	addi	sp,sp,96
 87e:	8082                	ret

0000000000000880 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 880:	715d                	addi	sp,sp,-80
 882:	ec06                	sd	ra,24(sp)
 884:	e822                	sd	s0,16(sp)
 886:	1000                	addi	s0,sp,32
 888:	e010                	sd	a2,0(s0)
 88a:	e414                	sd	a3,8(s0)
 88c:	e818                	sd	a4,16(s0)
 88e:	ec1c                	sd	a5,24(s0)
 890:	03043023          	sd	a6,32(s0)
 894:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 898:	8622                	mv	a2,s0
 89a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 89e:	d5fff0ef          	jal	5fc <vprintf>
}
 8a2:	60e2                	ld	ra,24(sp)
 8a4:	6442                	ld	s0,16(sp)
 8a6:	6161                	addi	sp,sp,80
 8a8:	8082                	ret

00000000000008aa <printf>:

void
printf(const char *fmt, ...)
{
 8aa:	711d                	addi	sp,sp,-96
 8ac:	ec06                	sd	ra,24(sp)
 8ae:	e822                	sd	s0,16(sp)
 8b0:	1000                	addi	s0,sp,32
 8b2:	e40c                	sd	a1,8(s0)
 8b4:	e810                	sd	a2,16(s0)
 8b6:	ec14                	sd	a3,24(s0)
 8b8:	f018                	sd	a4,32(s0)
 8ba:	f41c                	sd	a5,40(s0)
 8bc:	03043823          	sd	a6,48(s0)
 8c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8c4:	00840613          	addi	a2,s0,8
 8c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8cc:	85aa                	mv	a1,a0
 8ce:	4505                	li	a0,1
 8d0:	d2dff0ef          	jal	5fc <vprintf>
}
 8d4:	60e2                	ld	ra,24(sp)
 8d6:	6442                	ld	s0,16(sp)
 8d8:	6125                	addi	sp,sp,96
 8da:	8082                	ret

00000000000008dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8dc:	1141                	addi	sp,sp,-16
 8de:	e406                	sd	ra,8(sp)
 8e0:	e022                	sd	s0,0(sp)
 8e2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8e4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e8:	00001797          	auipc	a5,0x1
 8ec:	7187b783          	ld	a5,1816(a5) # 2000 <freep>
 8f0:	a02d                	j	91a <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8f2:	4618                	lw	a4,8(a2)
 8f4:	9f2d                	addw	a4,a4,a1
 8f6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8fa:	6398                	ld	a4,0(a5)
 8fc:	6310                	ld	a2,0(a4)
 8fe:	a83d                	j	93c <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 900:	ff852703          	lw	a4,-8(a0)
 904:	9f31                	addw	a4,a4,a2
 906:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 908:	ff053683          	ld	a3,-16(a0)
 90c:	a091                	j	950 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 90e:	6398                	ld	a4,0(a5)
 910:	00e7e463          	bltu	a5,a4,918 <free+0x3c>
 914:	00e6ea63          	bltu	a3,a4,928 <free+0x4c>
{
 918:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91a:	fed7fae3          	bgeu	a5,a3,90e <free+0x32>
 91e:	6398                	ld	a4,0(a5)
 920:	00e6e463          	bltu	a3,a4,928 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 924:	fee7eae3          	bltu	a5,a4,918 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 928:	ff852583          	lw	a1,-8(a0)
 92c:	6390                	ld	a2,0(a5)
 92e:	02059813          	slli	a6,a1,0x20
 932:	01c85713          	srli	a4,a6,0x1c
 936:	9736                	add	a4,a4,a3
 938:	fae60de3          	beq	a2,a4,8f2 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 93c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 940:	4790                	lw	a2,8(a5)
 942:	02061593          	slli	a1,a2,0x20
 946:	01c5d713          	srli	a4,a1,0x1c
 94a:	973e                	add	a4,a4,a5
 94c:	fae68ae3          	beq	a3,a4,900 <free+0x24>
    p->s.ptr = bp->s.ptr;
 950:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 952:	00001717          	auipc	a4,0x1
 956:	6af73723          	sd	a5,1710(a4) # 2000 <freep>
}
 95a:	60a2                	ld	ra,8(sp)
 95c:	6402                	ld	s0,0(sp)
 95e:	0141                	addi	sp,sp,16
 960:	8082                	ret

0000000000000962 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 962:	7139                	addi	sp,sp,-64
 964:	fc06                	sd	ra,56(sp)
 966:	f822                	sd	s0,48(sp)
 968:	f04a                	sd	s2,32(sp)
 96a:	ec4e                	sd	s3,24(sp)
 96c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 96e:	02051993          	slli	s3,a0,0x20
 972:	0209d993          	srli	s3,s3,0x20
 976:	09bd                	addi	s3,s3,15
 978:	0049d993          	srli	s3,s3,0x4
 97c:	2985                	addiw	s3,s3,1
 97e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 980:	00001517          	auipc	a0,0x1
 984:	68053503          	ld	a0,1664(a0) # 2000 <freep>
 988:	c905                	beqz	a0,9b8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98c:	4798                	lw	a4,8(a5)
 98e:	09377663          	bgeu	a4,s3,a1a <malloc+0xb8>
 992:	f426                	sd	s1,40(sp)
 994:	e852                	sd	s4,16(sp)
 996:	e456                	sd	s5,8(sp)
 998:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 99a:	8a4e                	mv	s4,s3
 99c:	6705                	lui	a4,0x1
 99e:	00e9f363          	bgeu	s3,a4,9a4 <malloc+0x42>
 9a2:	6a05                	lui	s4,0x1
 9a4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9a8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9ac:	00001497          	auipc	s1,0x1
 9b0:	65448493          	addi	s1,s1,1620 # 2000 <freep>
  if(p == (char*)-1)
 9b4:	5afd                	li	s5,-1
 9b6:	a83d                	j	9f4 <malloc+0x92>
 9b8:	f426                	sd	s1,40(sp)
 9ba:	e852                	sd	s4,16(sp)
 9bc:	e456                	sd	s5,8(sp)
 9be:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9c0:	00001797          	auipc	a5,0x1
 9c4:	65078793          	addi	a5,a5,1616 # 2010 <base>
 9c8:	00001717          	auipc	a4,0x1
 9cc:	62f73c23          	sd	a5,1592(a4) # 2000 <freep>
 9d0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9d2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9d6:	b7d1                	j	99a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9d8:	6398                	ld	a4,0(a5)
 9da:	e118                	sd	a4,0(a0)
 9dc:	a899                	j	a32 <malloc+0xd0>
  hp->s.size = nu;
 9de:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9e2:	0541                	addi	a0,a0,16
 9e4:	ef9ff0ef          	jal	8dc <free>
  return freep;
 9e8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9ea:	c125                	beqz	a0,a4a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ee:	4798                	lw	a4,8(a5)
 9f0:	03277163          	bgeu	a4,s2,a12 <malloc+0xb0>
    if(p == freep)
 9f4:	6098                	ld	a4,0(s1)
 9f6:	853e                	mv	a0,a5
 9f8:	fef71ae3          	bne	a4,a5,9ec <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9fc:	8552                	mv	a0,s4
 9fe:	af3ff0ef          	jal	4f0 <sbrk>
  if(p == (char*)-1)
 a02:	fd551ee3          	bne	a0,s5,9de <malloc+0x7c>
        return 0;
 a06:	4501                	li	a0,0
 a08:	74a2                	ld	s1,40(sp)
 a0a:	6a42                	ld	s4,16(sp)
 a0c:	6aa2                	ld	s5,8(sp)
 a0e:	6b02                	ld	s6,0(sp)
 a10:	a03d                	j	a3e <malloc+0xdc>
 a12:	74a2                	ld	s1,40(sp)
 a14:	6a42                	ld	s4,16(sp)
 a16:	6aa2                	ld	s5,8(sp)
 a18:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a1a:	fae90fe3          	beq	s2,a4,9d8 <malloc+0x76>
        p->s.size -= nunits;
 a1e:	4137073b          	subw	a4,a4,s3
 a22:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a24:	02071693          	slli	a3,a4,0x20
 a28:	01c6d713          	srli	a4,a3,0x1c
 a2c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a2e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a32:	00001717          	auipc	a4,0x1
 a36:	5ca73723          	sd	a0,1486(a4) # 2000 <freep>
      return (void*)(p + 1);
 a3a:	01078513          	addi	a0,a5,16
  }
}
 a3e:	70e2                	ld	ra,56(sp)
 a40:	7442                	ld	s0,48(sp)
 a42:	7902                	ld	s2,32(sp)
 a44:	69e2                	ld	s3,24(sp)
 a46:	6121                	addi	sp,sp,64
 a48:	8082                	ret
 a4a:	74a2                	ld	s1,40(sp)
 a4c:	6a42                	ld	s4,16(sp)
 a4e:	6aa2                	ld	s5,8(sp)
 a50:	6b02                	ld	s6,0(sp)
 a52:	b7f5                	j	a3e <malloc+0xdc>
