
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  14:	4785                	li	a5,1
  16:	06a7d063          	bge	a5,a0,76 <main+0x76>
  1a:	00858493          	addi	s1,a1,8
  1e:	3579                	addiw	a0,a0,-2
  20:	02051793          	slli	a5,a0,0x20
  24:	01d7d513          	srli	a0,a5,0x1d
  28:	00a48ab3          	add	s5,s1,a0
  2c:	05c1                	addi	a1,a1,16
  2e:	00a58a33          	add	s4,a1,a0
    write(1, argv[i], strlen(argv[i]));
  32:	4985                	li	s3,1
    if(i + 1 < argc){
      write(1, " ", 1);
  34:	00001b17          	auipc	s6,0x1
  38:	8dcb0b13          	addi	s6,s6,-1828 # 910 <malloc+0xfc>
  3c:	a809                	j	4e <main+0x4e>
  3e:	864e                	mv	a2,s3
  40:	85da                	mv	a1,s6
  42:	854e                	mv	a0,s3
  44:	2f6000ef          	jal	33a <write>
  for(i = 1; i < argc; i++){
  48:	04a1                	addi	s1,s1,8
  4a:	03448663          	beq	s1,s4,76 <main+0x76>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	08a000ef          	jal	de <strlen>
  58:	862a                	mv	a2,a0
  5a:	85ca                	mv	a1,s2
  5c:	854e                	mv	a0,s3
  5e:	2dc000ef          	jal	33a <write>
    if(i + 1 < argc){
  62:	fd549ee3          	bne	s1,s5,3e <main+0x3e>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	8b058593          	addi	a1,a1,-1872 # 918 <malloc+0x104>
  70:	8532                	mv	a0,a2
  72:	2c8000ef          	jal	33a <write>
    }
  }
  exit(0);
  76:	4501                	li	a0,0
  78:	2a2000ef          	jal	31a <exit>

000000000000007c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e406                	sd	ra,8(sp)
  80:	e022                	sd	s0,0(sp)
  82:	0800                	addi	s0,sp,16
  extern int main();
  main();
  84:	f7dff0ef          	jal	0 <main>
  exit(0);
  88:	4501                	li	a0,0
  8a:	290000ef          	jal	31a <exit>

000000000000008e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  96:	87aa                	mv	a5,a0
  98:	0585                	addi	a1,a1,1
  9a:	0785                	addi	a5,a5,1
  9c:	fff5c703          	lbu	a4,-1(a1)
  a0:	fee78fa3          	sb	a4,-1(a5)
  a4:	fb75                	bnez	a4,98 <strcpy+0xa>
    ;
  return os;
}
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cb91                	beqz	a5,ce <strcmp+0x20>
  bc:	0005c703          	lbu	a4,0(a1)
  c0:	00f71763          	bne	a4,a5,ce <strcmp+0x20>
    p++, q++;
  c4:	0505                	addi	a0,a0,1
  c6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	fbe5                	bnez	a5,bc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ce:	0005c503          	lbu	a0,0(a1)
}
  d2:	40a7853b          	subw	a0,a5,a0
  d6:	60a2                	ld	ra,8(sp)
  d8:	6402                	ld	s0,0(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret

00000000000000de <strlen>:

uint
strlen(const char *s)
{
  de:	1141                	addi	sp,sp,-16
  e0:	e406                	sd	ra,8(sp)
  e2:	e022                	sd	s0,0(sp)
  e4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e6:	00054783          	lbu	a5,0(a0)
  ea:	cf99                	beqz	a5,108 <strlen+0x2a>
  ec:	0505                	addi	a0,a0,1
  ee:	87aa                	mv	a5,a0
  f0:	86be                	mv	a3,a5
  f2:	0785                	addi	a5,a5,1
  f4:	fff7c703          	lbu	a4,-1(a5)
  f8:	ff65                	bnez	a4,f0 <strlen+0x12>
  fa:	40a6853b          	subw	a0,a3,a0
  fe:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 100:	60a2                	ld	ra,8(sp)
 102:	6402                	ld	s0,0(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret
  for(n = 0; s[n]; n++)
 108:	4501                	li	a0,0
 10a:	bfdd                	j	100 <strlen+0x22>

000000000000010c <memset>:

void*
memset(void *dst, int c, uint n)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 114:	ca19                	beqz	a2,12a <memset+0x1e>
 116:	87aa                	mv	a5,a0
 118:	1602                	slli	a2,a2,0x20
 11a:	9201                	srli	a2,a2,0x20
 11c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 120:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 124:	0785                	addi	a5,a5,1
 126:	fee79de3          	bne	a5,a4,120 <memset+0x14>
  }
  return dst;
}
 12a:	60a2                	ld	ra,8(sp)
 12c:	6402                	ld	s0,0(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strchr>:

char*
strchr(const char *s, char c)
{
 132:	1141                	addi	sp,sp,-16
 134:	e406                	sd	ra,8(sp)
 136:	e022                	sd	s0,0(sp)
 138:	0800                	addi	s0,sp,16
  for(; *s; s++)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cf81                	beqz	a5,156 <strchr+0x24>
    if(*s == c)
 140:	00f58763          	beq	a1,a5,14e <strchr+0x1c>
  for(; *s; s++)
 144:	0505                	addi	a0,a0,1
 146:	00054783          	lbu	a5,0(a0)
 14a:	fbfd                	bnez	a5,140 <strchr+0xe>
      return (char*)s;
  return 0;
 14c:	4501                	li	a0,0
}
 14e:	60a2                	ld	ra,8(sp)
 150:	6402                	ld	s0,0(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret
  return 0;
 156:	4501                	li	a0,0
 158:	bfdd                	j	14e <strchr+0x1c>

000000000000015a <gets>:

char*
gets(char *buf, int max)
{
 15a:	7159                	addi	sp,sp,-112
 15c:	f486                	sd	ra,104(sp)
 15e:	f0a2                	sd	s0,96(sp)
 160:	eca6                	sd	s1,88(sp)
 162:	e8ca                	sd	s2,80(sp)
 164:	e4ce                	sd	s3,72(sp)
 166:	e0d2                	sd	s4,64(sp)
 168:	fc56                	sd	s5,56(sp)
 16a:	f85a                	sd	s6,48(sp)
 16c:	f45e                	sd	s7,40(sp)
 16e:	f062                	sd	s8,32(sp)
 170:	ec66                	sd	s9,24(sp)
 172:	e86a                	sd	s10,16(sp)
 174:	1880                	addi	s0,sp,112
 176:	8caa                	mv	s9,a0
 178:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17a:	892a                	mv	s2,a0
 17c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 17e:	f9f40b13          	addi	s6,s0,-97
 182:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 184:	4ba9                	li	s7,10
 186:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 188:	8d26                	mv	s10,s1
 18a:	0014899b          	addiw	s3,s1,1
 18e:	84ce                	mv	s1,s3
 190:	0349d563          	bge	s3,s4,1ba <gets+0x60>
    cc = read(0, &c, 1);
 194:	8656                	mv	a2,s5
 196:	85da                	mv	a1,s6
 198:	4501                	li	a0,0
 19a:	198000ef          	jal	332 <read>
    if(cc < 1)
 19e:	00a05e63          	blez	a0,1ba <gets+0x60>
    buf[i++] = c;
 1a2:	f9f44783          	lbu	a5,-97(s0)
 1a6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1aa:	01778763          	beq	a5,s7,1b8 <gets+0x5e>
 1ae:	0905                	addi	s2,s2,1
 1b0:	fd879ce3          	bne	a5,s8,188 <gets+0x2e>
    buf[i++] = c;
 1b4:	8d4e                	mv	s10,s3
 1b6:	a011                	j	1ba <gets+0x60>
 1b8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1ba:	9d66                	add	s10,s10,s9
 1bc:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1c0:	8566                	mv	a0,s9
 1c2:	70a6                	ld	ra,104(sp)
 1c4:	7406                	ld	s0,96(sp)
 1c6:	64e6                	ld	s1,88(sp)
 1c8:	6946                	ld	s2,80(sp)
 1ca:	69a6                	ld	s3,72(sp)
 1cc:	6a06                	ld	s4,64(sp)
 1ce:	7ae2                	ld	s5,56(sp)
 1d0:	7b42                	ld	s6,48(sp)
 1d2:	7ba2                	ld	s7,40(sp)
 1d4:	7c02                	ld	s8,32(sp)
 1d6:	6ce2                	ld	s9,24(sp)
 1d8:	6d42                	ld	s10,16(sp)
 1da:	6165                	addi	sp,sp,112
 1dc:	8082                	ret

00000000000001de <stat>:

int
stat(const char *n, struct stat *st)
{
 1de:	1101                	addi	sp,sp,-32
 1e0:	ec06                	sd	ra,24(sp)
 1e2:	e822                	sd	s0,16(sp)
 1e4:	e04a                	sd	s2,0(sp)
 1e6:	1000                	addi	s0,sp,32
 1e8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ea:	4581                	li	a1,0
 1ec:	16e000ef          	jal	35a <open>
  if(fd < 0)
 1f0:	02054263          	bltz	a0,214 <stat+0x36>
 1f4:	e426                	sd	s1,8(sp)
 1f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f8:	85ca                	mv	a1,s2
 1fa:	178000ef          	jal	372 <fstat>
 1fe:	892a                	mv	s2,a0
  close(fd);
 200:	8526                	mv	a0,s1
 202:	140000ef          	jal	342 <close>
  return r;
 206:	64a2                	ld	s1,8(sp)
}
 208:	854a                	mv	a0,s2
 20a:	60e2                	ld	ra,24(sp)
 20c:	6442                	ld	s0,16(sp)
 20e:	6902                	ld	s2,0(sp)
 210:	6105                	addi	sp,sp,32
 212:	8082                	ret
    return -1;
 214:	597d                	li	s2,-1
 216:	bfcd                	j	208 <stat+0x2a>

0000000000000218 <atoi>:

int
atoi(const char *s)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e406                	sd	ra,8(sp)
 21c:	e022                	sd	s0,0(sp)
 21e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 220:	00054683          	lbu	a3,0(a0)
 224:	fd06879b          	addiw	a5,a3,-48
 228:	0ff7f793          	zext.b	a5,a5
 22c:	4625                	li	a2,9
 22e:	02f66963          	bltu	a2,a5,260 <atoi+0x48>
 232:	872a                	mv	a4,a0
  n = 0;
 234:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 236:	0705                	addi	a4,a4,1
 238:	0025179b          	slliw	a5,a0,0x2
 23c:	9fa9                	addw	a5,a5,a0
 23e:	0017979b          	slliw	a5,a5,0x1
 242:	9fb5                	addw	a5,a5,a3
 244:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 248:	00074683          	lbu	a3,0(a4)
 24c:	fd06879b          	addiw	a5,a3,-48
 250:	0ff7f793          	zext.b	a5,a5
 254:	fef671e3          	bgeu	a2,a5,236 <atoi+0x1e>
  return n;
}
 258:	60a2                	ld	ra,8(sp)
 25a:	6402                	ld	s0,0(sp)
 25c:	0141                	addi	sp,sp,16
 25e:	8082                	ret
  n = 0;
 260:	4501                	li	a0,0
 262:	bfdd                	j	258 <atoi+0x40>

0000000000000264 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 264:	1141                	addi	sp,sp,-16
 266:	e406                	sd	ra,8(sp)
 268:	e022                	sd	s0,0(sp)
 26a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 26c:	02b57563          	bgeu	a0,a1,296 <memmove+0x32>
    while(n-- > 0)
 270:	00c05f63          	blez	a2,28e <memmove+0x2a>
 274:	1602                	slli	a2,a2,0x20
 276:	9201                	srli	a2,a2,0x20
 278:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 27c:	872a                	mv	a4,a0
      *dst++ = *src++;
 27e:	0585                	addi	a1,a1,1
 280:	0705                	addi	a4,a4,1
 282:	fff5c683          	lbu	a3,-1(a1)
 286:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 28a:	fee79ae3          	bne	a5,a4,27e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28e:	60a2                	ld	ra,8(sp)
 290:	6402                	ld	s0,0(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret
    dst += n;
 296:	00c50733          	add	a4,a0,a2
    src += n;
 29a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 29c:	fec059e3          	blez	a2,28e <memmove+0x2a>
 2a0:	fff6079b          	addiw	a5,a2,-1
 2a4:	1782                	slli	a5,a5,0x20
 2a6:	9381                	srli	a5,a5,0x20
 2a8:	fff7c793          	not	a5,a5
 2ac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ae:	15fd                	addi	a1,a1,-1
 2b0:	177d                	addi	a4,a4,-1
 2b2:	0005c683          	lbu	a3,0(a1)
 2b6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ba:	fef71ae3          	bne	a4,a5,2ae <memmove+0x4a>
 2be:	bfc1                	j	28e <memmove+0x2a>

00000000000002c0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e406                	sd	ra,8(sp)
 2c4:	e022                	sd	s0,0(sp)
 2c6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c8:	ca0d                	beqz	a2,2fa <memcmp+0x3a>
 2ca:	fff6069b          	addiw	a3,a2,-1
 2ce:	1682                	slli	a3,a3,0x20
 2d0:	9281                	srli	a3,a3,0x20
 2d2:	0685                	addi	a3,a3,1
 2d4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	0005c703          	lbu	a4,0(a1)
 2de:	00e79863          	bne	a5,a4,2ee <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2e2:	0505                	addi	a0,a0,1
    p2++;
 2e4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e6:	fed518e3          	bne	a0,a3,2d6 <memcmp+0x16>
  }
  return 0;
 2ea:	4501                	li	a0,0
 2ec:	a019                	j	2f2 <memcmp+0x32>
      return *p1 - *p2;
 2ee:	40e7853b          	subw	a0,a5,a4
}
 2f2:	60a2                	ld	ra,8(sp)
 2f4:	6402                	ld	s0,0(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret
  return 0;
 2fa:	4501                	li	a0,0
 2fc:	bfdd                	j	2f2 <memcmp+0x32>

00000000000002fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 306:	f5fff0ef          	jal	264 <memmove>
}
 30a:	60a2                	ld	ra,8(sp)
 30c:	6402                	ld	s0,0(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret

0000000000000312 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 312:	4885                	li	a7,1
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <exit>:
.global exit
exit:
 li a7, SYS_exit
 31a:	4889                	li	a7,2
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <wait>:
.global wait
wait:
 li a7, SYS_wait
 322:	488d                	li	a7,3
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32a:	4891                	li	a7,4
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <read>:
.global read
read:
 li a7, SYS_read
 332:	4895                	li	a7,5
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <write>:
.global write
write:
 li a7, SYS_write
 33a:	48c1                	li	a7,16
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <close>:
.global close
close:
 li a7, SYS_close
 342:	48d5                	li	a7,21
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <kill>:
.global kill
kill:
 li a7, SYS_kill
 34a:	4899                	li	a7,6
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <exec>:
.global exec
exec:
 li a7, SYS_exec
 352:	489d                	li	a7,7
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <open>:
.global open
open:
 li a7, SYS_open
 35a:	48bd                	li	a7,15
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 362:	48c5                	li	a7,17
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36a:	48c9                	li	a7,18
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 372:	48a1                	li	a7,8
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <link>:
.global link
link:
 li a7, SYS_link
 37a:	48cd                	li	a7,19
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 382:	48d1                	li	a7,20
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38a:	48a5                	li	a7,9
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <dup>:
.global dup
dup:
 li a7, SYS_dup
 392:	48a9                	li	a7,10
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39a:	48ad                	li	a7,11
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3a2:	48b1                	li	a7,12
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3aa:	48b5                	li	a7,13
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b2:	48b9                	li	a7,14
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3ba:	48d9                	li	a7,22
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <getcpids>:
.global getcpids
getcpids:
 li a7, SYS_getcpids
 3c2:	48dd                	li	a7,23
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <getpaddr>:
.global getpaddr
getpaddr:
 li a7, SYS_getpaddr
 3ca:	48e1                	li	a7,24
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <gettraphistory>:
.global gettraphistory
gettraphistory:
 li a7, SYS_gettraphistory
 3d2:	48e5                	li	a7,25
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <nice>:
.global nice
nice:
 li a7, SYS_nice
 3da:	48e9                	li	a7,26
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <getruntime>:
.global getruntime
getruntime:
 li a7, SYS_getruntime
 3e2:	48ed                	li	a7,27
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <startcfs>:
.global startcfs
startcfs:
 li a7, SYS_startcfs
 3ea:	48f1                	li	a7,28
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <stopcfs>:
.global stopcfs
stopcfs:
 li a7, SYS_stopcfs
 3f2:	48f5                	li	a7,29
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3fa:	1101                	addi	sp,sp,-32
 3fc:	ec06                	sd	ra,24(sp)
 3fe:	e822                	sd	s0,16(sp)
 400:	1000                	addi	s0,sp,32
 402:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 406:	4605                	li	a2,1
 408:	fef40593          	addi	a1,s0,-17
 40c:	f2fff0ef          	jal	33a <write>
}
 410:	60e2                	ld	ra,24(sp)
 412:	6442                	ld	s0,16(sp)
 414:	6105                	addi	sp,sp,32
 416:	8082                	ret

0000000000000418 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 418:	7139                	addi	sp,sp,-64
 41a:	fc06                	sd	ra,56(sp)
 41c:	f822                	sd	s0,48(sp)
 41e:	f426                	sd	s1,40(sp)
 420:	f04a                	sd	s2,32(sp)
 422:	ec4e                	sd	s3,24(sp)
 424:	0080                	addi	s0,sp,64
 426:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 428:	c299                	beqz	a3,42e <printint+0x16>
 42a:	0605ce63          	bltz	a1,4a6 <printint+0x8e>
  neg = 0;
 42e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 430:	fc040313          	addi	t1,s0,-64
  neg = 0;
 434:	869a                	mv	a3,t1
  i = 0;
 436:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 438:	00000817          	auipc	a6,0x0
 43c:	4f080813          	addi	a6,a6,1264 # 928 <digits>
 440:	88be                	mv	a7,a5
 442:	0017851b          	addiw	a0,a5,1
 446:	87aa                	mv	a5,a0
 448:	02c5f73b          	remuw	a4,a1,a2
 44c:	1702                	slli	a4,a4,0x20
 44e:	9301                	srli	a4,a4,0x20
 450:	9742                	add	a4,a4,a6
 452:	00074703          	lbu	a4,0(a4)
 456:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 45a:	872e                	mv	a4,a1
 45c:	02c5d5bb          	divuw	a1,a1,a2
 460:	0685                	addi	a3,a3,1
 462:	fcc77fe3          	bgeu	a4,a2,440 <printint+0x28>
  if(neg)
 466:	000e0c63          	beqz	t3,47e <printint+0x66>
    buf[i++] = '-';
 46a:	fd050793          	addi	a5,a0,-48
 46e:	00878533          	add	a0,a5,s0
 472:	02d00793          	li	a5,45
 476:	fef50823          	sb	a5,-16(a0)
 47a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 47e:	fff7899b          	addiw	s3,a5,-1
 482:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 486:	fff4c583          	lbu	a1,-1(s1)
 48a:	854a                	mv	a0,s2
 48c:	f6fff0ef          	jal	3fa <putc>
  while(--i >= 0)
 490:	39fd                	addiw	s3,s3,-1
 492:	14fd                	addi	s1,s1,-1
 494:	fe09d9e3          	bgez	s3,486 <printint+0x6e>
}
 498:	70e2                	ld	ra,56(sp)
 49a:	7442                	ld	s0,48(sp)
 49c:	74a2                	ld	s1,40(sp)
 49e:	7902                	ld	s2,32(sp)
 4a0:	69e2                	ld	s3,24(sp)
 4a2:	6121                	addi	sp,sp,64
 4a4:	8082                	ret
    x = -xx;
 4a6:	40b005bb          	negw	a1,a1
    neg = 1;
 4aa:	4e05                	li	t3,1
    x = -xx;
 4ac:	b751                	j	430 <printint+0x18>

00000000000004ae <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ae:	711d                	addi	sp,sp,-96
 4b0:	ec86                	sd	ra,88(sp)
 4b2:	e8a2                	sd	s0,80(sp)
 4b4:	e4a6                	sd	s1,72(sp)
 4b6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b8:	0005c483          	lbu	s1,0(a1)
 4bc:	26048663          	beqz	s1,728 <vprintf+0x27a>
 4c0:	e0ca                	sd	s2,64(sp)
 4c2:	fc4e                	sd	s3,56(sp)
 4c4:	f852                	sd	s4,48(sp)
 4c6:	f456                	sd	s5,40(sp)
 4c8:	f05a                	sd	s6,32(sp)
 4ca:	ec5e                	sd	s7,24(sp)
 4cc:	e862                	sd	s8,16(sp)
 4ce:	e466                	sd	s9,8(sp)
 4d0:	8b2a                	mv	s6,a0
 4d2:	8a2e                	mv	s4,a1
 4d4:	8bb2                	mv	s7,a2
  state = 0;
 4d6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4d8:	4901                	li	s2,0
 4da:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4dc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4e0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4e4:	06c00c93          	li	s9,108
 4e8:	a00d                	j	50a <vprintf+0x5c>
        putc(fd, c0);
 4ea:	85a6                	mv	a1,s1
 4ec:	855a                	mv	a0,s6
 4ee:	f0dff0ef          	jal	3fa <putc>
 4f2:	a019                	j	4f8 <vprintf+0x4a>
    } else if(state == '%'){
 4f4:	03598363          	beq	s3,s5,51a <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4f8:	0019079b          	addiw	a5,s2,1
 4fc:	893e                	mv	s2,a5
 4fe:	873e                	mv	a4,a5
 500:	97d2                	add	a5,a5,s4
 502:	0007c483          	lbu	s1,0(a5)
 506:	20048963          	beqz	s1,718 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 50a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 50e:	fe0993e3          	bnez	s3,4f4 <vprintf+0x46>
      if(c0 == '%'){
 512:	fd579ce3          	bne	a5,s5,4ea <vprintf+0x3c>
        state = '%';
 516:	89be                	mv	s3,a5
 518:	b7c5                	j	4f8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 51a:	00ea06b3          	add	a3,s4,a4
 51e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 522:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 524:	c681                	beqz	a3,52c <vprintf+0x7e>
 526:	9752                	add	a4,a4,s4
 528:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 52c:	03878e63          	beq	a5,s8,568 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 530:	05978863          	beq	a5,s9,580 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 534:	07500713          	li	a4,117
 538:	0ee78263          	beq	a5,a4,61c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 53c:	07800713          	li	a4,120
 540:	12e78463          	beq	a5,a4,668 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 544:	07000713          	li	a4,112
 548:	14e78963          	beq	a5,a4,69a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 54c:	07300713          	li	a4,115
 550:	18e78863          	beq	a5,a4,6e0 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 554:	02500713          	li	a4,37
 558:	04e79463          	bne	a5,a4,5a0 <vprintf+0xf2>
        putc(fd, '%');
 55c:	85ba                	mv	a1,a4
 55e:	855a                	mv	a0,s6
 560:	e9bff0ef          	jal	3fa <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 564:	4981                	li	s3,0
 566:	bf49                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 568:	008b8493          	addi	s1,s7,8
 56c:	4685                	li	a3,1
 56e:	4629                	li	a2,10
 570:	000ba583          	lw	a1,0(s7)
 574:	855a                	mv	a0,s6
 576:	ea3ff0ef          	jal	418 <printint>
 57a:	8ba6                	mv	s7,s1
      state = 0;
 57c:	4981                	li	s3,0
 57e:	bfad                	j	4f8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 580:	06400793          	li	a5,100
 584:	02f68963          	beq	a3,a5,5b6 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 588:	06c00793          	li	a5,108
 58c:	04f68263          	beq	a3,a5,5d0 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 590:	07500793          	li	a5,117
 594:	0af68063          	beq	a3,a5,634 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 598:	07800793          	li	a5,120
 59c:	0ef68263          	beq	a3,a5,680 <vprintf+0x1d2>
        putc(fd, '%');
 5a0:	02500593          	li	a1,37
 5a4:	855a                	mv	a0,s6
 5a6:	e55ff0ef          	jal	3fa <putc>
        putc(fd, c0);
 5aa:	85a6                	mv	a1,s1
 5ac:	855a                	mv	a0,s6
 5ae:	e4dff0ef          	jal	3fa <putc>
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	b791                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b6:	008b8493          	addi	s1,s7,8
 5ba:	4685                	li	a3,1
 5bc:	4629                	li	a2,10
 5be:	000ba583          	lw	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	e55ff0ef          	jal	418 <printint>
        i += 1;
 5c8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ca:	8ba6                	mv	s7,s1
      state = 0;
 5cc:	4981                	li	s3,0
        i += 1;
 5ce:	b72d                	j	4f8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d0:	06400793          	li	a5,100
 5d4:	02f60763          	beq	a2,a5,602 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5d8:	07500793          	li	a5,117
 5dc:	06f60963          	beq	a2,a5,64e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5e0:	07800793          	li	a5,120
 5e4:	faf61ee3          	bne	a2,a5,5a0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e8:	008b8493          	addi	s1,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4641                	li	a2,16
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	e23ff0ef          	jal	418 <printint>
        i += 2;
 5fa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fc:	8ba6                	mv	s7,s1
      state = 0;
 5fe:	4981                	li	s3,0
        i += 2;
 600:	bde5                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 602:	008b8493          	addi	s1,s7,8
 606:	4685                	li	a3,1
 608:	4629                	li	a2,10
 60a:	000ba583          	lw	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	e09ff0ef          	jal	418 <printint>
        i += 2;
 614:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 616:	8ba6                	mv	s7,s1
      state = 0;
 618:	4981                	li	s3,0
        i += 2;
 61a:	bdf9                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 61c:	008b8493          	addi	s1,s7,8
 620:	4681                	li	a3,0
 622:	4629                	li	a2,10
 624:	000ba583          	lw	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	defff0ef          	jal	418 <printint>
 62e:	8ba6                	mv	s7,s1
      state = 0;
 630:	4981                	li	s3,0
 632:	b5d9                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 634:	008b8493          	addi	s1,s7,8
 638:	4681                	li	a3,0
 63a:	4629                	li	a2,10
 63c:	000ba583          	lw	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	dd7ff0ef          	jal	418 <printint>
        i += 1;
 646:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 648:	8ba6                	mv	s7,s1
      state = 0;
 64a:	4981                	li	s3,0
        i += 1;
 64c:	b575                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 64e:	008b8493          	addi	s1,s7,8
 652:	4681                	li	a3,0
 654:	4629                	li	a2,10
 656:	000ba583          	lw	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	dbdff0ef          	jal	418 <printint>
        i += 2;
 660:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 662:	8ba6                	mv	s7,s1
      state = 0;
 664:	4981                	li	s3,0
        i += 2;
 666:	bd49                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 668:	008b8493          	addi	s1,s7,8
 66c:	4681                	li	a3,0
 66e:	4641                	li	a2,16
 670:	000ba583          	lw	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	da3ff0ef          	jal	418 <printint>
 67a:	8ba6                	mv	s7,s1
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bdad                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 680:	008b8493          	addi	s1,s7,8
 684:	4681                	li	a3,0
 686:	4641                	li	a2,16
 688:	000ba583          	lw	a1,0(s7)
 68c:	855a                	mv	a0,s6
 68e:	d8bff0ef          	jal	418 <printint>
        i += 1;
 692:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 694:	8ba6                	mv	s7,s1
      state = 0;
 696:	4981                	li	s3,0
        i += 1;
 698:	b585                	j	4f8 <vprintf+0x4a>
 69a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 69c:	008b8d13          	addi	s10,s7,8
 6a0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6a4:	03000593          	li	a1,48
 6a8:	855a                	mv	a0,s6
 6aa:	d51ff0ef          	jal	3fa <putc>
  putc(fd, 'x');
 6ae:	07800593          	li	a1,120
 6b2:	855a                	mv	a0,s6
 6b4:	d47ff0ef          	jal	3fa <putc>
 6b8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ba:	00000b97          	auipc	s7,0x0
 6be:	26eb8b93          	addi	s7,s7,622 # 928 <digits>
 6c2:	03c9d793          	srli	a5,s3,0x3c
 6c6:	97de                	add	a5,a5,s7
 6c8:	0007c583          	lbu	a1,0(a5)
 6cc:	855a                	mv	a0,s6
 6ce:	d2dff0ef          	jal	3fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d2:	0992                	slli	s3,s3,0x4
 6d4:	34fd                	addiw	s1,s1,-1
 6d6:	f4f5                	bnez	s1,6c2 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6d8:	8bea                	mv	s7,s10
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	6d02                	ld	s10,0(sp)
 6de:	bd29                	j	4f8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6e0:	008b8993          	addi	s3,s7,8
 6e4:	000bb483          	ld	s1,0(s7)
 6e8:	cc91                	beqz	s1,704 <vprintf+0x256>
        for(; *s; s++)
 6ea:	0004c583          	lbu	a1,0(s1)
 6ee:	c195                	beqz	a1,712 <vprintf+0x264>
          putc(fd, *s);
 6f0:	855a                	mv	a0,s6
 6f2:	d09ff0ef          	jal	3fa <putc>
        for(; *s; s++)
 6f6:	0485                	addi	s1,s1,1
 6f8:	0004c583          	lbu	a1,0(s1)
 6fc:	f9f5                	bnez	a1,6f0 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6fe:	8bce                	mv	s7,s3
      state = 0;
 700:	4981                	li	s3,0
 702:	bbdd                	j	4f8 <vprintf+0x4a>
          s = "(null)";
 704:	00000497          	auipc	s1,0x0
 708:	21c48493          	addi	s1,s1,540 # 920 <malloc+0x10c>
        for(; *s; s++)
 70c:	02800593          	li	a1,40
 710:	b7c5                	j	6f0 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 712:	8bce                	mv	s7,s3
      state = 0;
 714:	4981                	li	s3,0
 716:	b3cd                	j	4f8 <vprintf+0x4a>
 718:	6906                	ld	s2,64(sp)
 71a:	79e2                	ld	s3,56(sp)
 71c:	7a42                	ld	s4,48(sp)
 71e:	7aa2                	ld	s5,40(sp)
 720:	7b02                	ld	s6,32(sp)
 722:	6be2                	ld	s7,24(sp)
 724:	6c42                	ld	s8,16(sp)
 726:	6ca2                	ld	s9,8(sp)
    }
  }
}
 728:	60e6                	ld	ra,88(sp)
 72a:	6446                	ld	s0,80(sp)
 72c:	64a6                	ld	s1,72(sp)
 72e:	6125                	addi	sp,sp,96
 730:	8082                	ret

