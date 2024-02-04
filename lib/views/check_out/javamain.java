import java.util.*; 
import java.io.*;

class javamain {

  public static int ArrayChallenge(int[] arr) {
   int n= arr.length;
   int[] jumps=new int[n];
   Arrays.fill(jumps,Integer.MAX_VALUE);
   jumps[0]=0;
   for(int i = 0;i<n; i++){
     int maxSteps = arr[i];
     for(int j=1;j<=maxSteps && i+j<n;j++){
       jumps[i+j]=Math.min(jumps[i+j],jumps[i]+1);
     }
   }
    
    return jumps[n-1] == Interger.MAX_VALUE ? -1 : jumps[n-1];
  
}
  public static void main (String[] args) {  
       int []arr= {3,4,2,1,1,100};
    // Scanner s = new Scanner(System.in);
    // String input = s.nextLine();
    // String[] inputArr = input.split(" ");
    // int[] arr= new int[inputArr.length];
    // for(int i=0;i<arr.length;i++){
    //   arr[i]=Integer.parseInt(inputArr[i]);
   
    System.out.print(ArrayChallenge(arr)); 
   } // s.close();
  }

