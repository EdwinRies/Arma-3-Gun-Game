/*
	File: heapHeader.sqf
	Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
	Date: 2018-10-14
	Please do not redistribute this work without acknowledgement of the original author. 
	You are otherwise free to use this code as you wish. 

	Description: Common defines and macros for the heap functions
*/
//Min/max switch, comment for a min heap, uncomment for a max heap
#define MAX_HEAP

#define NODEPARAMS(x) (x) params ["_key", "_value"]
#define NODE_KEY 0
#define NODE_VALUE 1

#ifdef MAX_HEAP
	//Max heap
	#define INFINITY 1e39
	#define UNDEFINED_KEY -INFINITY
	#define G_TOP_KEY INFINITY

	#define COMPARE(x,y) ((x) > (y))
#else
	//Min heap
	#define INFINITY 1e39
	#define UNDEFINED_KEY INFINITY
	#define G_TOP_KEY -INFINITY

	#define COMPARE(x,y) ((x) < (y))
#endif

#define KEY(x) ((x) select NODE_KEY)
#define VALUE(x) ((x) select NODE_VALUE)
#define PARENT(x) (floor (((x)-1)/2))
#define LEFT(x) (2*(x)+1)
#define RIGHT(x) (2*(x)+2)
#define LAST(x) ((count (x))-1)