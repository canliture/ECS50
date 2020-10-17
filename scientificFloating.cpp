#include <stdio.h>
#include <iostream>
#include <math.h>

using namespace std;

double splitfunc(double floating)
{
    double fractional, integer;
    fractional = modf(floating, &integer);
    printf ("Floating: %g\nInteger: %g\nFractional: %g\n", floating, integer, fractional); // when using printf, there are no floats
    
    int whole,fp,ld,binary,count=0;
    whole = (int)integer;
    while(fp!=0)
    {
        fp = whole/2;
        ld = whole%2;
        binary = (ld*pow(10,count))+binary;
        whole = fp;
        count++;
    }
    std::cout<<"Produced Binary: "<<binary<<std::endl;
    
    return fractional;
}
int main()
{
    double fractional = 0.0,floating=0.0;
    cin>>floating;
    fractional = splitfunc(floating);
    std::cout<<"This is the fractional value : "<<fractional;
}
