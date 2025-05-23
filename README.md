# xv6-project
xv6-riscv project partitioned into three major parts: chatroom implementation, virtual address space, and Completely Fair Scheduler
Change the main function for each project. That is, chatroom.c for 1A, testsyscall_b for 1B, and testsyscall_c for 1C. Also, change the Makefil accordinly for each case.

@author Rei Aoki

# Project 1A Documentation:
    chatroom.c

# Project 1B Documentation:
This documentation contains three main notes: Kernel Side, User Side, and Implementation note. Kernel Side and User Side notes briefly explains, in my word, what fields and variables (both local and global) are needed to include in files apart from the main implementation file (i.e. sysproc.c) so that the whole program runs properly. Therefore, these two notes contain describpitons similar to the ones stated in the project specification. If you need not to read them, please do skip to the Implemenation part which contains the major idea of the four newly added system call handlers.

### Kernel Side

#### kernel/syscall.h file
Addition of unique identifier for four new system calls.
These ids will help maintain the mapping `*syscalls[]` contiguous and clean

Line 29-32:

        SYS_getppid 22
        SYS_getcpids 23
        SYS_getpaddr 24
        SYS_gettraphistory 25

#### kernel/syscall.c file

Addition of prototypes defined above in `kernel/syscall.h`

Line 105-109:

    extern uint64 sys_getppid(void);
    extern uint64 sys_getcpids(void);
    extern uint64 sys_getpaddr(void);
    extern uint64 sys_gettraphistory(void);
    
Addition of pointers to new system call handlers in a syscalls array. This ensures the mapping between system calls and their uniqu numbers.

Line 144-147:

    [SYS_getppid] sys_getppid,
    [SYS_getcpids] sys_getcpids,
    [SYS_getpaddr] sys_getpaddr,
    [SYS_gettraphistory] sys_gettraphistory,


#### kernel/sysproc.c file

The implementation of new system call handlers. Arguments are not passed in since they are stored in stack pointers when a callee sets them. See `argaddr()` and `argint()`.

Line 99-102: the handler for system call getppid
    
        sys_getppid(void)

Line 105-136: the handler for system call getcpids

        sys_getcpids(void)

Line 139-156: the handler for system call getpaddr

        sys_getpaddr(void)

Line 159-180: the handler for system call gettraphistory

        sys_gettraphistory(void)

#### kernel/proc.h file
Added a global array containing all the processes' PCBs so it can be accessed from multiple places. 

Line 115:

        extern struct proc proc[NPROC]


In struct proc (PCB), add trap fields to handle all the history of trap events. This is discussed in (4)sys_gettraphistory with more details.
        int trapcount
        int syscallcount
        int devintcount
        int tierintcount

### User Side

#### user/usys.pl file
Entries to integrate with the kernel. Assembly codes are genereated by this file

Line 41-44

#### user/user.h file 

Line 29-32:

System call declarations which are function interfaces for user programs so they take some arguments and pass them to system call handlers.

### Implementation
#### kernel/sysproc.c file
(1) sys_getppid(): (line 97-100)
    Using myproc() function, it can retrieve a pointer structure that is a currently running process' PCB.
    The system call simply returns the pid value obtained from the field in the PCB's parent which is also a pointer.

(2) sys_getcpids(): (line 103-131)
    Since the system call for user program, corresponding to this handler, has two arguments, this handler first retrieves those from kernel stack and record them in local variables, cparray and nmax.

    uint64 cparray - A variable that will hold an address of the first argument (int *cpids)
    int nmax - will hold the second argument address (int max)

We are interested in returning the number of all the processes children to a common parent process.
    
    int nchild - the number of all child processes

The for loop runs the nmax numer of times.
    At each index i, it checks whether the global PCB array, proc[i] is a child of some parents, that is proc[i] iteself should not be a root.
    Once it gets the pid which is child to some parent, it checks whether the parent is the pid of the currently running process.
    If so, it copy out all the necessary data (PCB) and aquired cpid into a given virtual address. This virtual address is partitioned into the size of (32-bit int), each containing the value of cpid with the j number of children having the common parent.

Returns the number of child processes in the array.

(3) sys_getpaddr():
Simlar to sys_getcpids(), first obtain arguments from the kernel stack: (void *paddr).
Since this handler deals with the translation of address, it needs:

        VirtAddr - a source address pointer
        PhysAddr - a destination address pointer which is a physical address

Once it gets the virtual address, it then finds its corresponding page table entry using walk(pagetable_t pagetable, uint64 va, int alloc).
Using the valid bit, it can tell that it is safe to retrieve a page entry.
    
    If valid = 0, return 0
    If valid = 1, address translation as in the following:

Using the given function 
    
    PhysAddr = PTE2PA(*pte) | (VirtAddr & 0xFFF) 
                    Page Size:   12KB
                    Offset mask: 0xfff

(4) sys_gettraphistory():