0000000000000732 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 732:	715d                	addi	sp,sp,-80
 734:	ec06                	sd	ra,24(sp)
 736:	e822                	sd	s0,16(sp)
 738:	1000                	addi	s0,sp,32
 73a:	e010                	sd	a2,0(s0)
 73c:	e414                	sd	a3,8(s0)
 73e:	e818                	sd	a4,16(s0)
 740:	ec1c                	sd	a5,24(s0)
 742:	03043023          	sd	a6,32(s0)
 746:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74a:	8622                	mv	a2,s0
 74c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 750:	d5fff0ef          	jal	4ae <vprintf>
}
 754:	60e2                	ld	ra,24(sp)
 756:	6442                	ld	s0,16(sp)
 758:	6161                	addi	sp,sp,80
 75a:	8082                	ret

000000000000075c <printf>:

void
printf(const char *fmt, ...)
{
 75c:	711d                	addi	sp,sp,-96
 75e:	ec06                	sd	ra,24(sp)
 760:	e822                	sd	s0,16(sp)
 762:	1000                	addi	s0,sp,32
 764:	e40c                	sd	a1,8(s0)
 766:	e810                	sd	a2,16(s0)
 768:	ec14                	sd	a3,24(s0)
 76a:	f018                	sd	a4,32(s0)
 76c:	f41c                	sd	a5,40(s0)
 76e:	03043823          	sd	a6,48(s0)
 772:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 776:	00840613          	addi	a2,s0,8
 77a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 77e:	85aa                	mv	a1,a0
 780:	4505                	li	a0,1
 782:	d2dff0ef          	jal	4ae <vprintf>
}
 786:	60e2                	ld	ra,24(sp)
 788:	6442                	ld	s0,16(sp)
 78a:	6125                	addi	sp,sp,96
 78c:	8082                	ret

