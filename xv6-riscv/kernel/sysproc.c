#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

// Project 1B >>>
//
// The handler for system call getppid
// Using myproc() function, it can retrieve a currently running process' PCB.
uint64
sys_getppid(void) {
  return myproc()->parent->pid;
}

// The handler for system call getcpids
uint64
sys_getcpids(void) {
  // A variable that will hold an address of the given argument (a pointer to int)
  uint64 cparray;
  // nmax will hold the argument address (a pointer to an int)
  // nchild will be the number of all processes and returned at the end.
  int nmax, nchild = -1;
  struct proc *p = myproc();
  
  argaddr(0, &cparray);
  argint(1, &nmax);
  //if the given max value was greater than the limt NPROC, return -1.
  if(nmax>NPROC||nmax<0) return -1;

  // A new index, j used for cparray to effectively increment the sizeof(cpid)
  // gets incremented when current pid == processlist.ppid
  int j = 0;
  for(int i=0; i<nmax; i++){
    if(proc[i].parent != 0) {
      int cpid = proc[i].pid;
      if(p->pid == proc[i].parent->pid) {
        // The j number of children having the common parent
        if(copyout(p->pagetable, cparray+sizeof(cpid)*j, (char*)&cpid, sizeof(cpid)) < 0){
          return -1;
        }
        nchild = j+1;
        j++;
      }
    }
  }
  return nchild;
}

// The handler for system call getaddr
uint64
sys_getpaddr(void) {
  // Src addr -> Dest addr (phys addr)
  uint64 VirtAddr, PhysAddr = 0;
  pte_t *pte;
  struct proc *p = myproc();
  argaddr(0, &VirtAddr);
  pte = walk(p->pagetable, VirtAddr,0);
  if(pte!=0 && (*pte & PTE_V)){
    //the PTE pointed to by pte this is a valid page entry
    PhysAddr = PTE2PA(*pte) | (VirtAddr & 0xFFF);
  }else{
    //the PTE pointed to by pte is invalid; that is, the virtual address is invalid
    //just return 0.
  }
  
  return PhysAddr;
}

// The handler for system call gettraphistory
uint64
sys_gettraphistory(void) {
  //int trapcount=0, syscallcount=0, devintcount=0, timerintcount=0;
  uint64 trapc, sysc, devc, timerc;
  int trap, sys, dev, timer;
  struct proc *p = myproc();
  argaddr(0, &trapc);
  argaddr(1, &sysc);
  argaddr(2, &devc);
  argaddr(3, &timerc);
  trap = p->trapcount;
  sys = p->syscallcount;
  dev = p->devintcount;
  timer = p->timerintcount;
  if(copyout(p->pagetable, trapc, (char*)&trap, sizeof(trap)) < 0 ||
     copyout(p->pagetable, sysc, (char*)&sys, sizeof(sys)) < 0  ||
     copyout(p->pagetable, devc, (char*)&dev, sizeof(dev)) < 0  ||
     copyout(p->pagetable, timerc, (char*)&timer, sizeof(timer)) < 0){
    return -1;
  }
  return 0;
}
// <<< Project 1B

// Project 1C >>>
// The handler for system call nice
uint64
sys_nice(void) {
  int n;
  argint(0, &n);
  struct proc *p = myproc();
  if(n>=-19&&n<=20) {
    p->nice = n;
  }
  return p->nice;
}

// The handler for system call getruntime
uint64
sys_getruntime(void) {
  uint64 rtarray;
  int runtime, vruntime;
  struct proc *p = myproc();
  argaddr(0, &rtarray);
  runtime = p->runtime;
  vruntime = p->vruntime;
  if(rtarray!= 0) {
    if(copyout(p->pagetable, rtarray, (char*)&runtime, sizeof(runtime)) < 0 ||
      copyout(p->pagetable, rtarray+sizeof(runtime), (char *)&vruntime, sizeof(vruntime)) < 0){
      return -1;
    }
    return 0;
  }
  return -1;
}

// The handler for system call startcfs
uint64
sys_startcfs(void) {
  int latency, max, min;
  argint(0, &latency);
  argint(1, &max);
  argint(2, &min);
  cfs = 1;
  cfs_sched_latency = latency;
  cfs_max_timeslice = max;
  cfs_min_timeslice = min;
  return 1;
}

// The handler for system call stopcfs
uint64
sys_stopcfs(void) {
  cfs = 0;
  return 1;
}
// <<< Project 1C