The life cycle of PCB will be reused even after its termination. So it is reasonable to initialize trap fields each time this happens. The freeproc(...) function in kernel/proc.c manages the memory of used PCB.
        
        freeproc(struct proc *p) {
            ...
            p->trapcount = 0;
            p->syscallcount = 0;
            p->devintcount = 0;
            p->timerintcount = 0;
        }
Mainly, the function usertrap(void) in kernel/trap.c handles all the system calls, exceptions and interrupt events. Here, it counts all the necessary trap event occurrences.

        p->trapcount++     when the current process structure is retrieved
        p->syscallcount++  when the new system call is called
        p->devintcount++   when hardware/device interrupts occur
        p->timerintcount++ when the timer (quanta) interrupts occur
    
In our implementation, all the four fields are assigned to corresponding virtual addresses passed as arguments in gettraphistory(...).
Using the same strategy as in sys_getcpids, we copy out all the four cases using copyout(...) function.


# Project 1C Documentation:
    This documentation contains three main notes: Kernel Side, User Side, and Implementation note. Kernel Side and User Side notes briefly explains what fields and variables (both local and global) are needed to include in files apart from the main implementation file (i.e. sysproc.c) so that the whole program runs properly. Therefore, these two notes contain describpitons similar to the ones stated in the project specification. If you need not to read them, please do skip to the Implemenation part which contains the major idea of the four newly added system call handlers.

### Kernel Side
In kernel/proc.h, important field values: (line: 114-116)
  int nice;     // Each process is assigned a "nice" value, -20 to +19 (higher to lower priority, respectively)
  int runtime;  // The actual runtime of the process (Unit: ticks)
  int vruntime; // Each process accumulates its own virtual runtime to fairly divide a CPU evenly as opposed to a fixed time slice

In kernel/proc.c, freeproc function (line: 178-180),
  Initialize the three fields to 0 whenever a new process is created.

  (line: 29?-32?) global or local to scheduler() ?
  int cfs_sched_latency = 128; //default length of scheduling latency   //TO BE CHANGED
  int cfs_max_timeslice = 16; //max number of ticks for a process per scheduling latency    //TO BE CHANGED
  int cfs_min_timeslice = 1; //min number of ticks for a process per scheduling latency     //TO BE CHANGED

  (line: 34-45)
  The conversion from nice value to weight based on the nice value domains (-20 to 19).
  Given a nice value x, it should be converted to the range of [0-39] in the array. So perform x+20 adjustment.
  int nice_to_weight[40] = {...};

  (line: 47-55) TO BE CHANGED
  //indicate if the fair scheduler is the current scheduler, 0 is the default setting indicates that the current scheduler is the default RR scheduler 
  //while 1 indicates the current scheduler is this fair scheduler
  int cfs = 0;
  //the process currently scheduled to run by the fair scheduler and is initialized to 0 meaning there is no such process
  struct proc *cfs_current_proc=0;
  //number of ticks assigned to the above (current) process if it exists
  int cfs_proc_timeslice_len=0;
  //number of ticks that the above process can still run if it exists
  int cfs_proc_timeslice_left=0;

  Helper function for a fair scheduler (line: 478-?):
    int weight_sum() - TO BE ADDED
    struct proc* shortest_runtime_proc() - TO BE ADDED

    Implementation of Completely Fair Scheduler (line: 4??-???)
    void cfs_scheduler(struct cpu *c) - TO BE ADDED
    old_scheduler(struct cpu *c) - The original RR scheduler is moved to old_scheduler void
    scheduler(void) - // TO BE CHANGED The scheduler runs the original RR scheduler (if cfs==0) or CFS (if cfs==1)

### User Side
In user/syscall.h (line: 35-38)
  SYS_nice            26
  SYS_getruntime      27
  SYS_startcfs        28
  SYS_stopcfs         29
In user/syscall.c (line: 113-116)
  (line: 113-116) Prototypes for system call handlers
  sys_nice(void);
  sys_getruntime(void);
  sys_startcfs(void);
  sys_stopcfs(void);
  (line: 149-152) Pointers to ... system call handlers in a syscall[] array
  [SYS_nice] sys_nice,
  [SYS_getruntime] sys_getruntime,
  [SYS_startcfs] sys_startcfs,
  [SYS_stopcfs] sys_stopcfs,

In user/usys.pl, (line: 47-50)
    entry("nice");
    entry("getruntime");
    entry("startcfs");
    entry("stopcfs");

In user/user.h, (line: 37-46) TO BE CHANGED
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

In kernel/sysproc.c, (line: 183-???),
  // The handler for system call nice
  uint64 sys_nice(void)
  // The handler for system call getruntime
  uint64 sys_getruntime(void)
  // The handler for system call startcfs
  uint64 sys_startcfs(void)
  // The handler for system call stopcfs
  uint64 sys_stopcfs(void)
