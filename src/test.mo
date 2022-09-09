import Debug "mo:base/Debug";
import Jazz "./jazz";
import Prim "mo:prim"; 
import Time "mo:base/Time";

actor class Test() {

  // JAZZ BEING ---
  let jazz = Jazz.init();
  system func heartbeat() : async () { ignore jazz.heartbeat() };
  // JAZZ END -----

  
  var te : Text = "Initial";

  // Check whats going on with `te`
  public query func get() : async Text { te };
  
  // Our function using jazz.delay
  public shared({caller}) func first_example() : async () {

    var unforgettable = "Something else"; 
  
    // This function will execute after 5 seconds
    jazz.delay(5, func() : () {
      unforgettable := unforgettable # " Whee"; // our delayed function will have access to parent scope variable 
      te := unforgettable; // lets set te so the public get function can confirm our function executed

    });

  };


  // Our function using jazz.retry. To see it in action, repeatedly call 'get' function after calling `second_example`
  public shared({caller}) func second_example() : async () {

    te := "Let's go..."; 

    // This function will execute up to 3 times with 5 seconds interval. If it returns `true` there will be no more retrying
    ignore jazz.retry(3, 5, func() : async Bool {
      te := te # " # "; 

      false;
    });

  };



  // Check memory consumption
  public query func stats() : async (Nat,Nat) {
    (Prim.rts_memory_size(),Prim.rts_heap_size())
  }

};
