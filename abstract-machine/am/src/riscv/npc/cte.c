#include <am.h>
#include <klib.h>

static Context* (*user_handler)(Event, Context*) = NULL;

Context* __am_irq_handle(Context *c) {
  if (user_handler) {
    Event ev = {0};
    switch (c->mcause) {
      case 11: c->mepc+=4; ev.event = (c->gpr[17]==-1?EVENT_YIELD:EVENT_SYSCALL); break;
      default: ev.event = EVENT_ERROR; break;
    }

    c = user_handler(ev, c);
    assert(c != NULL);
  }

  return c;
}

extern void __am_asm_trap(void);

bool cte_init(Context*(*handler)(Event, Context*)) {
  // initialize exception entry
  asm volatile("csrw mtvec, %0" : : "r"(__am_asm_trap));

  // register event handler
  user_handler = handler;

  return true;
}

Context *kcontext(Area kstack, void (*entry)(void *), void *arg) {
  return NULL;
}

void yield() {
  asm volatile("li a7, -1; ecall");
}

bool ienabled() {
  unsigned long x,y;
  asm("csrr %0,mstatus; csrr %1,mie":"=r"(x),"=r"(y):);
  return (x>>3&1)&&(y>>7&1);
}

void iset(bool enable) {
  asm("csrw mstatus,%0" : :"r"(enable?0xa0001880uLL:0xa0001888uLL));
  asm("csrw mie,%0": :"r"(enable?0x80uLL:0));
}
