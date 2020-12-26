//Using Strings to Cater for Letter Possibilities
#include <iostream>
#include <math.h>
#include <string>
#include <ctype.h>

using namespace std;

int base = 0,newbase = 0;
int chartodigit(char c) 
{ 
	if (c >= '0' && c <= '9') 
		return (int)c - '0'; 
	else
		return (int)c - 'A' + 10; 
}
std::string digittochar(int a)
{
    //std::cout<<"Function entry";                                                //Testing
    if(a >=10 && a <=10+base)
    {
         std::string s;
         char pls;
         pls = char((a-10)+'A');
         s.push_back(pls);
         return s;
    }
    else
    {
        std::string s;
        s = std::to_string(a);
        return s;
    }
}



int main()
{
    //int base = 0, newbase = 0;
    int ld=0,count = 0,internum = 0;
    std::string newnum="",num="",fp="";
    
    std::cout<<"Please enter the number's base: "<<std::endl;
    cin>>base;
    std::cout<<"Please enter the number: "<<std::endl;
    cin>>num;
    std::cout<<"Please enter the new base: "<<std::endl;
    cin>>newbase;
    fp = num;
    int lengths = num.length();
    //Loops for Original to Base 10
    for(int i =lengths-1;i>=0;i--)
    {
        ld = num[i];
        internum = internum + chartodigit(ld)*pow(base,count);
        count++;
    }
    std::cout<<num<<" base "<<base<<" is ";
    
    //int newnums=0;
    
    //Loops for Base 10 to New Base
    count=0;
    int fps=1;
    if(newbase!=10)                         //Internum is always digits as it handles Decimals
    {
        while(fps!=0)
        {
            fps = internum/newbase;
            ld = internum%newbase;
         
            newnum = digittochar(ld)+newnum;                                            //Testing
            //newnums = newnums + ld*pow(base,count);
            //std::cout<<"Value for ld is : "<<ld<<std::endl;                             //Testing
            //std::cout<<"Value for digittochar(ld) is : "<<digittochar(ld)<<std::endl;   //Testing
            //std::cout<<"Value for newnum is : "<<newnum<<std::endl;                     //Testing
            internum = fps;
            count++;
        }
        std::cout<<newnum<<" base "<< newbase << std::endl;
    }
    else
    {
        std::cout<<internum<<" base "<<newbase << std::endl;
    }
    
    return 0;
}
