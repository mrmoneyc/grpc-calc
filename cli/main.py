# -*- coding: utf-8 -*-

from random import randint
import logging
import grpc
import calculator_pb2
import calculator_pb2_grpc


CONN_TARGET = "localhost:50051"


class Calc:
    def __init__(self):
        try:
            channel = grpc.insecure_channel(CONN_TARGET)
            self._stub = calculator_pb2_grpc.CalculatorStub(channel)
        except grpc.RpcError as e:
            logging.error(e)

    def get_plus_result(self, x, y):
        try:
            response = self._stub.Plus(calculator_pb2.CalcRequest(num_x=x, num_y=y))
        except grpc.RpcError as e:
            return e.details()
        else:
            return response.result

    def get_sub_result(self, x, y):
        try:
            response = self._stub.Sub(calculator_pb2.CalcRequest(num_x=x, num_y=y))
        except grpc.RpcError as e:
            return e.details()
        else:
            return response.result

    def get_mul_result(self, x, y):
        try:
            response = self._stub.Mul(calculator_pb2.CalcRequest(num_x=x, num_y=y))
        except grpc.RpcError as e:
            return e.details()
        else:
            return response.result

    def get_div_result(self, x, y):
        try:
            response = self._stub.Div(calculator_pb2.CalcRequest(num_x=x, num_y=y))
        except grpc.RpcError as e:
            return e.details()
        else:
            return response.result


def main():
    x = randint(0, 100)
    y = randint(0, 1)

    c = Calc()

    print("{} + {} = {}".format(x, y, c.get_plus_result(x, y)))
    print("{} - {} = {}".format(x, y, c.get_sub_result(x, y)))
    print("{} * {} = {}".format(x, y, c.get_mul_result(x, y)))
    print("{} / {} = {}".format(x, y, c.get_div_result(x, y)))


if __name__ == "__main__":
    main()
