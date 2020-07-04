// here is a comment

// this should trigger

// TODO: this exported function should have a comment describing it.
func (s *Server) FunctionName(args) {

}

// this should trigger

// TODO: this exported function should have a comment describing it.
func (s *Server) FunctionName2(args) {
	
}

// this should trigger

// TODO: this exported type should have a comment describing it.
type DispatchManualEvent struct {

}

// this shouldn't trigger
type SomeOtherType struct {
	
}

// this should trigger

// TODO: this exported type should have a comment describing it.
type SomeOtherType2 struct {
	
}
