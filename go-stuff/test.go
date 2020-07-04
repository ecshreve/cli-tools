// here is a comment

// this shouldn't trigger
func (s *Server) FunctionName(args) {


}


// this shouldn't trigger


func (s *Server) functionName(args) {


}


// this should trigger


// TODO: this exported function should have a comment describing it.
func (s *Server) FunctionName(args) {


}


// this should trigger


// TODO: this exported type should have a comment describing it.
type DispatchManualEvent struct {


}


// this shouldn't trigger
type SomeOtherType struct {


}