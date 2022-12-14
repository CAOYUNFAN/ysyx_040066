#include <isa.h>
#include "local-include/reg.h"

const char *regs[] = {
  "$0", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
  "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
  "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
  "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"
};

#define Cao_show_reg(name,data) printf("%8s 0x%016lx %ld\n",name,data,data)
#define Cao_show_2(name) Cao_show_reg(str(name),cpu.name)

void isa_reg_display() {
	for(int i=0;i<32;++i) 
	Cao_show_reg(regs[i],gpr(i));
	Cao_show_reg("pc",cpu.pc);

	Cao_show_2(mepc);
	Cao_show_2(mstatus);
	Cao_show_2(mcause);
	Cao_show_2(mtvec);

	return;
}

word_t isa_reg_str2val(const char *s, bool *success) {
//	printf("%s\n",s+1);
	for(int i=0;i<32;++i){
//		printf("%s ",regs[i]);
		if(strcmp(s+1,regs[i])==0){
			*success=true;
			return gpr(i);
		}
//		printf("%d\n",strcmp(s+1,regs[i]));
	}
	if(strcmp(s+1,"pc")==0){
		*success=true;
		return cpu.pc;
	}
	*success=false;
	return 0;
}
