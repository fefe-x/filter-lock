#define  N  4 // change number of threads here
short level[N]
short victim[N]
short counter = 0

inline check_conflict(me, l) {
START:
   int i=0;
   do
    :: (i == N || victim[l] != me) -> break;
    :: else ->  do
                :: (i != me && (level[i] == l || level[i] == l + 1)) -> goto START;
                :: else -> skip;
                od;
                i++;
   od;
}

inline lock(me) {
  int l=1
  do
    :: l<N ->
         level[me] = l
         victim[l] = me
         do
           :: victim[l] == me -> check_conflict(me, l); break
           :: victim[l] != me -> break
         od
         printf("Thread %d now in level %d\n", me, l);
         l++
    :: l >= N -> printf("Thread %d now in CS!\n", me); break
  od
}

inline unlock(me) {
    printf("Thread %d unlocking!\n", me);
    level[me] = 0
}

proctype filterlock(int me) {
  printf("Started thread with ID %d.\n", me);
  do
  :: 1>0 ->
    lock(me)
    counter++
    assert(counter == 1)
    counter--
    unlock(me)
  od
}

init {
  int i=N-1;
  do
   :: i>=0 -> run filterlock(i); i--;
  od
}
