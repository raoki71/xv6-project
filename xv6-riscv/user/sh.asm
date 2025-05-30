
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	22e58593          	addi	a1,a1,558 # 1240 <malloc+0xfa>
      1a:	8532                	mv	a0,a2
      1c:	451000ef          	jal	c6c <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	219000ef          	jal	a3e <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	25f000ef          	jal	a8c <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a0053b          	negw	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	1fc58593          	addi	a1,a1,508 # 1250 <malloc+0x10a>
      5c:	4509                	li	a0,2
      5e:	006010ef          	jal	1064 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	3e9000ef          	jal	c4c <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	3d5000ef          	jal	c44 <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	1d650513          	addi	a0,a0,470 # 1258 <malloc+0x112>
      8a:	fc1ff0ef          	jal	4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	addi	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	1800                	addi	s0,sp,48
  if(cmd == 0)
      96:	c115                	beqz	a0,ba <runcmd+0x2c>
      98:	ec26                	sd	s1,24(sp)
      9a:	84aa                	mv	s1,a0
  switch(cmd->type){
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e163          	bltu	a5,a4,c2 <runcmd+0x34>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	slli	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	2ae70713          	addi	a4,a4,686 # 1358 <malloc+0x212>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
      ba:	ec26                	sd	s1,24(sp)
    exit(1);
      bc:	4505                	li	a0,1
      be:	38f000ef          	jal	c4c <exit>
    panic("runcmd");
      c2:	00001517          	auipc	a0,0x1
      c6:	19e50513          	addi	a0,a0,414 # 1260 <malloc+0x11a>
      ca:	f81ff0ef          	jal	4a <panic>
    if(ecmd->argv[0] == 0)
      ce:	6508                	ld	a0,8(a0)
      d0:	c105                	beqz	a0,f0 <runcmd+0x62>
    exec(ecmd->argv[0], ecmd->argv);
      d2:	00848593          	addi	a1,s1,8
      d6:	3af000ef          	jal	c84 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      da:	6490                	ld	a2,8(s1)
      dc:	00001597          	auipc	a1,0x1
      e0:	18c58593          	addi	a1,a1,396 # 1268 <malloc+0x122>
      e4:	4509                	li	a0,2
      e6:	77f000ef          	jal	1064 <fprintf>
  exit(0);
      ea:	4501                	li	a0,0
      ec:	361000ef          	jal	c4c <exit>
      exit(1);
      f0:	4505                	li	a0,1
      f2:	35b000ef          	jal	c4c <exit>
    close(rcmd->fd);
      f6:	5148                	lw	a0,36(a0)
      f8:	37d000ef          	jal	c74 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fc:	508c                	lw	a1,32(s1)
      fe:	6888                	ld	a0,16(s1)
     100:	38d000ef          	jal	c8c <open>
     104:	00054563          	bltz	a0,10e <runcmd+0x80>
    runcmd(rcmd->cmd);
     108:	6488                	ld	a0,8(s1)
     10a:	f85ff0ef          	jal	8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10e:	6890                	ld	a2,16(s1)
     110:	00001597          	auipc	a1,0x1
     114:	16858593          	addi	a1,a1,360 # 1278 <malloc+0x132>
     118:	4509                	li	a0,2
     11a:	74b000ef          	jal	1064 <fprintf>
      exit(1);
     11e:	4505                	li	a0,1
     120:	32d000ef          	jal	c4c <exit>
    if(fork1() == 0)
     124:	f45ff0ef          	jal	68 <fork1>
     128:	e501                	bnez	a0,130 <runcmd+0xa2>
      runcmd(lcmd->left);
     12a:	6488                	ld	a0,8(s1)
     12c:	f63ff0ef          	jal	8e <runcmd>
    wait(0);
     130:	4501                	li	a0,0
     132:	323000ef          	jal	c54 <wait>
    runcmd(lcmd->right);
     136:	6888                	ld	a0,16(s1)
     138:	f57ff0ef          	jal	8e <runcmd>
    if(pipe(p) < 0)
     13c:	fd840513          	addi	a0,s0,-40
     140:	31d000ef          	jal	c5c <pipe>
     144:	02054763          	bltz	a0,172 <runcmd+0xe4>
    if(fork1() == 0){
     148:	f21ff0ef          	jal	68 <fork1>
     14c:	e90d                	bnez	a0,17e <runcmd+0xf0>
      close(1);
     14e:	4505                	li	a0,1
     150:	325000ef          	jal	c74 <close>
      dup(p[1]);
     154:	fdc42503          	lw	a0,-36(s0)
     158:	36d000ef          	jal	cc4 <dup>
      close(p[0]);
     15c:	fd842503          	lw	a0,-40(s0)
     160:	315000ef          	jal	c74 <close>
      close(p[1]);
     164:	fdc42503          	lw	a0,-36(s0)
     168:	30d000ef          	jal	c74 <close>
      runcmd(pcmd->left);
     16c:	6488                	ld	a0,8(s1)
     16e:	f21ff0ef          	jal	8e <runcmd>
      panic("pipe");
     172:	00001517          	auipc	a0,0x1
     176:	11650513          	addi	a0,a0,278 # 1288 <malloc+0x142>
     17a:	ed1ff0ef          	jal	4a <panic>
    if(fork1() == 0){
     17e:	eebff0ef          	jal	68 <fork1>
     182:	e115                	bnez	a0,1a6 <runcmd+0x118>
      close(0);
     184:	2f1000ef          	jal	c74 <close>
      dup(p[0]);
     188:	fd842503          	lw	a0,-40(s0)
     18c:	339000ef          	jal	cc4 <dup>
      close(p[0]);
     190:	fd842503          	lw	a0,-40(s0)
     194:	2e1000ef          	jal	c74 <close>
      close(p[1]);
     198:	fdc42503          	lw	a0,-36(s0)
     19c:	2d9000ef          	jal	c74 <close>
      runcmd(pcmd->right);
     1a0:	6888                	ld	a0,16(s1)
     1a2:	eedff0ef          	jal	8e <runcmd>
    close(p[0]);
     1a6:	fd842503          	lw	a0,-40(s0)
     1aa:	2cb000ef          	jal	c74 <close>
    close(p[1]);
     1ae:	fdc42503          	lw	a0,-36(s0)
     1b2:	2c3000ef          	jal	c74 <close>
    wait(0);
     1b6:	4501                	li	a0,0
     1b8:	29d000ef          	jal	c54 <wait>
    wait(0);
     1bc:	4501                	li	a0,0
     1be:	297000ef          	jal	c54 <wait>
    break;
     1c2:	b725                	j	ea <runcmd+0x5c>
    if(fork1() == 0)
     1c4:	ea5ff0ef          	jal	68 <fork1>
     1c8:	f20511e3          	bnez	a0,ea <runcmd+0x5c>
      runcmd(bcmd->cmd);
     1cc:	6488                	ld	a0,8(s1)
     1ce:	ec1ff0ef          	jal	8e <runcmd>

00000000000001d2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d2:	1101                	addi	sp,sp,-32
     1d4:	ec06                	sd	ra,24(sp)
     1d6:	e822                	sd	s0,16(sp)
     1d8:	e426                	sd	s1,8(sp)
     1da:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1dc:	0a800513          	li	a0,168
     1e0:	767000ef          	jal	1146 <malloc>
     1e4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e6:	0a800613          	li	a2,168
     1ea:	4581                	li	a1,0
     1ec:	053000ef          	jal	a3e <memset>
  cmd->type = EXEC;
     1f0:	4785                	li	a5,1
     1f2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f4:	8526                	mv	a0,s1
     1f6:	60e2                	ld	ra,24(sp)
     1f8:	6442                	ld	s0,16(sp)
     1fa:	64a2                	ld	s1,8(sp)
     1fc:	6105                	addi	sp,sp,32
     1fe:	8082                	ret

0000000000000200 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     200:	7139                	addi	sp,sp,-64
     202:	fc06                	sd	ra,56(sp)
     204:	f822                	sd	s0,48(sp)
     206:	f426                	sd	s1,40(sp)
     208:	f04a                	sd	s2,32(sp)
     20a:	ec4e                	sd	s3,24(sp)
     20c:	e852                	sd	s4,16(sp)
     20e:	e456                	sd	s5,8(sp)
     210:	e05a                	sd	s6,0(sp)
     212:	0080                	addi	s0,sp,64
     214:	8b2a                	mv	s6,a0
     216:	8aae                	mv	s5,a1
     218:	8a32                	mv	s4,a2
     21a:	89b6                	mv	s3,a3
     21c:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21e:	02800513          	li	a0,40
     222:	725000ef          	jal	1146 <malloc>
     226:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     228:	02800613          	li	a2,40
     22c:	4581                	li	a1,0
     22e:	011000ef          	jal	a3e <memset>
  cmd->type = REDIR;
     232:	4789                	li	a5,2
     234:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     236:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     23a:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     23e:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     242:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     246:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     24a:	8526                	mv	a0,s1
     24c:	70e2                	ld	ra,56(sp)
     24e:	7442                	ld	s0,48(sp)
     250:	74a2                	ld	s1,40(sp)
     252:	7902                	ld	s2,32(sp)
     254:	69e2                	ld	s3,24(sp)
     256:	6a42                	ld	s4,16(sp)
     258:	6aa2                	ld	s5,8(sp)
     25a:	6b02                	ld	s6,0(sp)
     25c:	6121                	addi	sp,sp,64
     25e:	8082                	ret

0000000000000260 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     260:	7179                	addi	sp,sp,-48
     262:	f406                	sd	ra,40(sp)
     264:	f022                	sd	s0,32(sp)
     266:	ec26                	sd	s1,24(sp)
     268:	e84a                	sd	s2,16(sp)
     26a:	e44e                	sd	s3,8(sp)
     26c:	1800                	addi	s0,sp,48
     26e:	89aa                	mv	s3,a0
     270:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     272:	4561                	li	a0,24
     274:	6d3000ef          	jal	1146 <malloc>
     278:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     27a:	4661                	li	a2,24
     27c:	4581                	li	a1,0
     27e:	7c0000ef          	jal	a3e <memset>
  cmd->type = PIPE;
     282:	478d                	li	a5,3
     284:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     286:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     28a:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     28e:	8526                	mv	a0,s1
     290:	70a2                	ld	ra,40(sp)
     292:	7402                	ld	s0,32(sp)
     294:	64e2                	ld	s1,24(sp)
     296:	6942                	ld	s2,16(sp)
     298:	69a2                	ld	s3,8(sp)
     29a:	6145                	addi	sp,sp,48
     29c:	8082                	ret

000000000000029e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     29e:	7179                	addi	sp,sp,-48
     2a0:	f406                	sd	ra,40(sp)
     2a2:	f022                	sd	s0,32(sp)
     2a4:	ec26                	sd	s1,24(sp)
     2a6:	e84a                	sd	s2,16(sp)
     2a8:	e44e                	sd	s3,8(sp)
     2aa:	1800                	addi	s0,sp,48
     2ac:	89aa                	mv	s3,a0
     2ae:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b0:	4561                	li	a0,24
     2b2:	695000ef          	jal	1146 <malloc>
     2b6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b8:	4661                	li	a2,24
     2ba:	4581                	li	a1,0
     2bc:	782000ef          	jal	a3e <memset>
  cmd->type = LIST;
     2c0:	4791                	li	a5,4
     2c2:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c4:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     2c8:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     2cc:	8526                	mv	a0,s1
     2ce:	70a2                	ld	ra,40(sp)
     2d0:	7402                	ld	s0,32(sp)
     2d2:	64e2                	ld	s1,24(sp)
     2d4:	6942                	ld	s2,16(sp)
     2d6:	69a2                	ld	s3,8(sp)
     2d8:	6145                	addi	sp,sp,48
     2da:	8082                	ret

00000000000002dc <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2dc:	1101                	addi	sp,sp,-32
     2de:	ec06                	sd	ra,24(sp)
     2e0:	e822                	sd	s0,16(sp)
     2e2:	e426                	sd	s1,8(sp)
     2e4:	e04a                	sd	s2,0(sp)
     2e6:	1000                	addi	s0,sp,32
     2e8:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ea:	4541                	li	a0,16
     2ec:	65b000ef          	jal	1146 <malloc>
     2f0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f2:	4641                	li	a2,16
     2f4:	4581                	li	a1,0
     2f6:	748000ef          	jal	a3e <memset>
  cmd->type = BACK;
     2fa:	4795                	li	a5,5
     2fc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fe:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     302:	8526                	mv	a0,s1
     304:	60e2                	ld	ra,24(sp)
     306:	6442                	ld	s0,16(sp)
     308:	64a2                	ld	s1,8(sp)
     30a:	6902                	ld	s2,0(sp)
     30c:	6105                	addi	sp,sp,32
     30e:	8082                	ret

0000000000000310 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     310:	7139                	addi	sp,sp,-64
     312:	fc06                	sd	ra,56(sp)
     314:	f822                	sd	s0,48(sp)
     316:	f426                	sd	s1,40(sp)
     318:	f04a                	sd	s2,32(sp)
     31a:	ec4e                	sd	s3,24(sp)
     31c:	e852                	sd	s4,16(sp)
     31e:	e456                	sd	s5,8(sp)
     320:	e05a                	sd	s6,0(sp)
     322:	0080                	addi	s0,sp,64
     324:	8a2a                	mv	s4,a0
     326:	892e                	mv	s2,a1
     328:	8ab2                	mv	s5,a2
     32a:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32c:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32e:	00002997          	auipc	s3,0x2
     332:	cda98993          	addi	s3,s3,-806 # 2008 <whitespace>
     336:	00b4fc63          	bgeu	s1,a1,34e <gettoken+0x3e>
     33a:	0004c583          	lbu	a1,0(s1)
     33e:	854e                	mv	a0,s3
     340:	724000ef          	jal	a64 <strchr>
     344:	c509                	beqz	a0,34e <gettoken+0x3e>
    s++;
     346:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     348:	fe9919e3          	bne	s2,s1,33a <gettoken+0x2a>
     34c:	84ca                	mv	s1,s2
  if(q)
     34e:	000a8463          	beqz	s5,356 <gettoken+0x46>
    *q = s;
     352:	009ab023          	sd	s1,0(s5)
  ret = *s;
     356:	0004c783          	lbu	a5,0(s1)
     35a:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35e:	03c00713          	li	a4,60
     362:	06f76463          	bltu	a4,a5,3ca <gettoken+0xba>
     366:	03a00713          	li	a4,58
     36a:	00f76e63          	bltu	a4,a5,386 <gettoken+0x76>
     36e:	cf89                	beqz	a5,388 <gettoken+0x78>
     370:	02600713          	li	a4,38
     374:	00e78963          	beq	a5,a4,386 <gettoken+0x76>
     378:	fd87879b          	addiw	a5,a5,-40
     37c:	0ff7f793          	zext.b	a5,a5
     380:	4705                	li	a4,1
     382:	06f76b63          	bltu	a4,a5,3f8 <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     386:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     388:	000b0463          	beqz	s6,390 <gettoken+0x80>
    *eq = s;
     38c:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     390:	00002997          	auipc	s3,0x2
     394:	c7898993          	addi	s3,s3,-904 # 2008 <whitespace>
     398:	0124fc63          	bgeu	s1,s2,3b0 <gettoken+0xa0>
     39c:	0004c583          	lbu	a1,0(s1)
     3a0:	854e                	mv	a0,s3
     3a2:	6c2000ef          	jal	a64 <strchr>
     3a6:	c509                	beqz	a0,3b0 <gettoken+0xa0>
    s++;
     3a8:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3aa:	fe9919e3          	bne	s2,s1,39c <gettoken+0x8c>
     3ae:	84ca                	mv	s1,s2
  *ps = s;
     3b0:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3b4:	8556                	mv	a0,s5
     3b6:	70e2                	ld	ra,56(sp)
     3b8:	7442                	ld	s0,48(sp)
     3ba:	74a2                	ld	s1,40(sp)
     3bc:	7902                	ld	s2,32(sp)
     3be:	69e2                	ld	s3,24(sp)
     3c0:	6a42                	ld	s4,16(sp)
     3c2:	6aa2                	ld	s5,8(sp)
     3c4:	6b02                	ld	s6,0(sp)
     3c6:	6121                	addi	sp,sp,64
     3c8:	8082                	ret
  switch(*s){
     3ca:	03e00713          	li	a4,62
     3ce:	02e79163          	bne	a5,a4,3f0 <gettoken+0xe0>
    s++;
     3d2:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     3d6:	0014c703          	lbu	a4,1(s1)
     3da:	03e00793          	li	a5,62
      s++;
     3de:	0489                	addi	s1,s1,2
      ret = '+';
     3e0:	02b00a93          	li	s5,43
    if(*s == '>'){
     3e4:	faf702e3          	beq	a4,a5,388 <gettoken+0x78>
    s++;
     3e8:	84b6                	mv	s1,a3
  ret = *s;
     3ea:	03e00a93          	li	s5,62
     3ee:	bf69                	j	388 <gettoken+0x78>
  switch(*s){
     3f0:	07c00713          	li	a4,124
     3f4:	f8e789e3          	beq	a5,a4,386 <gettoken+0x76>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3f8:	00002997          	auipc	s3,0x2
     3fc:	c1098993          	addi	s3,s3,-1008 # 2008 <whitespace>
     400:	00002a97          	auipc	s5,0x2
     404:	c00a8a93          	addi	s5,s5,-1024 # 2000 <symbols>
     408:	0324fd63          	bgeu	s1,s2,442 <gettoken+0x132>
     40c:	0004c583          	lbu	a1,0(s1)
     410:	854e                	mv	a0,s3
     412:	652000ef          	jal	a64 <strchr>
     416:	e11d                	bnez	a0,43c <gettoken+0x12c>
     418:	0004c583          	lbu	a1,0(s1)
     41c:	8556                	mv	a0,s5
     41e:	646000ef          	jal	a64 <strchr>
     422:	e911                	bnez	a0,436 <gettoken+0x126>
      s++;
     424:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     426:	fe9913e3          	bne	s2,s1,40c <gettoken+0xfc>
  if(eq)
     42a:	84ca                	mv	s1,s2
    ret = 'a';
     42c:	06100a93          	li	s5,97
  if(eq)
     430:	f40b1ee3          	bnez	s6,38c <gettoken+0x7c>
     434:	bfb5                	j	3b0 <gettoken+0xa0>
    ret = 'a';
     436:	06100a93          	li	s5,97
     43a:	b7b9                	j	388 <gettoken+0x78>
     43c:	06100a93          	li	s5,97
     440:	b7a1                	j	388 <gettoken+0x78>
     442:	06100a93          	li	s5,97
  if(eq)
     446:	f40b13e3          	bnez	s6,38c <gettoken+0x7c>
     44a:	b79d                	j	3b0 <gettoken+0xa0>

000000000000044c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     44c:	7139                	addi	sp,sp,-64
     44e:	fc06                	sd	ra,56(sp)
     450:	f822                	sd	s0,48(sp)
     452:	f426                	sd	s1,40(sp)
     454:	f04a                	sd	s2,32(sp)
     456:	ec4e                	sd	s3,24(sp)
     458:	e852                	sd	s4,16(sp)
     45a:	e456                	sd	s5,8(sp)
     45c:	0080                	addi	s0,sp,64
     45e:	8a2a                	mv	s4,a0
     460:	892e                	mv	s2,a1
     462:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     464:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     466:	00002997          	auipc	s3,0x2
     46a:	ba298993          	addi	s3,s3,-1118 # 2008 <whitespace>
     46e:	00b4fc63          	bgeu	s1,a1,486 <peek+0x3a>
     472:	0004c583          	lbu	a1,0(s1)
     476:	854e                	mv	a0,s3
     478:	5ec000ef          	jal	a64 <strchr>
     47c:	c509                	beqz	a0,486 <peek+0x3a>
    s++;
     47e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     480:	fe9919e3          	bne	s2,s1,472 <peek+0x26>
     484:	84ca                	mv	s1,s2
  *ps = s;
     486:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     48a:	0004c583          	lbu	a1,0(s1)
     48e:	4501                	li	a0,0
     490:	e991                	bnez	a1,4a4 <peek+0x58>
}
     492:	70e2                	ld	ra,56(sp)
     494:	7442                	ld	s0,48(sp)
     496:	74a2                	ld	s1,40(sp)
     498:	7902                	ld	s2,32(sp)
     49a:	69e2                	ld	s3,24(sp)
     49c:	6a42                	ld	s4,16(sp)
     49e:	6aa2                	ld	s5,8(sp)
     4a0:	6121                	addi	sp,sp,64
     4a2:	8082                	ret
  return *s && strchr(toks, *s);
     4a4:	8556                	mv	a0,s5
     4a6:	5be000ef          	jal	a64 <strchr>
     4aa:	00a03533          	snez	a0,a0
     4ae:	b7d5                	j	492 <peek+0x46>

00000000000004b0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4b0:	7159                	addi	sp,sp,-112
     4b2:	f486                	sd	ra,104(sp)
     4b4:	f0a2                	sd	s0,96(sp)
     4b6:	eca6                	sd	s1,88(sp)
     4b8:	e8ca                	sd	s2,80(sp)
     4ba:	e4ce                	sd	s3,72(sp)
     4bc:	e0d2                	sd	s4,64(sp)
     4be:	fc56                	sd	s5,56(sp)
     4c0:	f85a                	sd	s6,48(sp)
     4c2:	f45e                	sd	s7,40(sp)
     4c4:	f062                	sd	s8,32(sp)
     4c6:	ec66                	sd	s9,24(sp)
     4c8:	1880                	addi	s0,sp,112
     4ca:	8a2a                	mv	s4,a0
     4cc:	89ae                	mv	s3,a1
     4ce:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4d0:	00001b17          	auipc	s6,0x1
     4d4:	de0b0b13          	addi	s6,s6,-544 # 12b0 <malloc+0x16a>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4d8:	f9040c93          	addi	s9,s0,-112
     4dc:	f9840c13          	addi	s8,s0,-104
     4e0:	06100b93          	li	s7,97
  while(peek(ps, es, "<>")){
     4e4:	a00d                	j	506 <parseredirs+0x56>
      panic("missing file for redirection");
     4e6:	00001517          	auipc	a0,0x1
     4ea:	daa50513          	addi	a0,a0,-598 # 1290 <malloc+0x14a>
     4ee:	b5dff0ef          	jal	4a <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4f2:	4701                	li	a4,0
     4f4:	4681                	li	a3,0
     4f6:	f9043603          	ld	a2,-112(s0)
     4fa:	f9843583          	ld	a1,-104(s0)
     4fe:	8552                	mv	a0,s4
     500:	d01ff0ef          	jal	200 <redircmd>
     504:	8a2a                	mv	s4,a0
    switch(tok){
     506:	03c00a93          	li	s5,60
  while(peek(ps, es, "<>")){
     50a:	865a                	mv	a2,s6
     50c:	85ca                	mv	a1,s2
     50e:	854e                	mv	a0,s3
     510:	f3dff0ef          	jal	44c <peek>
     514:	c135                	beqz	a0,578 <parseredirs+0xc8>
    tok = gettoken(ps, es, 0, 0);
     516:	4681                	li	a3,0
     518:	4601                	li	a2,0
     51a:	85ca                	mv	a1,s2
     51c:	854e                	mv	a0,s3
     51e:	df3ff0ef          	jal	310 <gettoken>
     522:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     524:	86e6                	mv	a3,s9
     526:	8662                	mv	a2,s8
     528:	85ca                	mv	a1,s2
     52a:	854e                	mv	a0,s3
     52c:	de5ff0ef          	jal	310 <gettoken>
     530:	fb751be3          	bne	a0,s7,4e6 <parseredirs+0x36>
    switch(tok){
     534:	fb548fe3          	beq	s1,s5,4f2 <parseredirs+0x42>
     538:	03e00793          	li	a5,62
     53c:	02f48263          	beq	s1,a5,560 <parseredirs+0xb0>
     540:	02b00793          	li	a5,43
     544:	fcf493e3          	bne	s1,a5,50a <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     548:	4705                	li	a4,1
     54a:	20100693          	li	a3,513
     54e:	f9043603          	ld	a2,-112(s0)
     552:	f9843583          	ld	a1,-104(s0)
     556:	8552                	mv	a0,s4
     558:	ca9ff0ef          	jal	200 <redircmd>
     55c:	8a2a                	mv	s4,a0
      break;
     55e:	b765                	j	506 <parseredirs+0x56>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     560:	4705                	li	a4,1
     562:	60100693          	li	a3,1537
     566:	f9043603          	ld	a2,-112(s0)
     56a:	f9843583          	ld	a1,-104(s0)
     56e:	8552                	mv	a0,s4
     570:	c91ff0ef          	jal	200 <redircmd>
     574:	8a2a                	mv	s4,a0
      break;
     576:	bf41                	j	506 <parseredirs+0x56>
    }
  }
  return cmd;
}
     578:	8552                	mv	a0,s4
     57a:	70a6                	ld	ra,104(sp)
     57c:	7406                	ld	s0,96(sp)
     57e:	64e6                	ld	s1,88(sp)
     580:	6946                	ld	s2,80(sp)
     582:	69a6                	ld	s3,72(sp)
     584:	6a06                	ld	s4,64(sp)
     586:	7ae2                	ld	s5,56(sp)
     588:	7b42                	ld	s6,48(sp)
     58a:	7ba2                	ld	s7,40(sp)
     58c:	7c02                	ld	s8,32(sp)
     58e:	6ce2                	ld	s9,24(sp)
     590:	6165                	addi	sp,sp,112
     592:	8082                	ret

0000000000000594 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     594:	7119                	addi	sp,sp,-128
     596:	fc86                	sd	ra,120(sp)
     598:	f8a2                	sd	s0,112(sp)
     59a:	f4a6                	sd	s1,104(sp)
     59c:	e8d2                	sd	s4,80(sp)
     59e:	e4d6                	sd	s5,72(sp)
     5a0:	0100                	addi	s0,sp,128
     5a2:	8a2a                	mv	s4,a0
     5a4:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     5a6:	00001617          	auipc	a2,0x1
     5aa:	d1260613          	addi	a2,a2,-750 # 12b8 <malloc+0x172>
     5ae:	e9fff0ef          	jal	44c <peek>
     5b2:	e121                	bnez	a0,5f2 <parseexec+0x5e>
     5b4:	f0ca                	sd	s2,96(sp)
     5b6:	ecce                	sd	s3,88(sp)
     5b8:	e0da                	sd	s6,64(sp)
     5ba:	fc5e                	sd	s7,56(sp)
     5bc:	f862                	sd	s8,48(sp)
     5be:	f466                	sd	s9,40(sp)
     5c0:	f06a                	sd	s10,32(sp)
     5c2:	ec6e                	sd	s11,24(sp)
     5c4:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     5c6:	c0dff0ef          	jal	1d2 <execcmd>
     5ca:	8daa                	mv	s11,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5cc:	8656                	mv	a2,s5
     5ce:	85d2                	mv	a1,s4
     5d0:	ee1ff0ef          	jal	4b0 <parseredirs>
     5d4:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5d6:	008d8913          	addi	s2,s11,8
     5da:	00001b17          	auipc	s6,0x1
     5de:	cfeb0b13          	addi	s6,s6,-770 # 12d8 <malloc+0x192>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     5e2:	f8040c13          	addi	s8,s0,-128
     5e6:	f8840b93          	addi	s7,s0,-120
      break;
    if(tok != 'a')
     5ea:	06100d13          	li	s10,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5ee:	4ca9                	li	s9,10
  while(!peek(ps, es, "|)&;")){
     5f0:	a815                	j	624 <parseexec+0x90>
    return parseblock(ps, es);
     5f2:	85d6                	mv	a1,s5
     5f4:	8552                	mv	a0,s4
     5f6:	170000ef          	jal	766 <parseblock>
     5fa:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5fc:	8526                	mv	a0,s1
     5fe:	70e6                	ld	ra,120(sp)
     600:	7446                	ld	s0,112(sp)
     602:	74a6                	ld	s1,104(sp)
     604:	6a46                	ld	s4,80(sp)
     606:	6aa6                	ld	s5,72(sp)
     608:	6109                	addi	sp,sp,128
     60a:	8082                	ret
      panic("syntax");
     60c:	00001517          	auipc	a0,0x1
     610:	cb450513          	addi	a0,a0,-844 # 12c0 <malloc+0x17a>
     614:	a37ff0ef          	jal	4a <panic>
    ret = parseredirs(ret, ps, es);
     618:	8656                	mv	a2,s5
     61a:	85d2                	mv	a1,s4
     61c:	8526                	mv	a0,s1
     61e:	e93ff0ef          	jal	4b0 <parseredirs>
     622:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     624:	865a                	mv	a2,s6
     626:	85d6                	mv	a1,s5
     628:	8552                	mv	a0,s4
     62a:	e23ff0ef          	jal	44c <peek>
     62e:	ed05                	bnez	a0,666 <parseexec+0xd2>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     630:	86e2                	mv	a3,s8
     632:	865e                	mv	a2,s7
     634:	85d6                	mv	a1,s5
     636:	8552                	mv	a0,s4
     638:	cd9ff0ef          	jal	310 <gettoken>
     63c:	c50d                	beqz	a0,666 <parseexec+0xd2>
    if(tok != 'a')
     63e:	fda517e3          	bne	a0,s10,60c <parseexec+0x78>
    cmd->argv[argc] = q;
     642:	f8843783          	ld	a5,-120(s0)
     646:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     64a:	f8043783          	ld	a5,-128(s0)
     64e:	04f93823          	sd	a5,80(s2)
    argc++;
     652:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     654:	0921                	addi	s2,s2,8
     656:	fd9991e3          	bne	s3,s9,618 <parseexec+0x84>
      panic("too many args");
     65a:	00001517          	auipc	a0,0x1
     65e:	c6e50513          	addi	a0,a0,-914 # 12c8 <malloc+0x182>
     662:	9e9ff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     666:	098e                	slli	s3,s3,0x3
     668:	9dce                	add	s11,s11,s3
     66a:	000db423          	sd	zero,8(s11)
  cmd->eargv[argc] = 0;
     66e:	040dbc23          	sd	zero,88(s11)
     672:	7906                	ld	s2,96(sp)
     674:	69e6                	ld	s3,88(sp)
     676:	6b06                	ld	s6,64(sp)
     678:	7be2                	ld	s7,56(sp)
     67a:	7c42                	ld	s8,48(sp)
     67c:	7ca2                	ld	s9,40(sp)
     67e:	7d02                	ld	s10,32(sp)
     680:	6de2                	ld	s11,24(sp)
  return ret;
     682:	bfad                	j	5fc <parseexec+0x68>

0000000000000684 <parsepipe>:
{
     684:	7179                	addi	sp,sp,-48
     686:	f406                	sd	ra,40(sp)
     688:	f022                	sd	s0,32(sp)
     68a:	ec26                	sd	s1,24(sp)
     68c:	e84a                	sd	s2,16(sp)
     68e:	e44e                	sd	s3,8(sp)
     690:	1800                	addi	s0,sp,48
     692:	892a                	mv	s2,a0
     694:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     696:	effff0ef          	jal	594 <parseexec>
     69a:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     69c:	00001617          	auipc	a2,0x1
     6a0:	c4460613          	addi	a2,a2,-956 # 12e0 <malloc+0x19a>
     6a4:	85ce                	mv	a1,s3
     6a6:	854a                	mv	a0,s2
     6a8:	da5ff0ef          	jal	44c <peek>
     6ac:	e909                	bnez	a0,6be <parsepipe+0x3a>
}
     6ae:	8526                	mv	a0,s1
     6b0:	70a2                	ld	ra,40(sp)
     6b2:	7402                	ld	s0,32(sp)
     6b4:	64e2                	ld	s1,24(sp)
     6b6:	6942                	ld	s2,16(sp)
     6b8:	69a2                	ld	s3,8(sp)
     6ba:	6145                	addi	sp,sp,48
     6bc:	8082                	ret
    gettoken(ps, es, 0, 0);
     6be:	4681                	li	a3,0
     6c0:	4601                	li	a2,0
     6c2:	85ce                	mv	a1,s3
     6c4:	854a                	mv	a0,s2
     6c6:	c4bff0ef          	jal	310 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ca:	85ce                	mv	a1,s3
     6cc:	854a                	mv	a0,s2
     6ce:	fb7ff0ef          	jal	684 <parsepipe>
     6d2:	85aa                	mv	a1,a0
     6d4:	8526                	mv	a0,s1
     6d6:	b8bff0ef          	jal	260 <pipecmd>
     6da:	84aa                	mv	s1,a0
  return cmd;
     6dc:	bfc9                	j	6ae <parsepipe+0x2a>

00000000000006de <parseline>:
{
     6de:	7179                	addi	sp,sp,-48
     6e0:	f406                	sd	ra,40(sp)
     6e2:	f022                	sd	s0,32(sp)
     6e4:	ec26                	sd	s1,24(sp)
     6e6:	e84a                	sd	s2,16(sp)
     6e8:	e44e                	sd	s3,8(sp)
     6ea:	e052                	sd	s4,0(sp)
     6ec:	1800                	addi	s0,sp,48
     6ee:	892a                	mv	s2,a0
     6f0:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6f2:	f93ff0ef          	jal	684 <parsepipe>
     6f6:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6f8:	00001a17          	auipc	s4,0x1
     6fc:	bf0a0a13          	addi	s4,s4,-1040 # 12e8 <malloc+0x1a2>
     700:	a819                	j	716 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     702:	4681                	li	a3,0
     704:	4601                	li	a2,0
     706:	85ce                	mv	a1,s3
     708:	854a                	mv	a0,s2
     70a:	c07ff0ef          	jal	310 <gettoken>
    cmd = backcmd(cmd);
     70e:	8526                	mv	a0,s1
     710:	bcdff0ef          	jal	2dc <backcmd>
     714:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     716:	8652                	mv	a2,s4
     718:	85ce                	mv	a1,s3
     71a:	854a                	mv	a0,s2
     71c:	d31ff0ef          	jal	44c <peek>
     720:	f16d                	bnez	a0,702 <parseline+0x24>
  if(peek(ps, es, ";")){
     722:	00001617          	auipc	a2,0x1
     726:	bce60613          	addi	a2,a2,-1074 # 12f0 <malloc+0x1aa>
     72a:	85ce                	mv	a1,s3
     72c:	854a                	mv	a0,s2
     72e:	d1fff0ef          	jal	44c <peek>
     732:	e911                	bnez	a0,746 <parseline+0x68>
}
     734:	8526                	mv	a0,s1
     736:	70a2                	ld	ra,40(sp)
     738:	7402                	ld	s0,32(sp)
     73a:	64e2                	ld	s1,24(sp)
     73c:	6942                	ld	s2,16(sp)
     73e:	69a2                	ld	s3,8(sp)
     740:	6a02                	ld	s4,0(sp)
     742:	6145                	addi	sp,sp,48
     744:	8082                	ret
    gettoken(ps, es, 0, 0);
     746:	4681                	li	a3,0
     748:	4601                	li	a2,0
     74a:	85ce                	mv	a1,s3
     74c:	854a                	mv	a0,s2
     74e:	bc3ff0ef          	jal	310 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     752:	85ce                	mv	a1,s3
     754:	854a                	mv	a0,s2
     756:	f89ff0ef          	jal	6de <parseline>
     75a:	85aa                	mv	a1,a0
     75c:	8526                	mv	a0,s1
     75e:	b41ff0ef          	jal	29e <listcmd>
     762:	84aa                	mv	s1,a0
  return cmd;
     764:	bfc1                	j	734 <parseline+0x56>

0000000000000766 <parseblock>:
{
     766:	7179                	addi	sp,sp,-48
     768:	f406                	sd	ra,40(sp)
     76a:	f022                	sd	s0,32(sp)
     76c:	ec26                	sd	s1,24(sp)
     76e:	e84a                	sd	s2,16(sp)
     770:	e44e                	sd	s3,8(sp)
     772:	1800                	addi	s0,sp,48
     774:	84aa                	mv	s1,a0
     776:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     778:	00001617          	auipc	a2,0x1
     77c:	b4060613          	addi	a2,a2,-1216 # 12b8 <malloc+0x172>
     780:	ccdff0ef          	jal	44c <peek>
     784:	c539                	beqz	a0,7d2 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     786:	4681                	li	a3,0
     788:	4601                	li	a2,0
     78a:	85ca                	mv	a1,s2
     78c:	8526                	mv	a0,s1
     78e:	b83ff0ef          	jal	310 <gettoken>
  cmd = parseline(ps, es);
     792:	85ca                	mv	a1,s2
     794:	8526                	mv	a0,s1
     796:	f49ff0ef          	jal	6de <parseline>
     79a:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     79c:	00001617          	auipc	a2,0x1
     7a0:	b6c60613          	addi	a2,a2,-1172 # 1308 <malloc+0x1c2>
     7a4:	85ca                	mv	a1,s2
     7a6:	8526                	mv	a0,s1
     7a8:	ca5ff0ef          	jal	44c <peek>
     7ac:	c90d                	beqz	a0,7de <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     7ae:	4681                	li	a3,0
     7b0:	4601                	li	a2,0
     7b2:	85ca                	mv	a1,s2
     7b4:	8526                	mv	a0,s1
     7b6:	b5bff0ef          	jal	310 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     7ba:	864a                	mv	a2,s2
     7bc:	85a6                	mv	a1,s1
     7be:	854e                	mv	a0,s3
     7c0:	cf1ff0ef          	jal	4b0 <parseredirs>
}
     7c4:	70a2                	ld	ra,40(sp)
     7c6:	7402                	ld	s0,32(sp)
     7c8:	64e2                	ld	s1,24(sp)
     7ca:	6942                	ld	s2,16(sp)
     7cc:	69a2                	ld	s3,8(sp)
     7ce:	6145                	addi	sp,sp,48
     7d0:	8082                	ret
    panic("parseblock");
     7d2:	00001517          	auipc	a0,0x1
     7d6:	b2650513          	addi	a0,a0,-1242 # 12f8 <malloc+0x1b2>
     7da:	871ff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     7de:	00001517          	auipc	a0,0x1
     7e2:	b3250513          	addi	a0,a0,-1230 # 1310 <malloc+0x1ca>
     7e6:	865ff0ef          	jal	4a <panic>

00000000000007ea <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7ea:	1101                	addi	sp,sp,-32
     7ec:	ec06                	sd	ra,24(sp)
     7ee:	e822                	sd	s0,16(sp)
     7f0:	e426                	sd	s1,8(sp)
     7f2:	1000                	addi	s0,sp,32
     7f4:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7f6:	c131                	beqz	a0,83a <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7f8:	4118                	lw	a4,0(a0)
     7fa:	4795                	li	a5,5
     7fc:	02e7ef63          	bltu	a5,a4,83a <nulterminate+0x50>
     800:	00056783          	lwu	a5,0(a0)
     804:	078a                	slli	a5,a5,0x2
     806:	00001717          	auipc	a4,0x1
     80a:	b6a70713          	addi	a4,a4,-1174 # 1370 <malloc+0x22a>
     80e:	97ba                	add	a5,a5,a4
     810:	439c                	lw	a5,0(a5)
     812:	97ba                	add	a5,a5,a4
     814:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     816:	651c                	ld	a5,8(a0)
     818:	c38d                	beqz	a5,83a <nulterminate+0x50>
     81a:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     81e:	67b8                	ld	a4,72(a5)
     820:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     824:	07a1                	addi	a5,a5,8
     826:	ff87b703          	ld	a4,-8(a5)
     82a:	fb75                	bnez	a4,81e <nulterminate+0x34>
     82c:	a039                	j	83a <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     82e:	6508                	ld	a0,8(a0)
     830:	fbbff0ef          	jal	7ea <nulterminate>
    *rcmd->efile = 0;
     834:	6c9c                	ld	a5,24(s1)
     836:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     83a:	8526                	mv	a0,s1
     83c:	60e2                	ld	ra,24(sp)
     83e:	6442                	ld	s0,16(sp)
     840:	64a2                	ld	s1,8(sp)
     842:	6105                	addi	sp,sp,32
     844:	8082                	ret
    nulterminate(pcmd->left);
     846:	6508                	ld	a0,8(a0)
     848:	fa3ff0ef          	jal	7ea <nulterminate>
    nulterminate(pcmd->right);
     84c:	6888                	ld	a0,16(s1)
     84e:	f9dff0ef          	jal	7ea <nulterminate>
    break;
     852:	b7e5                	j	83a <nulterminate+0x50>
    nulterminate(lcmd->left);
     854:	6508                	ld	a0,8(a0)
     856:	f95ff0ef          	jal	7ea <nulterminate>
    nulterminate(lcmd->right);
     85a:	6888                	ld	a0,16(s1)
     85c:	f8fff0ef          	jal	7ea <nulterminate>
    break;
     860:	bfe9                	j	83a <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     862:	6508                	ld	a0,8(a0)
     864:	f87ff0ef          	jal	7ea <nulterminate>
    break;
     868:	bfc9                	j	83a <nulterminate+0x50>

000000000000086a <parsecmd>:
{
     86a:	7139                	addi	sp,sp,-64
     86c:	fc06                	sd	ra,56(sp)
     86e:	f822                	sd	s0,48(sp)
     870:	f426                	sd	s1,40(sp)
     872:	f04a                	sd	s2,32(sp)
     874:	ec4e                	sd	s3,24(sp)
     876:	0080                	addi	s0,sp,64
     878:	fca43423          	sd	a0,-56(s0)
  es = s + strlen(s);
     87c:	84aa                	mv	s1,a0
     87e:	192000ef          	jal	a10 <strlen>
     882:	1502                	slli	a0,a0,0x20
     884:	9101                	srli	a0,a0,0x20
     886:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     888:	fc840993          	addi	s3,s0,-56
     88c:	85a6                	mv	a1,s1
     88e:	854e                	mv	a0,s3
     890:	e4fff0ef          	jal	6de <parseline>
     894:	892a                	mv	s2,a0
  peek(&s, es, "");
     896:	00001617          	auipc	a2,0x1
     89a:	9b260613          	addi	a2,a2,-1614 # 1248 <malloc+0x102>
     89e:	85a6                	mv	a1,s1
     8a0:	854e                	mv	a0,s3
     8a2:	babff0ef          	jal	44c <peek>
  if(s != es){
     8a6:	fc843603          	ld	a2,-56(s0)
     8aa:	00961d63          	bne	a2,s1,8c4 <parsecmd+0x5a>
  nulterminate(cmd);
     8ae:	854a                	mv	a0,s2
     8b0:	f3bff0ef          	jal	7ea <nulterminate>
}
     8b4:	854a                	mv	a0,s2
     8b6:	70e2                	ld	ra,56(sp)
     8b8:	7442                	ld	s0,48(sp)
     8ba:	74a2                	ld	s1,40(sp)
     8bc:	7902                	ld	s2,32(sp)
     8be:	69e2                	ld	s3,24(sp)
     8c0:	6121                	addi	sp,sp,64
     8c2:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     8c4:	00001597          	auipc	a1,0x1
     8c8:	a6458593          	addi	a1,a1,-1436 # 1328 <malloc+0x1e2>
     8cc:	4509                	li	a0,2
     8ce:	796000ef          	jal	1064 <fprintf>
    panic("syntax");
     8d2:	00001517          	auipc	a0,0x1
     8d6:	9ee50513          	addi	a0,a0,-1554 # 12c0 <malloc+0x17a>
     8da:	f70ff0ef          	jal	4a <panic>

00000000000008de <main>:
{
     8de:	7139                	addi	sp,sp,-64
     8e0:	fc06                	sd	ra,56(sp)
     8e2:	f822                	sd	s0,48(sp)
     8e4:	f426                	sd	s1,40(sp)
     8e6:	f04a                	sd	s2,32(sp)
     8e8:	ec4e                	sd	s3,24(sp)
     8ea:	e852                	sd	s4,16(sp)
     8ec:	e456                	sd	s5,8(sp)
     8ee:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     8f0:	4489                	li	s1,2
     8f2:	00001917          	auipc	s2,0x1
     8f6:	a4690913          	addi	s2,s2,-1466 # 1338 <malloc+0x1f2>
     8fa:	85a6                	mv	a1,s1
     8fc:	854a                	mv	a0,s2
     8fe:	38e000ef          	jal	c8c <open>
     902:	00054663          	bltz	a0,90e <main+0x30>
    if(fd >= 3){
     906:	fea4dae3          	bge	s1,a0,8fa <main+0x1c>
      close(fd);
     90a:	36a000ef          	jal	c74 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     90e:	00001497          	auipc	s1,0x1
     912:	71248493          	addi	s1,s1,1810 # 2020 <buf.0>
     916:	06400913          	li	s2,100
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     91a:	06300993          	li	s3,99
     91e:	02000a13          	li	s4,32
     922:	a039                	j	930 <main+0x52>
    if(fork1() == 0)
     924:	f44ff0ef          	jal	68 <fork1>
     928:	c925                	beqz	a0,998 <main+0xba>
    wait(0);
     92a:	4501                	li	a0,0
     92c:	328000ef          	jal	c54 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     930:	85ca                	mv	a1,s2
     932:	8526                	mv	a0,s1
     934:	eccff0ef          	jal	0 <getcmd>
     938:	06054863          	bltz	a0,9a8 <main+0xca>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     93c:	0004c783          	lbu	a5,0(s1)
     940:	ff3792e3          	bne	a5,s3,924 <main+0x46>
     944:	0014c783          	lbu	a5,1(s1)
     948:	fd279ee3          	bne	a5,s2,924 <main+0x46>
     94c:	0024c783          	lbu	a5,2(s1)
     950:	fd479ae3          	bne	a5,s4,924 <main+0x46>
      buf[strlen(buf)-1] = 0;  // chop \n
     954:	00001a97          	auipc	s5,0x1
     958:	6cca8a93          	addi	s5,s5,1740 # 2020 <buf.0>
     95c:	8556                	mv	a0,s5
     95e:	0b2000ef          	jal	a10 <strlen>
     962:	fff5079b          	addiw	a5,a0,-1
     966:	1782                	slli	a5,a5,0x20
     968:	9381                	srli	a5,a5,0x20
     96a:	9abe                	add	s5,s5,a5
     96c:	000a8023          	sb	zero,0(s5)
      if(chdir(buf+3) < 0)
     970:	00001517          	auipc	a0,0x1
     974:	6b350513          	addi	a0,a0,1715 # 2023 <buf.0+0x3>
     978:	344000ef          	jal	cbc <chdir>
     97c:	fa055ae3          	bgez	a0,930 <main+0x52>
        fprintf(2, "cannot cd %s\n", buf+3);
     980:	00001617          	auipc	a2,0x1
     984:	6a360613          	addi	a2,a2,1699 # 2023 <buf.0+0x3>
     988:	00001597          	auipc	a1,0x1
     98c:	9b858593          	addi	a1,a1,-1608 # 1340 <malloc+0x1fa>
     990:	4509                	li	a0,2
     992:	6d2000ef          	jal	1064 <fprintf>
     996:	bf69                	j	930 <main+0x52>
      runcmd(parsecmd(buf));
     998:	00001517          	auipc	a0,0x1
     99c:	68850513          	addi	a0,a0,1672 # 2020 <buf.0>
     9a0:	ecbff0ef          	jal	86a <parsecmd>
     9a4:	eeaff0ef          	jal	8e <runcmd>
  exit(0);
     9a8:	4501                	li	a0,0
     9aa:	2a2000ef          	jal	c4c <exit>

00000000000009ae <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     9ae:	1141                	addi	sp,sp,-16
     9b0:	e406                	sd	ra,8(sp)
     9b2:	e022                	sd	s0,0(sp)
     9b4:	0800                	addi	s0,sp,16
  extern int main();
  main();
     9b6:	f29ff0ef          	jal	8de <main>
  exit(0);
     9ba:	4501                	li	a0,0
     9bc:	290000ef          	jal	c4c <exit>

00000000000009c0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9c0:	1141                	addi	sp,sp,-16
     9c2:	e406                	sd	ra,8(sp)
     9c4:	e022                	sd	s0,0(sp)
     9c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9c8:	87aa                	mv	a5,a0
     9ca:	0585                	addi	a1,a1,1
     9cc:	0785                	addi	a5,a5,1
     9ce:	fff5c703          	lbu	a4,-1(a1)
     9d2:	fee78fa3          	sb	a4,-1(a5)
     9d6:	fb75                	bnez	a4,9ca <strcpy+0xa>
    ;
  return os;
}
     9d8:	60a2                	ld	ra,8(sp)
     9da:	6402                	ld	s0,0(sp)
     9dc:	0141                	addi	sp,sp,16
     9de:	8082                	ret

00000000000009e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9e0:	1141                	addi	sp,sp,-16
     9e2:	e406                	sd	ra,8(sp)
     9e4:	e022                	sd	s0,0(sp)
     9e6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9e8:	00054783          	lbu	a5,0(a0)
     9ec:	cb91                	beqz	a5,a00 <strcmp+0x20>
     9ee:	0005c703          	lbu	a4,0(a1)
     9f2:	00f71763          	bne	a4,a5,a00 <strcmp+0x20>
    p++, q++;
     9f6:	0505                	addi	a0,a0,1
     9f8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9fa:	00054783          	lbu	a5,0(a0)
     9fe:	fbe5                	bnez	a5,9ee <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     a00:	0005c503          	lbu	a0,0(a1)
}
     a04:	40a7853b          	subw	a0,a5,a0
     a08:	60a2                	ld	ra,8(sp)
     a0a:	6402                	ld	s0,0(sp)
     a0c:	0141                	addi	sp,sp,16
     a0e:	8082                	ret

0000000000000a10 <strlen>:

uint
strlen(const char *s)
{
     a10:	1141                	addi	sp,sp,-16
     a12:	e406                	sd	ra,8(sp)
     a14:	e022                	sd	s0,0(sp)
     a16:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     a18:	00054783          	lbu	a5,0(a0)
     a1c:	cf99                	beqz	a5,a3a <strlen+0x2a>
     a1e:	0505                	addi	a0,a0,1
     a20:	87aa                	mv	a5,a0
     a22:	86be                	mv	a3,a5
     a24:	0785                	addi	a5,a5,1
     a26:	fff7c703          	lbu	a4,-1(a5)
     a2a:	ff65                	bnez	a4,a22 <strlen+0x12>
     a2c:	40a6853b          	subw	a0,a3,a0
     a30:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     a32:	60a2                	ld	ra,8(sp)
     a34:	6402                	ld	s0,0(sp)
     a36:	0141                	addi	sp,sp,16
     a38:	8082                	ret
  for(n = 0; s[n]; n++)
     a3a:	4501                	li	a0,0
     a3c:	bfdd                	j	a32 <strlen+0x22>

0000000000000a3e <memset>:

void*
memset(void *dst, int c, uint n)
{
     a3e:	1141                	addi	sp,sp,-16
     a40:	e406                	sd	ra,8(sp)
     a42:	e022                	sd	s0,0(sp)
     a44:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a46:	ca19                	beqz	a2,a5c <memset+0x1e>
     a48:	87aa                	mv	a5,a0
     a4a:	1602                	slli	a2,a2,0x20
     a4c:	9201                	srli	a2,a2,0x20
     a4e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a52:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a56:	0785                	addi	a5,a5,1
     a58:	fee79de3          	bne	a5,a4,a52 <memset+0x14>
  }
  return dst;
}
     a5c:	60a2                	ld	ra,8(sp)
     a5e:	6402                	ld	s0,0(sp)
     a60:	0141                	addi	sp,sp,16
     a62:	8082                	ret

0000000000000a64 <strchr>:

char*
strchr(const char *s, char c)
{
     a64:	1141                	addi	sp,sp,-16
     a66:	e406                	sd	ra,8(sp)
     a68:	e022                	sd	s0,0(sp)
     a6a:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a6c:	00054783          	lbu	a5,0(a0)
     a70:	cf81                	beqz	a5,a88 <strchr+0x24>
    if(*s == c)
     a72:	00f58763          	beq	a1,a5,a80 <strchr+0x1c>
  for(; *s; s++)
     a76:	0505                	addi	a0,a0,1
     a78:	00054783          	lbu	a5,0(a0)
     a7c:	fbfd                	bnez	a5,a72 <strchr+0xe>
      return (char*)s;
  return 0;
     a7e:	4501                	li	a0,0
}
     a80:	60a2                	ld	ra,8(sp)
     a82:	6402                	ld	s0,0(sp)
     a84:	0141                	addi	sp,sp,16
     a86:	8082                	ret
  return 0;
     a88:	4501                	li	a0,0
     a8a:	bfdd                	j	a80 <strchr+0x1c>

0000000000000a8c <gets>:

char*
gets(char *buf, int max)
{
     a8c:	7159                	addi	sp,sp,-112
     a8e:	f486                	sd	ra,104(sp)
     a90:	f0a2                	sd	s0,96(sp)
     a92:	eca6                	sd	s1,88(sp)
     a94:	e8ca                	sd	s2,80(sp)
     a96:	e4ce                	sd	s3,72(sp)
     a98:	e0d2                	sd	s4,64(sp)
     a9a:	fc56                	sd	s5,56(sp)
     a9c:	f85a                	sd	s6,48(sp)
     a9e:	f45e                	sd	s7,40(sp)
     aa0:	f062                	sd	s8,32(sp)
     aa2:	ec66                	sd	s9,24(sp)
     aa4:	e86a                	sd	s10,16(sp)
     aa6:	1880                	addi	s0,sp,112
     aa8:	8caa                	mv	s9,a0
     aaa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     aac:	892a                	mv	s2,a0
     aae:	4481                	li	s1,0
    cc = read(0, &c, 1);
     ab0:	f9f40b13          	addi	s6,s0,-97
     ab4:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     ab6:	4ba9                	li	s7,10
     ab8:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     aba:	8d26                	mv	s10,s1
     abc:	0014899b          	addiw	s3,s1,1
     ac0:	84ce                	mv	s1,s3
     ac2:	0349d563          	bge	s3,s4,aec <gets+0x60>
    cc = read(0, &c, 1);
     ac6:	8656                	mv	a2,s5
     ac8:	85da                	mv	a1,s6
     aca:	4501                	li	a0,0
     acc:	198000ef          	jal	c64 <read>
    if(cc < 1)
     ad0:	00a05e63          	blez	a0,aec <gets+0x60>
    buf[i++] = c;
     ad4:	f9f44783          	lbu	a5,-97(s0)
     ad8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     adc:	01778763          	beq	a5,s7,aea <gets+0x5e>
     ae0:	0905                	addi	s2,s2,1
     ae2:	fd879ce3          	bne	a5,s8,aba <gets+0x2e>
    buf[i++] = c;
     ae6:	8d4e                	mv	s10,s3
     ae8:	a011                	j	aec <gets+0x60>
     aea:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     aec:	9d66                	add	s10,s10,s9
     aee:	000d0023          	sb	zero,0(s10)
  return buf;
}
     af2:	8566                	mv	a0,s9
     af4:	70a6                	ld	ra,104(sp)
     af6:	7406                	ld	s0,96(sp)
     af8:	64e6                	ld	s1,88(sp)
     afa:	6946                	ld	s2,80(sp)
     afc:	69a6                	ld	s3,72(sp)
     afe:	6a06                	ld	s4,64(sp)
     b00:	7ae2                	ld	s5,56(sp)
     b02:	7b42                	ld	s6,48(sp)
     b04:	7ba2                	ld	s7,40(sp)
     b06:	7c02                	ld	s8,32(sp)
     b08:	6ce2                	ld	s9,24(sp)
     b0a:	6d42                	ld	s10,16(sp)
     b0c:	6165                	addi	sp,sp,112
     b0e:	8082                	ret

0000000000000b10 <stat>:

int
stat(const char *n, struct stat *st)
{
     b10:	1101                	addi	sp,sp,-32
     b12:	ec06                	sd	ra,24(sp)
     b14:	e822                	sd	s0,16(sp)
     b16:	e04a                	sd	s2,0(sp)
     b18:	1000                	addi	s0,sp,32
     b1a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b1c:	4581                	li	a1,0
     b1e:	16e000ef          	jal	c8c <open>
  if(fd < 0)
     b22:	02054263          	bltz	a0,b46 <stat+0x36>
     b26:	e426                	sd	s1,8(sp)
     b28:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     b2a:	85ca                	mv	a1,s2
     b2c:	178000ef          	jal	ca4 <fstat>
     b30:	892a                	mv	s2,a0
  close(fd);
     b32:	8526                	mv	a0,s1
     b34:	140000ef          	jal	c74 <close>
  return r;
     b38:	64a2                	ld	s1,8(sp)
}
     b3a:	854a                	mv	a0,s2
     b3c:	60e2                	ld	ra,24(sp)
     b3e:	6442                	ld	s0,16(sp)
     b40:	6902                	ld	s2,0(sp)
     b42:	6105                	addi	sp,sp,32
     b44:	8082                	ret
    return -1;
     b46:	597d                	li	s2,-1
     b48:	bfcd                	j	b3a <stat+0x2a>

0000000000000b4a <atoi>:

int
atoi(const char *s)
{
     b4a:	1141                	addi	sp,sp,-16
     b4c:	e406                	sd	ra,8(sp)
     b4e:	e022                	sd	s0,0(sp)
     b50:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b52:	00054683          	lbu	a3,0(a0)
     b56:	fd06879b          	addiw	a5,a3,-48
     b5a:	0ff7f793          	zext.b	a5,a5
     b5e:	4625                	li	a2,9
     b60:	02f66963          	bltu	a2,a5,b92 <atoi+0x48>
     b64:	872a                	mv	a4,a0
  n = 0;
     b66:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b68:	0705                	addi	a4,a4,1
     b6a:	0025179b          	slliw	a5,a0,0x2
     b6e:	9fa9                	addw	a5,a5,a0
     b70:	0017979b          	slliw	a5,a5,0x1
     b74:	9fb5                	addw	a5,a5,a3
     b76:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b7a:	00074683          	lbu	a3,0(a4)
     b7e:	fd06879b          	addiw	a5,a3,-48
     b82:	0ff7f793          	zext.b	a5,a5
     b86:	fef671e3          	bgeu	a2,a5,b68 <atoi+0x1e>
  return n;
}
     b8a:	60a2                	ld	ra,8(sp)
     b8c:	6402                	ld	s0,0(sp)
     b8e:	0141                	addi	sp,sp,16
     b90:	8082                	ret
  n = 0;
     b92:	4501                	li	a0,0
     b94:	bfdd                	j	b8a <atoi+0x40>

0000000000000b96 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b96:	1141                	addi	sp,sp,-16
     b98:	e406                	sd	ra,8(sp)
     b9a:	e022                	sd	s0,0(sp)
     b9c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b9e:	02b57563          	bgeu	a0,a1,bc8 <memmove+0x32>
    while(n-- > 0)
     ba2:	00c05f63          	blez	a2,bc0 <memmove+0x2a>
     ba6:	1602                	slli	a2,a2,0x20
     ba8:	9201                	srli	a2,a2,0x20
     baa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     bae:	872a                	mv	a4,a0
      *dst++ = *src++;
     bb0:	0585                	addi	a1,a1,1
     bb2:	0705                	addi	a4,a4,1
     bb4:	fff5c683          	lbu	a3,-1(a1)
     bb8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     bbc:	fee79ae3          	bne	a5,a4,bb0 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     bc0:	60a2                	ld	ra,8(sp)
     bc2:	6402                	ld	s0,0(sp)
     bc4:	0141                	addi	sp,sp,16
     bc6:	8082                	ret
    dst += n;
     bc8:	00c50733          	add	a4,a0,a2
    src += n;
     bcc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     bce:	fec059e3          	blez	a2,bc0 <memmove+0x2a>
     bd2:	fff6079b          	addiw	a5,a2,-1
     bd6:	1782                	slli	a5,a5,0x20
     bd8:	9381                	srli	a5,a5,0x20
     bda:	fff7c793          	not	a5,a5
     bde:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     be0:	15fd                	addi	a1,a1,-1
     be2:	177d                	addi	a4,a4,-1
     be4:	0005c683          	lbu	a3,0(a1)
     be8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     bec:	fef71ae3          	bne	a4,a5,be0 <memmove+0x4a>
     bf0:	bfc1                	j	bc0 <memmove+0x2a>

0000000000000bf2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bf2:	1141                	addi	sp,sp,-16
     bf4:	e406                	sd	ra,8(sp)
     bf6:	e022                	sd	s0,0(sp)
     bf8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bfa:	ca0d                	beqz	a2,c2c <memcmp+0x3a>
     bfc:	fff6069b          	addiw	a3,a2,-1
     c00:	1682                	slli	a3,a3,0x20
     c02:	9281                	srli	a3,a3,0x20
     c04:	0685                	addi	a3,a3,1
     c06:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     c08:	00054783          	lbu	a5,0(a0)
     c0c:	0005c703          	lbu	a4,0(a1)
     c10:	00e79863          	bne	a5,a4,c20 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     c14:	0505                	addi	a0,a0,1
    p2++;
     c16:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     c18:	fed518e3          	bne	a0,a3,c08 <memcmp+0x16>
  }
  return 0;
     c1c:	4501                	li	a0,0
     c1e:	a019                	j	c24 <memcmp+0x32>
      return *p1 - *p2;
     c20:	40e7853b          	subw	a0,a5,a4
}
     c24:	60a2                	ld	ra,8(sp)
     c26:	6402                	ld	s0,0(sp)
     c28:	0141                	addi	sp,sp,16
     c2a:	8082                	ret
  return 0;
     c2c:	4501                	li	a0,0
     c2e:	bfdd                	j	c24 <memcmp+0x32>

0000000000000c30 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     c30:	1141                	addi	sp,sp,-16
     c32:	e406                	sd	ra,8(sp)
     c34:	e022                	sd	s0,0(sp)
     c36:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c38:	f5fff0ef          	jal	b96 <memmove>
}
     c3c:	60a2                	ld	ra,8(sp)
     c3e:	6402                	ld	s0,0(sp)
     c40:	0141                	addi	sp,sp,16
     c42:	8082                	ret

0000000000000c44 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c44:	4885                	li	a7,1
 ecall
     c46:	00000073          	ecall
 ret
     c4a:	8082                	ret

0000000000000c4c <exit>:
.global exit
exit:
 li a7, SYS_exit
     c4c:	4889                	li	a7,2
 ecall
     c4e:	00000073          	ecall
 ret
     c52:	8082                	ret

0000000000000c54 <wait>:
.global wait
wait:
 li a7, SYS_wait
     c54:	488d                	li	a7,3
 ecall
     c56:	00000073          	ecall
 ret
     c5a:	8082                	ret

0000000000000c5c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c5c:	4891                	li	a7,4
 ecall
     c5e:	00000073          	ecall
 ret
     c62:	8082                	ret

0000000000000c64 <read>:
.global read
read:
 li a7, SYS_read
     c64:	4895                	li	a7,5
 ecall
     c66:	00000073          	ecall
 ret
     c6a:	8082                	ret

0000000000000c6c <write>:
.global write
write:
 li a7, SYS_write
     c6c:	48c1                	li	a7,16
 ecall
     c6e:	00000073          	ecall
 ret
     c72:	8082                	ret

0000000000000c74 <close>:
.global close
close:
 li a7, SYS_close
     c74:	48d5                	li	a7,21
 ecall
     c76:	00000073          	ecall
 ret
     c7a:	8082                	ret

0000000000000c7c <kill>:
.global kill
kill:
 li a7, SYS_kill
     c7c:	4899                	li	a7,6
 ecall
     c7e:	00000073          	ecall
 ret
     c82:	8082                	ret

0000000000000c84 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c84:	489d                	li	a7,7
 ecall
     c86:	00000073          	ecall
 ret
     c8a:	8082                	ret

0000000000000c8c <open>:
.global open
open:
 li a7, SYS_open
     c8c:	48bd                	li	a7,15
 ecall
     c8e:	00000073          	ecall
 ret
     c92:	8082                	ret

0000000000000c94 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c94:	48c5                	li	a7,17
 ecall
     c96:	00000073          	ecall
 ret
     c9a:	8082                	ret

0000000000000c9c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c9c:	48c9                	li	a7,18
 ecall
     c9e:	00000073          	ecall
 ret
     ca2:	8082                	ret

0000000000000ca4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ca4:	48a1                	li	a7,8
 ecall
     ca6:	00000073          	ecall
 ret
     caa:	8082                	ret

0000000000000cac <link>:
.global link
link:
 li a7, SYS_link
     cac:	48cd                	li	a7,19
 ecall
     cae:	00000073          	ecall
 ret
     cb2:	8082                	ret

0000000000000cb4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     cb4:	48d1                	li	a7,20
 ecall
     cb6:	00000073          	ecall
 ret
     cba:	8082                	ret

0000000000000cbc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     cbc:	48a5                	li	a7,9
 ecall
     cbe:	00000073          	ecall
 ret
     cc2:	8082                	ret

0000000000000cc4 <dup>:
.global dup
dup:
 li a7, SYS_dup
     cc4:	48a9                	li	a7,10
 ecall
     cc6:	00000073          	ecall
 ret
     cca:	8082                	ret

0000000000000ccc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ccc:	48ad                	li	a7,11
 ecall
     cce:	00000073          	ecall
 ret
     cd2:	8082                	ret

0000000000000cd4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     cd4:	48b1                	li	a7,12
 ecall
     cd6:	00000073          	ecall
 ret
     cda:	8082                	ret

0000000000000cdc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     cdc:	48b5                	li	a7,13
 ecall
     cde:	00000073          	ecall
 ret
     ce2:	8082                	ret

0000000000000ce4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ce4:	48b9                	li	a7,14
 ecall
     ce6:	00000073          	ecall
 ret
     cea:	8082                	ret

0000000000000cec <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
     cec:	48d9                	li	a7,22
 ecall
     cee:	00000073          	ecall
 ret
     cf2:	8082                	ret

0000000000000cf4 <getcpids>:
.global getcpids
getcpids:
 li a7, SYS_getcpids
     cf4:	48dd                	li	a7,23
 ecall
     cf6:	00000073          	ecall
 ret
     cfa:	8082                	ret

0000000000000cfc <getpaddr>:
.global getpaddr
getpaddr:
 li a7, SYS_getpaddr
     cfc:	48e1                	li	a7,24
 ecall
     cfe:	00000073          	ecall
 ret
     d02:	8082                	ret

0000000000000d04 <gettraphistory>:
.global gettraphistory
gettraphistory:
 li a7, SYS_gettraphistory
     d04:	48e5                	li	a7,25
 ecall
     d06:	00000073          	ecall
 ret
     d0a:	8082                	ret

0000000000000d0c <nice>:
.global nice
nice:
 li a7, SYS_nice
     d0c:	48e9                	li	a7,26
 ecall
     d0e:	00000073          	ecall
 ret
     d12:	8082                	ret

0000000000000d14 <getruntime>:
.global getruntime
getruntime:
 li a7, SYS_getruntime
     d14:	48ed                	li	a7,27
 ecall
     d16:	00000073          	ecall
 ret
     d1a:	8082                	ret

0000000000000d1c <startcfs>:
.global startcfs
startcfs:
 li a7, SYS_startcfs
     d1c:	48f1                	li	a7,28
 ecall
     d1e:	00000073          	ecall
 ret
     d22:	8082                	ret

0000000000000d24 <stopcfs>:
.global stopcfs
stopcfs:
 li a7, SYS_stopcfs
     d24:	48f5                	li	a7,29
 ecall
     d26:	00000073          	ecall
 ret
     d2a:	8082                	ret

0000000000000d2c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d2c:	1101                	addi	sp,sp,-32
     d2e:	ec06                	sd	ra,24(sp)
     d30:	e822                	sd	s0,16(sp)
     d32:	1000                	addi	s0,sp,32
     d34:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d38:	4605                	li	a2,1
     d3a:	fef40593          	addi	a1,s0,-17
     d3e:	f2fff0ef          	jal	c6c <write>
}
     d42:	60e2                	ld	ra,24(sp)
     d44:	6442                	ld	s0,16(sp)
     d46:	6105                	addi	sp,sp,32
     d48:	8082                	ret

0000000000000d4a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     d4a:	7139                	addi	sp,sp,-64
     d4c:	fc06                	sd	ra,56(sp)
     d4e:	f822                	sd	s0,48(sp)
     d50:	f426                	sd	s1,40(sp)
     d52:	f04a                	sd	s2,32(sp)
     d54:	ec4e                	sd	s3,24(sp)
     d56:	0080                	addi	s0,sp,64
     d58:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d5a:	c299                	beqz	a3,d60 <printint+0x16>
     d5c:	0605ce63          	bltz	a1,dd8 <printint+0x8e>
  neg = 0;
     d60:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     d62:	fc040313          	addi	t1,s0,-64
  neg = 0;
     d66:	869a                	mv	a3,t1
  i = 0;
     d68:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     d6a:	00000817          	auipc	a6,0x0
     d6e:	61e80813          	addi	a6,a6,1566 # 1388 <digits>
     d72:	88be                	mv	a7,a5
     d74:	0017851b          	addiw	a0,a5,1
     d78:	87aa                	mv	a5,a0
     d7a:	02c5f73b          	remuw	a4,a1,a2
     d7e:	1702                	slli	a4,a4,0x20
     d80:	9301                	srli	a4,a4,0x20
     d82:	9742                	add	a4,a4,a6
     d84:	00074703          	lbu	a4,0(a4)
     d88:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     d8c:	872e                	mv	a4,a1
     d8e:	02c5d5bb          	divuw	a1,a1,a2
     d92:	0685                	addi	a3,a3,1
     d94:	fcc77fe3          	bgeu	a4,a2,d72 <printint+0x28>
  if(neg)
     d98:	000e0c63          	beqz	t3,db0 <printint+0x66>
    buf[i++] = '-';
     d9c:	fd050793          	addi	a5,a0,-48
     da0:	00878533          	add	a0,a5,s0
     da4:	02d00793          	li	a5,45
     da8:	fef50823          	sb	a5,-16(a0)
     dac:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
     db0:	fff7899b          	addiw	s3,a5,-1
     db4:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
     db8:	fff4c583          	lbu	a1,-1(s1)
     dbc:	854a                	mv	a0,s2
     dbe:	f6fff0ef          	jal	d2c <putc>
  while(--i >= 0)
     dc2:	39fd                	addiw	s3,s3,-1
     dc4:	14fd                	addi	s1,s1,-1
     dc6:	fe09d9e3          	bgez	s3,db8 <printint+0x6e>
}
     dca:	70e2                	ld	ra,56(sp)
     dcc:	7442                	ld	s0,48(sp)
     dce:	74a2                	ld	s1,40(sp)
     dd0:	7902                	ld	s2,32(sp)
     dd2:	69e2                	ld	s3,24(sp)
     dd4:	6121                	addi	sp,sp,64
     dd6:	8082                	ret
    x = -xx;
     dd8:	40b005bb          	negw	a1,a1
    neg = 1;
     ddc:	4e05                	li	t3,1
    x = -xx;
     dde:	b751                	j	d62 <printint+0x18>

0000000000000de0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     de0:	711d                	addi	sp,sp,-96
     de2:	ec86                	sd	ra,88(sp)
     de4:	e8a2                	sd	s0,80(sp)
     de6:	e4a6                	sd	s1,72(sp)
     de8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     dea:	0005c483          	lbu	s1,0(a1)
     dee:	26048663          	beqz	s1,105a <vprintf+0x27a>
     df2:	e0ca                	sd	s2,64(sp)
     df4:	fc4e                	sd	s3,56(sp)
     df6:	f852                	sd	s4,48(sp)
     df8:	f456                	sd	s5,40(sp)
     dfa:	f05a                	sd	s6,32(sp)
     dfc:	ec5e                	sd	s7,24(sp)
     dfe:	e862                	sd	s8,16(sp)
     e00:	e466                	sd	s9,8(sp)
     e02:	8b2a                	mv	s6,a0
     e04:	8a2e                	mv	s4,a1
     e06:	8bb2                	mv	s7,a2
  state = 0;
     e08:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     e0a:	4901                	li	s2,0
     e0c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     e0e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     e12:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     e16:	06c00c93          	li	s9,108
     e1a:	a00d                	j	e3c <vprintf+0x5c>
        putc(fd, c0);
     e1c:	85a6                	mv	a1,s1
     e1e:	855a                	mv	a0,s6
     e20:	f0dff0ef          	jal	d2c <putc>
     e24:	a019                	j	e2a <vprintf+0x4a>
    } else if(state == '%'){
     e26:	03598363          	beq	s3,s5,e4c <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
     e2a:	0019079b          	addiw	a5,s2,1
     e2e:	893e                	mv	s2,a5
     e30:	873e                	mv	a4,a5
     e32:	97d2                	add	a5,a5,s4
     e34:	0007c483          	lbu	s1,0(a5)
     e38:	20048963          	beqz	s1,104a <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
     e3c:	0004879b          	sext.w	a5,s1
    if(state == 0){
     e40:	fe0993e3          	bnez	s3,e26 <vprintf+0x46>
      if(c0 == '%'){
     e44:	fd579ce3          	bne	a5,s5,e1c <vprintf+0x3c>
        state = '%';
     e48:	89be                	mv	s3,a5
     e4a:	b7c5                	j	e2a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     e4c:	00ea06b3          	add	a3,s4,a4
     e50:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     e54:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     e56:	c681                	beqz	a3,e5e <vprintf+0x7e>
     e58:	9752                	add	a4,a4,s4
     e5a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     e5e:	03878e63          	beq	a5,s8,e9a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
     e62:	05978863          	beq	a5,s9,eb2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     e66:	07500713          	li	a4,117
     e6a:	0ee78263          	beq	a5,a4,f4e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     e6e:	07800713          	li	a4,120
     e72:	12e78463          	beq	a5,a4,f9a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     e76:	07000713          	li	a4,112
     e7a:	14e78963          	beq	a5,a4,fcc <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     e7e:	07300713          	li	a4,115
     e82:	18e78863          	beq	a5,a4,1012 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e86:	02500713          	li	a4,37
     e8a:	04e79463          	bne	a5,a4,ed2 <vprintf+0xf2>
        putc(fd, '%');
     e8e:	85ba                	mv	a1,a4
     e90:	855a                	mv	a0,s6
     e92:	e9bff0ef          	jal	d2c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     e96:	4981                	li	s3,0
     e98:	bf49                	j	e2a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     e9a:	008b8493          	addi	s1,s7,8
     e9e:	4685                	li	a3,1
     ea0:	4629                	li	a2,10
     ea2:	000ba583          	lw	a1,0(s7)
     ea6:	855a                	mv	a0,s6
     ea8:	ea3ff0ef          	jal	d4a <printint>
     eac:	8ba6                	mv	s7,s1
      state = 0;
     eae:	4981                	li	s3,0
     eb0:	bfad                	j	e2a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     eb2:	06400793          	li	a5,100
     eb6:	02f68963          	beq	a3,a5,ee8 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     eba:	06c00793          	li	a5,108
     ebe:	04f68263          	beq	a3,a5,f02 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
     ec2:	07500793          	li	a5,117
     ec6:	0af68063          	beq	a3,a5,f66 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
     eca:	07800793          	li	a5,120
     ece:	0ef68263          	beq	a3,a5,fb2 <vprintf+0x1d2>
        putc(fd, '%');
     ed2:	02500593          	li	a1,37
     ed6:	855a                	mv	a0,s6
     ed8:	e55ff0ef          	jal	d2c <putc>
        putc(fd, c0);
     edc:	85a6                	mv	a1,s1
     ede:	855a                	mv	a0,s6
     ee0:	e4dff0ef          	jal	d2c <putc>
      state = 0;
     ee4:	4981                	li	s3,0
     ee6:	b791                	j	e2a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ee8:	008b8493          	addi	s1,s7,8
     eec:	4685                	li	a3,1
     eee:	4629                	li	a2,10
     ef0:	000ba583          	lw	a1,0(s7)
     ef4:	855a                	mv	a0,s6
     ef6:	e55ff0ef          	jal	d4a <printint>
        i += 1;
     efa:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     efc:	8ba6                	mv	s7,s1
      state = 0;
     efe:	4981                	li	s3,0
        i += 1;
     f00:	b72d                	j	e2a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     f02:	06400793          	li	a5,100
     f06:	02f60763          	beq	a2,a5,f34 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     f0a:	07500793          	li	a5,117
     f0e:	06f60963          	beq	a2,a5,f80 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     f12:	07800793          	li	a5,120
     f16:	faf61ee3          	bne	a2,a5,ed2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f1a:	008b8493          	addi	s1,s7,8
     f1e:	4681                	li	a3,0
     f20:	4641                	li	a2,16
     f22:	000ba583          	lw	a1,0(s7)
     f26:	855a                	mv	a0,s6
     f28:	e23ff0ef          	jal	d4a <printint>
        i += 2;
     f2c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f2e:	8ba6                	mv	s7,s1
      state = 0;
     f30:	4981                	li	s3,0
        i += 2;
     f32:	bde5                	j	e2a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f34:	008b8493          	addi	s1,s7,8
     f38:	4685                	li	a3,1
     f3a:	4629                	li	a2,10
     f3c:	000ba583          	lw	a1,0(s7)
     f40:	855a                	mv	a0,s6
     f42:	e09ff0ef          	jal	d4a <printint>
        i += 2;
     f46:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f48:	8ba6                	mv	s7,s1
      state = 0;
     f4a:	4981                	li	s3,0
        i += 2;
     f4c:	bdf9                	j	e2a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
     f4e:	008b8493          	addi	s1,s7,8
     f52:	4681                	li	a3,0
     f54:	4629                	li	a2,10
     f56:	000ba583          	lw	a1,0(s7)
     f5a:	855a                	mv	a0,s6
     f5c:	defff0ef          	jal	d4a <printint>
     f60:	8ba6                	mv	s7,s1
      state = 0;
     f62:	4981                	li	s3,0
     f64:	b5d9                	j	e2a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f66:	008b8493          	addi	s1,s7,8
     f6a:	4681                	li	a3,0
     f6c:	4629                	li	a2,10
     f6e:	000ba583          	lw	a1,0(s7)
     f72:	855a                	mv	a0,s6
     f74:	dd7ff0ef          	jal	d4a <printint>
        i += 1;
     f78:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f7a:	8ba6                	mv	s7,s1
      state = 0;
     f7c:	4981                	li	s3,0
        i += 1;
     f7e:	b575                	j	e2a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f80:	008b8493          	addi	s1,s7,8
     f84:	4681                	li	a3,0
     f86:	4629                	li	a2,10
     f88:	000ba583          	lw	a1,0(s7)
     f8c:	855a                	mv	a0,s6
     f8e:	dbdff0ef          	jal	d4a <printint>
        i += 2;
     f92:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f94:	8ba6                	mv	s7,s1
      state = 0;
     f96:	4981                	li	s3,0
        i += 2;
     f98:	bd49                	j	e2a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
     f9a:	008b8493          	addi	s1,s7,8
     f9e:	4681                	li	a3,0
     fa0:	4641                	li	a2,16
     fa2:	000ba583          	lw	a1,0(s7)
     fa6:	855a                	mv	a0,s6
     fa8:	da3ff0ef          	jal	d4a <printint>
     fac:	8ba6                	mv	s7,s1
      state = 0;
     fae:	4981                	li	s3,0
     fb0:	bdad                	j	e2a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     fb2:	008b8493          	addi	s1,s7,8
     fb6:	4681                	li	a3,0
     fb8:	4641                	li	a2,16
     fba:	000ba583          	lw	a1,0(s7)
     fbe:	855a                	mv	a0,s6
     fc0:	d8bff0ef          	jal	d4a <printint>
        i += 1;
     fc4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     fc6:	8ba6                	mv	s7,s1
      state = 0;
     fc8:	4981                	li	s3,0
        i += 1;
     fca:	b585                	j	e2a <vprintf+0x4a>
     fcc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     fce:	008b8d13          	addi	s10,s7,8
     fd2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     fd6:	03000593          	li	a1,48
     fda:	855a                	mv	a0,s6
     fdc:	d51ff0ef          	jal	d2c <putc>
  putc(fd, 'x');
     fe0:	07800593          	li	a1,120
     fe4:	855a                	mv	a0,s6
     fe6:	d47ff0ef          	jal	d2c <putc>
     fea:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fec:	00000b97          	auipc	s7,0x0
     ff0:	39cb8b93          	addi	s7,s7,924 # 1388 <digits>
     ff4:	03c9d793          	srli	a5,s3,0x3c
     ff8:	97de                	add	a5,a5,s7
     ffa:	0007c583          	lbu	a1,0(a5)
     ffe:	855a                	mv	a0,s6
    1000:	d2dff0ef          	jal	d2c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1004:	0992                	slli	s3,s3,0x4
    1006:	34fd                	addiw	s1,s1,-1
    1008:	f4f5                	bnez	s1,ff4 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    100a:	8bea                	mv	s7,s10
      state = 0;
    100c:	4981                	li	s3,0
    100e:	6d02                	ld	s10,0(sp)
    1010:	bd29                	j	e2a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1012:	008b8993          	addi	s3,s7,8
    1016:	000bb483          	ld	s1,0(s7)
    101a:	cc91                	beqz	s1,1036 <vprintf+0x256>
        for(; *s; s++)
    101c:	0004c583          	lbu	a1,0(s1)
    1020:	c195                	beqz	a1,1044 <vprintf+0x264>
          putc(fd, *s);
    1022:	855a                	mv	a0,s6
    1024:	d09ff0ef          	jal	d2c <putc>
        for(; *s; s++)
    1028:	0485                	addi	s1,s1,1
    102a:	0004c583          	lbu	a1,0(s1)
    102e:	f9f5                	bnez	a1,1022 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
    1030:	8bce                	mv	s7,s3
      state = 0;
    1032:	4981                	li	s3,0
    1034:	bbdd                	j	e2a <vprintf+0x4a>
          s = "(null)";
    1036:	00000497          	auipc	s1,0x0
    103a:	31a48493          	addi	s1,s1,794 # 1350 <malloc+0x20a>
        for(; *s; s++)
    103e:	02800593          	li	a1,40
    1042:	b7c5                	j	1022 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
    1044:	8bce                	mv	s7,s3
      state = 0;
    1046:	4981                	li	s3,0
    1048:	b3cd                	j	e2a <vprintf+0x4a>
    104a:	6906                	ld	s2,64(sp)
    104c:	79e2                	ld	s3,56(sp)
    104e:	7a42                	ld	s4,48(sp)
    1050:	7aa2                	ld	s5,40(sp)
    1052:	7b02                	ld	s6,32(sp)
    1054:	6be2                	ld	s7,24(sp)
    1056:	6c42                	ld	s8,16(sp)
    1058:	6ca2                	ld	s9,8(sp)
    }
  }
}
    105a:	60e6                	ld	ra,88(sp)
    105c:	6446                	ld	s0,80(sp)
    105e:	64a6                	ld	s1,72(sp)
    1060:	6125                	addi	sp,sp,96
    1062:	8082                	ret

0000000000001064 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1064:	715d                	addi	sp,sp,-80
    1066:	ec06                	sd	ra,24(sp)
    1068:	e822                	sd	s0,16(sp)
    106a:	1000                	addi	s0,sp,32
    106c:	e010                	sd	a2,0(s0)
    106e:	e414                	sd	a3,8(s0)
    1070:	e818                	sd	a4,16(s0)
    1072:	ec1c                	sd	a5,24(s0)
    1074:	03043023          	sd	a6,32(s0)
    1078:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    107c:	8622                	mv	a2,s0
    107e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1082:	d5fff0ef          	jal	de0 <vprintf>
}
    1086:	60e2                	ld	ra,24(sp)
    1088:	6442                	ld	s0,16(sp)
    108a:	6161                	addi	sp,sp,80
    108c:	8082                	ret

000000000000108e <printf>:

void
printf(const char *fmt, ...)
{
    108e:	711d                	addi	sp,sp,-96
    1090:	ec06                	sd	ra,24(sp)
    1092:	e822                	sd	s0,16(sp)
    1094:	1000                	addi	s0,sp,32
    1096:	e40c                	sd	a1,8(s0)
    1098:	e810                	sd	a2,16(s0)
    109a:	ec14                	sd	a3,24(s0)
    109c:	f018                	sd	a4,32(s0)
    109e:	f41c                	sd	a5,40(s0)
    10a0:	03043823          	sd	a6,48(s0)
    10a4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10a8:	00840613          	addi	a2,s0,8
    10ac:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10b0:	85aa                	mv	a1,a0
    10b2:	4505                	li	a0,1
    10b4:	d2dff0ef          	jal	de0 <vprintf>
}
    10b8:	60e2                	ld	ra,24(sp)
    10ba:	6442                	ld	s0,16(sp)
    10bc:	6125                	addi	sp,sp,96
    10be:	8082                	ret

00000000000010c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10c0:	1141                	addi	sp,sp,-16
    10c2:	e406                	sd	ra,8(sp)
    10c4:	e022                	sd	s0,0(sp)
    10c6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10c8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10cc:	00001797          	auipc	a5,0x1
    10d0:	f447b783          	ld	a5,-188(a5) # 2010 <freep>
    10d4:	a02d                	j	10fe <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    10d6:	4618                	lw	a4,8(a2)
    10d8:	9f2d                	addw	a4,a4,a1
    10da:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10de:	6398                	ld	a4,0(a5)
    10e0:	6310                	ld	a2,0(a4)
    10e2:	a83d                	j	1120 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    10e4:	ff852703          	lw	a4,-8(a0)
    10e8:	9f31                	addw	a4,a4,a2
    10ea:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    10ec:	ff053683          	ld	a3,-16(a0)
    10f0:	a091                	j	1134 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10f2:	6398                	ld	a4,0(a5)
    10f4:	00e7e463          	bltu	a5,a4,10fc <free+0x3c>
    10f8:	00e6ea63          	bltu	a3,a4,110c <free+0x4c>
{
    10fc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10fe:	fed7fae3          	bgeu	a5,a3,10f2 <free+0x32>
    1102:	6398                	ld	a4,0(a5)
    1104:	00e6e463          	bltu	a3,a4,110c <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1108:	fee7eae3          	bltu	a5,a4,10fc <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    110c:	ff852583          	lw	a1,-8(a0)
    1110:	6390                	ld	a2,0(a5)
    1112:	02059813          	slli	a6,a1,0x20
    1116:	01c85713          	srli	a4,a6,0x1c
    111a:	9736                	add	a4,a4,a3
    111c:	fae60de3          	beq	a2,a4,10d6 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    1120:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1124:	4790                	lw	a2,8(a5)
    1126:	02061593          	slli	a1,a2,0x20
    112a:	01c5d713          	srli	a4,a1,0x1c
    112e:	973e                	add	a4,a4,a5
    1130:	fae68ae3          	beq	a3,a4,10e4 <free+0x24>
    p->s.ptr = bp->s.ptr;
    1134:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1136:	00001717          	auipc	a4,0x1
    113a:	ecf73d23          	sd	a5,-294(a4) # 2010 <freep>
}
    113e:	60a2                	ld	ra,8(sp)
    1140:	6402                	ld	s0,0(sp)
    1142:	0141                	addi	sp,sp,16
    1144:	8082                	ret

0000000000001146 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1146:	7139                	addi	sp,sp,-64
    1148:	fc06                	sd	ra,56(sp)
    114a:	f822                	sd	s0,48(sp)
    114c:	f04a                	sd	s2,32(sp)
    114e:	ec4e                	sd	s3,24(sp)
    1150:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1152:	02051993          	slli	s3,a0,0x20
    1156:	0209d993          	srli	s3,s3,0x20
    115a:	09bd                	addi	s3,s3,15
    115c:	0049d993          	srli	s3,s3,0x4
    1160:	2985                	addiw	s3,s3,1
    1162:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1164:	00001517          	auipc	a0,0x1
    1168:	eac53503          	ld	a0,-340(a0) # 2010 <freep>
    116c:	c905                	beqz	a0,119c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    116e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1170:	4798                	lw	a4,8(a5)
    1172:	09377663          	bgeu	a4,s3,11fe <malloc+0xb8>
    1176:	f426                	sd	s1,40(sp)
    1178:	e852                	sd	s4,16(sp)
    117a:	e456                	sd	s5,8(sp)
    117c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    117e:	8a4e                	mv	s4,s3
    1180:	6705                	lui	a4,0x1
    1182:	00e9f363          	bgeu	s3,a4,1188 <malloc+0x42>
    1186:	6a05                	lui	s4,0x1
    1188:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    118c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1190:	00001497          	auipc	s1,0x1
    1194:	e8048493          	addi	s1,s1,-384 # 2010 <freep>
  if(p == (char*)-1)
    1198:	5afd                	li	s5,-1
    119a:	a83d                	j	11d8 <malloc+0x92>
    119c:	f426                	sd	s1,40(sp)
    119e:	e852                	sd	s4,16(sp)
    11a0:	e456                	sd	s5,8(sp)
    11a2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11a4:	00001797          	auipc	a5,0x1
    11a8:	ee478793          	addi	a5,a5,-284 # 2088 <base>
    11ac:	00001717          	auipc	a4,0x1
    11b0:	e6f73223          	sd	a5,-412(a4) # 2010 <freep>
    11b4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11b6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11ba:	b7d1                	j	117e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    11bc:	6398                	ld	a4,0(a5)
    11be:	e118                	sd	a4,0(a0)
    11c0:	a899                	j	1216 <malloc+0xd0>
  hp->s.size = nu;
    11c2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11c6:	0541                	addi	a0,a0,16
    11c8:	ef9ff0ef          	jal	10c0 <free>
  return freep;
    11cc:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    11ce:	c125                	beqz	a0,122e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11d0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11d2:	4798                	lw	a4,8(a5)
    11d4:	03277163          	bgeu	a4,s2,11f6 <malloc+0xb0>
    if(p == freep)
    11d8:	6098                	ld	a4,0(s1)
    11da:	853e                	mv	a0,a5
    11dc:	fef71ae3          	bne	a4,a5,11d0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    11e0:	8552                	mv	a0,s4
    11e2:	af3ff0ef          	jal	cd4 <sbrk>
  if(p == (char*)-1)
    11e6:	fd551ee3          	bne	a0,s5,11c2 <malloc+0x7c>
        return 0;
    11ea:	4501                	li	a0,0
    11ec:	74a2                	ld	s1,40(sp)
    11ee:	6a42                	ld	s4,16(sp)
    11f0:	6aa2                	ld	s5,8(sp)
    11f2:	6b02                	ld	s6,0(sp)
    11f4:	a03d                	j	1222 <malloc+0xdc>
    11f6:	74a2                	ld	s1,40(sp)
    11f8:	6a42                	ld	s4,16(sp)
    11fa:	6aa2                	ld	s5,8(sp)
    11fc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    11fe:	fae90fe3          	beq	s2,a4,11bc <malloc+0x76>
        p->s.size -= nunits;
    1202:	4137073b          	subw	a4,a4,s3
    1206:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1208:	02071693          	slli	a3,a4,0x20
    120c:	01c6d713          	srli	a4,a3,0x1c
    1210:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1212:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1216:	00001717          	auipc	a4,0x1
    121a:	dea73d23          	sd	a0,-518(a4) # 2010 <freep>
      return (void*)(p + 1);
    121e:	01078513          	addi	a0,a5,16
  }
}
    1222:	70e2                	ld	ra,56(sp)
    1224:	7442                	ld	s0,48(sp)
    1226:	7902                	ld	s2,32(sp)
    1228:	69e2                	ld	s3,24(sp)
    122a:	6121                	addi	sp,sp,64
    122c:	8082                	ret
    122e:	74a2                	ld	s1,40(sp)
    1230:	6a42                	ld	s4,16(sp)
    1232:	6aa2                	ld	s5,8(sp)
    1234:	6b02                	ld	s6,0(sp)
    1236:	b7f5                	j	1222 <malloc+0xdc>