000000000000078e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 78e:	1141                	addi	sp,sp,-16
 790:	e406                	sd	ra,8(sp)
 792:	e022                	sd	s0,0(sp)
 794:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 796:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79a:	00001797          	auipc	a5,0x1
 79e:	8667b783          	ld	a5,-1946(a5) # 1000 <freep>
 7a2:	a02d                	j	7cc <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7a4:	4618                	lw	a4,8(a2)
 7a6:	9f2d                	addw	a4,a4,a1
 7a8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ac:	6398                	ld	a4,0(a5)
 7ae:	6310                	ld	a2,0(a4)
 7b0:	a83d                	j	7ee <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7b2:	ff852703          	lw	a4,-8(a0)
 7b6:	9f31                	addw	a4,a4,a2
 7b8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ba:	ff053683          	ld	a3,-16(a0)
 7be:	a091                	j	802 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c0:	6398                	ld	a4,0(a5)
 7c2:	00e7e463          	bltu	a5,a4,7ca <free+0x3c>
 7c6:	00e6ea63          	bltu	a3,a4,7da <free+0x4c>
{
 7ca:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7cc:	fed7fae3          	bgeu	a5,a3,7c0 <free+0x32>
 7d0:	6398                	ld	a4,0(a5)
 7d2:	00e6e463          	bltu	a3,a4,7da <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d6:	fee7eae3          	bltu	a5,a4,7ca <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7da:	ff852583          	lw	a1,-8(a0)
 7de:	6390                	ld	a2,0(a5)
 7e0:	02059813          	slli	a6,a1,0x20
 7e4:	01c85713          	srli	a4,a6,0x1c
 7e8:	9736                	add	a4,a4,a3
 7ea:	fae60de3          	beq	a2,a4,7a4 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7ee:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7f2:	4790                	lw	a2,8(a5)
 7f4:	02061593          	slli	a1,a2,0x20
 7f8:	01c5d713          	srli	a4,a1,0x1c
 7fc:	973e                	add	a4,a4,a5
 7fe:	fae68ae3          	beq	a3,a4,7b2 <free+0x24>
    p->s.ptr = bp->s.ptr;
 802:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 804:	00000717          	auipc	a4,0x0
 808:	7ef73e23          	sd	a5,2044(a4) # 1000 <freep>
}
 80c:	60a2                	ld	ra,8(sp)
 80e:	6402                	ld	s0,0(sp)
 810:	0141                	addi	sp,sp,16
 812:	8082                	ret

