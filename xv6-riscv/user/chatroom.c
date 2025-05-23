
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define MAX_MSG_LEN 512
#define MAX_NUM_CHATBOT 5

int fd[MAX_NUM_CHATBOT+1][2];
int checkBotNames(char *msgBuf, int numBots, char *botNames[]);


//handle exception
void
panic(char *s){
  fprintf(2, "%s\n", s);
  exit(1);
}


//create a new process
int
fork1(void){
  int pid;
  pid = fork();
  if(pid == -1)
    panic("fork");
  return pid;
}

//create a pipe
void
pipe1(int fd[2]){
 int rc = pipe(fd);
 if(rc<0){
   panic("Fail to create a pipe.");
 }
}

//get a string from std input and save it to msgBuf
void
gets1(char msgBuf[MAX_MSG_LEN]){
    gets(msgBuf,MAX_MSG_LEN);
	int len = strlen(msgBuf);
	msgBuf[len-1]='\0';
}

// Helper function to set an invalid flag in the case when the user inputs an invalid bot name
// Initially set it to 1 so that when it encounters a valid name, it can simply exit and inform that the input is safe
int
checkBotNames(char *msgBuf, int numBots, char *botNames[]){
    int flag = 1;
    for(int i=1; i<numBots; i++) {
        if(strcmp(msgBuf, botNames[i])==0){ 
            return flag = 0;
        }
    }
    return flag;
}


/**
 * @param
 *  int myId        : The ID of a currently running chatbot process
 *  char *myName    : The name of the chatbot
 *  int numBots     : The number of all chatbots passed in the arguments of main()
 *  char *botNames[]: The list of chatbot names. Used for checking an invalid input by the user
 * 
 */
