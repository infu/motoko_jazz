
import O "../../rxmo/src/observable";
import Jazz "./jazz";
import Debug "mo:base/Debug";

module {


  // Applies a given project function to each value emitted by the source Observable,
  // and emits the resulting values as an Observable.
  public func timerOnce( jazz: Jazz.Jazz, sec: Nat ) : O.Obs<Bool> {

    let obs = O.Subject<Bool>();

    jazz.delay(sec, func() {
        Debug.print("XOO");
        obs.next(true);
    });

    return obs;
  };

}