.global _start

.equ totalbits, 32

.data

dividend:
        .space 4
divisor:
        .space 4

.text

_start:

#movl $0, %eax                               #Quotient = $0    
#movl $0, %edx                               #Remainder = $0
movl $0, %edi                               #i = 0

movl dividend,%eax
shrl $31,%eax                            #remainder = (dividend >> 31);
movl %eax,%edx

movl divisor,%ebx                            #Subtract = Divisor

for_start:
    cmpl $totalbits, %edi
    jge for_end

    #If else if structure
    If1:
        cmpl %edx,divisor                   #Divisor - Remainder
        jle else_start
        movl $0, %ebx                       #Subtract = $0
        
	    movl $31, %ecx
	    subl %edi, %ecx				#ecx= 31-i
	    movl $1, %esi
	    shll %cl, %esi				#(1 <<(31-i));
        not %esi
        andl %esi,%eax        #This holds Quotient = Quotient & (~(1 <<(31-i))
    jmp end_else
    
    else_start:
        movl $31, %ecx
	    subl %edi, %ecx				#ecx= 31-i
	    movl $1, %esi
	    shll %cl, %esi				#(1 <<(31-i));
            movl divisor, %ebx
	orl %esi,%eax    #------------- Quotient |=((1 <<(31-i));
        jmp end_else
    end_else:

    subl %ebx, %edx
    shll $1, %edx   #------------- remainder <<=1;

    If2:
        cmpl $31,%edi       #if i<31
        jge end_If2
        If3:
        
            movl $30, %ecx
	        subl %edi, %ecx				#ecx= 30-i
	        movl $1, %esi
	        shll %cl, %esi	
            andl dividend, %esi     #-------------dividend & (1 << (30-i))
            cmpl $0,%esi       #Check if false
            je end_If2
            orl $1, %edx   #-------------remainder |=1
            jmp end_If2
        end_If3:
    end_If2:
    
    movl divisor,%ebx

    incl %edi   #i++
    jmp for_start
for_end:

shrl $1, %edx  #-------------remainder >>=1 DONE

    
done:
    nop
