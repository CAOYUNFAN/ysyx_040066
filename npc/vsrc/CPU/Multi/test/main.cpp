#include <bits/stdc++.h>
#include "emu_multi.h"
#include "verilated_vcd_c.h"
using namespace std;
typedef long long LL;
typedef unsigned long long uLL;

const int N=100000;
uLL ramdom(){
    return (uLL)rand()*(uLL)rand()*(uLL)rand()*(uLL)rand();
}

emu_multi * emu;
uLL a[2],b[2];
int is_w[2],aluctr[2];
void data_update(int pos){
    emu->src1_in=a[pos]=random();
    emu->src2_in=b[pos]=random();
    emu->ALUctr_in=aluctr[pos]=rand()%4;
    emu->ALUctr=aluctr[pos^1];
    is_w[pos]=rand()&1;
    emu->is_w=is_w[pos^1];
}

uLL get(int pos){
    switch(aluctr[pos]){
        case 0:return is_w[pos]?(uLL)((int)(a[pos]*b[pos])):a[pos]*b[pos];
        case 1:return (uLL)(((__int128_t)a[pos]*(__int128_t)b[pos])>>(__int128_t)64);
        case 2:return (uLL)(((__int128_t)a[pos]*(__uint128_t)b[pos])>>(__int128_t)64);
        default: return (uLL)(((__uint128_t)a[pos]*(__uint128_t)b[pos])>>(__int128_t)64);
    }
}

int main(){
    srand(unsigned(time(0)));
    emu=new emu_multi;
    //VerilatedVcdC* //tfp = new VerilatedVcdC;
    //tfp->open("wave.vcd");
    int maintime=0;
    printf("hello!\n");
    emu->clk=0;
    emu->eval();
    //tfp->dump(maintime++);
    emu->clk=1;
    emu->eval();
    emu->clk=0;
    emu->eval();
    //tfp->dump(maintime++);
    data_update(0);
    emu->clk=1;
    emu->eval();
    emu->clk=0;
    //tfp->dump(maintime++);
    emu->eval();
    emu->clk=1;
    emu->eval();
    data_update(0);
    emu->clk=0;
    emu->eval();
    //tfp->dump(maintime++);
    emu->clk=1;
    emu->eval();
    data_update(1);
    emu->clk=0;
    emu->eval();
    //tfp->dump(maintime++);
    printf("READY!\n");
    for(int i=2;i<N;i++){
        emu->clk=1;
        emu->eval();
        if(emu->result!=get(i&1)){
            int t=(i&1);
            printf("different:%lld*%lld=%ld,ALUctr=%d,is_w=%d,ref=%lld\n",a[t],b[t],emu->result,aluctr[t],is_w[t],get(t));
            return 1;
        }
        data_update(i&1);
        emu->clk=0;
        emu->eval();
        //tfp->dump(maintime++);
    }
    printf("PASSED!\n");
    return 0;
}