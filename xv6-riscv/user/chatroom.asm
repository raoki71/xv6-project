
user/_chatroom:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <panic>:
int checkBotNames(char *msgBuf, int numBots, char *botNames[]);


//handle exception
void
panic(char *s){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
   a:	00001597          	auipc	a1,0x1
   e:	d7658593          	addi	a1,a1,-650 # d80 <malloc+0xf8>
  12:	4509                	li	a0,2
  14:	393000ef          	jal	ba6 <fprintf>
  exit(1);
  18:	4505                	li	a0,1
  1a:	7b4000ef          	jal	7ce <exit>

000000000000001e <fork1>:
}


//create a new process
int
fork1(void){
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  int pid;
  pid = fork();
  26:	7a0000ef          	jal	7c6 <fork>
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
  3c:	d5050513          	addi	a0,a0,-688 # d88 <malloc+0x100>
  40:	fc1ff0ef          	jal	0 <panic>

0000000000000044 <pipe1>:

//create a pipe
void
pipe1(int fd[2]){
  44:	1141                	addi	sp,sp,-16
  46:	e406                	sd	ra,8(sp)
  48:	e022                	sd	s0,0(sp)
  4a:	0800                	addi	s0,sp,16
 int rc = pipe(fd);
  4c:	792000ef          	jal	7de <pipe>
 if(rc<0){
  50:	00054663          	bltz	a0,5c <pipe1+0x18>
   panic("Fail to create a pipe.");
 }
}
  54:	60a2                	ld	ra,8(sp)
  56:	6402                	ld	s0,0(sp)
  58:	0141                	addi	sp,sp,16
  5a:	8082                	ret
   panic("Fail to create a pipe.");
  5c:	00001517          	auipc	a0,0x1
  60:	d3450513          	addi	a0,a0,-716 # d90 <malloc+0x108>
  64:	f9dff0ef          	jal	0 <panic>

0000000000000068 <gets1>:

//get a string from std input and save it to msgBuf
void
gets1(char msgBuf[MAX_MSG_LEN]){
  68:	1101                	addi	sp,sp,-32
  6a:	ec06                	sd	ra,24(sp)
  6c:	e822                	sd	s0,16(sp)
  6e:	e426                	sd	s1,8(sp)
  70:	1000                	addi	s0,sp,32
  72:	84aa                	mv	s1,a0
    gets(msgBuf,MAX_MSG_LEN);
  74:	20000593          	li	a1,512
  78:	596000ef          	jal	60e <gets>
	int len = strlen(msgBuf);
  7c:	8526                	mv	a0,s1
  7e:	514000ef          	jal	592 <strlen>
	msgBuf[len-1]='\0';
  82:	94aa                	add	s1,s1,a0
  84:	fe048fa3          	sb	zero,-1(s1)
}
  88:	60e2                	ld	ra,24(sp)
  8a:	6442                	ld	s0,16(sp)
  8c:	64a2                	ld	s1,8(sp)
  8e:	6105                	addi	sp,sp,32
  90:	8082                	ret

0000000000000092 <checkBotNames>:
// Helper function to set an invalid flag in the case when the user inputs an invalid bot name
// Initially set it to 1 so that when it encounters a valid name, it can simply exit and inform that the input is safe
int
checkBotNames(char *msgBuf, int numBots, char *botNames[]){
    int flag = 1;
    for(int i=1; i<numBots; i++) {
  92:	4785                	li	a5,1
  94:	04b7d463          	bge	a5,a1,dc <checkBotNames+0x4a>
checkBotNames(char *msgBuf, int numBots, char *botNames[]){
  98:	7179                	addi	sp,sp,-48
  9a:	f406                	sd	ra,40(sp)
  9c:	f022                	sd	s0,32(sp)
  9e:	ec26                	sd	s1,24(sp)
  a0:	e84a                	sd	s2,16(sp)
  a2:	e44e                	sd	s3,8(sp)
  a4:	1800                	addi	s0,sp,48
  a6:	89aa                	mv	s3,a0
  a8:	00860493          	addi	s1,a2,8
  ac:	ffe5891b          	addiw	s2,a1,-2
  b0:	02091793          	slli	a5,s2,0x20
  b4:	01d7d913          	srli	s2,a5,0x1d
  b8:	0641                	addi	a2,a2,16
  ba:	9932                	add	s2,s2,a2
        if(strcmp(msgBuf, botNames[i])==0){ 
  bc:	608c                	ld	a1,0(s1)
  be:	854e                	mv	a0,s3
  c0:	4a2000ef          	jal	562 <strcmp>
  c4:	c509                	beqz	a0,ce <checkBotNames+0x3c>
    for(int i=1; i<numBots; i++) {
  c6:	04a1                	addi	s1,s1,8
  c8:	ff249ae3          	bne	s1,s2,bc <checkBotNames+0x2a>
            return flag = 0;
        }
    }
    return flag;
  cc:	4505                	li	a0,1
}
  ce:	70a2                	ld	ra,40(sp)
  d0:	7402                	ld	s0,32(sp)
  d2:	64e2                	ld	s1,24(sp)
  d4:	6942                	ld	s2,16(sp)
  d6:	69a2                	ld	s3,8(sp)
  d8:	6145                	addi	sp,sp,48
  da:	8082                	ret
    return flag;
  dc:	4505                	li	a0,1
}
  de:	8082                	ret

00000000000000e0 <chatbot>:
 *  int numBots     : The number of all chatbots passed in the arguments of main()
 *  char *botNames[]: The list of chatbot names. Used for checking an invalid input by the user
 * 
 */
void
chatbot(int myId, char *myName, int numBots, char *botNames[]){
  e0:	b7010113          	addi	sp,sp,-1168
  e4:	48113423          	sd	ra,1160(sp)
  e8:	48813023          	sd	s0,1152(sp)
  ec:	46913c23          	sd	s1,1144(sp)
  f0:	47213823          	sd	s2,1136(sp)
  f4:	47313423          	sd	s3,1128(sp)
  f8:	47413023          	sd	s4,1120(sp)
  fc:	45513c23          	sd	s5,1112(sp)
 100:	45613823          	sd	s6,1104(sp)
 104:	45713423          	sd	s7,1096(sp)
 108:	45813023          	sd	s8,1088(sp)
 10c:	43913c23          	sd	s9,1080(sp)
 110:	43a13823          	sd	s10,1072(sp)
 114:	43b13423          	sd	s11,1064(sp)
 118:	49010413          	addi	s0,sp,1168
 11c:	b6a43c23          	sd	a0,-1160(s0)
 120:	8a2e                	mv	s4,a1
 122:	8ab2                	mv	s5,a2
 124:	8b36                	mv	s6,a3
    //close un-used pipe descriptors
    for(int i=0; i<myId-1; i++){
 126:	fff5099b          	addiw	s3,a0,-1
 12a:	03305a63          	blez	s3,15e <chatbot+0x7e>
 12e:	00002497          	auipc	s1,0x2
 132:	ee248493          	addi	s1,s1,-286 # 2010 <fd>
 136:	ffe5091b          	addiw	s2,a0,-2
 13a:	02091793          	slli	a5,s2,0x20
 13e:	01d7d913          	srli	s2,a5,0x1d
 142:	00002797          	auipc	a5,0x2
 146:	ed678793          	addi	a5,a5,-298 # 2018 <fd+0x8>
 14a:	993e                	add	s2,s2,a5
        close(fd[i][0]);
 14c:	4088                	lw	a0,0(s1)
 14e:	6a8000ef          	jal	7f6 <close>
        close(fd[i][1]);
 152:	40c8                	lw	a0,4(s1)
 154:	6a2000ef          	jal	7f6 <close>
    for(int i=0; i<myId-1; i++){
 158:	04a1                	addi	s1,s1,8
 15a:	ff2499e3          	bne	s1,s2,14c <chatbot+0x6c>
    }
    close(fd[myId-1][1]);
 15e:	00002497          	auipc	s1,0x2
 162:	eb248493          	addi	s1,s1,-334 # 2010 <fd>
 166:	00399793          	slli	a5,s3,0x3
 16a:	97a6                	add	a5,a5,s1
 16c:	43c8                	lw	a0,4(a5)
 16e:	688000ef          	jal	7f6 <close>
    close(fd[myId][0]);
 172:	b7843903          	ld	s2,-1160(s0)
 176:	00391793          	slli	a5,s2,0x3
 17a:	94be                	add	s1,s1,a5
 17c:	4088                	lw	a0,0(s1)
 17e:	678000ef          	jal	7f6 <close>

    //loop
    while(1){
        //to get msg from the previous chatbot
        char recvMsg[MAX_MSG_LEN];
        read(fd[myId-1][0], recvMsg, MAX_MSG_LEN);
 182:	b9040d93          	addi	s11,s0,-1136
 186:	00002797          	auipc	a5,0x2
 18a:	e8a78793          	addi	a5,a5,-374 # 2010 <fd>
 18e:	098e                	slli	s3,s3,0x3
 190:	01378733          	add	a4,a5,s3
 194:	b8e43423          	sd	a4,-1144(s0)
                        }
                    }
                }
                
                //pass the msg to the next one on the ring
                write(fd[myId][1], msgBuf, MAX_MSG_LEN);
 198:	b8943023          	sd	s1,-1152(s0)
 19c:	a231                	j	2a8 <chatbot+0x1c8>
                printf("Hello, this is chatbot %s. Please type:\n", myName);
 19e:	85d2                	mv	a1,s4
 1a0:	00001517          	auipc	a0,0x1
 1a4:	c2050513          	addi	a0,a0,-992 # dc0 <malloc+0x138>
 1a8:	229000ef          	jal	bd0 <printf>
                gets1(msgBuf);
 1ac:	d9040493          	addi	s1,s0,-624
 1b0:	8526                	mv	a0,s1
 1b2:	eb7ff0ef          	jal	68 <gets1>
                printf("I heard you said: %s\n", msgBuf);
 1b6:	85a6                	mv	a1,s1
 1b8:	00001517          	auipc	a0,0x1
 1bc:	c3850513          	addi	a0,a0,-968 # df0 <malloc+0x168>
 1c0:	211000ef          	jal	bd0 <printf>
                int invalidFlg = 1;
 1c4:	4c05                	li	s8,1
                int styFlg=0;
 1c6:	4c81                	li	s9,0
                    if(strcmp(msgBuf, ":CHANGE")==0||strcmp(msgBuf, ":change")==0) {
 1c8:	00001d17          	auipc	s10,0x1
 1cc:	c40d0d13          	addi	s10,s10,-960 # e08 <malloc+0x180>
                    if(strcmp(msgBuf,":EXIT")==0||strcmp(msgBuf,":exit")==0){
 1d0:	00001917          	auipc	s2,0x1
 1d4:	bd890913          	addi	s2,s2,-1064 # da8 <malloc+0x120>
 1d8:	00001997          	auipc	s3,0x1
 1dc:	bd898993          	addi	s3,s3,-1064 # db0 <malloc+0x128>
 1e0:	a0bd                	j	24e <chatbot+0x16e>
                        printf("OK, please type the name of the bot you want to chat next:\n");
 1e2:	00001517          	auipc	a0,0x1
 1e6:	c3650513          	addi	a0,a0,-970 # e18 <malloc+0x190>
 1ea:	1e7000ef          	jal	bd0 <printf>
                        gets1(msgBuf);
 1ee:	8526                	mv	a0,s1
 1f0:	e79ff0ef          	jal	68 <gets1>
                        invalidFlg = checkBotNames(msgBuf, numBots, botNames);
 1f4:	865a                	mv	a2,s6
 1f6:	85d6                	mv	a1,s5
 1f8:	8526                	mv	a0,s1
 1fa:	e99ff0ef          	jal	92 <checkBotNames>
 1fe:	8c2a                	mv	s8,a0
                        if(strcmp(msgBuf, myName)==0){ styFlg = 1;}
 200:	85d2                	mv	a1,s4
 202:	8526                	mv	a0,s1
 204:	35e000ef          	jal	562 <strcmp>
 208:	00153513          	seqz	a0,a0
 20c:	00ace533          	or	a0,s9,a0
 210:	00050c9b          	sext.w	s9,a0
                        chgFlg = 1;
 214:	4b85                	li	s7,1
                    if(strcmp(msgBuf,":EXIT")==0||strcmp(msgBuf,":exit")==0){
 216:	85ca                	mv	a1,s2
 218:	8526                	mv	a0,s1
 21a:	348000ef          	jal	562 <strcmp>
 21e:	c539                	beqz	a0,26c <chatbot+0x18c>
 220:	85ce                	mv	a1,s3
 222:	8526                	mv	a0,s1
 224:	33e000ef          	jal	562 <strcmp>
 228:	c131                	beqz	a0,26c <chatbot+0x18c>
                        if(!chgFlg) {   //if the :change FLAG is not raised, keep continue chatting with the current bot
 22a:	0c0b9f63          	bnez	s7,308 <chatbot+0x228>
                            printf("Please continue typing:\n");
 22e:	00001517          	auipc	a0,0x1
 232:	c5250513          	addi	a0,a0,-942 # e80 <malloc+0x1f8>
 236:	19b000ef          	jal	bd0 <printf>
                            gets1(msgBuf);
 23a:	8526                	mv	a0,s1
 23c:	e2dff0ef          	jal	68 <gets1>
                            printf("I heard you said: %s\n", msgBuf);
 240:	85a6                	mv	a1,s1
 242:	00001517          	auipc	a0,0x1
 246:	bae50513          	addi	a0,a0,-1106 # df0 <malloc+0x168>
 24a:	187000ef          	jal	bd0 <printf>
                    if(strcmp(msgBuf, ":CHANGE")==0||strcmp(msgBuf, ":change")==0) {
 24e:	85ea                	mv	a1,s10
 250:	8526                	mv	a0,s1
 252:	310000ef          	jal	562 <strcmp>
 256:	d551                	beqz	a0,1e2 <chatbot+0x102>
 258:	00001597          	auipc	a1,0x1
 25c:	bb858593          	addi	a1,a1,-1096 # e10 <malloc+0x188>
 260:	8526                	mv	a0,s1
 262:	300000ef          	jal	562 <strcmp>
 266:	4b81                	li	s7,0
 268:	f55d                	bnez	a0,216 <chatbot+0x136>
 26a:	bfa5                	j	1e2 <chatbot+0x102>
                        printf("OK, the chatroom is closing ...\n");
 26c:	00001517          	auipc	a0,0x1
 270:	bec50513          	addi	a0,a0,-1044 # e58 <malloc+0x1d0>
 274:	15d000ef          	jal	bd0 <printf>
                while(!chgFlg && !extFlg){
 278:	a839                	j	296 <chatbot+0x1b6>
                                    printf("I heard you said: %s\n", msgBuf);
 27a:	d9040593          	addi	a1,s0,-624
 27e:	00001517          	auipc	a0,0x1
 282:	b7250513          	addi	a0,a0,-1166 # df0 <malloc+0x168>
 286:	14b000ef          	jal	bd0 <printf>
                                    printf("OK, the chatroom is closing ...\n");
 28a:	00001517          	auipc	a0,0x1
 28e:	bce50513          	addi	a0,a0,-1074 # e58 <malloc+0x1d0>
 292:	13f000ef          	jal	bd0 <printf>
                write(fd[myId][1], msgBuf, MAX_MSG_LEN);
 296:	20000613          	li	a2,512
 29a:	d9040593          	addi	a1,s0,-624
 29e:	b8043783          	ld	a5,-1152(s0)
 2a2:	43c8                	lw	a0,4(a5)
 2a4:	54a000ef          	jal	7ee <write>
        read(fd[myId-1][0], recvMsg, MAX_MSG_LEN);
 2a8:	20000613          	li	a2,512
 2ac:	85ee                	mv	a1,s11
 2ae:	b8843783          	ld	a5,-1144(s0)
 2b2:	4388                	lw	a0,0(a5)
 2b4:	532000ef          	jal	7e6 <read>
        if(strcmp(recvMsg,":EXIT")!=0 && strcmp(recvMsg,":exit")!=0){//if the received msg is not EXIT/exit: continue chatting 
 2b8:	00001597          	auipc	a1,0x1
 2bc:	af058593          	addi	a1,a1,-1296 # da8 <malloc+0x120>
 2c0:	856e                	mv	a0,s11
 2c2:	2a0000ef          	jal	562 <strcmp>
 2c6:	c169                	beqz	a0,388 <chatbot+0x2a8>
 2c8:	00001597          	auipc	a1,0x1
 2cc:	ae858593          	addi	a1,a1,-1304 # db0 <malloc+0x128>
 2d0:	856e                	mv	a0,s11
 2d2:	290000ef          	jal	562 <strcmp>
 2d6:	c94d                	beqz	a0,388 <chatbot+0x2a8>
            if(strcmp(recvMsg, ":START")==0||strcmp(recvMsg, myName)==0) {
 2d8:	00001597          	auipc	a1,0x1
 2dc:	ae058593          	addi	a1,a1,-1312 # db8 <malloc+0x130>
 2e0:	856e                	mv	a0,s11
 2e2:	280000ef          	jal	562 <strcmp>
 2e6:	ea050ce3          	beqz	a0,19e <chatbot+0xbe>
 2ea:	85d2                	mv	a1,s4
 2ec:	856e                	mv	a0,s11
 2ee:	274000ef          	jal	562 <strcmp>
 2f2:	ea0506e3          	beqz	a0,19e <chatbot+0xbe>
            } else {
                //Upon ":CHANGE" or ":change", if recvMsg was different from the current bot name (i.e. myName) simply skip to the next bot until it hits
                //Acts like a ring passing a message multiple times
                write(fd[myId][1], recvMsg, MAX_MSG_LEN); 
 2f6:	20000613          	li	a2,512
 2fa:	85ee                	mv	a1,s11
 2fc:	b8043783          	ld	a5,-1152(s0)
 300:	43c8                	lw	a0,4(a5)
 302:	4ec000ef          	jal	7ee <write>
    while(1){
 306:	b74d                	j	2a8 <chatbot+0x1c8>
                                printf("There is no bot named %s. Please type a valid bot name:\n", msgBuf);
 308:	00001b97          	auipc	s7,0x1
 30c:	b98b8b93          	addi	s7,s7,-1128 # ea0 <malloc+0x218>
                            while(invalidFlg) {
 310:	020c0e63          	beqz	s8,34c <chatbot+0x26c>
                                printf("There is no bot named %s. Please type a valid bot name:\n", msgBuf);
 314:	85a6                	mv	a1,s1
 316:	855e                	mv	a0,s7
 318:	0b9000ef          	jal	bd0 <printf>
                                gets1(msgBuf);
 31c:	8526                	mv	a0,s1
 31e:	d4bff0ef          	jal	68 <gets1>
                                if(strcmp(msgBuf, ":EXIT")!=0&&strcmp(msgBuf, ":exit")!=0) {
 322:	85ca                	mv	a1,s2
 324:	8526                	mv	a0,s1
 326:	23c000ef          	jal	562 <strcmp>
 32a:	d921                	beqz	a0,27a <chatbot+0x19a>
 32c:	85ce                	mv	a1,s3
 32e:	8526                	mv	a0,s1
 330:	232000ef          	jal	562 <strcmp>
 334:	d139                	beqz	a0,27a <chatbot+0x19a>
                                    if(strcmp(msgBuf, myName)==0){ 
 336:	85d2                	mv	a1,s4
 338:	8526                	mv	a0,s1
 33a:	228000ef          	jal	562 <strcmp>
 33e:	c909                	beqz	a0,350 <chatbot+0x270>
                                        invalidFlg = checkBotNames(msgBuf, numBots, botNames);
 340:	865a                	mv	a2,s6
 342:	85d6                	mv	a1,s5
 344:	8526                	mv	a0,s1
 346:	d4dff0ef          	jal	92 <checkBotNames>
                            while(invalidFlg) {
 34a:	f569                	bnez	a0,314 <chatbot+0x234>
                                if(styFlg) {    //Entered bot-name is the same, so stay
 34c:	020c8563          	beqz	s9,376 <chatbot+0x296>
                                    printf("Great, you choose to stay. Please continue typing:\n");
 350:	00001517          	auipc	a0,0x1
 354:	b9050513          	addi	a0,a0,-1136 # ee0 <malloc+0x258>
 358:	079000ef          	jal	bd0 <printf>
                                    gets1(msgBuf);
 35c:	8526                	mv	a0,s1
 35e:	d0bff0ef          	jal	68 <gets1>
                                    printf("I heard you said: %s\n", msgBuf);
 362:	85a6                	mv	a1,s1
 364:	00001517          	auipc	a0,0x1
 368:	a8c50513          	addi	a0,a0,-1396 # df0 <malloc+0x168>
 36c:	065000ef          	jal	bd0 <printf>
 370:	4c01                	li	s8,0
                                    styFlg = 0;
 372:	4c81                	li	s9,0
                while(!chgFlg && !extFlg){
 374:	bde9                	j	24e <chatbot+0x16e>
                                    printf("OK, I will send you to chat with %s.\n", msgBuf);
 376:	d9040593          	addi	a1,s0,-624
 37a:	00001517          	auipc	a0,0x1
 37e:	b9e50513          	addi	a0,a0,-1122 # f18 <malloc+0x290>
 382:	04f000ef          	jal	bd0 <printf>
                while(!chgFlg && !extFlg){
 386:	bf01                	j	296 <chatbot+0x1b6>
            }

            

        } else {//if receives EXIT/exit: pass the msg down and exit myself
            write(fd[myId][1], recvMsg, MAX_MSG_LEN);
 388:	b7843783          	ld	a5,-1160(s0)
 38c:	078e                	slli	a5,a5,0x3
 38e:	00002717          	auipc	a4,0x2
 392:	c8270713          	addi	a4,a4,-894 # 2010 <fd>
 396:	97ba                	add	a5,a5,a4
 398:	20000613          	li	a2,512
 39c:	b9040593          	addi	a1,s0,-1136
 3a0:	43c8                	lw	a0,4(a5)
 3a2:	44c000ef          	jal	7ee <write>
            exit(0);    
 3a6:	4501                	li	a0,0
 3a8:	426000ef          	jal	7ce <exit>

00000000000003ac <main>:


//script for parent process
int
main(int argc, char *argv[])
{
 3ac:	db010113          	addi	sp,sp,-592
 3b0:	24113423          	sd	ra,584(sp)
 3b4:	24813023          	sd	s0,576(sp)
 3b8:	23413023          	sd	s4,544(sp)
 3bc:	0c80                	addi	s0,sp,592
 3be:	8a2e                	mv	s4,a1
    if(argc<3||argc>MAX_NUM_CHATBOT+1){
 3c0:	ffd5071b          	addiw	a4,a0,-3
 3c4:	478d                	li	a5,3
 3c6:	02e7f963          	bgeu	a5,a4,3f8 <main+0x4c>
 3ca:	22913c23          	sd	s1,568(sp)
 3ce:	23213823          	sd	s2,560(sp)
 3d2:	23313423          	sd	s3,552(sp)
 3d6:	21513c23          	sd	s5,536(sp)
 3da:	21613823          	sd	s6,528(sp)
 3de:	21713423          	sd	s7,520(sp)
        printf("Usage: %s <list of names for up to %d chatbots>\n", argv[0], MAX_NUM_CHATBOT);
 3e2:	4615                	li	a2,5
 3e4:	618c                	ld	a1,0(a1)
 3e6:	00001517          	auipc	a0,0x1
 3ea:	b5a50513          	addi	a0,a0,-1190 # f40 <malloc+0x2b8>
 3ee:	7e2000ef          	jal	bd0 <printf>
        exit(1);
 3f2:	4505                	li	a0,1
 3f4:	3da000ef          	jal	7ce <exit>
 3f8:	22913c23          	sd	s1,568(sp)
 3fc:	23213823          	sd	s2,560(sp)
 400:	23313423          	sd	s3,552(sp)
 404:	21513c23          	sd	s5,536(sp)
 408:	89aa                	mv	s3,a0
    }

    pipe1(fd[0]); //create the first pipe #0
 40a:	00002517          	auipc	a0,0x2
 40e:	c0650513          	addi	a0,a0,-1018 # 2010 <fd>
 412:	c33ff0ef          	jal	44 <pipe1>
    for(int i=1; i<argc; i++){
 416:	00002a97          	auipc	s5,0x2
 41a:	c02a8a93          	addi	s5,s5,-1022 # 2018 <fd+0x8>
    pipe1(fd[0]); //create the first pipe #0
 41e:	84d6                	mv	s1,s5
    for(int i=1; i<argc; i++){
 420:	4905                	li	s2,1
 422:	a011                	j	426 <main+0x7a>
 424:	893e                	mv	s2,a5
        pipe1(fd[i]); //create one new pipe for each chatbot
 426:	8526                	mv	a0,s1
 428:	c1dff0ef          	jal	44 <pipe1>
        //to create child proc #i (emulating chatbot #i)
        if(fork1()==0){
 42c:	bf3ff0ef          	jal	1e <fork1>
 430:	0e050363          	beqz	a0,516 <main+0x16a>
    for(int i=1; i<argc; i++){
 434:	0019079b          	addiw	a5,s2,1
 438:	04a1                	addi	s1,s1,8
 43a:	fef995e3          	bne	s3,a5,424 <main+0x78>
 43e:	21613823          	sd	s6,528(sp)
 442:	21713423          	sd	s7,520(sp)
            chatbot(i,argv[i],argc,argv);
        }    
    }

    //close the fds not used any longer
    close(fd[0][0]); 
 446:	00002497          	auipc	s1,0x2
 44a:	bca48493          	addi	s1,s1,-1078 # 2010 <fd>
 44e:	4088                	lw	a0,0(s1)
 450:	3a6000ef          	jal	7f6 <close>
    close(fd[argc-1][1]);
 454:	00391793          	slli	a5,s2,0x3
 458:	94be                	add	s1,s1,a5
 45a:	40c8                	lw	a0,4(s1)
 45c:	39a000ef          	jal	7f6 <close>
    for(int i=1; i<argc-1; i++){
 460:	ffe9049b          	addiw	s1,s2,-2
 464:	02049793          	slli	a5,s1,0x20
 468:	01d7d493          	srli	s1,a5,0x1d
 46c:	00002797          	auipc	a5,0x2
 470:	bb478793          	addi	a5,a5,-1100 # 2020 <fd+0x10>
 474:	94be                	add	s1,s1,a5
        close(fd[i][0]);
 476:	000aa503          	lw	a0,0(s5)
 47a:	37c000ef          	jal	7f6 <close>
        close(fd[i][1]);
 47e:	004aa503          	lw	a0,4(s5)
 482:	374000ef          	jal	7f6 <close>
    for(int i=1; i<argc-1; i++){
 486:	0aa1                	addi	s5,s5,8
 488:	fe9a97e3          	bne	s5,s1,476 <main+0xca>
    }

    //send the START msg to the first chatbot
    write(fd[0][1], ":START", 6);
 48c:	4619                	li	a2,6
 48e:	00001597          	auipc	a1,0x1
 492:	92a58593          	addi	a1,a1,-1750 # db8 <malloc+0x130>
 496:	00002517          	auipc	a0,0x2
 49a:	b7e52503          	lw	a0,-1154(a0) # 2014 <fd+0x4>
 49e:	350000ef          	jal	7ee <write>

    //loop: when receive a token from predecessor, pass it to successor
    while(1){
        char recvMsg[MAX_MSG_LEN];
        read(fd[argc-1][0], recvMsg, MAX_MSG_LEN); 
 4a2:	db040493          	addi	s1,s0,-592
 4a6:	00002a97          	auipc	s5,0x2
 4aa:	b6aa8a93          	addi	s5,s5,-1174 # 2010 <fd>
 4ae:	00391a13          	slli	s4,s2,0x3
 4b2:	9a56                	add	s4,s4,s5
 4b4:	20000993          	li	s3,512
        write(fd[0][1], recvMsg, MAX_MSG_LEN);
	    if(strcmp(recvMsg,":EXIT")==0||strcmp(recvMsg,":exit")==0) break; //break from the loop if the msg is EXIT
 4b8:	00001b17          	auipc	s6,0x1
 4bc:	8f0b0b13          	addi	s6,s6,-1808 # da8 <malloc+0x120>
 4c0:	00001b97          	auipc	s7,0x1
 4c4:	8f0b8b93          	addi	s7,s7,-1808 # db0 <malloc+0x128>
        read(fd[argc-1][0], recvMsg, MAX_MSG_LEN); 
 4c8:	864e                	mv	a2,s3
 4ca:	85a6                	mv	a1,s1
 4cc:	000a2503          	lw	a0,0(s4)
 4d0:	316000ef          	jal	7e6 <read>
        write(fd[0][1], recvMsg, MAX_MSG_LEN);
 4d4:	864e                	mv	a2,s3
 4d6:	85a6                	mv	a1,s1
 4d8:	004aa503          	lw	a0,4(s5)
 4dc:	312000ef          	jal	7ee <write>
	    if(strcmp(recvMsg,":EXIT")==0||strcmp(recvMsg,":exit")==0) break; //break from the loop if the msg is EXIT
 4e0:	85da                	mv	a1,s6
 4e2:	8526                	mv	a0,s1
 4e4:	07e000ef          	jal	562 <strcmp>
 4e8:	c511                	beqz	a0,4f4 <main+0x148>
 4ea:	85de                	mv	a1,s7
 4ec:	8526                	mv	a0,s1
 4ee:	074000ef          	jal	562 <strcmp>
 4f2:	f979                	bnez	a0,4c8 <main+0x11c>
    }

    //exit after all children exit
    for(int i=1; i<=argc; i++) wait(0);
 4f4:	2909                	addiw	s2,s2,2
 4f6:	4485                	li	s1,1
 4f8:	4501                	li	a0,0
 4fa:	2dc000ef          	jal	7d6 <wait>
 4fe:	2485                	addiw	s1,s1,1
 500:	ff249ce3          	bne	s1,s2,4f8 <main+0x14c>
    printf("Now the chatroom closes. Bye bye!\n");
 504:	00001517          	auipc	a0,0x1
 508:	a7450513          	addi	a0,a0,-1420 # f78 <malloc+0x2f0>
 50c:	6c4000ef          	jal	bd0 <printf>
    exit(0);
 510:	4501                	li	a0,0
 512:	2bc000ef          	jal	7ce <exit>
 516:	21613823          	sd	s6,528(sp)
 51a:	21713423          	sd	s7,520(sp)
            chatbot(i,argv[i],argc,argv);
 51e:	00391793          	slli	a5,s2,0x3
 522:	97d2                	add	a5,a5,s4
 524:	86d2                	mv	a3,s4
 526:	864e                	mv	a2,s3
 528:	638c                	ld	a1,0(a5)
 52a:	854a                	mv	a0,s2
 52c:	bb5ff0ef          	jal	e0 <chatbot>

0000000000000530 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 530:	1141                	addi	sp,sp,-16
 532:	e406                	sd	ra,8(sp)
 534:	e022                	sd	s0,0(sp)
 536:	0800                	addi	s0,sp,16
  extern int main();
  main();
 538:	e75ff0ef          	jal	3ac <main>
  exit(0);
 53c:	4501                	li	a0,0
 53e:	290000ef          	jal	7ce <exit>

0000000000000542 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 542:	1141                	addi	sp,sp,-16
 544:	e406                	sd	ra,8(sp)
 546:	e022                	sd	s0,0(sp)
 548:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 54a:	87aa                	mv	a5,a0
 54c:	0585                	addi	a1,a1,1
 54e:	0785                	addi	a5,a5,1
 550:	fff5c703          	lbu	a4,-1(a1)
 554:	fee78fa3          	sb	a4,-1(a5)
 558:	fb75                	bnez	a4,54c <strcpy+0xa>
    ;
  return os;
}
 55a:	60a2                	ld	ra,8(sp)
 55c:	6402                	ld	s0,0(sp)
 55e:	0141                	addi	sp,sp,16
 560:	8082                	ret

0000000000000562 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 562:	1141                	addi	sp,sp,-16
 564:	e406                	sd	ra,8(sp)
 566:	e022                	sd	s0,0(sp)
 568:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 56a:	00054783          	lbu	a5,0(a0)
 56e:	cb91                	beqz	a5,582 <strcmp+0x20>
 570:	0005c703          	lbu	a4,0(a1)
 574:	00f71763          	bne	a4,a5,582 <strcmp+0x20>
    p++, q++;
 578:	0505                	addi	a0,a0,1
 57a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 57c:	00054783          	lbu	a5,0(a0)
 580:	fbe5                	bnez	a5,570 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 582:	0005c503          	lbu	a0,0(a1)
}
 586:	40a7853b          	subw	a0,a5,a0
 58a:	60a2                	ld	ra,8(sp)
 58c:	6402                	ld	s0,0(sp)
 58e:	0141                	addi	sp,sp,16
 590:	8082                	ret

0000000000000592 <strlen>:

uint
strlen(const char *s)
{
 592:	1141                	addi	sp,sp,-16
 594:	e406                	sd	ra,8(sp)
 596:	e022                	sd	s0,0(sp)
 598:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 59a:	00054783          	lbu	a5,0(a0)
 59e:	cf99                	beqz	a5,5bc <strlen+0x2a>
 5a0:	0505                	addi	a0,a0,1
 5a2:	87aa                	mv	a5,a0
 5a4:	86be                	mv	a3,a5
 5a6:	0785                	addi	a5,a5,1
 5a8:	fff7c703          	lbu	a4,-1(a5)
 5ac:	ff65                	bnez	a4,5a4 <strlen+0x12>
 5ae:	40a6853b          	subw	a0,a3,a0
 5b2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 5b4:	60a2                	ld	ra,8(sp)
 5b6:	6402                	ld	s0,0(sp)
 5b8:	0141                	addi	sp,sp,16
 5ba:	8082                	ret
  for(n = 0; s[n]; n++)
 5bc:	4501                	li	a0,0
 5be:	bfdd                	j	5b4 <strlen+0x22>

00000000000005c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5c0:	1141                	addi	sp,sp,-16
 5c2:	e406                	sd	ra,8(sp)
 5c4:	e022                	sd	s0,0(sp)
 5c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5c8:	ca19                	beqz	a2,5de <memset+0x1e>
 5ca:	87aa                	mv	a5,a0
 5cc:	1602                	slli	a2,a2,0x20
 5ce:	9201                	srli	a2,a2,0x20
 5d0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5d4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5d8:	0785                	addi	a5,a5,1
 5da:	fee79de3          	bne	a5,a4,5d4 <memset+0x14>
  }
  return dst;
}
 5de:	60a2                	ld	ra,8(sp)
 5e0:	6402                	ld	s0,0(sp)
 5e2:	0141                	addi	sp,sp,16
 5e4:	8082                	ret

00000000000005e6 <strchr>:

char*
strchr(const char *s, char c)
{
 5e6:	1141                	addi	sp,sp,-16
 5e8:	e406                	sd	ra,8(sp)
 5ea:	e022                	sd	s0,0(sp)
 5ec:	0800                	addi	s0,sp,16
  for(; *s; s++)
 5ee:	00054783          	lbu	a5,0(a0)
 5f2:	cf81                	beqz	a5,60a <strchr+0x24>
    if(*s == c)
 5f4:	00f58763          	beq	a1,a5,602 <strchr+0x1c>
  for(; *s; s++)
 5f8:	0505                	addi	a0,a0,1
 5fa:	00054783          	lbu	a5,0(a0)
 5fe:	fbfd                	bnez	a5,5f4 <strchr+0xe>
      return (char*)s;
  return 0;
 600:	4501                	li	a0,0
}
 602:	60a2                	ld	ra,8(sp)
 604:	6402                	ld	s0,0(sp)
 606:	0141                	addi	sp,sp,16
 608:	8082                	ret
  return 0;
 60a:	4501                	li	a0,0
 60c:	bfdd                	j	602 <strchr+0x1c>

000000000000060e <gets>:

char*
gets(char *buf, int max)
{
 60e:	7159                	addi	sp,sp,-112
 610:	f486                	sd	ra,104(sp)
 612:	f0a2                	sd	s0,96(sp)
 614:	eca6                	sd	s1,88(sp)
 616:	e8ca                	sd	s2,80(sp)
 618:	e4ce                	sd	s3,72(sp)
 61a:	e0d2                	sd	s4,64(sp)
 61c:	fc56                	sd	s5,56(sp)
 61e:	f85a                	sd	s6,48(sp)
 620:	f45e                	sd	s7,40(sp)
 622:	f062                	sd	s8,32(sp)
 624:	ec66                	sd	s9,24(sp)
 626:	e86a                	sd	s10,16(sp)
 628:	1880                	addi	s0,sp,112
 62a:	8caa                	mv	s9,a0
 62c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 62e:	892a                	mv	s2,a0
 630:	4481                	li	s1,0
    cc = read(0, &c, 1);
 632:	f9f40b13          	addi	s6,s0,-97
 636:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 638:	4ba9                	li	s7,10
 63a:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 63c:	8d26                	mv	s10,s1
 63e:	0014899b          	addiw	s3,s1,1
 642:	84ce                	mv	s1,s3
 644:	0349d563          	bge	s3,s4,66e <gets+0x60>
    cc = read(0, &c, 1);
 648:	8656                	mv	a2,s5
 64a:	85da                	mv	a1,s6
 64c:	4501                	li	a0,0
 64e:	198000ef          	jal	7e6 <read>
    if(cc < 1)
 652:	00a05e63          	blez	a0,66e <gets+0x60>
    buf[i++] = c;
 656:	f9f44783          	lbu	a5,-97(s0)
 65a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 65e:	01778763          	beq	a5,s7,66c <gets+0x5e>
 662:	0905                	addi	s2,s2,1
 664:	fd879ce3          	bne	a5,s8,63c <gets+0x2e>
    buf[i++] = c;
 668:	8d4e                	mv	s10,s3
 66a:	a011                	j	66e <gets+0x60>
 66c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 66e:	9d66                	add	s10,s10,s9
 670:	000d0023          	sb	zero,0(s10)
  return buf;
}
 674:	8566                	mv	a0,s9
 676:	70a6                	ld	ra,104(sp)
 678:	7406                	ld	s0,96(sp)
 67a:	64e6                	ld	s1,88(sp)
 67c:	6946                	ld	s2,80(sp)
 67e:	69a6                	ld	s3,72(sp)
 680:	6a06                	ld	s4,64(sp)
 682:	7ae2                	ld	s5,56(sp)
 684:	7b42                	ld	s6,48(sp)
 686:	7ba2                	ld	s7,40(sp)
 688:	7c02                	ld	s8,32(sp)
 68a:	6ce2                	ld	s9,24(sp)
 68c:	6d42                	ld	s10,16(sp)
 68e:	6165                	addi	sp,sp,112
 690:	8082                	ret

0000000000000692 <stat>:

int
stat(const char *n, struct stat *st)
{
 692:	1101                	addi	sp,sp,-32
 694:	ec06                	sd	ra,24(sp)
 696:	e822                	sd	s0,16(sp)
 698:	e04a                	sd	s2,0(sp)
 69a:	1000                	addi	s0,sp,32
 69c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 69e:	4581                	li	a1,0
 6a0:	16e000ef          	jal	80e <open>
  if(fd < 0)
 6a4:	02054263          	bltz	a0,6c8 <stat+0x36>
 6a8:	e426                	sd	s1,8(sp)
 6aa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 6ac:	85ca                	mv	a1,s2
 6ae:	178000ef          	jal	826 <fstat>
 6b2:	892a                	mv	s2,a0
  close(fd);
 6b4:	8526                	mv	a0,s1
 6b6:	140000ef          	jal	7f6 <close>
  return r;
 6ba:	64a2                	ld	s1,8(sp)
}
 6bc:	854a                	mv	a0,s2
 6be:	60e2                	ld	ra,24(sp)
 6c0:	6442                	ld	s0,16(sp)
 6c2:	6902                	ld	s2,0(sp)
 6c4:	6105                	addi	sp,sp,32
 6c6:	8082                	ret
    return -1;
 6c8:	597d                	li	s2,-1
 6ca:	bfcd                	j	6bc <stat+0x2a>

00000000000006cc <atoi>:

int
atoi(const char *s)
{
 6cc:	1141                	addi	sp,sp,-16
 6ce:	e406                	sd	ra,8(sp)
 6d0:	e022                	sd	s0,0(sp)
 6d2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6d4:	00054683          	lbu	a3,0(a0)
 6d8:	fd06879b          	addiw	a5,a3,-48
 6dc:	0ff7f793          	zext.b	a5,a5
 6e0:	4625                	li	a2,9
 6e2:	02f66963          	bltu	a2,a5,714 <atoi+0x48>
 6e6:	872a                	mv	a4,a0
  n = 0;
 6e8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 6ea:	0705                	addi	a4,a4,1
 6ec:	0025179b          	slliw	a5,a0,0x2
 6f0:	9fa9                	addw	a5,a5,a0
 6f2:	0017979b          	slliw	a5,a5,0x1
 6f6:	9fb5                	addw	a5,a5,a3
 6f8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6fc:	00074683          	lbu	a3,0(a4)
 700:	fd06879b          	addiw	a5,a3,-48
 704:	0ff7f793          	zext.b	a5,a5
 708:	fef671e3          	bgeu	a2,a5,6ea <atoi+0x1e>
  return n;
}
 70c:	60a2                	ld	ra,8(sp)
 70e:	6402                	ld	s0,0(sp)
 710:	0141                	addi	sp,sp,16
 712:	8082                	ret
  n = 0;
 714:	4501                	li	a0,0
 716:	bfdd                	j	70c <atoi+0x40>

0000000000000718 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 718:	1141                	addi	sp,sp,-16
 71a:	e406                	sd	ra,8(sp)
 71c:	e022                	sd	s0,0(sp)
 71e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 720:	02b57563          	bgeu	a0,a1,74a <memmove+0x32>
    while(n-- > 0)
 724:	00c05f63          	blez	a2,742 <memmove+0x2a>
 728:	1602                	slli	a2,a2,0x20
 72a:	9201                	srli	a2,a2,0x20
 72c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 730:	872a                	mv	a4,a0
      *dst++ = *src++;
 732:	0585                	addi	a1,a1,1
 734:	0705                	addi	a4,a4,1
 736:	fff5c683          	lbu	a3,-1(a1)
 73a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 73e:	fee79ae3          	bne	a5,a4,732 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 742:	60a2                	ld	ra,8(sp)
 744:	6402                	ld	s0,0(sp)
 746:	0141                	addi	sp,sp,16
 748:	8082                	ret
    dst += n;
 74a:	00c50733          	add	a4,a0,a2
    src += n;
 74e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 750:	fec059e3          	blez	a2,742 <memmove+0x2a>
 754:	fff6079b          	addiw	a5,a2,-1
 758:	1782                	slli	a5,a5,0x20
 75a:	9381                	srli	a5,a5,0x20
 75c:	fff7c793          	not	a5,a5
 760:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 762:	15fd                	addi	a1,a1,-1
 764:	177d                	addi	a4,a4,-1
 766:	0005c683          	lbu	a3,0(a1)
 76a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 76e:	fef71ae3          	bne	a4,a5,762 <memmove+0x4a>
 772:	bfc1                	j	742 <memmove+0x2a>

0000000000000774 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 774:	1141                	addi	sp,sp,-16
 776:	e406                	sd	ra,8(sp)
 778:	e022                	sd	s0,0(sp)
 77a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 77c:	ca0d                	beqz	a2,7ae <memcmp+0x3a>
 77e:	fff6069b          	addiw	a3,a2,-1
 782:	1682                	slli	a3,a3,0x20
 784:	9281                	srli	a3,a3,0x20
 786:	0685                	addi	a3,a3,1
 788:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 78a:	00054783          	lbu	a5,0(a0)
 78e:	0005c703          	lbu	a4,0(a1)
 792:	00e79863          	bne	a5,a4,7a2 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 796:	0505                	addi	a0,a0,1
    p2++;
 798:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 79a:	fed518e3          	bne	a0,a3,78a <memcmp+0x16>
  }
  return 0;
 79e:	4501                	li	a0,0
 7a0:	a019                	j	7a6 <memcmp+0x32>
      return *p1 - *p2;
 7a2:	40e7853b          	subw	a0,a5,a4
}
 7a6:	60a2                	ld	ra,8(sp)
 7a8:	6402                	ld	s0,0(sp)
 7aa:	0141                	addi	sp,sp,16
 7ac:	8082                	ret
  return 0;
 7ae:	4501                	li	a0,0
 7b0:	bfdd                	j	7a6 <memcmp+0x32>

00000000000007b2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 7b2:	1141                	addi	sp,sp,-16
 7b4:	e406                	sd	ra,8(sp)
 7b6:	e022                	sd	s0,0(sp)
 7b8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 7ba:	f5fff0ef          	jal	718 <memmove>
}
 7be:	60a2                	ld	ra,8(sp)
 7c0:	6402                	ld	s0,0(sp)
 7c2:	0141                	addi	sp,sp,16
 7c4:	8082                	ret

00000000000007c6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7c6:	4885                	li	a7,1
 ecall
 7c8:	00000073          	ecall
 ret
 7cc:	8082                	ret

00000000000007ce <exit>:
.global exit
exit:
 li a7, SYS_exit
 7ce:	4889                	li	a7,2
 ecall
 7d0:	00000073          	ecall
 ret
 7d4:	8082                	ret

00000000000007d6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 7d6:	488d                	li	a7,3
 ecall
 7d8:	00000073          	ecall
 ret
 7dc:	8082                	ret

00000000000007de <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7de:	4891                	li	a7,4
 ecall
 7e0:	00000073          	ecall
 ret
 7e4:	8082                	ret

00000000000007e6 <read>:
.global read
read:
 li a7, SYS_read
 7e6:	4895                	li	a7,5
 ecall
 7e8:	00000073          	ecall
 ret
 7ec:	8082                	ret

00000000000007ee <write>:
.global write
write:
 li a7, SYS_write
 7ee:	48c1                	li	a7,16
 ecall
 7f0:	00000073          	ecall
 ret
 7f4:	8082                	ret

00000000000007f6 <close>:
.global close
close:
 li a7, SYS_close
 7f6:	48d5                	li	a7,21
 ecall
 7f8:	00000073          	ecall
 ret
 7fc:	8082                	ret

00000000000007fe <kill>:
.global kill
kill:
 li a7, SYS_kill
 7fe:	4899                	li	a7,6
 ecall
 800:	00000073          	ecall
 ret
 804:	8082                	ret

0000000000000806 <exec>:
.global exec
exec:
 li a7, SYS_exec
 806:	489d                	li	a7,7
 ecall
 808:	00000073          	ecall
 ret
 80c:	8082                	ret

000000000000080e <open>:
.global open
open:
 li a7, SYS_open
 80e:	48bd                	li	a7,15
 ecall
 810:	00000073          	ecall
 ret
 814:	8082                	ret

0000000000000816 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 816:	48c5                	li	a7,17
 ecall
 818:	00000073          	ecall
 ret
 81c:	8082                	ret

000000000000081e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 81e:	48c9                	li	a7,18
 ecall
 820:	00000073          	ecall
 ret
 824:	8082                	ret

0000000000000826 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 826:	48a1                	li	a7,8
 ecall
 828:	00000073          	ecall
 ret
 82c:	8082                	ret

000000000000082e <link>:
.global link
link:
 li a7, SYS_link
 82e:	48cd                	li	a7,19
 ecall
 830:	00000073          	ecall
 ret
 834:	8082                	ret

0000000000000836 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 836:	48d1                	li	a7,20
 ecall
 838:	00000073          	ecall
 ret
 83c:	8082                	ret

000000000000083e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 83e:	48a5                	li	a7,9
 ecall
 840:	00000073          	ecall
 ret
 844:	8082                	ret

0000000000000846 <dup>:
.global dup
dup:
 li a7, SYS_dup
 846:	48a9                	li	a7,10
 ecall
 848:	00000073          	ecall
 ret
 84c:	8082                	ret

000000000000084e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 84e:	48ad                	li	a7,11
 ecall
 850:	00000073          	ecall
 ret
 854:	8082                	ret

0000000000000856 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 856:	48b1                	li	a7,12
 ecall
 858:	00000073          	ecall
 ret
 85c:	8082                	ret

000000000000085e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 85e:	48b5                	li	a7,13
 ecall
 860:	00000073          	ecall
 ret
 864:	8082                	ret

0000000000000866 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 866:	48b9                	li	a7,14
 ecall
 868:	00000073          	ecall
 ret
 86c:	8082                	ret

000000000000086e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 86e:	1101                	addi	sp,sp,-32
 870:	ec06                	sd	ra,24(sp)
 872:	e822                	sd	s0,16(sp)
 874:	1000                	addi	s0,sp,32
 876:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 87a:	4605                	li	a2,1
 87c:	fef40593          	addi	a1,s0,-17
 880:	f6fff0ef          	jal	7ee <write>
}
 884:	60e2                	ld	ra,24(sp)
 886:	6442                	ld	s0,16(sp)
 888:	6105                	addi	sp,sp,32
 88a:	8082                	ret

000000000000088c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 88c:	7139                	addi	sp,sp,-64
 88e:	fc06                	sd	ra,56(sp)
 890:	f822                	sd	s0,48(sp)
 892:	f426                	sd	s1,40(sp)
 894:	f04a                	sd	s2,32(sp)
 896:	ec4e                	sd	s3,24(sp)
 898:	0080                	addi	s0,sp,64
 89a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 89c:	c299                	beqz	a3,8a2 <printint+0x16>
 89e:	0605ce63          	bltz	a1,91a <printint+0x8e>
  neg = 0;
 8a2:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 8a4:	fc040313          	addi	t1,s0,-64
  neg = 0;
 8a8:	869a                	mv	a3,t1
  i = 0;
 8aa:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 8ac:	00000817          	auipc	a6,0x0
 8b0:	6fc80813          	addi	a6,a6,1788 # fa8 <digits>
 8b4:	88be                	mv	a7,a5
 8b6:	0017851b          	addiw	a0,a5,1
 8ba:	87aa                	mv	a5,a0
 8bc:	02c5f73b          	remuw	a4,a1,a2
 8c0:	1702                	slli	a4,a4,0x20
 8c2:	9301                	srli	a4,a4,0x20
 8c4:	9742                	add	a4,a4,a6
 8c6:	00074703          	lbu	a4,0(a4)
 8ca:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 8ce:	872e                	mv	a4,a1
 8d0:	02c5d5bb          	divuw	a1,a1,a2
 8d4:	0685                	addi	a3,a3,1
 8d6:	fcc77fe3          	bgeu	a4,a2,8b4 <printint+0x28>
  if(neg)
 8da:	000e0c63          	beqz	t3,8f2 <printint+0x66>
    buf[i++] = '-';
 8de:	fd050793          	addi	a5,a0,-48
 8e2:	00878533          	add	a0,a5,s0
 8e6:	02d00793          	li	a5,45
 8ea:	fef50823          	sb	a5,-16(a0)
 8ee:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 8f2:	fff7899b          	addiw	s3,a5,-1
 8f6:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 8fa:	fff4c583          	lbu	a1,-1(s1)
 8fe:	854a                	mv	a0,s2
 900:	f6fff0ef          	jal	86e <putc>
  while(--i >= 0)
 904:	39fd                	addiw	s3,s3,-1
 906:	14fd                	addi	s1,s1,-1
 908:	fe09d9e3          	bgez	s3,8fa <printint+0x6e>
}
 90c:	70e2                	ld	ra,56(sp)
 90e:	7442                	ld	s0,48(sp)
 910:	74a2                	ld	s1,40(sp)
 912:	7902                	ld	s2,32(sp)
 914:	69e2                	ld	s3,24(sp)
 916:	6121                	addi	sp,sp,64
 918:	8082                	ret
    x = -xx;
 91a:	40b005bb          	negw	a1,a1
    neg = 1;
 91e:	4e05                	li	t3,1
    x = -xx;
 920:	b751                	j	8a4 <printint+0x18>

0000000000000922 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 922:	711d                	addi	sp,sp,-96
 924:	ec86                	sd	ra,88(sp)
 926:	e8a2                	sd	s0,80(sp)
 928:	e4a6                	sd	s1,72(sp)
 92a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 92c:	0005c483          	lbu	s1,0(a1)
 930:	26048663          	beqz	s1,b9c <vprintf+0x27a>
 934:	e0ca                	sd	s2,64(sp)
 936:	fc4e                	sd	s3,56(sp)
 938:	f852                	sd	s4,48(sp)
 93a:	f456                	sd	s5,40(sp)
 93c:	f05a                	sd	s6,32(sp)
 93e:	ec5e                	sd	s7,24(sp)
 940:	e862                	sd	s8,16(sp)
 942:	e466                	sd	s9,8(sp)
 944:	8b2a                	mv	s6,a0
 946:	8a2e                	mv	s4,a1
 948:	8bb2                	mv	s7,a2
  state = 0;
 94a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 94c:	4901                	li	s2,0
 94e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 950:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 954:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 958:	06c00c93          	li	s9,108
 95c:	a00d                	j	97e <vprintf+0x5c>
        putc(fd, c0);
 95e:	85a6                	mv	a1,s1
 960:	855a                	mv	a0,s6
 962:	f0dff0ef          	jal	86e <putc>
 966:	a019                	j	96c <vprintf+0x4a>
    } else if(state == '%'){
 968:	03598363          	beq	s3,s5,98e <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 96c:	0019079b          	addiw	a5,s2,1
 970:	893e                	mv	s2,a5
 972:	873e                	mv	a4,a5
 974:	97d2                	add	a5,a5,s4
 976:	0007c483          	lbu	s1,0(a5)
 97a:	20048963          	beqz	s1,b8c <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 97e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 982:	fe0993e3          	bnez	s3,968 <vprintf+0x46>
      if(c0 == '%'){
 986:	fd579ce3          	bne	a5,s5,95e <vprintf+0x3c>
        state = '%';
 98a:	89be                	mv	s3,a5
 98c:	b7c5                	j	96c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 98e:	00ea06b3          	add	a3,s4,a4
 992:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 996:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 998:	c681                	beqz	a3,9a0 <vprintf+0x7e>
 99a:	9752                	add	a4,a4,s4
 99c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 9a0:	03878e63          	beq	a5,s8,9dc <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 9a4:	05978863          	beq	a5,s9,9f4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 9a8:	07500713          	li	a4,117
 9ac:	0ee78263          	beq	a5,a4,a90 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 9b0:	07800713          	li	a4,120
 9b4:	12e78463          	beq	a5,a4,adc <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 9b8:	07000713          	li	a4,112
 9bc:	14e78963          	beq	a5,a4,b0e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 9c0:	07300713          	li	a4,115
 9c4:	18e78863          	beq	a5,a4,b54 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 9c8:	02500713          	li	a4,37
 9cc:	04e79463          	bne	a5,a4,a14 <vprintf+0xf2>
        putc(fd, '%');
 9d0:	85ba                	mv	a1,a4
 9d2:	855a                	mv	a0,s6
 9d4:	e9bff0ef          	jal	86e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 9d8:	4981                	li	s3,0
 9da:	bf49                	j	96c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 9dc:	008b8493          	addi	s1,s7,8
 9e0:	4685                	li	a3,1
 9e2:	4629                	li	a2,10
 9e4:	000ba583          	lw	a1,0(s7)
 9e8:	855a                	mv	a0,s6
 9ea:	ea3ff0ef          	jal	88c <printint>
 9ee:	8ba6                	mv	s7,s1
      state = 0;
 9f0:	4981                	li	s3,0
 9f2:	bfad                	j	96c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 9f4:	06400793          	li	a5,100
 9f8:	02f68963          	beq	a3,a5,a2a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9fc:	06c00793          	li	a5,108
 a00:	04f68263          	beq	a3,a5,a44 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 a04:	07500793          	li	a5,117
 a08:	0af68063          	beq	a3,a5,aa8 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 a0c:	07800793          	li	a5,120
 a10:	0ef68263          	beq	a3,a5,af4 <vprintf+0x1d2>
        putc(fd, '%');
 a14:	02500593          	li	a1,37
 a18:	855a                	mv	a0,s6
 a1a:	e55ff0ef          	jal	86e <putc>
        putc(fd, c0);
 a1e:	85a6                	mv	a1,s1
 a20:	855a                	mv	a0,s6
 a22:	e4dff0ef          	jal	86e <putc>
      state = 0;
 a26:	4981                	li	s3,0
 a28:	b791                	j	96c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a2a:	008b8493          	addi	s1,s7,8
 a2e:	4685                	li	a3,1
 a30:	4629                	li	a2,10
 a32:	000ba583          	lw	a1,0(s7)
 a36:	855a                	mv	a0,s6
 a38:	e55ff0ef          	jal	88c <printint>
        i += 1;
 a3c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a3e:	8ba6                	mv	s7,s1
      state = 0;
 a40:	4981                	li	s3,0
        i += 1;
 a42:	b72d                	j	96c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a44:	06400793          	li	a5,100
 a48:	02f60763          	beq	a2,a5,a76 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 a4c:	07500793          	li	a5,117
 a50:	06f60963          	beq	a2,a5,ac2 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 a54:	07800793          	li	a5,120
 a58:	faf61ee3          	bne	a2,a5,a14 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a5c:	008b8493          	addi	s1,s7,8
 a60:	4681                	li	a3,0
 a62:	4641                	li	a2,16
 a64:	000ba583          	lw	a1,0(s7)
 a68:	855a                	mv	a0,s6
 a6a:	e23ff0ef          	jal	88c <printint>
        i += 2;
 a6e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a70:	8ba6                	mv	s7,s1
      state = 0;
 a72:	4981                	li	s3,0
        i += 2;
 a74:	bde5                	j	96c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a76:	008b8493          	addi	s1,s7,8
 a7a:	4685                	li	a3,1
 a7c:	4629                	li	a2,10
 a7e:	000ba583          	lw	a1,0(s7)
 a82:	855a                	mv	a0,s6
 a84:	e09ff0ef          	jal	88c <printint>
        i += 2;
 a88:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a8a:	8ba6                	mv	s7,s1
      state = 0;
 a8c:	4981                	li	s3,0
        i += 2;
 a8e:	bdf9                	j	96c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 a90:	008b8493          	addi	s1,s7,8
 a94:	4681                	li	a3,0
 a96:	4629                	li	a2,10
 a98:	000ba583          	lw	a1,0(s7)
 a9c:	855a                	mv	a0,s6
 a9e:	defff0ef          	jal	88c <printint>
 aa2:	8ba6                	mv	s7,s1
      state = 0;
 aa4:	4981                	li	s3,0
 aa6:	b5d9                	j	96c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 aa8:	008b8493          	addi	s1,s7,8
 aac:	4681                	li	a3,0
 aae:	4629                	li	a2,10
 ab0:	000ba583          	lw	a1,0(s7)
 ab4:	855a                	mv	a0,s6
 ab6:	dd7ff0ef          	jal	88c <printint>
        i += 1;
 aba:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 abc:	8ba6                	mv	s7,s1
      state = 0;
 abe:	4981                	li	s3,0
        i += 1;
 ac0:	b575                	j	96c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ac2:	008b8493          	addi	s1,s7,8
 ac6:	4681                	li	a3,0
 ac8:	4629                	li	a2,10
 aca:	000ba583          	lw	a1,0(s7)
 ace:	855a                	mv	a0,s6
 ad0:	dbdff0ef          	jal	88c <printint>
        i += 2;
 ad4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 ad6:	8ba6                	mv	s7,s1
      state = 0;
 ad8:	4981                	li	s3,0
        i += 2;
 ada:	bd49                	j	96c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 adc:	008b8493          	addi	s1,s7,8
 ae0:	4681                	li	a3,0
 ae2:	4641                	li	a2,16
 ae4:	000ba583          	lw	a1,0(s7)
 ae8:	855a                	mv	a0,s6
 aea:	da3ff0ef          	jal	88c <printint>
 aee:	8ba6                	mv	s7,s1
      state = 0;
 af0:	4981                	li	s3,0
 af2:	bdad                	j	96c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 af4:	008b8493          	addi	s1,s7,8
 af8:	4681                	li	a3,0
 afa:	4641                	li	a2,16
 afc:	000ba583          	lw	a1,0(s7)
 b00:	855a                	mv	a0,s6
 b02:	d8bff0ef          	jal	88c <printint>
        i += 1;
 b06:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 b08:	8ba6                	mv	s7,s1
      state = 0;
 b0a:	4981                	li	s3,0
        i += 1;
 b0c:	b585                	j	96c <vprintf+0x4a>
 b0e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 b10:	008b8d13          	addi	s10,s7,8
 b14:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b18:	03000593          	li	a1,48
 b1c:	855a                	mv	a0,s6
 b1e:	d51ff0ef          	jal	86e <putc>
  putc(fd, 'x');
 b22:	07800593          	li	a1,120
 b26:	855a                	mv	a0,s6
 b28:	d47ff0ef          	jal	86e <putc>
 b2c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b2e:	00000b97          	auipc	s7,0x0
 b32:	47ab8b93          	addi	s7,s7,1146 # fa8 <digits>
 b36:	03c9d793          	srli	a5,s3,0x3c
 b3a:	97de                	add	a5,a5,s7
 b3c:	0007c583          	lbu	a1,0(a5)
 b40:	855a                	mv	a0,s6
 b42:	d2dff0ef          	jal	86e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b46:	0992                	slli	s3,s3,0x4
 b48:	34fd                	addiw	s1,s1,-1
 b4a:	f4f5                	bnez	s1,b36 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 b4c:	8bea                	mv	s7,s10
      state = 0;
 b4e:	4981                	li	s3,0
 b50:	6d02                	ld	s10,0(sp)
 b52:	bd29                	j	96c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 b54:	008b8993          	addi	s3,s7,8
 b58:	000bb483          	ld	s1,0(s7)
 b5c:	cc91                	beqz	s1,b78 <vprintf+0x256>
        for(; *s; s++)
 b5e:	0004c583          	lbu	a1,0(s1)
 b62:	c195                	beqz	a1,b86 <vprintf+0x264>
          putc(fd, *s);
 b64:	855a                	mv	a0,s6
 b66:	d09ff0ef          	jal	86e <putc>
        for(; *s; s++)
 b6a:	0485                	addi	s1,s1,1
 b6c:	0004c583          	lbu	a1,0(s1)
 b70:	f9f5                	bnez	a1,b64 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 b72:	8bce                	mv	s7,s3
      state = 0;
 b74:	4981                	li	s3,0
 b76:	bbdd                	j	96c <vprintf+0x4a>
          s = "(null)";
 b78:	00000497          	auipc	s1,0x0
 b7c:	42848493          	addi	s1,s1,1064 # fa0 <malloc+0x318>
        for(; *s; s++)
 b80:	02800593          	li	a1,40
 b84:	b7c5                	j	b64 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 b86:	8bce                	mv	s7,s3
      state = 0;
 b88:	4981                	li	s3,0
 b8a:	b3cd                	j	96c <vprintf+0x4a>
 b8c:	6906                	ld	s2,64(sp)
 b8e:	79e2                	ld	s3,56(sp)
 b90:	7a42                	ld	s4,48(sp)
 b92:	7aa2                	ld	s5,40(sp)
 b94:	7b02                	ld	s6,32(sp)
 b96:	6be2                	ld	s7,24(sp)
 b98:	6c42                	ld	s8,16(sp)
 b9a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 b9c:	60e6                	ld	ra,88(sp)
 b9e:	6446                	ld	s0,80(sp)
 ba0:	64a6                	ld	s1,72(sp)
 ba2:	6125                	addi	sp,sp,96
 ba4:	8082                	ret

0000000000000ba6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 ba6:	715d                	addi	sp,sp,-80
 ba8:	ec06                	sd	ra,24(sp)
 baa:	e822                	sd	s0,16(sp)
 bac:	1000                	addi	s0,sp,32
 bae:	e010                	sd	a2,0(s0)
 bb0:	e414                	sd	a3,8(s0)
 bb2:	e818                	sd	a4,16(s0)
 bb4:	ec1c                	sd	a5,24(s0)
 bb6:	03043023          	sd	a6,32(s0)
 bba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 bbe:	8622                	mv	a2,s0
 bc0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 bc4:	d5fff0ef          	jal	922 <vprintf>
}
 bc8:	60e2                	ld	ra,24(sp)
 bca:	6442                	ld	s0,16(sp)
 bcc:	6161                	addi	sp,sp,80
 bce:	8082                	ret

0000000000000bd0 <printf>:

void
printf(const char *fmt, ...)
{
 bd0:	711d                	addi	sp,sp,-96
 bd2:	ec06                	sd	ra,24(sp)
 bd4:	e822                	sd	s0,16(sp)
 bd6:	1000                	addi	s0,sp,32
 bd8:	e40c                	sd	a1,8(s0)
 bda:	e810                	sd	a2,16(s0)
 bdc:	ec14                	sd	a3,24(s0)
 bde:	f018                	sd	a4,32(s0)
 be0:	f41c                	sd	a5,40(s0)
 be2:	03043823          	sd	a6,48(s0)
 be6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 bea:	00840613          	addi	a2,s0,8
 bee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 bf2:	85aa                	mv	a1,a0
 bf4:	4505                	li	a0,1
 bf6:	d2dff0ef          	jal	922 <vprintf>
}
 bfa:	60e2                	ld	ra,24(sp)
 bfc:	6442                	ld	s0,16(sp)
 bfe:	6125                	addi	sp,sp,96
 c00:	8082                	ret

0000000000000c02 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c02:	1141                	addi	sp,sp,-16
 c04:	e406                	sd	ra,8(sp)
 c06:	e022                	sd	s0,0(sp)
 c08:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c0a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c0e:	00001797          	auipc	a5,0x1
 c12:	3f27b783          	ld	a5,1010(a5) # 2000 <freep>
 c16:	a02d                	j	c40 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c18:	4618                	lw	a4,8(a2)
 c1a:	9f2d                	addw	a4,a4,a1
 c1c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c20:	6398                	ld	a4,0(a5)
 c22:	6310                	ld	a2,0(a4)
 c24:	a83d                	j	c62 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c26:	ff852703          	lw	a4,-8(a0)
 c2a:	9f31                	addw	a4,a4,a2
 c2c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c2e:	ff053683          	ld	a3,-16(a0)
 c32:	a091                	j	c76 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c34:	6398                	ld	a4,0(a5)
 c36:	00e7e463          	bltu	a5,a4,c3e <free+0x3c>
 c3a:	00e6ea63          	bltu	a3,a4,c4e <free+0x4c>
{
 c3e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c40:	fed7fae3          	bgeu	a5,a3,c34 <free+0x32>
 c44:	6398                	ld	a4,0(a5)
 c46:	00e6e463          	bltu	a3,a4,c4e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c4a:	fee7eae3          	bltu	a5,a4,c3e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 c4e:	ff852583          	lw	a1,-8(a0)
 c52:	6390                	ld	a2,0(a5)
 c54:	02059813          	slli	a6,a1,0x20
 c58:	01c85713          	srli	a4,a6,0x1c
 c5c:	9736                	add	a4,a4,a3
 c5e:	fae60de3          	beq	a2,a4,c18 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 c62:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 c66:	4790                	lw	a2,8(a5)
 c68:	02061593          	slli	a1,a2,0x20
 c6c:	01c5d713          	srli	a4,a1,0x1c
 c70:	973e                	add	a4,a4,a5
 c72:	fae68ae3          	beq	a3,a4,c26 <free+0x24>
    p->s.ptr = bp->s.ptr;
 c76:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c78:	00001717          	auipc	a4,0x1
 c7c:	38f73423          	sd	a5,904(a4) # 2000 <freep>
}
 c80:	60a2                	ld	ra,8(sp)
 c82:	6402                	ld	s0,0(sp)
 c84:	0141                	addi	sp,sp,16
 c86:	8082                	ret

0000000000000c88 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c88:	7139                	addi	sp,sp,-64
 c8a:	fc06                	sd	ra,56(sp)
 c8c:	f822                	sd	s0,48(sp)
 c8e:	f04a                	sd	s2,32(sp)
 c90:	ec4e                	sd	s3,24(sp)
 c92:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c94:	02051993          	slli	s3,a0,0x20
 c98:	0209d993          	srli	s3,s3,0x20
 c9c:	09bd                	addi	s3,s3,15
 c9e:	0049d993          	srli	s3,s3,0x4
 ca2:	2985                	addiw	s3,s3,1
 ca4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 ca6:	00001517          	auipc	a0,0x1
 caa:	35a53503          	ld	a0,858(a0) # 2000 <freep>
 cae:	c905                	beqz	a0,cde <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cb0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cb2:	4798                	lw	a4,8(a5)
 cb4:	09377663          	bgeu	a4,s3,d40 <malloc+0xb8>
 cb8:	f426                	sd	s1,40(sp)
 cba:	e852                	sd	s4,16(sp)
 cbc:	e456                	sd	s5,8(sp)
 cbe:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 cc0:	8a4e                	mv	s4,s3
 cc2:	6705                	lui	a4,0x1
 cc4:	00e9f363          	bgeu	s3,a4,cca <malloc+0x42>
 cc8:	6a05                	lui	s4,0x1
 cca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 cce:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 cd2:	00001497          	auipc	s1,0x1
 cd6:	32e48493          	addi	s1,s1,814 # 2000 <freep>
  if(p == (char*)-1)
 cda:	5afd                	li	s5,-1
 cdc:	a83d                	j	d1a <malloc+0x92>
 cde:	f426                	sd	s1,40(sp)
 ce0:	e852                	sd	s4,16(sp)
 ce2:	e456                	sd	s5,8(sp)
 ce4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 ce6:	00001797          	auipc	a5,0x1
 cea:	35a78793          	addi	a5,a5,858 # 2040 <base>
 cee:	00001717          	auipc	a4,0x1
 cf2:	30f73923          	sd	a5,786(a4) # 2000 <freep>
 cf6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 cf8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 cfc:	b7d1                	j	cc0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 cfe:	6398                	ld	a4,0(a5)
 d00:	e118                	sd	a4,0(a0)
 d02:	a899                	j	d58 <malloc+0xd0>
  hp->s.size = nu;
 d04:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d08:	0541                	addi	a0,a0,16
 d0a:	ef9ff0ef          	jal	c02 <free>
  return freep;
 d0e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 d10:	c125                	beqz	a0,d70 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d12:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d14:	4798                	lw	a4,8(a5)
 d16:	03277163          	bgeu	a4,s2,d38 <malloc+0xb0>
    if(p == freep)
 d1a:	6098                	ld	a4,0(s1)
 d1c:	853e                	mv	a0,a5
 d1e:	fef71ae3          	bne	a4,a5,d12 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 d22:	8552                	mv	a0,s4
 d24:	b33ff0ef          	jal	856 <sbrk>
  if(p == (char*)-1)
 d28:	fd551ee3          	bne	a0,s5,d04 <malloc+0x7c>
        return 0;
 d2c:	4501                	li	a0,0
 d2e:	74a2                	ld	s1,40(sp)
 d30:	6a42                	ld	s4,16(sp)
 d32:	6aa2                	ld	s5,8(sp)
 d34:	6b02                	ld	s6,0(sp)
 d36:	a03d                	j	d64 <malloc+0xdc>
 d38:	74a2                	ld	s1,40(sp)
 d3a:	6a42                	ld	s4,16(sp)
 d3c:	6aa2                	ld	s5,8(sp)
 d3e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 d40:	fae90fe3          	beq	s2,a4,cfe <malloc+0x76>
        p->s.size -= nunits;
 d44:	4137073b          	subw	a4,a4,s3
 d48:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d4a:	02071693          	slli	a3,a4,0x20
 d4e:	01c6d713          	srli	a4,a3,0x1c
 d52:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d54:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d58:	00001717          	auipc	a4,0x1
 d5c:	2aa73423          	sd	a0,680(a4) # 2000 <freep>
      return (void*)(p + 1);
 d60:	01078513          	addi	a0,a5,16
  }
}
 d64:	70e2                	ld	ra,56(sp)
 d66:	7442                	ld	s0,48(sp)
 d68:	7902                	ld	s2,32(sp)
 d6a:	69e2                	ld	s3,24(sp)
 d6c:	6121                	addi	sp,sp,64
 d6e:	8082                	ret
 d70:	74a2                	ld	s1,40(sp)
 d72:	6a42                	ld	s4,16(sp)
 d74:	6aa2                	ld	s5,8(sp)
 d76:	6b02                	ld	s6,0(sp)
 d78:	b7f5                	j	d64 <malloc+0xdc>
