CXX=clang
CXXFLAGS=-c -O3 -std=c++11 -emit-llvm --target=wasm64
LLC=llc
LLCFLAGS=-asm-verbose=false
W2B=wat2wasm
BIN=build/jsxmr.wasm

SRC=$(wildcard *.cpp)
WAST=$(SRC:%.cpp=%.wast)

all: $(WAST)
	$(W2B) -o $(BIN) $^

%.wast: %.cpp
	$(CXX) $(CXXFLAGS) $<
	$(LLC) $(LLCFLAGS) -o $(basename $(<F)).s $(basename $(<F)).bc
	s2wasm $(basename $(<F)).s > $(basename $(<F)).wast

.PHONY: clean

clean:
	rm -f *.bc
	rm -f *.s
	rm -f *.wast
