package main

type RustCallGo struct{}

func (r RustCallGo) ping(ping string) string {
	if ping == "PING" {
		return "PONG"
	}
	panic("invalid ping")
}

func init() {
	RsCallGoImpl = RustCallGo{}
}
