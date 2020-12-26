/*int** matadd(int **A, int num_rows_a, int num_cols_a, int** B, int num_rows_b, int num_cols_b)
{
    int** C = (int**)malloc(num_rows * sizeof(int*));
    int sum=0;
    for(int row=0;row< num_rows;++row)
    {
        C[row] = (int*)malloc(num_cols * sizsof(int));
        for(int col=0;col< num_cols;++col)
        {
            for(int k = 0;k<num_cols;++k)
            {
                C[row][col] += A[row][k] * B[k][col];
            }
        }
    }
    return C;
}*/

.global matMult  #Callable from outside this file
.equ ws, 4

#No _start as it isnt the start of the execution


.text
#No underscore start as we want it to be called and not the start of the file


matMult:
    prologue:
    push %ebp
    movl %esp, %ebp
    subl $(4+7) *ws, %esp   #Three variables Local Variables ((C,row,col,k),%esi,%edi,%ebx,edxtemp,eaxtemp,sum,temp)
    #ebx, esi, edi we'll push them here if we use them
    #we would have to use subl for the other registers too
    
    #Parameters Sent
    #This is ebp + 5*ws : num_cols 
    #This is ebp + 4*ws : num_rows
    #This is ebp + 3*ws : B
    #This is ebp + 2*ws : A  
    #This is ebp + 1*ws : Return address.
    #This is ebp + 0*ws : Top of stack is esp. EBP is here. EBP is a stack pointer
    #This is ebp + -1*ws : C
    #This is ebp + -2*ws : row
    #This is ebp + -3*ws : col
    #This is ebp + -4*ws : esi 
    #This is ebp + -5*ws : edi
    #This is ebp + -6*ws : ebx
    #This is ebp + -7*ws : edxtemp
    #This is ebp + -8*ws : eaxtemp
    


    #Arguments
    .equ A, (2*ws) #%ebp Labels should be used to make it easier to use
    .equ num_rows_a, (3*ws)
    .equ num_cols_a, (4*ws)
    .equ B, (5*ws)
    .equ num_rows_b, (6*ws)
    .equ num_cols_b, (7*ws)
    
    #Locals
    .equ C, (-1*ws)
    .equ row,(-2*ws)
    .equ col, (-3*ws)
    .equ old_esi, (-4*ws)
    .equ old_edi, (-5*ws)
    .equ old_ebx, (-6*ws)
    .equ edxtemp, (-7*ws)
    .equ eaxtemp, (-8*ws)
    .equ k, (-9*ws)
    .equ sum, (-10*ws)
    .equ temp, (-11*ws)
    
    movl %esi, old_esi(%ebp)    #Save the old esi value because we want to use
    movl %edi, old_edi(%ebp)    #Save the old edi value because we want to use
    movl %ebx, old_ebx(%ebp)    #Save the old ebx value because we want to use
    prologue_end: 
    
    movl $0, sum(%ebp)
#int** C = (int**)malloc(num_rows_a * sizeof(int*));
    
    movl num_rows_a(%ebp), %eax   #eax = 4*ws + ebp = num_rows_a
    shll $2, %eax               #eax = num_rows * sizeof(int*)
    push %eax                   #Set malloc's argument on stack
    call malloc                 #Defined as a C library
    addl $1*ws, %esp            #Remove Malloc's Argument on stack
    movl %eax, C(%ebp)          #C => -1*ws + ebp = %eax

#for(int row=0;row< num_rows_a;++row)
    #Row stored in %edx
    
    movl $0, %edx
    outer_for_start:
        cmpl num_rows_a(%ebp),%edx    #row<num_rows_a
        jge outer_for_end
        
#C[row] = (int*)malloc(num_cols_b * sizsof(int));
        movl num_cols_b(%ebp), %eax   #eax = 4*ws + ebp = num_cols_b
        shll $2, %eax               #eax = num_rows * sizeof(int*)
        push %eax
        movl %edx, row(%ebp)        #Save EDX CHECK DIFFERENCE, ignoring line will give an error
        call malloc                 #Malloc expects we dont have anything in ECX,EDX or EAX
        addl $1*ws, %esp
        movl row(%ebp), %edx      #Restore the value of edx to being row. 
        movl C(%ebp), %ecx          #ecx = C
        movl %eax,(%ecx,%edx,ws)   #C[row] = eax, the return value
        
        movl $0, sum(%ebp)
        
#for(int col=0;col< num_cols_b;++col)
        #col stored in %esi
        
        movl $0, %esi   #col=0
        inner_for_start:
            cmpl num_cols_b(%ebp), %esi
            jge inner_for_end

#for(int k = 0;k<num_cols_a;++k)
        #k stored in %ebx
        
        movl $0, %ebx   #k=0
        k_for_start:
            cmpl num_cols_a(%ebp), %ebx
            jge k_for_end
            
#C[row][col] += A[row][k] * B[k][col];  
#*(*(C + row) + col) += *(*(A + row) + k) * *(*(B + k) + col)
#ECX = *(*(A + row) + k)
            #movl A(%ebp,%edx,ws), %ecx     ecx = (&A)[i] It gives the location of A on the stack
            movl A(%ebp), %ecx
            movl (%ecx,%edx,ws), %ecx   #ECX = A[row]
            movl (%ecx,%ebx,ws), %ecx   #ECX = A[row][k]
#EDI = *(*(B + k) + col)       
            movl B(%ebp), %edi
            movl (%edi,%ebx,ws), %edi   #EDI = B[k]
            #Save eax because imull will rewrite it
            movl %edx, edxtemp(%ebp)
            movl %eax, eaxtemp(%ebp)
            movl (%edi,%esi,ws), %edi          #EDI = B[k][col]
            movl %ecx,%eax              #Get ready for multiplication
            imull %edi              #eax = A[row][k]*B[k][col]
            movl %eax,%ecx          #ecx stores multiplication
            movl edxtemp(%ebp), %edx
            movl eaxtemp(%ebp), %eax 
#For matadd adll (%edi, %esi, ws), %ecx #ECX = A[row][k] * B[k][col]------
            
#C[row][col] = C[row][col]+ A[row][k] * B[k][col];  
            
            #add %ecx, (%eax,%esi,ws)
            add %ecx, sum(%ebp)             #Sum = Sum + A[row][k] * B[k][col];  
            
            incl %ebx
            jmp k_for_start
        k_for_end:
            #movl row(%ebp), %ecx            #Ecx stores value of row
            movl C(%ebp), %eax              #EAX holds C in stack
            movl (%eax,%edx,ws), %eax
            movl sum(%ebp), %ecx
        	movl %ecx, (%eax, %esi, ws)
        	movl $0, sum(%ebp)
            incl %esi
            jmp inner_for_start
        inner_for_end:
        incl %edx
        jmp outer_for_start
    outer_for_end:
    
    #Set the return value
    movl C(%ebp), %eax
    
    epilogue:
    #restore saved registers
    movl old_esi(%ebp),%esi         #Save the old esi value because we want to use
    movl old_edi(%ebp),%edi         #Save the old edi value because we want to use
    movl old_ebx(%ebp),%ebx         #Save the old ebx value because we want to use
    movl %ebp, %esp                 #REmove locals
    pop %ebp                        #Restore old stack frame or Destroy created stack frame
    ret
    
