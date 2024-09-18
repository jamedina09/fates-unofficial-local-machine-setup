// Create a C++ thread from the main program

#include <iostream>
#include <thread>

// This function will be called from a thread
void call_from_thread()
{
    std::cout << "Hello, World!\n";
}

int main()
{
    // Launch a thread
    std::thread t1(call_from_thread);

    // Join the thread with the main thread
    t1.join();

    return 0;
}
// g++-14 tst_threads.cpp -o tst_threads
// ./tst_threads