void
chatbot(int myId, char *myName, int numBots, char *botNames[]){
    //close un-used pipe descriptors
    for(int i=0; i<myId-1; i++){
        close(fd[i][0]);
        close(fd[i][1]);
    }
    close(fd[myId-1][1]);
    close(fd[myId][0]);

    //loop
    while(1){
        //to get msg from the previous chatbot
        char recvMsg[MAX_MSG_LEN];
        read(fd[myId-1][0], recvMsg, MAX_MSG_LEN);

        //to get a string from std input and save it to msgBuf 
        char msgBuf[MAX_MSG_LEN];
	    
        if(strcmp(recvMsg,":EXIT")!=0 && strcmp(recvMsg,":exit")!=0){//if the received msg is not EXIT/exit: continue chatting 
            if(strcmp(recvMsg, ":START")==0||strcmp(recvMsg, myName)==0) {
                //The beginning of the chat with a bot
                printf("Hello, this is chatbot %s. Please type:\n", myName);
                gets1(msgBuf);
                printf("I heard you said: %s\n", msgBuf);

                //The flag is set when ":CHANGE" or ":change" are typed
                int chgFlg=0;
                //Set the stay flag when ":CHANGE/:change" results in the same bot 
                //Switch between two stdout
                int styFlg=0;
                //Set the flag for invalid bot name input
                int invalidFlg = 1;
                //Initialize the :exit flag to handle the termination of the chatroom
                int extFlg = 0;

                //Loop:
                //The bot stays until the user tells to change it
                while(!chgFlg && !extFlg){
                    if(strcmp(msgBuf, ":CHANGE")==0||strcmp(msgBuf, ":change")==0) {
                        //if user inputs CHANGE/change: change the bot i to j
                        printf("OK, please type the name of the bot you want to chat next:\n");
                        gets1(msgBuf);

                        //Raise the :change FLAG
                        chgFlg = 1;

                        //Check whether the input is an invalid bot name
                        invalidFlg = checkBotNames(msgBuf, numBots, botNames);

                        //Raise the stay FLAG if the input = myName
                        if(strcmp(msgBuf, myName)==0){ styFlg = 1;}
                    }

                    //if user inputs EXIT/exit: exit myself
                    if(strcmp(msgBuf,":EXIT")==0||strcmp(msgBuf,":exit")==0){
                        printf("OK, the chatroom is closing ...\n");
                        //Set the flag and jump out of the infinite loop
                        extFlg = 1;
                    } else {
                        if(!chgFlg) {   //if the :change FLAG is not raised, keep continue chatting with the current bot
                            printf("Please continue typing:\n");
                            gets1(msgBuf);
                            printf("I heard you said: %s\n", msgBuf);
                        } else {    //Given the :change FLAG is raised, check also that whether to stay with the current bot or not

                            //If the given name bot is invalid, loop until it gets a valid bot name
                            while(invalidFlg) {
                                printf("There is no bot named %s. Please type a valid bot name:\n", msgBuf);
                                gets1(msgBuf);

                                //Input is ":EXIT/:exit", then forcefully exit the processes
                                if(strcmp(msgBuf, ":EXIT")!=0&&strcmp(msgBuf, ":exit")!=0) {
                                    //Raise the stay FLAG
                                    if(strcmp(msgBuf, myName)==0){ 
                                        styFlg = 1;
                                        invalidFlg = 0;
                                    } else {
                                        invalidFlg = checkBotNames(msgBuf, numBots, botNames);
                                    }
                                } else {
                                    invalidFlg = 0;
                                    extFlg = 1;
                                    printf("I heard you said: %s\n", msgBuf);
                                    printf("OK, the chatroom is closing ...\n");
                                }
                                
                            }
                            if(!extFlg){
                                if(styFlg) {    //Entered bot-name is the same, so stay
                                    printf("Great, you choose to stay. Please continue typing:\n");
                                    styFlg = 0;
                                    chgFlg = 0;
                                    gets1(msgBuf);
                                    printf("I heard you said: %s\n", msgBuf);
                                } else {    //Prompt that you are being sent to the different bot
                                    printf("OK, I will send you to chat with %s.\n", msgBuf);
                                    chgFlg = 1;
                                }
                            }
                        }
                    }
                }
                
                //pass the msg to the next one on the ring
                write(fd[myId][1], msgBuf, MAX_MSG_LEN);
            } else {
                //Upon ":CHANGE" or ":change", if recvMsg was different from the current bot name (i.e. myName) simply skip to the next bot until it hits
                //Acts like a ring passing a message multiple times
                write(fd[myId][1], recvMsg, MAX_MSG_LEN); 
            }

            

        } else {//if receives EXIT/exit: pass the msg down and exit myself
            write(fd[myId][1], recvMsg, MAX_MSG_LEN);
            exit(0);    
        }
            
    }

}



//script for parent process
int
main(int argc, char *argv[])
{
    if(argc<3||argc>MAX_NUM_CHATBOT+1){
        printf("Usage: %s <list of names for up to %d chatbots>\n", argv[0], MAX_NUM_CHATBOT);
        exit(1);
    }

    pipe1(fd[0]); //create the first pipe #0
    for(int i=1; i<argc; i++){
        pipe1(fd[i]); //create one new pipe for each chatbot
        //to create child proc #i (emulating chatbot #i)
        if(fork1()==0){
            chatbot(i,argv[i],argc,argv);
        }    
    }

    //close the fds not used any longer
    close(fd[0][0]); 
    close(fd[argc-1][1]);
    for(int i=1; i<argc-1; i++){
        close(fd[i][0]);
        close(fd[i][1]);
    }

    //send the START msg to the first chatbot
    write(fd[0][1], ":START", 6);

    //loop: when receive a token from predecessor, pass it to successor
    while(1){
        char recvMsg[MAX_MSG_LEN];
        read(fd[argc-1][0], recvMsg, MAX_MSG_LEN); 
        write(fd[0][1], recvMsg, MAX_MSG_LEN);
	    if(strcmp(recvMsg,":EXIT")==0||strcmp(recvMsg,":exit")==0) break; //break from the loop if the msg is EXIT
    }

    //exit after all children exit
    for(int i=1; i<=argc; i++) wait(0);
    printf("Now the chatroom closes. Bye bye!\n");
    exit(0);

}


