// ref: https://hackmd.io/@sysprog/ry8NwAMvT
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// size of list_node = 16 bytes (w/ padding)
typedef struct list_node {
    int val;                    // 4 bytes
    struct list_node *next;     // 8 bytes
} list_node;

// Fast slow implementation
list_node *middle_node_fast_slow_imple(list_node *head)
{
    list_node  volatile *slow, *fast;
    slow = fast = head;
    while (fast && fast->next) {
        slow = slow->next;
        fast = fast->next->next;
    }
    return slow;
}

// Single pointer implementation
list_node *middle_node_single_imple(list_node *head)
{
    list_node *cur = head;
    int n = 0;
    while (cur) {
        ++n;
        cur = cur->next;
    }
    int k = 0;
    cur = head;
    while (k < n / 2) {
        ++k;
        cur = cur->next;
    }
    return cur;
}

typedef struct {
    list_node *head;
    int current_size;
    int max_capacity;
} linked_list;


linked_list *create_list(int capacity)
{
    linked_list *list = (linked_list *) malloc(sizeof(linked_list));
    list->head = NULL;
    list->current_size = 0;
    list->max_capacity = capacity;
    return list;
}

int insert_node(linked_list *list, int val)
{
    if (list->current_size >= list->max_capacity) {
        printf("list full\n");
        return 0;
    }

    list_node *node = (list_node *) malloc(sizeof(list_node));
    node->val = val;
    node->next = list->head;
    list->head = node;

    list->current_size++;

    return 1;
}

void shuffle_list(linked_list *list)
{
    int n = list->current_size;
    if (n < 2) return;

    // put list into temp array
    list_node **map = malloc(n * sizeof(list_node *));
    list_node *curr = list->head;
    for (int i = 0; i < n; i++) {
        map[i] = curr;
        curr = curr->next;
    }

    // Fisher-Yates Shuffle
    for (int i = n - 1; i > 0; i--) {
        int j = rand() % (i + 1);   // randomly take from 0 ~ i
        list_node *temp = map[i];
        map[i] = map[j];
        map[j] = temp;
    }

    // re-link the next pointer
    list->head = map[0];
    for (int i = 0; i < n - 1; i++) {
        map[i]->next = map[i + 1];
    }
    map[n - 1]->next = NULL;

    free(map);
}

void print_list_node_val(linked_list *list)
{
    list_node *head = list->head;
    for (int i = 0; i < list->current_size; i++) {
        printf("%d ", head->val);
        head = head->next;
    }
    printf("\n");
}

void print_list_node_addr(linked_list *list)
{
    list_node *head = list->head;
    for (int i = 0; i < list->current_size; i++) {
        printf("address = %p\n", head);
        head = head->next;
    }
    printf("\n");
}

void walk_list(list_node *head)
{
    list_node volatile *curr = head;
    while (curr) {
        curr = curr->next;
    }
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Please input the number of node\n");
        return 0;
    }
    int n_nodes = atoi(argv[1]);

    srand((unsigned int)time(NULL));

    printf("// Create %d of nodes \n", n_nodes);

    linked_list *list1 = create_list(n_nodes);
    for (int i = 0; i < n_nodes; i++) {
        if (insert_node(list1, i)) {
            // printf("insert pass\n");
            continue;
        } else {
            printf("insert fail\n");
        }
    }    

    // shuffle_list(list1);
    // print_list_node_val(list1);
    // print_list_node_addr(list1);
    // walk_list(list1->head);

    // Find middle pointer
    for (int i = 0; i < 10000; i++) {
        list_node *mid_node = middle_node_fast_slow_imple(list1->head);
    }
    // list_node *mid_node = middle_node_single_imple(list1->head);

    // printf(" middle node value = %d\n", mid_node->val);

    return 0;
}