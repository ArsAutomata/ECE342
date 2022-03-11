#include <stdio.h>
#include <math.h>
#include <stdlib.h>

typedef int fixed;

int Q_M = 0;
int Q_N = 0;
int F_ONE = 0;

float EMA_float[4][10];
fixed EMA_fixed[4][10];

void SET_Q_FORMAT(int M, int N){
    Q_M = M;
    Q_N = N;
    F_ONE = 1 << N;
}

int FLOAT_TO_FIXED(float f){
    return (fixed)(f * F_ONE);
}

float FIXED_TO_FLOAT(fixed f){
    return (float)(f)/F_ONE;
}

fixed FIXED_MULT(fixed op1, fixed op2){
		
	int shift = Q_N/2;
    fixed f = (op1>>shift)*(op2>>shift);
		// calculate the result of this multiplication
		// and return it here.
    return f >> (Q_N - (2*shift));
}

float ERR(fixed f1, float f2){
    float n1 = FLOAT_TO_FIXED(f1);
    
    float err = abs(n1-f1);
    return err; 
}



// For each of these datasets, find the Qm.n representation that minimizes the error.
// You only need to consider the following values of m : 4, 8, 16 and 24. 
float datasets[4][10] = {{429.53605647241415, 54.051172931707704, 163.58682870876768, 580.5297854212683, 699.4746398396891, 816.6555570791686, 552.2376581729087, 754.3120681461689, 85.19740340786541, 190.84266131541648},
{120069.86565516416, 21469.916452351572, 193920.6012388812, 201536.93026739376, 29439.382625284743, 155926.95756308752, 244118.3902060167, 21616.645699486355, 113960.0450136428, 125626.1350580619},
{0.07402272300410051, 4.0733941539004475, 2.7780734593791974, 4.647096565449923, 4.760313581913216, 1.0700010090755887, 5.999940306877167, 0.09692246551677397, 6.232799120276484, 4.409500084502266},
{18.922375022588515, 9.976071114431022, 1.1578493397893121, 16.946195430873466, 13.258356573949856, 22.789397104263998, 4.467453001844939, 28.000955923708002, 9.65995387643512, 27.66319226833275}};

void PRINT_Q_SET(){
    for(int i = 0; i<4; i++){
        
        printf("set %d: ", i+1);
        
        for(int j = 0; j<10; j++){
            printf("%d ", FLOAT_TO_FIXED(datasets[i][j]));
            if(j == 9){
                printf("\n");
            }
        }
        
        float curr_err;
        float total_err = 0; 
        printf("conversion error: ");
        for(int k = 0; k<10; k++){
            curr_err = FIXED_TO_FLOAT(FLOAT_TO_FIXED(datasets[i][k]))-datasets[i][k];
            if (curr_err < 0){
                curr_err = curr_err*(-1);
            }
            printf("%f ", curr_err);
            total_err = total_err + curr_err;
        }
        printf("\ntotal error for set = %f\n\n", total_err/10.0);
    }
    
}

void EMA_FIXED_CALC(){
    for(int i = 2; i<4; i++){
        EMA_fixed[i][0] = FLOAT_TO_FIXED(datasets[i][0]);
        
        printf("fixed EMA set %d: ", i+1);
        printf("%d ", EMA_fixed[i][0]);
        
        for(int j = 1; j<10; j++){
            EMA_fixed[i][j] = FIXED_MULT(FLOAT_TO_FIXED(0.1), FLOAT_TO_FIXED(datasets[i][j])) + FIXED_MULT(FLOAT_TO_FIXED(0.9), FLOAT_TO_FIXED(datasets[i][j-1]));
            printf("%d ", EMA_fixed[i][j]);
            if(j == 9){
                printf("\n");
            }
        }
        
        float total_err;
        float curr_err;
        printf("errors for EMA set %d: ", i+1);
        for(int k = 0; k<10; k++){
            curr_err = FIXED_TO_FLOAT(EMA_fixed[i][k])-EMA_float[i][k];
            if (curr_err < 0){
                curr_err = curr_err*(-1);
            }
            printf("%f ", curr_err);
            total_err = total_err + curr_err;
        }
        printf("\ntotal error for set = %f\n\n", total_err/10.0);
    }
}

int main(){
    
    
    printf("\n___________Q4,27 sets___________\n");
    SET_Q_FORMAT(4,31-4);
    PRINT_Q_SET();
    
    printf("\n___________Q8,23 sets___________\n");
    SET_Q_FORMAT(8,31-8);
    PRINT_Q_SET();
    
    printf("\n___________Q16,15 sets__________\n");
    SET_Q_FORMAT(16,31-16);
    PRINT_Q_SET();
    
    printf("\n___________Q24,7 sets___________\n");
    SET_Q_FORMAT(24,31-24);
    PRINT_Q_SET();
    
    
    
    printf("\n___________EMA float set_____________\n");
    for(int i = 2; i<4; i++){
        EMA_float[i][0] = datasets[i][0];
        
        printf("EMA set %d: ", i+1);
        printf("%f ", EMA_float[i][0]);
        
        for(int j = 1; j<10; j++){
            EMA_float[i][j] = 0.1*datasets[i][j] + 0.9*EMA_float[i][j-1];
            printf("%f ", EMA_float[i][j]);
            if(j == 9){
                printf("\n");
            }
        }
        printf("\n");
    }
    
    printf("\n___________EMA Q4,27 sets___________\n");
    SET_Q_FORMAT(4,31-4);
    EMA_FIXED_CALC();
    
    printf("\n___________EMA Q8,23 sets___________\n");
    SET_Q_FORMAT(8,31-8);
    EMA_FIXED_CALC();
    
    printf("\n___________EMA Q16,15 sets__________\n");
    SET_Q_FORMAT(16,31-16);
    EMA_FIXED_CALC();
    
    printf("\n___________EMA Q24,7 sets___________\n");
    SET_Q_FORMAT(24,31-24);
    EMA_FIXED_CALC();
    
    
	
	

	return 0;
} 
