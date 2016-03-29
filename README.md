# Yunho [![Build Status](https://travis-ci.org/melon8/Yunho.svg?branch=master)](https://travis-ci.org/melon8/Yunho)

a network library written in Swift, for study

## Example

### Basic Usage

#### GET

```swift
Yunho.request(.GET, url: "https://httpbin.org/get", params: ["param": "param"], success: { (response) -> () in
  print(response.data)
  print(response.string)
  print(response.json)
}) { (error) -> () in
  // deal with error
}
```

## Document

TODO

## License

MIT

## TVXQ Libs!

* [Yunho - a network library written in Swift, for study](https://github.com/melon8/Yunho)
* [Changmin - JSON lib](#)
* [Jaejoong - AlertView lib](#)
* [Yuchun - Drawer lib](#)
* [Junsu - Pull to Refresh lib](#)
