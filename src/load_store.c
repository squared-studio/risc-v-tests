// A simple ctest for store operation
// Author : Foez Ahmed (foez.official@gmail.com)

int main () {

    (*((volatile int unsigned *) (0x1000))) = 0x0;
    (*((volatile int unsigned *) (0x1001))) = 0x1;
    (*((volatile int unsigned *) (0x1002))) = 0x2;
    (*((volatile int unsigned *) (0x1003))) = 0x3;
    (*((volatile int unsigned *) (0x1004))) = 0x4;
    (*((volatile int unsigned *) (0x1005))) = 0x5;
    (*((volatile int unsigned *) (0x1006))) = 0x6;
    (*((volatile int unsigned *) (0x1007))) = 0x7;
    (*((volatile int unsigned *) (0x1008))) = 0x8;
    (*((volatile int unsigned *) (0x1009))) = 0x9;
    (*((volatile int unsigned *) (0x100A))) = 0xA;
    (*((volatile int unsigned *) (0x100B))) = 0xB;
    (*((volatile int unsigned *) (0x100C))) = 0xC;
    (*((volatile int unsigned *) (0x100D))) = 0xD;
    (*((volatile int unsigned *) (0x100E))) = 0xE;
    (*((volatile int unsigned *) (0x100F))) = 0xF;

    (*((volatile int unsigned *) (0x1010))) = (*((volatile int unsigned *) (0x1000)));
    (*((volatile int unsigned *) (0x1011))) = (*((volatile int unsigned *) (0x1001)));
    (*((volatile int unsigned *) (0x1012))) = (*((volatile int unsigned *) (0x1002)));
    (*((volatile int unsigned *) (0x1013))) = (*((volatile int unsigned *) (0x1003)));
    (*((volatile int unsigned *) (0x1014))) = (*((volatile int unsigned *) (0x1004)));
    (*((volatile int unsigned *) (0x1015))) = (*((volatile int unsigned *) (0x1005)));
    (*((volatile int unsigned *) (0x1016))) = (*((volatile int unsigned *) (0x1006)));
    (*((volatile int unsigned *) (0x1017))) = (*((volatile int unsigned *) (0x1007)));
    (*((volatile int unsigned *) (0x1018))) = (*((volatile int unsigned *) (0x1008)));
    (*((volatile int unsigned *) (0x1019))) = (*((volatile int unsigned *) (0x1009)));
    (*((volatile int unsigned *) (0x101A))) = (*((volatile int unsigned *) (0x100A)));
    (*((volatile int unsigned *) (0x101B))) = (*((volatile int unsigned *) (0x100B)));
    (*((volatile int unsigned *) (0x101C))) = (*((volatile int unsigned *) (0x100C)));
    (*((volatile int unsigned *) (0x101D))) = (*((volatile int unsigned *) (0x100D)));
    (*((volatile int unsigned *) (0x101E))) = (*((volatile int unsigned *) (0x100E)));
    (*((volatile int unsigned *) (0x101F))) = (*((volatile int unsigned *) (0x100F)));

    return 0;

}
