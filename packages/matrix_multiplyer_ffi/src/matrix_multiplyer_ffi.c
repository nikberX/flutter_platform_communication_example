#include <stdio.h>
#include <stdlib.h>
#include <time.h>


#include "matrix_multiplyer_ffi.h"

FFI_PLUGIN_EXPORT intptr_t multiplyMatrices(intptr_t dimensions) 
{ 
  return _multiplyMatrices(dimensions); 
}

int _multiplyMatrices(int n) {
    int i, j, k;
    int **matrixA, **matrixB, **result;
    clock_t start, end;
    
    // Выделение памяти под матрицы
    matrixA = (int **)malloc(n * sizeof(int *));
    matrixB = (int **)malloc(n * sizeof(int *));
    result = (int **)malloc(n * sizeof(int *));
    for (i = 0; i < n; i++) {
        matrixA[i] = (int *)malloc(n * sizeof(int));
        matrixB[i] = (int *)malloc(n * sizeof(int));
        result[i] = (int *)malloc(n * sizeof(int));
    }
    
    // Заполнение матриц случайными числами
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            matrixA[i][j] = rand() % 1000; // случайное число от 0 до 999
            matrixB[i][j] = rand() % 1000;
        }
    }
    
    // Умножение матриц и замер времени
    start = clock();
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            result[i][j] = 0;
            for (k = 0; k < n; k++) {
                result[i][j] += matrixA[i][k] * matrixB[k][j];
            }
        }
    }
    end = clock();
    
    // Освобождение памяти
    for (i = 0; i < n; i++) {
        free(matrixA[i]);
        free(matrixB[i]);
        free(result[i]);
    }
    free(matrixA);
    free(matrixB);
    free(result);
    
    // Возвращение времени в миллисекундах
    return (int)((end - start) * 1000 / CLOCKS_PER_SEC);
}
