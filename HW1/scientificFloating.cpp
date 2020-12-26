#include <iostream>
#include <string>
#include <math.h>

using namespace std;

int main()
{
    float input=0.0;
    std::string output,exponent;
    int counter=0;
    std::cout <<"Please enter a float: ";
    cin>>input;
    if(input!=0)
    {
    unsigned int float_int = *((unsigned int*)&input);  //Binary stored in float_int
    if(float_int&(1<<31))
    {
        std::cout<<"-";
    }
    else
    {}
    counter=22;
    while(counter>=0)
    {
        if(float_int&(1<<counter))
        {
            output = output + std::to_string(1);
        }
        else
        {
            output = output + std::to_string(0);
        }
        counter--;
    }
    counter = 22;
    while(1)
    {
        if(output[counter] =='0')
        {
            counter--;
        }
        else if (output[counter] !='0')
        {
            break;
        }
    }
    std::string ans = output.substr(0,counter+1);
    
    //std::cout<<"Mantissa : "<<ans<<std::endl;
    counter = 30;
    while(counter!=22)
    {
        if(float_int&(1<<counter))
        {
            exponent = exponent + std::to_string(1);
        }
        else
        {
            exponent = exponent + std::to_string(0);
        }
        counter--;
    }
    //std::cout<<"Exponent : "<<exponent<<std::endl;
    
    int intexponent = stoi(exponent);
    int fp=1,ld=0,digit=0,count=0;
    while(fp!=0)
    {
        fp=intexponent/10;
        ld = intexponent%10;
        digit = ld*pow(2,count) + digit;
        intexponent = fp;
        count++;
    }
    digit = digit-127;
    std::cout<<"1."<<ans<<"E"<<digit<<"\n";
    }
    else
    {
       std::cout<<"0E0"<<std::endl; 
    }
    return(0);
}
