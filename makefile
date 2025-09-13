#Concisely get sources and objects per https://stackoverflow.com/questions/49208817/make-wildcard-to-use-all-object-files/49209533#49209533
SOURCES = $(wildcard *.cpp)
OBJECTS = $(addsuffix .o, $(basename $(SOURCES)))

COMPILER = g++
CPPFLAGS = -g -Wall -Wextra -Wold-style-cast -Wshadow -Wpedantic -Wconversion -Wnull-dereference
#CPPFLAGS += -fsanitize=return -fsanitize=undefined -fsanitize=address

#Build rules from - https://gist.github.com/freelsn/fe5f160cf564e209dc9c5673296ee813
#Here, % is used to match a consistent pattern on each side of the rule - https://unix.stackexchange.com/questions/579332/whats-the-difference-between-percent-vs-asterisk-star-makefile-prerequisite
# $< means the current source file and $@ means the current object file - https://stackoverflow.com/questions/3220277/what-do-the-makefile-symbols-and-mean
%.o: ./%.cpp ./%.hpp
	$(COMPILER) $(CPPFLAGS) -c $< -o $@

all: program

program: $(OBJECTS)
	$(COMPILER) $(CPPFLAGS) $(OBJECTS) -o executable

clean:
	rm -rf *.o

run: program
	if echo $(CPPFLAGS) | grep -q 'sanitize'; then ./executable; else valgrind ./executable; fi

.PHONEY: clean