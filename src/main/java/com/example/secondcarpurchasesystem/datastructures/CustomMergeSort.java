package com.example.secondcarpurchasesystem.datastructures;

import java.util.Comparator;

public class CustomMergeSort<T> {

    private Comparator<T> comparator;

    public CustomMergeSort(Comparator<T> comparator) {
        this.comparator = comparator;
    }

    public CustomMergeSort() {
        this.comparator = null;
    }

    @SuppressWarnings("unchecked")
    public void sort(Object[] array) {
        if (array == null || array.length <= 1) {
            return;
        }

        Object[] tempArray = new Object[array.length];
        mergeSort(array, tempArray, 0, array.length - 1);
    }

    @SuppressWarnings("unchecked")
    private void mergeSort(Object[] array, Object[] tempArray, int left, int right) {
        if (left < right) {
            int mid = left + (right - left) / 2;

            // Sort first and second halves
            mergeSort(array, tempArray, left, mid);
            mergeSort(array, tempArray, mid + 1, right);

            // Merge the sorted halves
            merge(array, tempArray, left, mid, right);
        }
    }

    @SuppressWarnings("unchecked")
    private void merge(Object[] array, Object[] tempArray, int left, int mid, int right) {
        // Copy data to temp arrays
        for (int i = left; i <= right; i++) {
            tempArray[i] = array[i];
        }

        int i = left;     // Initial index of first subarray
        int j = mid + 1;  // Initial index of second subarray
        int k = left;     // Initial index of merged subarray

        // Merge the temp arrays back into array[left..right]
        while (i <= mid && j <= right) {
            if (compareElements((T)tempArray[i], (T)tempArray[j]) <= 0) {
                array[k] = tempArray[i];
                i++;
            } else {
                array[k] = tempArray[j];
                j++;
            }
            k++;
        }

        // Copy the remaining elements of left subarray, if any
        while (i <= mid) {
            array[k] = tempArray[i];
            i++;
            k++;
        }

        // Copy the remaining elements of right subarray, if any
        while (j <= right) {
            array[k] = tempArray[j];
            j++;
            k++;
        }
    }

    @SuppressWarnings("unchecked")
    private int compareElements(T a, T b) {
        if (comparator != null) {
            return comparator.compare(a, b);
        } else if (a instanceof Comparable) {
            return ((Comparable<T>) a).compareTo(b);
        } else {
            throw new IllegalArgumentException("Elements must be comparable or a comparator must be provided");
        }
    }

    // Sort a linked list using merge sort
    public void sortLinkedList(CustomLinkedList<T> list) {
        if (list == null || list.isEmpty() || list.size() == 1) {
            return;
        }

        // Convert linked list to array
        Object[] array = list.toArray();

        // Sort the array
        sort(array);

        // Convert array back to linked list
        list.fromArray(array);
    }
}