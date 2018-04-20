package main

import (
	"log"
	"net"

	"golang.org/x/net/context"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/reflection"

	pb "github.com/mrmoneyc/grpc-calc/calc"
)

const (
	port = ":50051"
)

type server struct{}

func (s *server) Plus(ctx context.Context, in *pb.CalcRequest) (*pb.CalcReply, error) {
	result := in.NumX + in.NumY
	log.Printf("[Plus] %v + %v = %v", in.NumX, in.NumY, result)

	return &pb.CalcReply{Result: result}, nil
}

func (s *server) Sub(ctx context.Context, in *pb.CalcRequest) (*pb.CalcReply, error) {
	result := in.NumX - in.NumY
	log.Printf("[Sub] %v - %v = %v", in.NumX, in.NumY, result)

	return &pb.CalcReply{Result: result}, nil
}

func (s *server) Mul(ctx context.Context, in *pb.CalcRequest) (*pb.CalcReply, error) {
	result := in.NumX * in.NumY
	log.Printf("[Mul] %v * %v = %v", in.NumX, in.NumY, result)

	return &pb.CalcReply{Result: result}, nil
}

func (s *server) Div(ctx context.Context, in *pb.CalcRequest) (*pb.CalcReply, error) {
	if in.NumY == 0 {
		return nil, grpc.Errorf(codes.InvalidArgument, "Cannot divide by zero")
	}

	result := in.NumX / in.NumY
	log.Printf("[Div] %v / %v = %v", in.NumX, in.NumY, result)

	return &pb.CalcReply{Result: result}, nil
}

func main() {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	s := grpc.NewServer()
	pb.RegisterCalculatorServer(s, &server{})
	reflection.Register(s)

	if err := s.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v", err)
	}
}
