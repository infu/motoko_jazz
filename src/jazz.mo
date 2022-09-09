import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Time "mo:base/Time";

module {

  type Callback = {
        #delay : Callback.Delay
  };

  module Callback {
      public type Delay = {
        time : Int;
        fn : {
            #seq : () -> ();
            #asy : () -> async (); // async
        };
      };

      
  };


  public class init<>() {
    // Mem
    let max_callbacks = 10000;
    let cbs : [var ?Callback] = Array.init<?Callback>(max_callbacks, null);
    var nextIdx:Nat = 0;

    // Public
    public func heartbeat() : async () {
        ignore run_next_callback();
    };

    // Operators
    public func delay(sec : Nat, fn : () -> () ) :  () {
       add(#delay({
        time = Time.now() + 1000000000 * sec;
        fn = #seq(fn);
        }));
    };

    public func delay_async(sec : Nat, fn : () -> async () ) :  () {
       add(#delay({
        time = Time.now() + 1000000000 * sec;
        fn = #asy(fn);
        }));
    };

    public func retry(max_repetitions:Nat, interval : Nat, fn : () -> async Bool ) : async () {
       var tries = 0;

       let delayfn =  func () : async () { 
           if (tries >= max_repetitions) return; // cancel 
           switch(await fn()) {
               case (true) return;
               case (false) { 
                    delay_async(interval, delayfn); // recursive delay

                    tries += 1; // another example of using parent scope variable in delayed function
               };
           };
       };

       await delayfn();
     
    };

    // Internal
    private func add(x: Callback) {
      let idx = nextIdx;
      cbs[idx] := ?x;
      nextIdx := get_next_freeIdx();
    };

    private func run_next_callback() : async () {
        var now = Time.now();

        var i:Nat = 0;
        while(i < max_callbacks) {
            switch(cbs[i]) {
                case (?x) {
                    switch(x) {
                        case (#delay({time; fn})) {

                            if (time < now) {
                                switch(fn) {
                                    case (#seq(ff)) {
                                        ff();
                                    };
                                    case (#asy(ff)) {
                                        ignore ff();
                                    };
                                };

                                cbs[i] := null;
                                return;
                            };
                        };
                    };
                };
                case (_) ();
            };
            i += 1;
        };
    };

    private func get_next_freeIdx() : Nat {
        var i:Nat = 0;
        label lo while( i < max_callbacks ) {
            switch(cbs[i]) {
                case (null) break lo;
                case (_) i += 1;
            };
        };
        return i;
      };
    };

  

}