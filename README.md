# LAPWebServiceReachabilityManager

LAPWebServiceReachabilityManager pings a web service with a given time interval to check it's reachability.

## Installation

LAPWebServiceReachabilityManager is available via CocoaPods

```ruby
pod "LAPWebServiceReachabilityManager"
```

## Usage

```objc
NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://google.de"]];

LAPWebServiceReachabilityManager *reachabilityManager = [[LAPWebServiceReachabilityManager alloc] initWithURLRequest:request timeInterval:5.0];
[reachabilityManager addStatusObserver:^(LAPWebServiceReachabilityManager *manager, LAPWebServiceReachabilityStatus status) {
    NSLog(@"Reachabiliy changed");
}];
```