0000000000000814 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 814:	7139                	addi	sp,sp,-64
 816:	fc06                	sd	ra,56(sp)
 818:	f822                	sd	s0,48(sp)
 81a:	f04a                	sd	s2,32(sp)
 81c:	ec4e                	sd	s3,24(sp)
 81e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 820:	02051993          	slli	s3,a0,0x20
 824:	0209d993          	srli	s3,s3,0x20
 828:	09bd                	addi	s3,s3,15
 82a:	0049d993          	srli	s3,s3,0x4
 82e:	2985                	addiw	s3,s3,1
 830:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 832:	00000517          	auipc	a0,0x0
 836:	7ce53503          	ld	a0,1998(a0) # 1000 <freep>
 83a:	c905                	beqz	a0,86a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83e:	4798                	lw	a4,8(a5)
 840:	09377663          	bgeu	a4,s3,8cc <malloc+0xb8>
 844:	f426                	sd	s1,40(sp)
 846:	e852                	sd	s4,16(sp)
 848:	e456                	sd	s5,8(sp)
 84a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 84c:	8a4e                	mv	s4,s3
 84e:	6705                	lui	a4,0x1
 850:	00e9f363          	bgeu	s3,a4,856 <malloc+0x42>
 854:	6a05                	lui	s4,0x1
 856:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 85a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 85e:	00000497          	auipc	s1,0x0
 862:	7a248493          	addi	s1,s1,1954 # 1000 <freep>
  if(p == (char*)-1)
 866:	5afd                	li	s5,-1
 868:	a83d                	j	8a6 <malloc+0x92>
 86a:	f426                	sd	s1,40(sp)
 86c:	e852                	sd	s4,16(sp)
 86e:	e456                	sd	s5,8(sp)
 870:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 872:	00000797          	auipc	a5,0x0
 876:	79e78793          	addi	a5,a5,1950 # 1010 <base>
 87a:	00000717          	auipc	a4,0x0
 87e:	78f73323          	sd	a5,1926(a4) # 1000 <freep>
 882:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 884:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 888:	b7d1                	j	84c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 88a:	6398                	ld	a4,0(a5)
 88c:	e118                	sd	a4,0(a0)
 88e:	a899                	j	8e4 <malloc+0xd0>
  hp->s.size = nu;
 890:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 894:	0541                	addi	a0,a0,16
 896:	ef9ff0ef          	jal	78e <free>
  return freep;
 89a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 89c:	c125                	beqz	a0,8fc <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a0:	4798                	lw	a4,8(a5)
 8a2:	03277163          	bgeu	a4,s2,8c4 <malloc+0xb0>
    if(p == freep)
 8a6:	6098                	ld	a4,0(s1)
 8a8:	853e                	mv	a0,a5
 8aa:	fef71ae3          	bne	a4,a5,89e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8ae:	8552                	mv	a0,s4
 8b0:	af3ff0ef          	jal	3a2 <sbrk>
  if(p == (char*)-1)
 8b4:	fd551ee3          	bne	a0,s5,890 <malloc+0x7c>
        return 0;
 8b8:	4501                	li	a0,0
 8ba:	74a2                	ld	s1,40(sp)
 8bc:	6a42                	ld	s4,16(sp)
 8be:	6aa2                	ld	s5,8(sp)
 8c0:	6b02                	ld	s6,0(sp)
 8c2:	a03d                	j	8f0 <malloc+0xdc>
 8c4:	74a2                	ld	s1,40(sp)
 8c6:	6a42                	ld	s4,16(sp)
 8c8:	6aa2                	ld	s5,8(sp)
 8ca:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8cc:	fae90fe3          	beq	s2,a4,88a <malloc+0x76>
        p->s.size -= nunits;
 8d0:	4137073b          	subw	a4,a4,s3
 8d4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d6:	02071693          	slli	a3,a4,0x20
 8da:	01c6d713          	srli	a4,a3,0x1c
 8de:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e4:	00000717          	auipc	a4,0x0
 8e8:	70a73e23          	sd	a0,1820(a4) # 1000 <freep>
      return (void*)(p + 1);
 8ec:	01078513          	addi	a0,a5,16
  }
}
 8f0:	70e2                	ld	ra,56(sp)
 8f2:	7442                	ld	s0,48(sp)
 8f4:	7902                	ld	s2,32(sp)
 8f6:	69e2                	ld	s3,24(sp)
 8f8:	6121                	addi	sp,sp,64
 8fa:	8082                	ret
 8fc:	74a2                	ld	s1,40(sp)
 8fe:	6a42                	ld	s4,16(sp)
 900:	6aa2                	ld	s5,8(sp)
 902:	6b02                	ld	s6,0(sp)
 904:	b7f5                	j	8f0 <malloc+0xdc>
