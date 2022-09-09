# Jazz
Motoko jazz

Jazz rhythms can range from simple to extremely complex. However, underlying even the most complex rhythms performed by each individual musician in a jazz group is an underlying pulse (the beat)

# Installation 
```diff
-(Warning! Not production ready. Also currently it's very expensive)
```

Add this in your actor
```mo
  // JAZZ BEING ---
  let jazz = Jazz.init();
  system func heartbeat() : async () { ignore jazz.heartbeat() };
  // JAZZ END -----
```


# Usage

## Delay
Execute a function after 5 seconds
```mo

    jazz.delay(5, func() : () {
        //...
    });
```

## Retry
Execute a function up to 3 times with 5 seconds interval (retrying gets cancelled if the function returns true)
```mo

   ignore jazz.retry(3, 5, func() : async Bool {
      //....
      false;
    });
```
