GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
VIRTUALENV_BIN=`which virtualenv`
PYTHON_BIN=`which python3.6`

SERVER_SRC=`pwd`/srv
CLIENT_SRC=`pwd`/cli

PROTOBUF_CMD=protoc
PROTOBUF_PY_PLUGIN=`which grpc_python_plugin`
PROTOBUF_PROTO_PATH=calc

PROTOBUF_GO_OUT_PATH=calc
PROTOBUF_PY_OUT_PATH=cli

BUILD_OUT=bin
SERVER_OUT=$(BUILD_OUT)/calc_server
CLIENT_OUT=$(BUILD_OUT)/calc_client

PYVENV_NAME=pyvenv

.PHONY: all proto proto_go proto_py dep server clean

all: proto dep server

proto: proto_go proto_py

proto_go:
	$(PROTOBUF_CMD) -I $(PROTOBUF_PROTO_PATH) --go_out=plugins=grpc:$(PROTOBUF_GO_OUT_PATH) $(PROTOBUF_PROTO_PATH)/*.proto

proto_py:
	$(PROTOBUF_CMD) -I $(PROTOBUF_PROTO_PATH) --python_out=$(PROTOBUF_PY_OUT_PATH) --grpc_out=$(PROTOBUF_PY_OUT_PATH) --plugin=protoc-gen-grpc=$(PROTOBUF_PY_PLUGIN) $(PROTOBUF_PROTO_PATH)/*.proto

dep:
	$(GOGET) -v -d ./...
	$(VIRTUALENV_BIN) $(PYVENV_NAME) -p $(PYTHON_BIN)
	@source $(PYVENV_NAME)/bin/activate && pip install -r requirements.txt

server:
	@echo "=== Building $(SERVER_OUT) ==="
	$(GOBUILD) -o $(SERVER_OUT) $(SERVER_SRC)/*.go

clean:
	rm -rf $(BUILD_OUT) $(PYVENV_NAME)
	find . -name '*.pb.go' -delete
	find . -name '*_pb2.py' -delete
	find . -name '*_pb2_grpc.py' -delete
	find . -name '*.pyc' -delete
	find . -name '__pycache__' -delete
