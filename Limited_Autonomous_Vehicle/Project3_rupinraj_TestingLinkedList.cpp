/*#include "mbed.h"
#include "MyLinkedList.h"

int main(){
    MyLinkedList list = MyLinkedList();
    LinkedListNode first = LinkedListNode(1,2);
    LinkedListNode second = LinkedListNode(5,4);
    LinkedListNode third = LinkedListNode(3,6);
    list.append(&second);
    list.prepend(&first);
    list.append(&third);

    while(list.getHead() != nullptr){
        LinkedListNode *x = list.removeFirst();
        putchar(x->getXValue()+70);
        putchar('\n');
        putchar(x->getYValue()+70);
        putchar('\n');
    }
}
*/