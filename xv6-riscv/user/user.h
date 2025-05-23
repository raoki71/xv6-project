struct stat;

// system calls
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(const char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);

// Project 1B
// System call declarations 
// Function interface for user programs so they take some arguments and pass them to system call handlers.
int getppid(void);
int getcpids(int *cpids, int max);
int getpaddr(void *va);
int gettraphistory(int *trapcount, int *syscallcount, int *devintcount, int *timerintcount);

// Project 1C
// System call declarations

// If new_nice is between –20 and 19, the caller’s nice is set to new_nice. 
// Otherwise, the nice value is unchanged. The system returns the nice value (after update) of the caller.
int nice(int new_nice);
// This system call returns the caller’s actual runtime and virtual runtime to the integer variables pointed to by the arguments, respectively.
int getruntime(int *runtime, int *vruntim);
// This system call starts the share scheduler by setting the variable cfs to 1 in proc.c. It also set the
// parameters cfs_sched_latency, cfs_max_timeslice and cfs_min_timeslice to the arguments, respectively. It returns 1.
int startcfs(int latency, int max, int min);
// This system call stops the share scheduler by setting the variable cfs to 0 in proc.c. It returns 1.
int stopcfs(void);

// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void fprintf(int, const char*, ...) __attribute__ ((format (printf, 2, 3)));
void printf(const char*, ...) __attribute__ ((format (printf, 1, 2)));
char* gets(char*, int max);
uint strlen(const char*);
void* memset(void*, int, uint);
int atoi(const char*);
int memcmp(const void *, const void *, uint);
void *memcpy(void *, const void *, uint);

// umalloc.c
void* malloc(uint);
void free(void*);
