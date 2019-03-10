#include <stdio.h>

int arr1[10] = {5,3,2,6,4,3,8,9};
int arr2[10] = {7,6,1,2,3,5,4,8};
int arrsize = 8;

void print_array(int[], int);
void quicksort(int[], int, int);
int partition(int[], int, int);
void swap(int[], int, int);

int main(){
  print_array(arr1, arrsize);
  print_array(arr2, arrsize);    

  quicksort(arr1, 0, arrsize-1);
  quicksort(arr2, 0, arrsize-1);
  print_array(arr1, arrsize);
  print_array(arr2, arrsize);

  return 0;
}

void print_array(int arr[], int size){
  for(int i = 0; i < size; i++){
	printf("%d ", arr[i]);
  } 
  printf("\n");
}

void quicksort(int arr[], int lo, int hi){
  if(lo < hi){
    int p = partition(arr, lo, hi);
    quicksort(arr, lo, p);
    quicksort(arr, p+1, hi);
  }
}

void swap(int arr[], int i, int j){
  int temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
}

int partition(int arr[], int lo, int hi){
  int pivot = arr[(lo + hi) / 2];
  int i = lo - 1;
  int j = hi + 1;

  while(1){
    do{
      i = i + 1;
    } while(arr[i] < pivot);

    do{
      j = j - 1;
    } while(arr[j] > pivot);

    if(i >= j){
      return j;
    }

    swap(arr, i, j);
  }
  return 0;
}
